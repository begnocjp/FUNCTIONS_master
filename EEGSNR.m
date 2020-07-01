
clear all;
%% Get Neighbours:
addpath(genpath('J:\PROCESSING_PIPELINE\PACKAGES\fieldtrip'));
cfg = [];
cfg.method = 'triangulation';
cfg.layout = 'biosemi64.lay';

neighbours = ft_prepare_neighbours(cfg);

clear cfg;
%% Reorganise Neighbours
orig_labels = [];
for i = 1:length(neighbours)
    orig_labels = [orig_labels;{neighbours(i).label}];
end

% Go through each NN and find index:
NN_Struc = [];
for i = 1:length(neighbours)
    ind_NN = [];
    for j = 1:length(neighbours(i).neighblabel)
        for k = 1:length(orig_labels)
            if strcmpi(neighbours(i).neighblabel{j},orig_labels{k});
                ind_NN = [ind_NN;{k}];
            end
        end
    end
    NN_Struc = [NN_Struc;{ind_NN}];
end

%% Interpolate Channel:

%addpath(genpath('J:\PROCESSING_PIPELINE\PACKAGES\eeglab'));

foldernames = dir('J:\MRData\RESTINGEEG\STRUCTURE\AGE*');
subjnames = {foldernames(:).name};
clc;
EEG_SNR = zeros(length(subjnames),3,64);
for subj_i = 1:length(subjnames)
    fprintf('%6s \t',subjnames{subj_i});
    cd (['J:\MRData\RESTINGEEG\STRUCTURE\',subjnames{subj_i},'\RESTING_EEG\']);
    for time_i = 1:3
        try
            addpath(genpath('J:\PROCESSING_PIPELINE\PACKAGES\eeglab'));
            filename = [subjnames{subj_i},'_RESTINGEEG_',num2str(time_i),'.edf'];
            [data,header] = readedf(filename);
            rmpath(genpath('J:\PROCESSING_PIPELINE\PACKAGES\eeglab'));
            % average all surrounding channels to get interpolated channel:
            %EEG_SNR = [];
            %fprintf('%6s \t',filename(1:6));
            [b1,a1]=butter(4,1/2048,'high');
            [b2,a2]=butter(4,30/2048,'low');
            %b2 = 1; a2 = 1;
            for chann_i = 1:64
                %fprintf('Working on %4s: Bad Channels: \t',orig_labels{chann_i})
                temp_channel = filtfilt(b1,a1,data(NN_Struc{chann_i}{1},:));
                temp_channel = filtfilt(b2,a2,temp_channel);
                CUE_SUM = temp_channel((2048*30):(end-2048*30));
                for NN_chan_i = 2:length(NN_Struc{chann_i})
                    %fprintf('%5s',orig_labels{NN_Struc{chann_i}{NN_chan_i}});
                    temp_channel = filtfilt(b1,a1,data(NN_Struc{chann_i}{NN_chan_i},:));
                    temp_channel = filtfilt(b2,a2,temp_channel);
                    CUE_SUM = CUE_SUM+temp_channel((2048*30):(end-2048*30));
                end
                Signal_Chann = CUE_SUM./length(NN_Struc{chann_i});
                %fprintf('\n');
                current_chan =  filtfilt(b1,a1,data(chann_i,:));
                current_chan =  filtfilt(b2,a2,current_chan);
                NOISE = Signal_Chann - current_chan((2048*30):(end-2048*30));
                
                mean_NOISE = mean(abs(NOISE));
                mean_SIGNAL = mean(abs(current_chan((2048*30):(end-2048*30))));
                %EEG_SNR =[EEG_SNR;mean_SIGNAL/mean_NOISE];
                EEG_SNR(subj_i,time_i,chann_i) = mean_SIGNAL/mean_NOISE;
            end
            
            subj_mean = mean(EEG_SNR(subj_i,time_i,:));
            subj_std = std(EEG_SNR(subj_i,time_i,:));
            for chann_i = 1:64
                if EEG_SNR(subj_i,time_i,:) < subj_mean-subj_std*2
                    fprintf('%4s,',orig_labels{i});
                end
            end
                    
            
            
            fprintf('\t ');
        catch e
            fprintf(e.message)
            fprintf('\t ');
        end
        
    end

    fprintf('\n');
end
%% PLOT:

close all;
EEG_SNR_MEAN = mean(EEG_SNR,3);
find(EEG_SNR_MEAN(:,1)==0)
EEG_SNR_MEAN_NAN(ans,1) = NaN;
find(EEG_SNR_MEAN(:,2)==0)
EEG_SNR_MEAN_NAN(ans,2) = NaN;
find(EEG_SNR_MEAN(:,3)==0)
EEG_SNR_MEAN_NAN(ans,3) = NaN;
for i = 1:3
subplot(1,3,i)

scatter(1:131,EEG_SNR_MEAN(:,i),'k','LineWidth',1.5);
hold on;
%plot(1:131,1.5*ones(1,131),'-k');
global_mean = nanmean(EEG_SNR_MEAN_NAN,1);
global_std  = nanstd(EEG_SNR_MEAN_NAN,1);

plot(1:131,(global_mean(i)-2*global_std(i))*ones(1,131),'-k');
set(gca,'YLim',[0,5]);
set(gca,'XLim',[1,131]);
axis square;
title(['Resting Period ',num2str(i)]);
xlabel('Subjects');
ylabel('EEG-SNR');
end



%% Bad Channel List:
clc;
for subj_i = 1:length(subjnames)
    fprintf('%6s \t',subjnames{subj_i});
    %cd (['J:\MRData\RESTINGEEG\STRUCTURE\',subjnames{subj_i},'\RESTING_EEG\']);
    for time_i = 1:3
        subj_mean = mean(EEG_SNR(subj_i,time_i,:));
        subj_std = std(EEG_SNR(subj_i,time_i,:));
        %fprintf('%3.3f %33f,',subj_mean,subj_std);
        for chann_i = 1:64
            if EEG_SNR(subj_i,time_i,chann_i) < subj_mean-subj_std*1.5 && chann_i ~=48
                fprintf('%4s,',orig_labels{chann_i});
            end
        end
        fprintf('\t');
    end
    fprintf('\n');
end
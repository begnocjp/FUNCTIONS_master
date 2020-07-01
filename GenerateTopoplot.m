% Load File:
%   - Files are in Wavelet_output\Participant\condition\channel.m
%   - For each Condition, we need to colaspse (find average) of all participants/channel
%   - We should end up with 4 matricies (1 for each condition).
%   - 

%% Setup:

clear all;
names = struct('pnum',{ 'AGE002' 'AGE003' ...
                        'AGE008' 'AGE012' 'AGE013' 'AGE014' 'AGE015' ...
                        'AGE017' 'AGE018' 'AGE019' 'AGE021' ...
                        'AGE022' 'AGE023' ...
                        'AGE024' 'AGE026' 'AGE027' 'AGE028' 'AGE030' ...
                        'AGE032' 'AGE033' 'AGE035' 'AGE036' 'AGE038' ...
                        'AGE046' 'AGE047' 'AGE050' 'AGE051' ...
                        'AGE052' 'AGE058'});
                    
CHANNELS = 1:64;

CONDITIONS = [{'switchto'},{'switchaway'},{'noninf'},{'mixrepeat'}];

CWD = 'F:\fieldtrip\';
DATA_DIR = 'WAVELET_OUTPUT\';
SAVE_DIR = 'TOPO_GRAPH\';

%Setup time windows
times = -400:0.5:2200;

start_intervals = 800:200:(2200-200);
end_intervals = start_intervals+200;


srate = 2048;
bins = 80;
frex=logspace(log10(2),log10(50),bins);     % Hz

start_freq  = [1,19,35,41,48];
end_freq    = [18,31,40,47,68];
freqname = [{'Delta'},{'Theta'},{'Lower Alpha'},{'Upper Alpha'},{'Beta'}];
timename = [{'0-200ms'},{'200-400ms'},{'400-600ms'},{'600-800ms'},{'800-1000ms'},{'1000-1200ms'},{'1200-1400ms'}];

    

%% BEGIN: 
% Sum all data points
% divide by number of datapoints
%Load File:

POWER = zeros(length(CONDITIONS),length(start_freq),length(start_intervals),length(CHANNELS));

for cond_i = 1:length(CONDITIONS);
    for chan_i = CHANNELS

        name_i = 1;
        temp_dir = [CWD,DATA_DIR,names(name_i).pnum,'\',CONDITIONS{cond_i},'\'];
        filename = [names(name_i).pnum,'_',CONDITIONS{cond_i},'_',num2str(chan_i),'_imagcoh_mwtf.mat'];
        temp_mwtf = load([temp_dir,filename],'mw_tf');
        sum_data = temp_mwtf.mw_tf;
        for name_i = 2:length(names)
            temp_dir = [CWD,DATA_DIR,names(name_i).pnum,'\',CONDITIONS{cond_i},'\'];
            filename = [names(name_i).pnum,'_',CONDITIONS{cond_i},'_',num2str(chan_i),'_imagcoh_mwtf.mat'];
            fprintf('%s\n',filename);
            temp_mwtf = load([temp_dir,filename],'mw_tf');
            sum_data = sum_data + temp_mwtf.mw_tf;
        end
        average_data = sum_data./length(names);

        %segment the intervals:
        for time_i = 1:length(start_intervals)
            for freq_i = 1:length(start_freq)
                POWER(cond_i,freq_i,time_i,chan_i) = mean(mean(average_data(start_freq(freq_i):end_freq(freq_i),start_intervals(time_i):end_intervals(time_i))));
            end
        end

    end
end

save([CWD,SAVE_DIR,'POWER.mat'],'POWER')

%% Draw Graphs:
load('POWER.mat')
locname = [CWD,SAVE_DIR,'\10-2064chan.locs'];
for cond_i = 1:length(CONDITIONS)
    for freq_i = 1:length(start_freq)
        for time_i = 1:length(start_intervals)
        
            a = squeeze(POWER(cond_i,freq_i,time_i,:));
            topoplot(a,locname,'maplimits',[-1,1]);
            colorbar();
            s_name = [CONDITIONS{cond_i},' ', freqname{freq_i}, ' ', timename{time_i}];
            title(s_name);
            saveas(gcf,[s_name,'.jpg']);
            close all;
        end
    end
end


%% Draw Contrast Graphs:


for cond_i = 1:length(CONDITIONS)-1
    for freq_i = 1:length(start_freq)
        for time_i = 1:length(start_intervals)
        
            a = squeeze(POWER(cond_i,freq_i,time_i,:));
            b = squeeze(POWER(4,freq_i,time_i,:));
            data = a-b;
            topoplot(data,locname,'maplimits',[-1,1]);
            colorbar();
            s_name = [CONDITIONS{cond_i},' vs Mixed-Repeat ', freqname{freq_i}, ' ', timename{time_i}];
            title(s_name);
            saveas(gcf,[s_name,'.jpg']);
            close all;
        end
    end
end






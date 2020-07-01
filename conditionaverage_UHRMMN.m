%% Set up parameters
clear all;close all;clc;
CWD = 'F:\fieldtrip\'; 
cd('F:\fieldtrip\');
datain = 'F:\fieldtrip\WAVELET_OUTPUT\';
dataout = 'F:\fieldtrip\WAVELET_OUTPUT\Movies\';
frex=logspace(log10(2),log10(100),160);
freqs = {1:29;30:57;58:80;81:111}%;112:130;134:151};%delta theta alpha beta lo_gamma hi_gamma
freq_labels ={'DELTA','THETA','ALPHA','BETA','LO_GAMMA','HI_GAMMA'};
times = -500:0.5:900;
channels = 64;
labels = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5',...
    'T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
    'POz','Pz','CPz','Fpz','Fp2','AF8','AF4','AFz','Fz','F2','F4','F6','F8','FT8','FC6',...
    'FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6',...
    'P8','P10','PO8','PO4','O2'}';

names = {'AH1958','AH1977','AO1954','AS1972','BM1967','DS1963_MMN','JI1972','JK1961','KB1967','KF1959','MY1969','SS1963','ZN1977',...
    'BH1975','DG1965','DJ1963','RT1986','SD1951'};
groupinds = [13,5];
clin_names = {'AH1958','AH1977','AO1954','AS1972','BM1967','DS1963_MMN','JI1972','JK1961','KB1967','KF1959','MY1969','SS1963','ZN1977'};
con_names =  {'BH1975','DG1965','DJ1963','RT1986','SD1951'};
%case_group = {'clinical', 'control'};
conditions = {'standard','duration_deviant','frequency_deviant','intensity_deviant','std_aftDev', 'durMMN','freqMMN','intMMN'};
blocks = {'standard','duration_deviant','frequency_deviant','intensity_deviant','std_aftDev','durMMN','freqMMN','intMMN'};
clusternames={'F','C','P','L','R'};
addpath(genpath('F:\fieldtrip\PACKAGES\fieldtrip'));
stats = zeros(length(names),5,5,5);
%% Load in data 
for block_i =1:length(blocks)
    %conditions=blocks{block_i};
    clusters={{'F1','Fz','F2'},...
        {'C1','Cz','C2'},...
        {'P1','Pz','P2'},...
        {'C5','T7','FC5','FT7'},...
        {'C6','T8','FC5','FT8'}};
    
    % clusterelec = {'F1','Fz','F2'};
    % clusterelec = {'FC1','FCz','FC2'};
    for cluster_i=1:length(clusters)
        clusterelec = clusters{cluster_i};
        electrodes = find(ismember(labels,clusterelec));
        count1 = 0;
        count2 = count1;
        cond_mwtf1 = zeros(160,2801);
        cond_mwtf2 = cond_mwtf1;
        
        clinicaldata_forttest = zeros(length(1:13),160,2801);
        controldata_forttest = zeros(5,160,2801);
        
        % for group_i = 1:length(age_group)
        for name_i = 1:13
            fprintf('\n%s\t%s','Working on subject:',clin_names{name_i});
            tempdata = zeros(160,2801);
%             for cond_i = 1:length(blocks)
                for elec_i = 1:length(electrodes)
                    fprintf('.');
                    load([datain clin_names{name_i} filesep blocks{block_i} filesep clin_names{name_i} '_' blocks{block_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                    cond_mwtf1 = cond_mwtf1 + mw_tf;
                    count1 = count1+1;
                    tempdata = tempdata+mw_tf;
                end
%             end
            clinicaldata_forttest(name_i,:,:) = tempdata./(length(electrodes)*length(blocks));
        end
        
        for name_i = 1:length(con_names)
            fprintf('\n%s\t%s','Working on subject:',con_names{name_i});
            tempdata = zeros(160,2801);
%             for cond_i = 1:length(blocks)
                for elec_i = 1:length(electrodes)
                    fprintf('.');
                    load([datain con_names{name_i} filesep blocks{block_i} filesep con_names{name_i} '_' blocks{block_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                    cond_mwtf2 = cond_mwtf2 + mw_tf;
                    count2 = count2+1;
                    tempdata = tempdata+mw_tf;
                end
                
%             end
            controldata_forttest(name_i,:,:) = tempdata./(length(electrodes)*length(blocks));
        end
%         if strcmpi(clusternames{cluster_i},'F')
%             p_clinical = zeros(160,length(1:2801));
%             for freq = 1:160
%                 [~,p_clinical(freq,:)] = ttest(squeeze(clinicaldata_forttest(:,freq,1:2801)));
%             end
%             
%             
%             
%             p_control = zeros(160,length(1:2801));
%             for freq = 1:160
%                 [~,p_control(freq,:)] = ttest(squeeze(controldata_forttest(:,freq,1:2801)));
%             end
%             
%             addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox\'));
%             thresh =0.05;
%             [~,crit_p]=fdr_bky(p_clinical,thresh,'no');
%             p_thresh_clinical=zeros(size(p_clinical));
%             p_thresh_clinical(p_clinical<crit_p)=1;
%             save(['E:\fieldtrip\WAVELET_OUTPUT\Movies\p_thresh_clinical_' blocks{block_i} '_' clusternames{cluster_i} '.mat'],'p_thresh_clinical');
%             
%             [~,crit_p]=fdr_bky(p_control,thresh,'no');
%             p_thresh_control=zeros(size(p_control));
%             p_thresh_control(p_control<crit_p)=1;
%             save(['E:\fieldtrip\WAVELET_OUTPUT\Movies\p_thresh_control_' blocks{block_i} '_' clusternames{cluster_i} '.mat'],'p_thresh_control');
%         end
        %% Avg across names
        clinical_avg = cond_mwtf1./count1;
        control_avg = cond_mwtf2./count2;
        % avg_group = cond_mwtf/length(names);
        
        save(['F:\fieldtrip\WAVELET_OUTPUT\Movies\clinical_avg_' blocks{block_i} '_' clusternames{cluster_i} '_power.mat'],'clinical_avg');
        save(['F:\fieldtrip\WAVELET_OUTPUT\Movies\control_avg_' blocks{block_i} '_' clusternames{cluster_i} '_power.mat'],'control_avg');
    end        
end        
%% avg group power plots at each cluster

% Full Freq
for block_i = 1:length(blocks)
    for cluster_i = 1:length(clusters)
        load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\clinical_avg_' blocks{block_i} '_' clusternames{cluster_i} '_power.mat'],'clinical_avg');
        load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\control_avg_' blocks{block_i} '_' clusternames{cluster_i} '_power.mat'],'control_avg');
        
        figure();set(gcf,'Position',[0 0 800 800],'Color',[1 1 1]);
        subplot(1,2,1);contourf(times(601:2001),frex(1:160),clinical_avg(1:160,601:2001),50,'linecolor','none');caxis([-1 1])
        hold on;
        colormap('Jet');
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['CLINICAL ' clusternames{cluster_i} ' ' blocks{block_i}]);axis square;
        subplot(1,2,2);contourf(times(601:2001),frex(1:160),control_avg(1:160,601:2001),50,'linecolor','none');caxis([-1 1])
        hold on;
        colormap('Jet');
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['CONTROL ' clusternames{cluster_i} ' ' blocks{block_i}]);axis square;
        saveas(gcf,[dataout 'AllFrex_' clusternames{cluster_i} '_' blocks{block_i} '_by_Grp.pdf'],'pdf');
        
        close
    end
    
    
end
%% Slower Freq

for block_i = 1:length(blocks)
    for cluster_i = 1:length(clusters)
        load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\clinical_avg_' blocks{block_i} '_' clusternames{cluster_i} '_power.mat'],'clinical_avg');
        load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\control_avg_' blocks{block_i} '_' clusternames{cluster_i} '_power.mat'],'control_avg');
        
        figure();set(gcf,'Position',[0 0 800 800],'Color',[1 1 1]);
        subplot(1,2,1);contourf(times(601:2001),frex(1:112),clinical_avg(1:112,601:2001),50,'linecolor','none');caxis([-1 1])
        hold on;
        colormap('Jet');
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['CLINICAL ' clusternames{cluster_i} ' ' blocks{block_i}]);axis square;
        subplot(1,2,2);contourf(times(601:2001),frex(1:112),control_avg(1:112,601:2001),50,'linecolor','none');caxis([-1 1])
        hold on;
        colormap('Jet');
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['CONTROL ' clusternames{cluster_i} ' ' blocks{block_i}]);axis square;
        saveas(gcf,[dataout 'SlowFrex_' clusternames{cluster_i} '_' blocks{block_i} '_by_Grp.pdf'],'pdf');
        
        
        close
    end
    
    
end

%% Collate both groups to test significance

for block_i =1:length(blocks)
    clusters={{'F1','Fz','F2'},...
        {'C1','Cz','C2'},...
        {'P1','Pz','P2'},...
        {'C5','T7','FC5','FT7'},...
        {'C6','T8','FC5','FT8'}};
    
    for cluster_i=1:length(clusters)
        clusterelec = clusters{cluster_i};
        electrodes = find(ismember(labels,clusterelec));
        countA = 0;
        cond_mwtf = zeros(160,2801);
        data_forttest = zeros(length(1:18),160,2801);
        
        for name_i = 1:length(names)
            fprintf('\n%s\t%s','Working on subject:',names{name_i});
            tempdata = zeros(160,2801);
            
            for elec_i = 1:length(electrodes)
                fprintf('.');
                load([datain names{name_i} filesep blocks{block_i} filesep names{name_i} '_' blocks{block_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf = cond_mwtf + mw_tf;
                countA = countA+1;
                tempdata = tempdata+mw_tf;
            end
            
            
            data_forttest(name_i,:,:) = tempdata./(length(electrodes)); %*length(blocks));
        end
        
        if strcmpi(clusternames{cluster_i},'F')
            t_vals = zeros(160,length(1:2801));
            p_vals = zeros(160,length(1:2801));
            for freq = 1:160
                [~,p_vals(freq,:),] = ttest(squeeze(data_forttest(:,freq,1:2801)));
            end
            
            save(['F:\fieldtrip\WAVELET_OUTPUT\Movies\t_vals_' blocks{block_i} '_' clusternames{cluster_i} '.mat'],'t_vals');
            save(['F:\fieldtrip\WAVELET_OUTPUT\Movies\p_vals_' blocks{block_i} '_' clusternames{cluster_i} '.mat'],'p_vals');
            
            addpath(genpath('F:\fieldtrip\PACKAGES\mass_uni_toolbox\'));
            thresh =0.05;
            [~,crit_p]=fdr_bky(p_vals,thresh,'no');
            p_thresh_dat=zeros(size(p_vals));
            p_thresh_dat(p_vals<crit_p)=1;
            save(['F:\fieldtrip\WAVELET_OUTPUT\Movies\p_thresh_dat_' blocks{block_i} '_' clusternames{cluster_i} '.mat'],'p_thresh_dat');
            
            
        end
        
        
        % Dataset Avg
%         dataset_avg = cond_mwtf./countA;
%         save(['F:\fieldtrip\WAVELET_OUTPUT\Movies\dataset_avg_' blocks{block_i} '_' clusternames{cluster_i} '_power.mat'],'dataset_avg');
		
    end
end
    
%%  Test avg power against significant frontal cluster
%

% Times to test = 50-300;(1101-1601)
% Freq Ranges = {1:29;30:57;58:80;81:111;112:130;134:151}
times2test = 1101:1601;

% Clinical Loop %
% Block Loop
for block_i = 1:length(blocks)
    
    load([datain 'Movies' filesep 'p_thresh_dat_' blocks{block_i} '_F.mat'],'p_thresh_dat');
    
    % Cluster Loop
    for cluster_i = 1:length(clusters)
        clusterelec = clusters{cluster_i};
        electrodes = find(ismember(labels,clusterelec));
        
        %         load([datain 'Movies' filesep 'clinical_avg_' blocks{block_i} '_' clusternames{cluster_i} '_power.mat'],'clinical_avg');
        %         load([datain 'Movies' filesep 'control_avg_' blocks{block_i} '_' clusternames{cluster_i} '_power.mat'],'control_avg');
        
        
        % Freq Loop
        for freq_i = 1:length(freqs)
            fprintf('\n');
            tmp_p = squeeze(p_thresh_dat(freqs{freq_i},times2test));
            tmp_data = zeros(length(freqs{freq_i}),length(times2test));
            tmp_data(tmp_p ~= 1) = NaN;
            tmp_inds = ~isnan(tmp_data);
            clin_temp_data = zeros(13,length(freqs{freq_i}),length(times2test));
            
            % name loop
            for name_i = 1:length(clin_names)
                
                tempdata = zeros(length(freqs{freq_i}),length(times2test));
                
                % elec loop
                for elec_i = 1:length(electrodes)
                    fprintf('.');
                    load([datain clin_names{name_i} filesep blocks{block_i} filesep clin_names{name_i} '_' blocks{block_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                    mw_tf(tmp_p ~= 1) = NaN;
                    tempdata = tempdata+mw_tf(length(freqs{freq_i}),length(times2test));
                end
                
                clin_temp_data(name_i,:,:) = tempdata./(length(electrodes));
            end
            clin_data_squeezed = squeeze(clin_temp_data(:,1,1));
            
            %            clin_data_cluster = clin_temp_data(:,(tmp_inds==1),(tmp_inds==1));
            %            tmp_data_val = mean(clin_temp_data(tmp_inds==1));
            cluster_stats(:,freq_i) = clin_data_squeezed;
            
            %                clin_data_squeezed = squeeze(clinical_avg(freqs{freq_i},times2test));
            %                clin_data_val = mean(clin_data_squeezed(tmp_inds==1));
        end
%         cluster_stat = cluster_stats';
        save(['F:\fieldtrip\WAVELET_OUTPUT\Movies\clin_freqavg' clusternames{cluster_i} '_' blocks{block_i} '.txt'],'cluster_stats','-ascii');
        clear cluster_stats %cluster_stat
    end
    
end

% Control Loop %

for block_i = 1:length(blocks)
    
    for cluster_i = 1:length(clusters)
        clusterelec = clusters{cluster_i};
        electrodes = find(ismember(labels,clusterelec));
        
        for freq_i = 1:length(freqs)
            fprintf('\n');
            tmp_p = squeeze(p_thresh_dat(freqs{freq_i},times2test));
            tmp_data = zeros(length(freqs{freq_i}),length(times2test));
            tmp_data(tmp_p ~= 1) = NaN;
            tmp_inds = ~isnan(tmp_data);
            con_temp_data = zeros(5,length(freqs{freq_i}),length(times2test));
            
            % name loop
            for name_i = 1:length(con_names)
                tempdata = zeros(length(freqs{freq_i}),length(times2test));
                % elec loop
                for elec_i = 1:length(electrodes)
                    fprintf('.');
                    load([datain con_names{name_i} filesep blocks{block_i} filesep con_names{name_i} '_' blocks{block_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                    mw_tf(tmp_p ~= 1) = NaN;
                    tempdata = tempdata+mw_tf(length(freqs{freq_i}),length(times2test));
                end
                
                con_temp_data(name_i,:,:) = tempdata./(length(electrodes));
            end
            
            con_data_squeezed = squeeze(con_temp_data(:,1,1));
            
            %                 if p_thresh_dat(freqs{freq_i},times{time_i}) == 1
            %                     % ttest
            %                     x = clinical_avg(freqs{freq_i},times{time_i});
            %                     y = control_avg(freqs{freq_i},times{time_i});
            %                     [~,pstat,stats.tstat] = ttest2(x,y);
            %                 end
            cluster_stats(:,freq_i) = con_data_squeezed;
           
        end
%         cluster_stat = cluster_stats';
        save(['F:\fieldtrip\WAVELET_OUTPUT\Movies\con_freqavg' clusternames{cluster_i} '_' blocks{block_i} '.txt'],'cluster_stats','-ascii');
        clear cluster_stats %cluster_stat
    end
end


%% Plot significant mask

for block_i = 1:length(blocks)
    
    load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\p_thresh_dat_' blocks{block_i} '_F.mat'],'p_thresh_dat');
    
%     for cluster_i = 1:length(clusters)
        
        load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\dataset_avg_' blocks{block_i} '_F_power.mat'],'dataset_avg');
        
        
        figure();set(gcf,'Position',[0 0 800 800],'Color',[1 1 1]);
        subplot(1,1,1);contourf(times(601:2801),frex(1:111),dataset_avg(1:111,601:2801),50,'linecolor','none');caxis([-2 2])
        hold on;
        colormap('Jet');
        mask_data_dataset=zeros(size(dataset_avg(1:111,601:2801)));
        temp_data_dataset=dataset_avg(1:111,601:2801);
        mask_data_dataset(p_thresh_dat(1:111,601:2801)==1)=temp_data_dataset(p_thresh_dat(1:111,601:2801)==1);
        subplot(1,1,1);contourf(times(601:2801),frex(1:111),p_thresh_dat(1:111,601:2801),50,'linecolor','k','linewidth',2);caxis([-2 2])
        
        
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['MASK ' clusternames{cluster_i} ' ' blocks{block_i}]);axis square;
        saveas(gcf,[dataout 'SlowFrexMASK_' blocks{block_i} '_F.pdf'],'pdf');
        close 
%     end
end

        %% Plot
        
%         figure();set(gcf,'Position',[0 0 900 900],'Color',[1 1 1]);
%                     subplot(1,1,1);contourf(times(601:2801),frex(1:111),dataset_avg(1:161,601:2801),50,'linecolor','none');caxis([-2 2])
% %         mask_data_clinical=zeros(size(clinical_avg(1:160,601:2801)));
% %         temp_data_clinical=clinical_avg(1:111,601:2801);
% %         mask_data_clinical(p_thresh_clinical(1:160,:)==1)=temp_data_clinical(p_thresh_clinical(1:160,:)==1);
%         subplot(1,2,1);contourf(times(601:2801),frex(1:160),clinical_avg(1:160,601:2801),50,'linecolor','none');caxis([-2 2])
%         hold on;
%         colormap('Jet');
% %        subplot(1,2,1);contour(times(601:2801),frex(1:160),p_thresh_clinical(1:160,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
%         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
%         set(gca,'FontSize',18);title(['CLINICAL ' clusternames{cluster_i} ' ' blocknames{block_i}]);axis square;
%         
% %         mask_data_control=zeros(size(control_avg(1:160,601:2801)));
% %         temp_data_control=control_avg(1:160,601:2801);
% %         mask_data_control(p_thresh_control(1:160,:)==1)=temp_data_control(p_thresh_control(1:160,:)==1);
%         subplot(1,2,2);contourf(times(601:2801),frex(1:160),control_avg(1:160,601:2801),50,'linecolor','none');caxis([-2 2])
%         
%         %             subplot(1,2,2);contourf(times(601:2801),frex(1:160),control_avg(1:160,601:2801),50,'linecolor','none');caxis([-2 2])
%         hold on;
% %         subplot(1,2,2);contour(times(601:2801),frex(1:160),p_thresh_control(1:160,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
%         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
%         set(gca,'FontSize',18);title(['CONTROL ' clusternames{cluster_i} ' ' blocknames{block_i}]);axis square;
%         saveas(gcf,[dataout 'TIMEF_' clusternames{cluster_i} '_' blocknames{block_i} '_Power.pdf'],'pdf');
%         close
%         
        %         freqs = {1:29;30:57;58:80;81:111;112:130;134:151};
        %         fprintf('\n\n%s\t','**********EXTRACTING AVERAGE VALUES**********');
        % %         if strcmpi(clusternames{cluster_i},'FC')
        %             for freq_i = 1:length(freqs)
        %                 fprintf('.');
        %                 tmp_p = squeeze(p_thresh_clinical(freqs{freq_i},:));
        %                 tmp_data = zeros(length(freqs{freq_i}),length(1001:2801));
        %                 tmp_data(tmp_p ~= 1) = NaN;
        %                 tmp_inds = ~isnan(tmp_data);
        %                 for name_i = 1:13
        %                     for cond_i = 1:length(conditions)
        %                         load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
        %                         tmp_data_squeezed = squeeze(mw_tf(freqs{freq_i},601:2801));
        %                         tmp_data_val = mean(tmp_data_squeezed(tmp_inds==1));
        %                         if strcmpi(blocknames{block_i},'nondir')
        %                             stats(name_i,(cond_i+length(blocknames{1})),cluster_i,freq_i) = tmp_data_val;
        %                         else
        %                             stats(name_i,cond_i,cluster_i,freq_i) = tmp_data_val;
        %                         end
        %
        %                     end
        %                 end
        %             end
        %             fprintf('\n');
        %             for freq_i = 1:length(freqs)
        %                 fprintf('.');
        %                 tmp_p = squeeze(p_thresh_control(freqs{freq_i},:));
        %                 tmp_data = zeros(length(freqs{freq_i}),length(601:2801));
        %                 tmp_data(tmp_p ~= 1) = NaN;
        %                 tmp_inds = ~isnan(tmp_data);
        %                 for name_i = 14:length(names)
        %                     for cond_i = 1:length(conditions)
        %                         load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
        %                         tmp_data_squeezed = squeeze(mw_tf(freqs{freq_i},601:2801));
        %                         tmp_data_val = mean(tmp_data_squeezed(tmp_inds==1));
        %                         if strcmpi(blocknames{block_i},'nondir')
        %                             stats(name_i,(cond_i+length(blocknames{1})),cluster_i,freq_i) = tmp_data_val;
        %                         else
        %                             stats(name_i,cond_i,cluster_i,freq_i) = tmp_data_val;
        %                         end
        %                     end
        %                 end
        %             end
        %         end
        
        
%     end
% end
%% plot
close all
subjs1 = 1:13;
subjs2 = 14:length(names);
for cluster_i=1:length(clusternames)
    figure();
    for freq_i=1:5
        subplot(2,3,freq_i);bar([squeeze(mean(stats(subjs1,:,cluster_i,freq_i),1)),squeeze(mean(stats(subjs2,:,cluster_i,freq_i),1))]);
        ylim([-2.5 2.5]);title(['freq: ' num2str(freq_i) ' ' clusternames{cluster_i}]);
    end
end
%% headplots
clear cond_mwtf1 cond_mwtf2 count* mw_tf clinicaldata_forttest controldata_forttest tempdata clinical_avg control_avg
% load('F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_clinical.mat');
% load('F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_con.mat');
timesets = 601:2801;
timeind = 1:length(601:2801);
% TIMECUTOFF = [2801;1001;4001];
for block_i =1:length(blocks)
    conditions=blocks{block_i};
    load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\clinical_data' blocknames{block_i} '.mat']);
    load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\control_data' blocknames{block_i} '.mat']);
    
    for cond_i = 1:length(blocks{block_i})
        fprintf('\n%s', conditions{cond_i})
        filename = ['F:\fieldtrip\WAVELET_OUTPUT\Movies\' conditions{cond_i} '_topovals.txt'];
        header = {};
        
        for elec_i = 1:length(labels)
            for freq_i = 1:length(freqs)
                for time_i = 1:length(timesets)
                    header = [header; labels{elec_i} '.' freq_labels{freq_i} '.' num2str(time_i)];
                end
            end
        end
        header = header';
        fid = fopen(filename, 'w');
        fprintf(fid, '%s\t', 'Subject');
        for header_i = 1:length(header)
            if header_i ~= length(header)
                fprintf(fid, '%s\t', header{header_i})
            elseif header_i == length(header)
                fprintf(fid, '%s', header{header_i})
            end
        end
        
        for name_i = 1:length(names)
            fprintf('.')
            fprintf(fid, '\n%s\t', names{name_i});
            for elec_i = 1:length(labels)
                load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(elec_i) '_imagcoh_mwtf.mat'],'mw_tf');
                for freq_i = 1:length(freqs)
                    for time_i = 1:length(timesets)
                        if name_i < 14
                            %                             mask_data_clinical=zeros(1,size(freqs{freq_i}),length(timesets{time_i}));
                            temp_data_clin = mw_tf(freqs{freq_i},timesets{time_i});
                            dataval=mean(temp_data_clinical(p_thresh_clinical(freqs{freq_i},timesets{time_i})==1));
                            fprintf(fid, '%2.4f\t', dataval);
                            
                        else
                            %                             mask_data_con=zeros(1,size(freqs{freq_i}),length(timesets{time_i}));
                            temp_data_con = mw_tf(freqs{freq_i},timesets{time_i});
                            dataval=mean(temp_data_control(p_thresh_control(freqs{freq_i},timesets{time_i})==1));
                            fprintf(fid, '%2.4f\t', dataval);
                            
                        end
                    end
                    
                end
            end
%             save(['F:\fieldtrip\WAVELET_OUTPUT\Movies' conditions{cond_i} 'matrix.mat',condmatrix]);
%             clear condmatrix
        end
        fclose(fid);
    end
end   
    
%     if block_i == 1
%         load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\p_thresh_clinical' blocknames{block_i} '_Pz.mat']);
%         load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\p_thresh_control' blocknames{block_i} '_Pz.mat']);
%     else
%         load('F:\fieldtrip\WAVELET_OUTPUT\Movies\p_thresh_clinicalNONDIR.mat');
%         load('F:\fieldtrip\WAVELET_OUTPUT\Movies\p_thresh_controlNONDIR.mat');
%     end    
    conditions=blocks{block_i};
    clusters={labels};
    
    % clusterelec = {'F1','Fz','F2'};
    % clusterelec = {'FC1','FCz','FC2'};
%     for cluster_i=1:length(clusters)
%         clusterelec = clusters{cluster_i};
%         electrodes = find(ismember(labels,clusterelec));
%         count1 = 0;
%         count2 = count1;        
%         % for group_i = 1:length(age_group)
%         clinical_data = zeros(64,160,2801);
%         for name_i = 1:13
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             tic;
%             for cond_i = 1:length(conditions)
%                 fprintf('.');
%                 for elec_i = 1:length(electrodes)
%                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     temp = squeeze(clinical_data(elec_i,:,:))+mw_tf;
%                     clinical_data(elec_i,:,:) = temp;
%                     clear temp;
% %                     for f=1:160
% %                         for t = 1:2801
% %                             clinical_data(elec_i,f,t) = clinical_data(elec_i,f,t)+mw_tf(f,t);
% %                         end
% %                     end
%                 end
%             end
%             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
%         end
%         clinical_data = clinical_data./(length(conditions)*13);
%         save(['F:\fieldtrip\WAVELET_OUTPUT\Movies\clinical_data' blocknames{block_i} '.mat'],'clinical_data');
        load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\clinical_data' blocknames{block_i} '.mat']);
        
%         control_data = zeros(64,160,2801);for name_i = 14:length(names)
%             tic;
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             for cond_i = 1:length(conditions)                    
%                 fprintf('.');
%                 for elec_i = 1:length(electrodes)
%                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     temp = squeeze(control_data(elec_i,:,:))+mw_tf;
%                     control_data(elec_i,:,:) = temp;
%                     clear temp;
% %                     for f=1:160
% %                         for t = 1:2801
% %                             control_data(elec_i,f,t) = control_data(elec_i,f,t)+mw_tf(f,t);
% %                         end
% %                     end
%                 end
%                 
%             end
%             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
%         end
%         
%         control_data = control_data./length(conditions)*5;

%         control_data = zeros(64,160,2801);
%         for name_i = 14:length(names)
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             tic;
%             for cond_i = 1:length(conditions)
%                 fprintf('.');
%                 for elec_i = 1:length(electrodes)
%                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     temp = squeeze(control_data(elec_i,:,:))+mw_tf;
%                     control_data(elec_i,:,:) = temp;
%                     clear temp;
% %                     for f=1:160
% %                         for t = 1:2801
% %                             clinical_data(elec_i,f,t) = clinical_data(elec_i,f,t)+mw_tf(f,t);
% %                         end
% %                     end
%                 end
%             end
%             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
%         end
%         control_data = control_data./(length(conditions)*5);
%         save(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\control_data' blocknames{block_i} '.mat'],'control_data');
        load(['F:\fieldtrip\WAVELET_OUTPUT\Movies\control_data' blocknames{block_i} '.mat']);
        
        %% Avg across names
%         clin_avg = squeeze(mean(clinical_data,1));
%         con_avg = squeeze(mean(control_data,1));
        % avg_group = cond_mwtf/length(names);
        TIMECUTOFF=2801;
        scale = [-2 2];
        count = 0;
        cfg =[];%set up config
        cfg.highlight = 'off';
        cfg.layout = 'biosemi64.lay';
        cfg.marker = 'off';
        cfg.parameter = 'avg';
        cfg.comment = 'no';
        cfg.contournum = 2;
        cfg.gridscale = 150;
        cfg.shading = 'interp';
        cfg.interactive = 'no';
        dat.var = zeros(72,1);
        dat.label = labels(:,1);
        dat.time = 1;
        dat.dimord = 'chan_time';
        cfg.zlim = scale;
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);

        %topoplot
        for freq_i =length(freq_labels):-1:1

            for time_i = 1
%                 switch time_i
%                     case 1%less than 500ms
                        count = count + 1;
%                         cfg =[];%set up config
%                         cfg.highlight = 'off';
%                         cfg.layout = 'biosemi64.lay';
%                         cfg.marker = 'off';
%                         cfg.parameter = 'avg';
%                         cfg.comment = 'no';
%                         cfg.contournum = 2;
%                         cfg.gridscale = 150;
%                         cfg.shading = 'interp';
%                         cfg.interactive = 'no';
%                         dat.var = zeros(72,1);
%                         dat.label = labels(:,1);
%                         dat.time = 1;
%                         dat.dimord = 'chan_time';
%                         cfg.zlim = scale;
%                         cfg.zlim ='maxmin';
%                         dat.avg = zeros(72,1);
%                         mask_data_clinical=zeros(size(clinical_data(:,freqs{freq_i},1:TIMECUTOFF(1))));
%                         temp_data_clinical=clinical_data(:,freqs{freq_i},1:TIMECUTOFF(1));
%                         mask_data_clinical(:,p_thresh_clinical(freqs{freq_i},601:TIMECUTOFF(1))==1)=temp_data_clinical(:,p_thresh_clinical(freqs{freq_i},1:TIMECUTOFF(1))==1);
%                         dat.avg=[squeeze(mean(mean(mask_data_clinical,2),3));0;0;0;0;0;0;0;0];
% %                         dat.avg=[squeeze(mean(mean(temp_data_clinical,2),3));0;0;0;0;0;0;0;0];
%                         subplot(4,2,count);ft_topoplotER(cfg,dat);
                        
                        dat.avg = zeros(72,1);
                        mask_data_control=zeros(size(control_data(:,freqs{freq_i},1:TIMECUTOFF(1))));
                        temp_data_control=control_data(:,freqs{freq_i},1:TIMECUTOFF(1));
                        mask_data_control(:,p_thresh_control(freqs{freq_i},601:TIMECUTOFF(1))==1)=temp_data_control(:,p_thresh_control(freqs{freq_i},1:TIMECUTOFF(1))==1);
                        dat.avg=[squeeze(mean(mean(mask_data_control,2),3));0;0;0;0;0;0;0;0];
                        subplot(4,2,count);ft_topoplotER(cfg,dat);
%                         
%                     case 2%above 500ms
%                         count = count + 1;
% %                         cfg =[];%set up config
% %                         cfg.highlight = 'off';
% %                         cfg.layout = 'biosemi64.lay';
% %                         cfg.marker = 'off';
% %                         cfg.parameter = 'avg';
% %                         cfg.comment = 'no';
% %                         cfg.contournum = 2;
% %                         cfg.gridscale = 50;
% %                         cfg.shading = 'interp';
% %                         cfg.interactive = 'no';
% %                         dat.var = zeros(72,1);
% %                         dat.label = labels(:,1);
% %                         dat.time = 1;
% %                         dat.dimord = 'chan_time';
% %                         cfg.zlim = scale;
% % %                         cfg.zlim ='maxmin';
%                         dat.avg = zeros(72,1);
% %                         mask_data_clinical=zeros(size(clinical_data(:,freqs{freq_i},TIMECUTOFF(1):2801)));
% %                         temp_data_clinical=clinical_data(:,freqs{freq_i},TIMECUTOFF(1):2801);
% %                         mask_data_clinical(:,p_thresh_clinical(freqs{freq_i},TIMECUTOFF(3):end)==1)=temp_data_clinical(:,p_thresh_clinical(freqs{freq_i},TIMECUTOFF(3):end)==1);
% %                         dat.avg=[squeeze(mean(mean(mask_data_clinical,2),3));0;0;0;0;0;0;0;0];
% % %                         dat.avg=[squeeze(mean(mean(temp_data_clinical,2),3));0;0;0;0;0;0;0;0];
% %                         subplot(4,2,count);ft_topoplotER(cfg,dat);
%                         
%                         mask_data_control=zeros(size(control_data(:,freqs{freq_i},TIMECUTOFF(1):2801)));
%                         temp_data_control=control_data(:,freqs{freq_i},TIMECUTOFF(1):2801);
%                         mask_data_control(:,p_thresh_control(freqs{freq_i},TIMECUTOFF(3):end)==1)=temp_data_control(:,p_thresh_control(freqs{freq_i},TIMECUTOFF(3):end)==1);
%                         dat.avg=[squeeze(mean(mean(mask_data_control,2),3));0;0;0;0;0;0;0;0];
%                         subplot(4,2,count);ft_topoplotER(cfg,dat);
%                 end
            end
        end%freq_i loop
        
%   saveas(gcf,['F:\fieldtrip\WAVELET_OUTPUT\Movies\clinicalHeadplots' blocknames{block_i} 'v2.pdf'],'pdf');
  saveas(gcf,['F:\fieldtrip\WAVELET_OUTPUT\Movies\controlHeadplots' blocknames{block_i} 'v2.pdf'],'pdf');
  
%     end
%end

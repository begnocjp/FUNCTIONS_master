%% Setup parameters
clear all;close all;clc;
datain = 'D:\fieldtrip\WAVELET_OUTPUT_DIR\';
dataout = 'D:\fieldtrip\WAVELET_OUTPUT_DIR\results\';
frex=2:55;
freqs = {1:3;4:6;7:12;13:29;30:54};%delta theta alpha beta lo-gamma
freq_labels ={'DELTA','THETA','ALPHA','BETA','LO-GAMMA'};
times = -1000:1.953125:3999;
channels = 1:128;
labels = {'A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','A12','A13','A14','A15','A16',...
    'A17','A18','A19','A20','A21','A22','A23','A24','A25','A26','A27','A28','A29','A30','A31','A32',...
    'B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','B11','B12','B13','B14','B15','B16',...
    'B17','B18','B19','B20','B21','B22','B23','B24','B25','B26','B27','B28','B29','B30','B31','B32',...
    'C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16',...
    'C17','C18','C19','C20','C21','C22','C23','C24','C25','C26','C27','C28','C29','C30','C31','C32',...
    'D1','D2','D3','D4','D5','D6','D7','D8','D9','D10','D11','D12','D13','D14','D15','D16',...
    'D17','D18','D19','D20','D21','D22','D23','D24','D25','D26','D27','D28','D29','D30','D31','D32'};

% names = {'PilotSubjectAERP'}; %'PilotSubjectSERP';;'Subject3_AERP'
% AUD
groups = {{'HC_1_072621_AERP','HC_2_072921_AERP','HC_3_080521_AERP','HC_5_101221 AERP','HC_6_101421 AERP',...
    'HC_7_102521 AERP','HC_8_110121 AERP','HC_10_121321 AERP','HC 11_020822 AERP','HC 12_020822 AERP',...
    'HC_13021422AERP','HC_14021722 AERP','HC_15_022122 AERP','HC_16_022822 AERP','HC_18_031722 AERP','HC_19_032822 AERP',...
    'HC_20_013023 AERP'}...
    ,{'TS_1_091321_AERP','TS_2_101821 AERP_2','TS_3_102121 AERP','TS_4_102121 AERP','TS_5_110221 AERP','TS_6_110821 AERP',...
    'TS_9_010322 AERP','TS_10_010622 AERP','TS 11_011322 AERP','TS 12_012422 AERP','TS 13_013122 AERP',...
    'TS 14021222 AERP','TS_15_022422 AERP','TS_16_030322 AERP','TS_18_091522 AERP','TS_20_092622 AERP',...
    'TS_21_100522 AERP','TS_22_100622 AERP','TS_23_110722 AERP','TS_24_111422 AERP','TS_27_011923 AERP'}}; %

% AUD
all_names = {'HC_1_072621_AERP','HC_2_072921_AERP','HC_3_080521_AERP','HC_5_101221 AERP','HC_6_101421 AERP',...
    'HC_7_102521 AERP','HC_8_110121 AERP','HC_10_121321 AERP','HC 11_020822 AERP','HC 12_020822 AERP',...
    'HC_13021422AERP','HC_14021722 AERP','HC_15_022122 AERP','HC_16_022822 AERP','HC_18_031722 AERP','HC_19_032822 AERP',...
    'HC_20_013023 AERP','TS_1_091321_AERP','TS_2_101821 AERP_2','TS_3_102121 AERP','TS_4_102121 AERP','TS_5_110221 AERP','TS_6_110821 AERP',...
    'TS_9_010322 AERP','TS_10_010622 AERP','TS 11_011322 AERP','TS 12_012422 AERP','TS 13_013122 AERP',...
    'TS 14021222 AERP','TS_15_022422 AERP','TS_16_030322 AERP','TS_18_091522 AERP','TS_20_092622 AERP',...
    'TS_21_100522 AERP','TS_22_100622 AERP','TS_23_110722 AERP','TS_24_111422 AERP','TS_27_011923 AERP'} ;

% TACT
% groups = {{'HC_1_072621_SERP','HC_2_072921_SERP','HC_3_080521_SERP','HC_5_101221 SERP','HC_6_101421 SERP',...
%     'HC_7_102521 SERP','HC_8_110121 SERP','HC_10_121321 SERP','HC 11_020822 SERP_2','HC 12_020822 SERP',...
%     'HC_13021422 SERP','HC_14021722 SERP','HC_15_022122 SERP','HC_16_022822 SERP','HC_17_031722 SERP 2',...
%     'HC_18_031722 SERP','HC_19_032822 SERP','HC_20_013023 SERP'},...
%     {'TS_1_091321_SERP','TS_2_101821 SERP','TS_3_102121 SERP','TS_4_102121 SERP','TS_5_110221 SERP','TS_6_110821 SERP',...
%     'TS_9_010322 SERP','TS_10_010622 SERP','TS 11_011322 SERP','TS 12_012422 SERP','TS 13_013122 SERP',...
%     'TS 14021222 SERP','TS_15_022422 SERP','TS_16_030322 SERP','TS_18_091522 SERP','TS_20_092622 SERP','TS_22_100622 SERP',...
%     'TS_23_110722 SERP','TS_24_111422 SERP','TS_25_112122 SERP','TS_26_112822 SERP','TS_27_011923 SERP'}};

% % TACT
% all_names = {'HC_1_072621_SERP','HC_2_072921_SERP','HC_3_080521_SERP','HC_5_101221 SERP','HC_6_101421 SERP',...
%     'HC_7_102521 SERP','HC_8_110121 SERP','HC_10_121321 SERP','HC 11_020822 SERP_2','HC 12_020822 SERP',...
%     'HC_13021422 SERP','HC_14021722 SERP','HC_15_022122 SERP','HC_16_022822 SERP','HC_17_031722 SERP 2',...
%     'HC_18_031722 SERP','HC_19_032822 SERP','HC_20_013023 SERP','TS_1_091321_SERP','TS_2_101821 SERP',...
%     'TS_3_102121 SERP','TS_4_102121 SERP','TS_5_110221 SERP','TS_6_110821 SERP','TS_9_010322 SERP',...
%     'TS_10_010622 SERP','TS 11_011322 SERP','TS 12_012422 SERP','TS 13_013122 SERP','TS 14021222 SERP',...
%     'TS_15_022422 SERP','TS_16_030322 SERP','TS_18_091522 SERP','TS_20_092622 SERP','TS_22_100622 SERP',...
%     'TS_23_110722 SERP','TS_24_111422 SERP','TS_25_112122 SERP','TS_26_112822 SERP','TS_27_011923 SERP'};


groupnames = {'HC','TS'};
% conditions = {'long','short'}; %,'vis' AUD task
% conditions = {'long','long_sham','short','short_sham','vis'}; %TACT task
clusternames = {'Frontal','Parietal','L_temporal','R_temporal','Central'};
addpath(genpath('D:\fieldtrip\PACKAGES\fieldtrip'));
% stats = zeros(length(groups{1}),5,5,5);

%% Load in data fo each subject for cluster avgs
% clusters={{'76','84','85','86','89'},... % Numbers of these electrodes: 'C21','C20','C22','C12','C25'
%     {'4','5','18','19','20','31','32'}}; % Numbers of these electrodes:  'A19','A4','A5','A18','A20','A31','A32'
% clusters={{'104','105','118','119','120','121'},... % Numbers of these electrodes: 'D23','D22','D8','D9','D24','D25'
%     {'46','47','57','58','59','60'}}; % Numbers of these electrodes:  'B26','B25','B15','B14','B27','B28'

clusters={{'76','84','85','86','89'},{'4','5','18','19','20','31','32'},...
    {'104','105','118','119','120','121'},{'46','47','57','58','59','60'},...
    {'1','2','33','65','97','111'}};
frontal = clusters{1};
parietal = clusters{2};
L_temporal = clusters{3};
R_temporal = clusters{4};
central = clusters{5};

for group_i = 1:length(groups)

        for cluster_i = 5%1:length(clusternames)
            
            count1 = 0;
            cond_mwtf1 = zeros(54,2561);
                        
            data_for_ttest = zeros(3,54,2561);
            
            for name_i = 1:length(groups{group_i})
                fprintf('\n%s\t%s','Working on subject:',groups{group_i}{name_i});
                tempdata = zeros(54,2561);%for
                clusterelec = clusters{cluster_i};
                for elec_i = 1:length(clusterelec)
                    fprintf('.');
                    load([datain groups{group_i}{name_i} filesep 'long' filesep groups{group_i}{name_i} '_long_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                    cond_mwtf1 = cond_mwtf1 + mw_tf;
                    count1 = count1+1;
                    tempdata = tempdata+mw_tf;
                end
            data_for_ttest(name_i,:,:) = tempdata./(length(clusterelec));%*length(conditions));
            
            end           

            power_avg = cond_mwtf1./count1; %plotting
            save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_' groupnames{group_i} '_long_' clusternames{cluster_i} '_corr.mat'],'power_avg');
            save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_' groupnames{group_i} '_long_' clusternames{cluster_i} '_corr.mat'],'data_for_ttest');
%             save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_' groupnames{group_i} '_long_' clusternames{cluster_i} '_corr.mat'],'power_avg');
%             save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_dat_' groupnames{group_i} '_long_' clusternames{cluster_i} '_corr.mat'],'data_for_ttest');

        end
%         clear cluster_i data_for
%         [groupnames{group_i} '_' conditions{cond_i} clusternames{1}] = frontal_AERP(:,:,:);
end
    clear cond_mw_tf1 tempdata  count1 mw_tf   
    



%% Load in data fo each subject for cluster avgs
% clusters={{'76','84','85','86','89'},... % Numbers of these electrodes: 'C21','C20','C22','C12','C25'
%     {'4','5','18','19','20','31','32'}}; % Numbers of these electrodes:  'A19','A4','A5','A18','A20','A31','A32'
% clusters={{'104','105','118','119','120','121'},... % Numbers of these electrodes: 'D23','D22','D8','D9','D24','D25'
%     {'46','47','57','58','59','60'}}; % Numbers of these electrodes:  'B26','B25','B15','B14','B27','B28'

clusters={{'76','84','85','86','89'},{'4','5','18','19','20','31','32'},...
    {'104','105','118','119','120','121'},{'46','47','57','58','59','60'},...
    {'1','2','33','65','97','111'}};
frontal = clusters{1};
parietal = clusters{2};
L_temporal = clusters{3};
R_temporal = clusters{4};
central = clusters{5};

% for group_i = 1:length(groups)

%     for cond_i = 1:length(conditions) % single

        for cluster_i = 5%1:length(clusternames)
            
            count1 = 0;
            cond_mwtf1 = zeros(54,2561);
                        
            data_for_ttest = zeros(31,54,2561);
            
            for name_i = 1:length(all_names)
                fprintf('\n%s\t%s','Working on subject:',all_names{name_i});
                tempdata = zeros(54,2561);%for
                clusterelec = clusters{cluster_i};
                for elec_i = 1:length(clusterelec)
                    fprintf('.');
                    load([datain all_names{name_i} filesep 'long' filesep all_names{name_i} '_long_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                    cond_mwtf1 = cond_mwtf1 + mw_tf;
                    count1 = count1+1;
                    tempdata = tempdata+mw_tf;
                end
            data_for_ttest(name_i,:,:) = tempdata./(length(clusterelec));%*length(conditions));
            
            end           

            power_avg = cond_mwtf1./count1;
            save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpair_avg_alldat_long_' clusternames{cluster_i} '_corr.mat'],'power_avg');
            save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpair_dat_alldat_long_' clusternames{cluster_i} '_corr.mat'],'data_for_ttest');
%             save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpair_avg_alldat_long_' clusternames{cluster_i} '_corr.mat'],'power_avg');
%             save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpair_dat_alldat_long_' clusternames{cluster_i} '_corr.mat'],'data_for_ttest');
        end
%         clear cluster_i data_for
%         [groupnames{group_i} '_' conditions{cond_i} clusternames{1}] = frontal_AERP(:,:,:);

%     end
    
% end
 
    clear cond_mw_tf1 cond_mw_tf2 tempdata tempdata2 count1 count2 mw_tf count3 tempdata2 cond_mw_tf3
    
    % end
%  At the end should have 8 files; 2 Sub x 2 Conds x 2 Clusters
    
%% Load Data for Plotting

HC_long_frontal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tact_avg_long_frontal_uncorr.mat');
HC_long_parietal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tact_avg_long_parietal_uncorr.mat');
HC_long_Ltemp = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tact_avg_long_L_temporal_uncorr.mat');
HC_long_Rtemp = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tact_avg_long_R_temporal_uncorr.mat');

HC_long_frontal = HC_long_frontal.power_avg;
HC_long_parietal = HC_long_parietal.power_avg;
HC_long_Ltemp = HC_long_Ltemp.power_avg;
HC_long_Rtemp = HC_long_Rtemp.power_avg;




%% Plot Group Data
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        %             subplot(1,2,1);contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        %         mask_data_young=zeros(size(young_avg(1:68,801:6801)));
        %         temp_data_young=young_avg(1:68,801:6801);
        %         mask_data_young(p_thresh_young(1:68,:)==1)=temp_data_young(p_thresh_young(1:68,:)==1);
        subplot(1,2,1);contourf(times(462:1537),frex(1:54),HC_long_frontal(1:54,462:1537),50,'linecolor','none');caxis([-2 2]);colorbar
        hold on;
        %        subplot(1,2,1);contour(times(801:6801),frex(1:68),p_thresh_young(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',16);title(['HC Frontal ROI']);axis square;%conditions{1}
        
        %         mask_data_old=zeros(size(old_avg(1:68,801:6801)));
        %         temp_data_old=old_avg(1:68,801:6801);
        %         mask_data_old(p_thresh_old(1:68,:)==1)=temp_data_old(p_thresh_old(1:68,:)==1);
        subplot(1,2,2);contourf(times(462:1537),frex(1:54),TS_long_frontal(1:54,462:1537),50,'linecolor','none');caxis([-2 2]);colorbar
        
        %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
        %         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',16);title(['TS Frontal ROI']);axis square;%conditions{2}
        
%         subplot(1,3,3);contourf(times(1601:3801),frex(1:54),L_temporal_vis_PilotSubjectAERP(1:54,1601:3801),50,'linecolor','none');caxis([-3 3]);colormap(parula)
%         
%         %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
%         hold on;
% %         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
%         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
%         set(gca,'FontSize',18);title(['Visual ' ]);axis square;%conditions{3}
        saveas(gcf,['E:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\aud_paried_stim_frontal_power_uncorr.jpg'],'jpg');
        close
        
%% Setup parameters - for TACT

% clear all;close all;clc;
% datain = 'E:\fieldtrip\WAVELET_OUTPUT_DIR\';
% dataout = 'E:\fieldtrip\WAVELET_OUTPUT_DIR\results\';
% frex=2:55;
% freqs = {1:3;4:7;8:12;13:29;30:54};%delta theta alpha beta lo-gamma
% freq_labels ={'DELTA','THETA','ALPHA','BETA','LO-GAMMA'};
% times = -900:0.5:4000;
% channels = 1:128;
% labels = {'A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','A12','A13','A14','A15','A16',...
%     'A17','A18','A19','A20','A21','A22','A23','A24','A25','A26','A27','A28','A29','A30','A31','A32',...
%     'B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','B11','B12','B13','B14','B15','B16',...
%     'B17','B18','B19','B20','B21','B22','B23','B24','B25','B26','B27','B28','B29','B30','B31','B32',...
%     'C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16',...
%     'C17','C18','C19','C20','C21','C22','C23','C24','C25','C26','C27','C28','C29','C30','C31','C32',...
%     'D1','D2','D3','D4','D5','D6','D7','D8','D9','D10','D11','D12','D13','D14','D15','D16',...
%     'D17','D18','D19','D20','D21','D22','D23','D24','D25','D26','D27','D28','D29','D30','D31','D32'};
% 
% % names = {'PilotSubjectAERP'}; %'PilotSubjectSERP';;'Subject3_AERP'
% 
% groups = {{'SERP_HC_3','HC_4 SERP','HC_5 SERP','HC_8 SERP'},{'TS_8 SERP','TS_9 SERP','TS_10 SERP','TS_12 SERP','TS_14 SERP'}};
% groupnames = {'HC','TS'};
% % conditions = {'long','short'}; %,'vis' AUD task
% conditions = {'long','long_sham','short','short_sham'}; %,'vis' TACT task
% clusternames = {'L_temporal','R_temporal','Frontal','Parietal'};
% addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
% stats = zeros(length(groups{1}),5,5,5);
%% Load in data fo each subject for cluster avgs
% clusters={{'76','84','85','86','89'},... % Numbers of these electrodes: 'C21','C20','C22','C12','C25'
%     {'4','5','18','19','20','31','32'}}; % Numbers of these electrodes:  'A19','A4','A5','A18','A20','A31','A32'
% clusters={{'104','105','118','119','120','121'},... % Numbers of these electrodes: 'D23','D22','D8','D9','D24','D25'
%     {'46','47','57','58','59','60'}}; % Numbers of these electrodes:  'B26','B25','B15','B14','B27','B28'

clusters={{'76','84','85','86','89'},{'4','5','18','19','20','31','32'},...
    {'104','105','118','119','120','121'},{'46','47','57','58','59','60'}};
frontal = clusters{1};
parietal = clusters{2};
L_temporal = clusters{3};
R_temporal = clusters{4};

for group_i = 1:length(groups)

    for cond_i = 1:length(conditions) % single

        for cluster_i = 1:length(clusternames)
            
            count1 = 0;
            cond_mwtf1 = zeros(54,9801);
                        
            data_for_ttest = zeros(4,54,9801);
            
            for name_i = 1:length(groups{group_i})
                fprintf('\n%s\t%s','Working on subject:',groups{group_i}{name_i});
                tempdata = zeros(54,9801);%for
                clusterelec = clusters{cluster_i};
                for elec_i = 1:length(clusterelec)
                    fprintf('.');
                    load([datain groups{group_i}{name_i} filesep conditions{cond_i} filesep groups{group_i}{name_i} '_' conditions{cond_i} '_' clusterelec{elec_i} '_uncorr_mwtf.mat'],'mw_tf');
                    cond_mwtf1 = cond_mwtf1 + mw_tf;
                    count1 = count1+1;
                    tempdata = tempdata+mw_tf;
                end
            data_for_ttest(name_i,:,:) = tempdata./(length(clusterelec));%*length(conditions));
            
            end           

            power_avg = cond_mwtf1./count1;
            save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tact_avg_' groupnames{group_i} '_' conditions{cond_i} '_' clusternames{cluster_i} '_uncorr.mat'],'power_avg');
%             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tact_dat_' groupnames{group_i} '_' conditions{cond_i} '_' clusternames{cluster_i} '.mat'],'data_for_ttest');
        end
%         clear cluster_i data_for
%         [groupnames{group_i} '_' conditions{cond_i} clusternames{1}] = frontal_AERP(:,:,:);

    end
    
end
 
    clear cond_mw_tf1 cond_mw_tf2 tempdata tempdata2 count1 count2 mw_tf count3 tempdata2 cond_mw_tf3
    
    % end
%  At the end should have 8 files; 2 Sub x 2 Conds x 2 Clusters
    
%% Load Data for Plotting

% AUDITORY TRIALS
% HC_frontal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_HC_long_Frontal_corr.mat');
% HC_parietal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_HC_long_Parietal_corr.mat');
% HC_Ltemp = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_HC_long_L_temporal_corr.mat');
% HC_Rtemp = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_HC_long_R_temporal_corr.mat');
% HC_central = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_HC_long_Central_corr.mat');
% 
% HC_frontal = HC_frontal.power_avg;
% HC_parietal = HC_parietal.power_avg;
% HC_Ltemp = HC_Ltemp.power_avg;
% HC_Rtemp = HC_Rtemp.power_avg;
% HC_central = HC_central.power_avg;
% 
% TS_frontal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_TS_long_Frontal_corr.mat');
% TS_parietal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_TS_long_Parietal_corr.mat');
% TS_Ltemp = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_TS_long_L_temporal_corr.mat');
% TS_Rtemp = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_TS_long_R_temporal_corr.mat');
% TS_central = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_TS_long_Central_corr.mat');
% 
% TS_frontal = TS_frontal.power_avg;
% TS_parietal = TS_parietal.power_avg;
% TS_Ltemp = TS_Ltemp.power_avg;
% TS_Rtemp = TS_Rtemp.power_avg;
% TS_central = TS_central.power_avg;

% TACTILE TRIALS

HC_frontal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_HC_long_Frontal_corr.mat');
HC_parietal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_HC_long_Parietal_corr.mat');
HC_Ltemp = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_HC_long_L_temporal_corr.mat');
HC_Rtemp = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_HC_long_R_temporal_corr.mat');
HC_central = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_HC_long_Central_corr.mat'); 

HC_frontal = HC_frontal.power_avg;
HC_parietal = HC_parietal.power_avg;
HC_Ltemp = HC_Ltemp.power_avg;
HC_Rtemp = HC_Rtemp.power_avg;
HC_central = HC_central.power_avg;

TS_frontal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_TS_long_Frontal_corr.mat');
TS_parietal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_TS_long_Parietal_corr.mat');
TS_Ltemp = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_TS_long_L_temporal_corr.mat');
TS_Rtemp = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_TS_long_R_temporal_corr.mat');
TS_central = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_TS_long_Central_corr.mat');

TS_frontal = TS_frontal.power_avg;
TS_parietal = TS_parietal.power_avg;
TS_Ltemp = TS_Ltemp.power_avg;
TS_Rtemp = TS_Rtemp.power_avg;
TS_central = TS_central.power_avg;


%% Plot Group Data
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        %             subplot(1,2,1);contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        %         mask_data_young=zeros(size(young_avg(1:68,801:6801)));
        %         temp_data_young=young_avg(1:68,801:6801);
        %         mask_data_young(p_thresh_young(1:68,:)==1)=temp_data_young(p_thresh_young(1:68,:)==1);
        subplot(1,2,1);contourf(times(411:1537),frex(1:54),HC_central(1:54,411:1537),50,'linecolor','none');caxis([-2 2]);colorbar
        hold on;
        %        subplot(1,2,1);contour(times(801:6801),frex(1:68),p_thresh_young(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',16);title(['HC Central ROI']);axis square;%conditions{1}
        
        %         mask_data_old=zeros(size(old_avg(1:68,801:6801)));
        %         temp_data_old=old_avg(1:68,801:6801);
        %         mask_data_old(p_thresh_old(1:68,:)==1)=temp_data_old(p_thresh_old(1:68,:)==1);
        subplot(1,2,2);contourf(times(461:1537),frex(1:54),TS_central(1:54,461:1537),50,'linecolor','none');caxis([-2 2]);colorbar
        
        %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
        %         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',16);title(['TS Central ROI']);axis square;%conditions{2}

%         saveas(gcf,['E:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\tact_short_frontal_power_uncorr.jpg'],'jpg');
         close
         
%% Pre-allocate and run t-tests for all data to extract sig clusters 

% long_frontal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpair_dat_alldat_long_Frontal_corr.mat');
% long_parietal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpair_dat_alldat_long_Parietal_corr.mat');
% long_Ltemporal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpair_dat_alldat_long_L_temporal_corr.mat');
% long_Rtemporal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpair_dat_alldat_long_R_temporal_corr.mat');
% long_central = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpair_dat_alldat_long_Central_corr.mat');

long_frontal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpair_dat_alldat_long_Frontal_corr.mat');
long_parietal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpair_dat_alldat_long_Parietal_corr.mat');
long_Ltemporal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpair_dat_alldat_long_L_temporal_corr.mat');
long_Rtemporal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpair_dat_alldat_long_R_temporal_corr.mat');
long_central = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpair_dat_alldat_long_Central_corr.mat');

long_front = long_frontal.data_for_ttest; 
long_par = long_parietal.data_for_ttest;
long_Ltemp = long_Ltemporal.data_for_ttest; 
long_Rtemp = long_Rtemporal.data_for_ttest;
long_cent = long_central.data_for_ttest; 

clear long_frontal long_parietal long_Ltemporal long_Rtemporal

% Preallocate p-val vectors
p_long_frontal = zeros(54,length(513:1537));
% t_long_frontal = zeros(54,length(513:1537));
p_long_parietal = zeros(54,length(513:1537));
% t_long_parietal = zeros(54,length(513:1537));
p_long_Ltemp = zeros(54,length(513:1537));
% t_long_Ltemp = zeros(54,length(513:1537));
p_long_Rtemp = zeros(54,length(513:1537));
% t_long_Rtemp = zeros(54,length(513:1537));
p_long_central = zeros(54,length(513:1537));
% t_long_central = zeros(54,length(513:1537));

for freq = 1:54
    [~,p_long_frontal(freq,:)] = ttest(long_front(:,freq,513:1537));%,'Alpha', 0.05);
end

for freq = 1:54
    [~,p_long_parietal(freq,:)] = ttest(long_par(:,freq,513:1537));%,'Alpha', 0.05);
end

for freq = 1:54
    [~,p_long_Ltemp(freq,:)] = ttest(long_Ltemp(:,freq,513:1537));%,'Alpha', 0.05);
end

for freq = 1:54
    [~,p_long_Rtemp(freq,:)] = ttest(long_Rtemp(:,freq,513:1537));%,'Alpha', 0.05);
end

for freq = 1:54
    [~,p_long_cent(freq,:)] = ttest(long_cent(:,freq,513:1537));%,'Alpha', 0.05);
end

addpath('D:\fieldtrip\PACKAGES\mass_uni_toolbox\');
thresh =0.05;

% Removing FDR as too conservative for 4 vs 4 mask
 
p_crit_frontal = zeros(size(p_long_frontal));
p_crit_parietal = zeros(size(p_crit_frontal));
p_crit_Ltemp = zeros(size(p_crit_frontal));
p_crit_Rtemp = zeros(size(p_crit_frontal));
p_crit_cent = zeros(size(p_crit_frontal));

for freq = 1:54
    [~,p_crit_frontal(freq,:)]=fdr_bky(p_long_frontal(freq,:),thresh,'no');
end

for freq = 1:54
    [~,p_crit_parietal(freq,:)]=fdr_bky(p_long_parietal(freq,:),thresh,'no');
end

for freq = 1:54
    [~,p_crit_Ltemp(freq,:)]=fdr_bky(p_long_Ltemp(freq,:),thresh,'no');
end

for freq = 1:54
    [~,p_crit_Rtemp(freq,:)]=fdr_bky(p_long_Rtemp(freq,:),thresh,'no');
end

for freq = 1:54
    [~,p_crit_cent(freq,:)]=fdr_bky(p_long_cent(freq,:),thresh,'no');
end

% Create and save masks

p_thresh_frontal=zeros(size(p_long_frontal));
p_thresh_frontal(p_long_frontal<p_crit_frontal)=1;
% p_thresh_frontal(p_crit_frontal<thresh)=1;
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_aud_long_frontal.mat'],'p_thresh_frontal');
save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_tact_long_frontal.mat'],'p_thresh_frontal');

p_thresh_parietal=zeros(size(p_long_parietal));
p_thresh_parietal(p_long_parietal<p_crit_parietal)=1;
% p_thresh_parietal(p_crit_parietal<thresh)=1;
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_aud_long_parietal.mat'],'p_thresh_parietal');
save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_tact_long_parietal.mat'],'p_thresh_parietal');

p_thresh_Ltemp=zeros(size(p_long_frontal));
p_thresh_Ltemp(p_long_Ltemp<p_crit_Ltemp)=1;
% p_thresh_Ltemp(p_crit_Ltemp<thresh)=1;
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_aud_long_Ltemp.mat'],'p_thresh_Ltemp');
save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_tact_long_Ltemp.mat'],'p_thresh_Ltemp');

p_thresh_Rtemp=zeros(size(p_long_parietal));
p_thresh_Rtemp(p_long_Rtemp<p_crit_Rtemp)=1;
% p_thresh_Rtemp(p_crit_Rtemp<thresh)=1;
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_aud_long_Rtemp.mat'],'p_thresh_Rtemp');
save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_tact_long_Rtemp.mat'],'p_thresh_Rtemp');

p_thresh_cent=zeros(size(p_long_parietal));
p_thresh_cent(p_long_cent<p_crit_cent)=1;
% p_thresh_Rtemp(p_crit_Rtemp<thresh)=1;
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_aud_long_cent.mat'],'p_thresh_cent');
save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_tact_long_cent.mat'],'p_thresh_cent');

clear p_crit_frontal p_crit_parietal p_crit_Ltemp p_crit_Rtemp p_thresh_frontal p_thresh_parietal p_thresh_Ltemp p_thresh_Rtemp 
clear p_long_frontal p_long_parietal p_long_Ltemp p_long_Rtemp long_front long_parietal long_Ltemp long_Rtemp long_cent long_central

%% Load in task avg and threshold data
hc_frontal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_HC_long_Frontal_corr.mat'],'power_avg');
hc_parietal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_HC_long_Parietal_corr.mat'],'power_avg');
hc_Ltemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_HC_long_L_temporal_corr.mat'],'power_avg');
hc_Rtemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_HC_long_R_temporal_corr.mat'],'power_avg');
hc_long_central = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_HC_long_Central_corr.mat'], 'power_avg');

ts_frontal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_TS_long_Frontal_corr.mat'],'power_avg');
ts_parietal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_TS_long_Parietal_corr.mat'],'power_avg');
ts_Ltemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_TS_long_L_temporal_corr.mat'],'power_avg');
ts_Rtemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_TS_long_R_temporal_corr.mat'],'power_avg');
ts_long_central = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_avg_TS_long_Central_corr.mat'], 'power_avg');

hc_front =  hc_frontal.power_avg; hc_par = hc_parietal.power_avg;
hc_Ltemp = hc_Ltemporal.power_avg; hc_Rtemp = hc_Rtemporal.power_avg;
hc_cent =  hc_central.power_avg;

ts_front =  ts_frontal.power_avg; ts_par = ts_parietal.power_avg;
ts_Ltemp = ts_Ltemporal.power_avg; ts_Rtemp = ts_Rtemporal.power_avg;
ts_cent =  ts_central.power_avg;

% hc_frontal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_HC_long_Frontal_corr.mat'],'power_avg');
% hc_parietal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_HC_long_Parietal_corr.mat'],'power_avg');
% hc_Ltemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_HC_long_L_temporal_corr.mat'],'power_avg');
% hc_Rtemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_HC_long_R_temporal_corr.mat'],'power_avg');
% hc_long_central = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_HC_long_Central_corr.mat'], 'power_avg');
% 
% ts_frontal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_TS_long_Frontal_corr.mat'],'power_avg');
% ts_parietal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_TS_long_Parietal_corr.mat'],'power_avg');
% ts_Ltemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_TS_long_L_temporal_corr.mat'],'power_avg');
% ts_Rtemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_TS_long_R_temporal_corr.mat'],'power_avg');
% ts_long_central = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_avg_TS_long_Central_corr.mat'], 'power_avg');
% 
% hc_front =  hc_frontal.power_avg; hc_par = hc_parietal.power_avg;
% hc_Ltemp = hc_Ltemporal.power_avg; hc_Rtemp = hc_Rtemporal.power_avg;
% hc_cent =  hc_central.power_avg;

% ts_front =  ts_frontal.power_avg; ts_par = ts_parietal.power_avg;
% ts_Ltemp = ts_Ltemporal.power_avg; ts_Rtemp = ts_Rtemporal.power_avg;
% ts_cent =  ts_central.power_avg;

clear hc_frontal hc_parietal hc_Ltemporal hc_Rtemporal ts_frontal ts_parietal ts_Ltemporal ts_Rtemporal

% p_frontal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_aud_long_frontal.mat');
% p_parietal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_aud_long_parietal.mat');
% p_Ltemporal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_aud_long_Ltemp.mat');
% p_Rtemporal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_aud_long_Rtemp.mat');

p_frontal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_tact_long_frontal.mat');
p_parietal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_tact_long_parietal.mat');
p_Ltemporal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_tact_long_Ltemp.mat');
p_Rtemporal = load('D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\p_thresh_tact_long_Rtemp.mat');

p_front = p_frontal.p_thresh_frontal; p_par = p_parietal.p_thresh_parietal;
p_Ltemp = p_Ltemporal.p_thresh_Ltemp; p_Rtemp = p_Rtemporal.p_thresh_Rtemp;

clear p_frontal p_parietal p_Ltemporal p_Rtemporal

%% Plot Masked Data

        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        %             subplot(1,2,1);contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        %         mask_data_young=zeros(size(young_avg(1:68,801:6801)));
        %         temp_data_young=young_avg(1:68,801:6801);
        %         mask_data_young(p_thresh_young(1:68,:)==1)=temp_data_young(p_thresh_young(1:68,:)==1);
        subplot(1,2,1);contourf(times(411:1537),frex(1:54),hc_front(1:54,411:1537),50,'linecolor','none');caxis([-3 3]);%colormap(jet)
        hold on;
        subplot(1,2,1);contour(times(513:1537),frex(1:54),p_front(1:54,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['HC Frontal ROI']);axis square;%conditions{1}
        
        %         mask_data_old=zeros(size(old_avg(1:68,801:6801)));
        %         temp_data_old=old_avg(1:68,801:6801);
        %         mask_data_old(p_thresh_old(1:68,:)==1)=temp_data_old(p_thresh_old(1:68,:)==1);
        subplot(1,2,2);contourf(times(411:1537),frex(1:54),ts_front(1:54,411:1537),50,'linecolor','none');caxis([-3 3]);%colormap(jet)
        
        %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
        subplot(1,2,2);contour(times(513:1537),frex(1:54),p_front(1:54,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['TS Frontal ROI']);axis square;%conditions{2}
        
%         subplot(1,3,3);contourf(times(1601:3801),frex(1:54),L_temporal_vis_PilotSubjectAERP(1:54,1601:3801),50,'linecolor','none');caxis([-3 3]);colormap(parula)
%         
%         %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
%         hold on;
% %         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
%         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
%         set(gca,'FontSize',18);title(['Visual ' ]);axis square;%conditions{3}
        %saveas(gcf,['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\short_parietal_power.jpg'],'jpg');
        close

%% Export avg values between after 0ms that fall in task avg FDR
% Previously: For all vals between 200-400ms 
% Previously: For all vals between 300-600ms
tmp_data = zeros(30,68,251);
 
% hc_frontal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_HC_long_Frontal_corr.mat'],'data_for_ttest');
% hc_parietal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_HC_long_Parietal_corr.mat'],'data_for_ttest');
% hc_Ltemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_HC_long_L_temporal_corr.mat'],'data_for_ttest');
% hc_Rtemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_HC_long_R_temporal_corr.mat'],'data_for_ttest');
% hc_central = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_HC_long_Central_corr.mat'],'data_for_ttest');
% 
% ts_frontal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_TS_long_Frontal_corr.mat'],'data_for_ttest');
% ts_parietal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_TS_long_Parietal_corr.mat'],'data_for_ttest');
% ts_Ltemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_TS_long_L_temporal_corr.mat'],'data_for_ttest');
% ts_Rtemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_TS_long_R_temporal_corr.mat'],'data_for_ttest');
% ts_central = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_ts_long_Central_corr.mat'],'data_for_ttest');
% 
% hc_front = hc_frontal.data_for_ttest; hc_par = hc_parietal.data_for_ttest;
% hc_Ltemp = hc_Ltemporal.data_for_ttest; hc_Rtemp = hc_Rtemporal.data_for_ttest;
% hc_cent =  hc_central.data_for_ttest;
% 
% ts_front = ts_frontal.data_for_ttest; ts_par = ts_parietal.data_for_ttest;
% ts_Ltemp = ts_Ltemporal.data_for_ttest; ts_Rtemp = ts_Rtemporal.data_for_ttest;
% ts_cent =  ts_central.data_for_ttest;
% 
% clear hc_frontal hc_parietal hc_Ltemporal hc_Rtemporal ts_frontal ts_parietal ts_Ltemporal ts_Rtemporal hc_central ts_central

hc_frontal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_dat_HC_long_Frontal_corr.mat'],'data_for_ttest');
hc_parietal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_dat_HC_long_Parietal_corr.mat'],'data_for_ttest');
hc_Ltemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_dat_HC_long_L_temporal_corr.mat'],'data_for_ttest');
hc_Rtemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_dat_HC_long_R_temporal_corr.mat'],'data_for_ttest');
hc_central = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_dat_HC_long_Central_corr.mat'],'data_for_ttest');

ts_frontal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_dat_TS_long_Frontal_corr.mat'],'data_for_ttest');
ts_parietal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_dat_TS_long_Parietal_corr.mat'],'data_for_ttest');
ts_Ltemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_dat_TS_long_L_temporal_corr.mat'],'data_for_ttest');
ts_Rtemporal = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_tactpaired_dat_TS_long_R_temporal_corr.mat'],'data_for_ttest');
ts_central = load(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\power_audpaired_dat_TS_long_Central_corr.mat'],'data_for_ttest');

hc_front = hc_frontal.data_for_ttest; hc_par = hc_parietal.data_for_ttest;
hc_Ltemp = hc_Ltemporal.data_for_ttest; hc_Rtemp = hc_Rtemporal.data_for_ttest;
hc_cent = hc_central.data_for_ttest;

ts_front = ts_frontal.data_for_ttest; ts_par = ts_parietal.data_for_ttest;
ts_Ltemp = ts_Ltemporal.data_for_ttest; ts_Rtemp = ts_Rtemporal.data_for_ttest;
ts_cent = ts_central.data_for_ttest;

clear hc_frontal hc_parietal hc_Ltemporal hc_Rtemporal ts_frontal ts_parietal ts_Ltemporal ts_Rtemporal hc_central ts_central

trials = {hc_front,hc_par,hc_Ltemp,hc_Rtemp,hc_cent,ts_front,ts_par,ts_Ltemp,ts_Rtemp,ts_cent};

% cluster_i = 1;%:length(clusters);
% cond_i = 1;%:length(conditions);

for name_i = 1:length(names)
    for freq_i = 1:54
        for time_i = 1:251
            if p_thresh_parietal(freq_i,time_i)==1
                tmp_data(name_i,freq_i,time_i) = repeat_parietal(name_i,freq_i,time_i);
            end
        end
    end
end


% sf_avg = mean(tmp_data,3);
% sp_avg = mean(tmp_data,3);
% rf_avg = mean(tmp_data,3);
rp_avg = mean(tmp_data,3);
clear tmp_data p_frontal p_parietal

% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\aud\frontal_aud_0-1000_power.mat'],'hf_avg');
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\aud\pareital_aud_0-1000_power.mat'],'hp_avg');
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\aud\Ltemp_aud_0-1000_power.mat'],'hlt_avg');
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\aud\Rtemp_aud_0-1000_power.mat'],'hrt_avg');

% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\tact\frontal_tact_0-1000_power.mat'],'tf_avg');
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\tact\pareital_tact_0-1000_power.mat'],'tp_avg');
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\tact\Ltemp_tact_0-1000_power.mat'],'tlt_avg');
% save(['D:\fieldtrip\WAVELET_OUTPUT_DIR\TSresults\tact\Rtemp_tact_0-1000_power.mat'],'trt_avg');

%% Load and extract AERP Gating data for S1 and S2
% Beta and Gamma power at 0-100ms following S1 and S2
% S1 times 0-100 = 513:564  S2 times 0-100 = 718:769
% beta = frex(13:29); gamma = frex(30:54);
% Load data for t-test in section at line 600

% Alpha

hc_front_a1 = hc_front(:,7:12,513:564);hc_front_a2 = hc_front(:,7:12,718:769); 
hc_par_a1 = hc_par(:,7:12,513:564);hc_par_a2 = hc_par(:,7:12,718:769); 
hc_Ltemp_a1 = hc_Ltemp(:,7:12,513:564);hc_Ltemp_a2 = hc_Ltemp(:,7:12,718:769); 
hc_Rtemp_a1 = hc_Rtemp(:,7:12,513:564);hc_Rtemp_a2 = hc_Rtemp(:,7:12,718:769); 
hc_cent_a1 = hc_cent(:,7:12,513:564);hc_cent_a2 = hc_cent(:,7:12,718:769);

ts_front_a1 = ts_front(:,7:12,513:564);ts_front_a2 = ts_front(:,7:12,718:769); 
ts_par_a1 = ts_par(:,7:12,513:564);ts_par_a2 = ts_par(:,7:12,718:769); 
ts_Ltemp_a1 = ts_Ltemp(:,7:12,513:564);ts_Ltemp_a2 = ts_Ltemp(:,7:12,718:769); 
ts_Rtemp_a1 = ts_Rtemp(:,7:12,513:564);ts_Rtemp_a2 = ts_Rtemp(:,7:12,718:769); 
ts_cent_a1 = ts_cent(:,7:12,513:564);ts_cent_a2 = ts_cent(:,7:12,718:769);

hc_front_a1 = mean(hc_front_a1,3); hc_front_a1 = mean(hc_front_a1,2);
hc_front_a2 = mean(hc_front_a2,3); hc_front_a2 = mean(hc_front_a2,2);
hc_par_a1 = mean(hc_par_a1,3); hc_par_a1 = mean(hc_par_a1,2);
hc_par_a2 = mean(hc_par_a2,3); hc_par_a2 = mean(hc_par_a2,2);
hc_Ltemp_a1 = mean(hc_Ltemp_a1,3); hc_Ltemp_a1 = mean(hc_Ltemp_a1,2);
hc_Ltemp_a2 = mean(hc_Ltemp_a2,3); hc_Ltemp_a2 = mean(hc_Ltemp_a2,2);
hc_Rtemp_a1 = mean(hc_Rtemp_a1,3); hc_Rtemp_a1 = mean(hc_Rtemp_a1,2);
hc_Rtemp_a2 = mean(hc_Rtemp_a2,3); hc_Rtemp_a2 = mean(hc_Rtemp_a2,2);
hc_cent_a1 = mean(hc_cent_a1,3); hc_cent_a1 = mean(hc_cent_a1,2);
hc_cent_a2 = mean(hc_cent_a2,3); hc_cent_a2 = mean(hc_cent_a2,2);

ts_front_a1 = mean(ts_front_a1,3); ts_front_a1 = mean(ts_front_a1,2);
ts_front_a2 = mean(ts_front_a2,3); ts_front_a2 = mean(ts_front_a2,2);
ts_par_a1 = mean(ts_par_a1,3);ts_par_a1 = mean(ts_par_a1,2);
ts_par_a2 = mean(ts_par_a2,3);ts_par_a2 = mean(ts_par_a2,2);
ts_Ltemp_a1 = mean(ts_Ltemp_a1,3);ts_Ltemp_a1 = mean(ts_Ltemp_a1,2);
ts_Ltemp_a2 = mean(ts_Ltemp_a2,3);ts_Ltemp_a2 = mean(ts_Ltemp_a2,2);
ts_Rtemp_a1 = mean(ts_Rtemp_a1,3);ts_Rtemp_a1 = mean(ts_Rtemp_a1,2);
ts_Rtemp_a2 = mean(ts_Rtemp_a2,3);ts_Rtemp_a2 = mean(ts_Rtemp_a2,2);
ts_cent_a1 = mean(ts_cent_a1,3); ts_cent_a1 = mean(ts_cent_a1,2);
ts_cent_a2 = mean(ts_cent_a2,3); ts_cent_a2 = mean(ts_cent_a2,2);

% Beta
hc_front_b1 = hc_front(:,13:29,513:564);hc_front_b2 = hc_front(:,13:29,718:769); 
hc_par_b1 = hc_par(:,13:29,513:564);hc_par_b2 = hc_par(:,13:29,718:769); 
hc_Ltemp_b1 = hc_Ltemp(:,13:29,513:564);hc_Ltemp_b2 = hc_Ltemp(:,13:29,718:769); 
hc_Rtemp_b1 = hc_Rtemp(:,13:29,513:564);hc_Rtemp_b2 = hc_Rtemp(:,13:29,718:769); 
hc_cent_b1 = hc_cent(:,13:29,513:564);hc_cent_b2 = hc_cent(:,13:29,718:769);

ts_front_b1 = ts_front(:,13:29,513:564);ts_front_b2 = ts_front(:,13:29,718:769); 
ts_par_b1 = ts_par(:,13:29,513:564);ts_par_b2 = ts_par(:,13:29,718:769); 
ts_Ltemp_b1 = ts_Ltemp(:,13:29,513:564);ts_Ltemp_b2 = ts_Ltemp(:,13:29,718:769); 
ts_Rtemp_b1 = ts_Rtemp(:,13:29,513:564);ts_Rtemp_b2 = ts_Rtemp(:,13:29,718:769); 
ts_cent_b1 = ts_cent(:,13:29,513:564);ts_cent_b2 = ts_cent(:,13:29,718:769);

hc_front_b1 = mean(hc_front_b1,3); hc_front_b1 = mean(hc_front_b1,2);
hc_front_b2 = mean(hc_front_b2,3); hc_front_b2 = mean(hc_front_b2,2);
hc_par_b1 = mean(hc_par_b1,3); hc_par_b1 = mean(hc_par_b1,2);
hc_par_b2 = mean(hc_par_b2,3); hc_par_b2 = mean(hc_par_b2,2);
hc_Ltemp_b1 = mean(hc_Ltemp_b1,3); hc_Ltemp_b1 = mean(hc_Ltemp_b1,2);
hc_Ltemp_b2 = mean(hc_Ltemp_b2,3); hc_Ltemp_b2 = mean(hc_Ltemp_b2,2);
hc_Rtemp_b1 = mean(hc_Rtemp_b1,3); hc_Rtemp_b1 = mean(hc_Rtemp_b1,2);
hc_Rtemp_b2 = mean(hc_Rtemp_b2,3); hc_Rtemp_b2 = mean(hc_Rtemp_b2,2);
hc_cent_b1 = mean(hc_cent_b1,3); hc_cent_b1 = mean(hc_cent_b1,2);
hc_cent_b2 = mean(hc_cent_b2,3); hc_cent_b2 = mean(hc_cent_b2,2);

ts_front_b1 = mean(ts_front_b1,3); ts_front_b1 = mean(ts_front_b1,2);
ts_front_b2 = mean(ts_front_b2,3); ts_front_b2 = mean(ts_front_b2,2);
ts_par_b1 = mean(ts_par_b1,3);ts_par_b1 = mean(ts_par_b1,2);
ts_par_b2 = mean(ts_par_b2,3);ts_par_b2 = mean(ts_par_b2,2);
ts_Ltemp_b1 = mean(ts_Ltemp_b1,3);ts_Ltemp_b1 = mean(ts_Ltemp_b1,2);
ts_Ltemp_b2 = mean(ts_Ltemp_b2,3);ts_Ltemp_b2 = mean(ts_Ltemp_b2,2);
ts_Rtemp_b1 = mean(ts_Rtemp_b1,3);ts_Rtemp_b1 = mean(ts_Rtemp_b1,2);
ts_Rtemp_b2 = mean(ts_Rtemp_b2,3);ts_Rtemp_b2 = mean(ts_Rtemp_b2,2);
ts_cent_b1 = mean(ts_cent_b1,3); ts_cent_b1 = mean(ts_cent_b1,2);
ts_cent_b2 = mean(ts_cent_b2,3); ts_cent_b2 = mean(ts_cent_b2,2);

% Gamma
hc_front_g1 = hc_front(:,30:54,513:564);hc_front_g2 = hc_front(:,30:54,718:769); 
hc_par_g1 = hc_par(:,30:54,513:564);hc_par_g2 = hc_par(:,30:54,718:769); 
hc_Ltemp_g1 = hc_Ltemp(:,30:54,513:564);hc_Ltemp_g2 = hc_Ltemp(:,30:54,718:769); 
hc_Rtemp_g1 = hc_Rtemp(:,30:54,513:564);hc_Rtemp_g2 = hc_Rtemp(:,30:54,718:769); 
hc_cent_g1 = hc_cent(:,30:54,513:564);hc_cent_g2 = hc_cent(:,30:54,718:769); 

ts_front_g1 = ts_front(:,30:54,513:564);ts_front_g2 = ts_front(:,30:54,718:769); 
ts_par_g1 = ts_par(:,30:54,513:564);ts_par_g2 = ts_par(:,30:54,718:769); 
ts_Ltemp_g1 = ts_Ltemp(:,30:54,513:564);ts_Ltemp_g2 = ts_Ltemp(:,30:54,718:769); 
ts_Rtemp_g1 = ts_Rtemp(:,30:54,513:564);ts_Rtemp_g2 = ts_Rtemp(:,30:54,718:769); 
ts_cent_g1 = ts_cent(:,30:54,513:564);ts_cent_g2 = ts_cent(:,30:54,718:769); 

hc_front_g1 = mean(hc_front_g1,3); hc_front_g1 = mean(hc_front_g1,2);
hc_front_g2 = mean(hc_front_g2,3); hc_front_g2 = mean(hc_front_g2,2);
hc_par_g1 = mean(hc_par_g1,3); hc_par_g1 = mean(hc_par_g1,2);
hc_par_g2 = mean(hc_par_g2,3); hc_par_g2 = mean(hc_par_g2,2);
hc_Ltemp_g1 = mean(hc_Ltemp_g1,3); hc_Ltemp_g1 = mean(hc_Ltemp_g1,2);
hc_Ltemp_g2 = mean(hc_Ltemp_g2,3); hc_Ltemp_g2 = mean(hc_Ltemp_g2,2);
hc_Rtemp_g1 = mean(hc_Rtemp_g1,3); hc_Rtemp_g1 = mean(hc_Rtemp_g1,2);
hc_Rtemp_g2 = mean(hc_Rtemp_g2,3); hc_Rtemp_g2 = mean(hc_Rtemp_g2,2);
hc_cent_g1 = mean(hc_cent_g1,3); hc_cent_g1 = mean(hc_cent_g1,2);
hc_cent_g2 = mean(hc_cent_g2,3); hc_cent_g2 = mean(hc_cent_g2,2);

ts_front_g1 = mean(ts_front_g1,3); ts_front_g1 = mean(ts_front_g1,2);
ts_front_g2 = mean(ts_front_g2,3); ts_front_g2 = mean(ts_front_g2,2);
ts_par_g1 = mean(ts_par_g1,3);ts_par_g1 = mean(ts_par_g1,2);
ts_par_g2 = mean(ts_par_g2,3);ts_par_g2 = mean(ts_par_g2,2);
ts_Ltemp_g1 = mean(ts_Ltemp_g1,3);ts_Ltemp_g1 = mean(ts_Ltemp_g1,2);
ts_Ltemp_g2 = mean(ts_Ltemp_g2,3);ts_Ltemp_g2 = mean(ts_Ltemp_g2,2);
ts_Rtemp_g1 = mean(ts_Rtemp_g1,3);ts_Rtemp_g1 = mean(ts_Rtemp_g1,2);
ts_Rtemp_g2 = mean(ts_Rtemp_g2,3);ts_Rtemp_g2 = mean(ts_Rtemp_g2,2);
ts_cent_g1 = mean(ts_cent_g1,3); ts_cent_g1 = mean(ts_cent_g1,2);
ts_cent_g2 = mean(ts_cent_g2,3); ts_cent_g2 = mean(ts_cent_g2,2);

clear hc_front hc_par hc_Ltemp hc_Rtemp ts_front ts_par ts_Ltemp ts_Rtemp hc_cent ts_cent

hc_aud_gating = [hc_front_a1,hc_front_a2,hc_par_a1,hc_par_a2,hc_Ltemp_a1,hc_Ltemp_a2,...
    hc_Rtemp_a1,hc_Rtemp_a2,hc_cent_a1,hc_cent_a2,...
    hc_front_b1,hc_front_b2,hc_par_b1,hc_par_b2,hc_Ltemp_b1,hc_Ltemp_b2,...
    hc_Rtemp_b1,hc_Rtemp_b2,hc_cent_b1,hc_cent_b2,...
    hc_front_g1,hc_front_g2,hc_par_g1,hc_par_g2,hc_Ltemp_g1,hc_Ltemp_g2,...
    hc_Rtemp_g1,hc_Rtemp_g2,hc_cent_g1,hc_cent_g2];
ts_aud_gating = [ts_front_a1,ts_front_a2,ts_par_a1,ts_par_a2,ts_Ltemp_a1,ts_Ltemp_a2,...
    ts_Rtemp_a1,ts_Rtemp_a2,ts_cent_a1,ts_cent_a2,...
    ts_front_b1,ts_front_b2,ts_par_b1,ts_par_b2,ts_Ltemp_b1,ts_Ltemp_b2,...
    ts_Rtemp_b1,ts_Rtemp_b2,ts_cent_b1,ts_cent_b2,...
    ts_front_g1,ts_front_g2,ts_par_g1,ts_par_g2,ts_Ltemp_g1,ts_Ltemp_g2,...
    ts_Rtemp_g1,ts_Rtemp_g2,ts_cent_g1,ts_cent_g2];

clear hc_front_a1 hc_front_a2 hc_par_a1 hc_par_a2 hc_Ltemp_a1 hc_Ltemp_a2 hc_Rtemp_a1 hc_Rtemp_a2 hc_cent_a1 hc_cent_a2
clear ts_front_a1 ts_front_a2 ts_par_a1 ts_par_a2 ts_Ltemp_a1 ts_Ltemp_a2 ts_Rtemp_a1 ts_Rtemp_a2 ts_cent_a1 ts_cent_a2
clear hc_front_b1 hc_front_b2 hc_par_b1 hc_par_b2 hc_Ltemp_b1 hc_Ltemp_b2 hc_Rtemp_b1 hc_Rtemp_b2 hc_cent_b1 hc_cent_b2
clear hc_front_g1 hc_front_g2 hc_par_g1 hc_par_g2 hc_Ltemp_g1 hc_Ltemp_g2 hc_Rtemp_g1 hc_Rtemp_g2 hc_cent_g1 hc_cent_g2
clear ts_front_b1 ts_front_b2 ts_par_b1 ts_par_b2 ts_Ltemp_b1 ts_Ltemp_b2 ts_Rtemp_b1 ts_Rtemp_b2 ts_cent_b1 ts_cent_b2
clear ts_front_g1 ts_front_g2 ts_par_g1 ts_par_g2 ts_Ltemp_g1 ts_Ltemp_g2 ts_Rtemp_g1 ts_Rtemp_g2 ts_cent_g1 ts_cent_g2

%% Load and extract SERP Gating data for S1 and S2
% Alpha, Beta and Gamma power at 0-100ms following S1 and S2
% S1 times 0-100 = 513:564  S2 times 0-100 = 769:820
% beta = frex(13:29); gamma = frex(30:54);
% Load data for t-test in section at line 620

% Alpha
hc_front_a1 = hc_front(:,7:12,513:564);hc_front_a2 = hc_front(:,7:12,769:820); 
hc_par_a1 = hc_par(:,7:12,513:564);hc_par_a2 = hc_par(:,7:12,769:820); 
hc_Ltemp_a1 = hc_Ltemp(:,7:12,513:564);hc_Ltemp_a2 = hc_Ltemp(:,7:12,769:820); 
hc_Rtemp_a1 = hc_Rtemp(:,7:12,513:564);hc_Rtemp_a2 = hc_Rtemp(:,7:12,769:820); 
hc_cent_a1 = hc_cent(:,7:12,513:564);hc_cent_a2 = hc_cent(:,7:12,769:820);

ts_front_a1 = ts_front(:,7:12,513:564);ts_front_a2 = ts_front(:,7:12,769:820); 
ts_par_a1 = ts_par(:,7:12,513:564);ts_par_a2 = ts_par(:,7:12,769:820); 
ts_Ltemp_a1 = ts_Ltemp(:,7:12,513:564);ts_Ltemp_a2 = ts_Ltemp(:,7:12,769:820); 
ts_Rtemp_a1 = ts_Rtemp(:,7:12,513:564);ts_Rtemp_a2 = ts_Rtemp(:,7:12,769:820);
ts_cent_a1 = ts_cent(:,7:12,513:564);ts_cent_a2 = ts_cent(:,7:12,769:820);

hc_front_a1 = mean(hc_front_a1,3); hc_front_a1 = mean(hc_front_a1,2);
hc_front_a2 = mean(hc_front_a2,3); hc_front_a2 = mean(hc_front_a2,2);
hc_par_a1 = mean(hc_par_a1,3); hc_par_a1 = mean(hc_par_a1,2);
hc_par_a2 = mean(hc_par_a2,3); hc_par_a2 = mean(hc_par_a2,2);
hc_Ltemp_a1 = mean(hc_Ltemp_a1,3); hc_Ltemp_a1 = mean(hc_Ltemp_a1,2);
hc_Ltemp_a2 = mean(hc_Ltemp_a2,3); hc_Ltemp_a2 = mean(hc_Ltemp_a2,2);
hc_Rtemp_a1 = mean(hc_Rtemp_a1,3); hc_Rtemp_a1 = mean(hc_Rtemp_a1,2);
hc_Rtemp_a2 = mean(hc_Rtemp_a2,3); hc_Rtemp_a2 = mean(hc_Rtemp_a2,2);
hc_cent_a1 = mean(hc_cent_a1,3); hc_cent_a1 = mean(hc_cent_a1,2);
hc_cent_a2 = mean(hc_cent_a2,3); hc_cent_a2 = mean(hc_cent_a2,2);

ts_front_a1 = mean(ts_front_a1,3); ts_front_a1 = mean(ts_front_a1,2);
ts_front_a2 = mean(ts_front_a2,3); ts_front_a2 = mean(ts_front_a2,2);
ts_par_a1 = mean(ts_par_a1,3);ts_par_a1 = mean(ts_par_a1,2);
ts_par_a2 = mean(ts_par_a2,3);ts_par_a2 = mean(ts_par_a2,2);
ts_Ltemp_a1 = mean(ts_Ltemp_a1,3);ts_Ltemp_a1 = mean(ts_Ltemp_a1,2);
ts_Ltemp_a2 = mean(ts_Ltemp_a2,3);ts_Ltemp_a2 = mean(ts_Ltemp_a2,2);
ts_Rtemp_a1 = mean(ts_Rtemp_a1,3);ts_Rtemp_a1 = mean(ts_Rtemp_a1,2);
ts_Rtemp_a2 = mean(ts_Rtemp_a2,3);ts_Rtemp_a2 = mean(ts_Rtemp_a2,2);
ts_cent_a1 = mean(ts_cent_a1,3); ts_cent_a1 = mean(ts_cent_a1,2);
ts_cent_a2 = mean(ts_cent_a2,3); ts_cent_a2 = mean(ts_cent_a2,2);

% Beta
hc_front_b1 = hc_front(:,13:29,513:564);hc_front_b2 = hc_front(:,13:29,769:820); 
hc_par_b1 = hc_par(:,13:29,513:564);hc_par_b2 = hc_par(:,13:29,769:820); 
hc_Ltemp_b1 = hc_Ltemp(:,13:29,513:564);hc_Ltemp_b2 = hc_Ltemp(:,13:29,769:820); 
hc_Rtemp_b1 = hc_Rtemp(:,13:29,513:564);hc_Rtemp_b2 = hc_Rtemp(:,13:29,769:820); 
hc_cent_b1 = hc_cent(:,13:29,513:564);hc_cent_b2 = hc_cent(:,13:29,769:820);

ts_front_b1 = ts_front(:,13:29,513:564);ts_front_b2 = ts_front(:,13:29,769:820); 
ts_par_b1 = ts_par(:,13:29,513:564);ts_par_b2 = ts_par(:,13:29,769:820); 
ts_Ltemp_b1 = ts_Ltemp(:,13:29,513:564);ts_Ltemp_b2 = ts_Ltemp(:,13:29,769:820); 
ts_Rtemp_b1 = ts_Rtemp(:,13:29,513:564);ts_Rtemp_b2 = ts_Rtemp(:,13:29,769:820);
ts_cent_b1 = ts_cent(:,13:29,513:564);ts_cent_b2 = ts_cent(:,13:29,769:820);

hc_front_b1 = mean(hc_front_b1,3); hc_front_b1 = mean(hc_front_b1,2);
hc_front_b2 = mean(hc_front_b2,3); hc_front_b2 = mean(hc_front_b2,2);
hc_par_b1 = mean(hc_par_b1,3); hc_par_b1 = mean(hc_par_b1,2);
hc_par_b2 = mean(hc_par_b2,3); hc_par_b2 = mean(hc_par_b2,2);
hc_Ltemp_b1 = mean(hc_Ltemp_b1,3); hc_Ltemp_b1 = mean(hc_Ltemp_b1,2);
hc_Ltemp_b2 = mean(hc_Ltemp_b2,3); hc_Ltemp_b2 = mean(hc_Ltemp_b2,2);
hc_Rtemp_b1 = mean(hc_Rtemp_b1,3); hc_Rtemp_b1 = mean(hc_Rtemp_b1,2);
hc_Rtemp_b2 = mean(hc_Rtemp_b2,3); hc_Rtemp_b2 = mean(hc_Rtemp_b2,2);
hc_cent_b1 = mean(hc_cent_b1,3); hc_cent_b1 = mean(hc_cent_b1,2);
hc_cent_b2 = mean(hc_cent_b2,3); hc_cent_b2 = mean(hc_cent_b2,2);

ts_front_b1 = mean(ts_front_b1,3); ts_front_b1 = mean(ts_front_b1,2);
ts_front_b2 = mean(ts_front_b2,3); ts_front_b2 = mean(ts_front_b2,2);
ts_par_b1 = mean(ts_par_b1,3);ts_par_b1 = mean(ts_par_b1,2);
ts_par_b2 = mean(ts_par_b2,3);ts_par_b2 = mean(ts_par_b2,2);
ts_Ltemp_b1 = mean(ts_Ltemp_b1,3);ts_Ltemp_b1 = mean(ts_Ltemp_b1,2);
ts_Ltemp_b2 = mean(ts_Ltemp_b2,3);ts_Ltemp_b2 = mean(ts_Ltemp_b2,2);
ts_Rtemp_b1 = mean(ts_Rtemp_b1,3);ts_Rtemp_b1 = mean(ts_Rtemp_b1,2);
ts_Rtemp_b2 = mean(ts_Rtemp_b2,3);ts_Rtemp_b2 = mean(ts_Rtemp_b2,2);
ts_cent_b1 = mean(ts_cent_b1,3); ts_cent_b1 = mean(ts_cent_b1,2);
ts_cent_b2 = mean(ts_cent_b2,3); ts_cent_b2 = mean(ts_cent_b2,2);

% Gamma
hc_front_g1 = hc_front(:,30:54,513:564);hc_front_g2 = hc_front(:,30:54,769:820); 
hc_par_g1 = hc_par(:,30:54,513:564);hc_par_g2 = hc_par(:,30:54,769:820); 
hc_Ltemp_g1 = hc_Ltemp(:,30:54,513:564);hc_Ltemp_g2 = hc_Ltemp(:,30:54,769:820); 
hc_Rtemp_g1 = hc_Rtemp(:,30:54,513:564);hc_Rtemp_g2 = hc_Rtemp(:,30:54,769:820);
hc_cent_g1 = hc_cent(:,30:54,513:564);hc_cent_g2 = hc_cent(:,30:54,769:820);

ts_front_g1 = ts_front(:,30:54,513:564);ts_front_g2 = ts_front(:,30:54,769:820); 
ts_par_g1 = ts_par(:,30:54,513:564);ts_par_g2 = ts_par(:,30:54,769:820); 
ts_Ltemp_g1 = ts_Ltemp(:,30:54,513:564);ts_Ltemp_g2 = ts_Ltemp(:,30:54,769:820); 
ts_Rtemp_g1 = ts_Rtemp(:,30:54,513:564);ts_Rtemp_g2 = ts_Rtemp(:,30:54,769:820); 
ts_cent_g1 = ts_cent(:,30:54,513:564);ts_cent_g2 = ts_cent(:,30:54,769:820);

hc_front_g1 = mean(hc_front_g1,3); hc_front_g1 = mean(hc_front_g1,2);
hc_front_g2 = mean(hc_front_g2,3); hc_front_g2 = mean(hc_front_g2,2);
hc_par_g1 = mean(hc_par_g1,3); hc_par_g1 = mean(hc_par_g1,2);
hc_par_g2 = mean(hc_par_g2,3); hc_par_g2 = mean(hc_par_g2,2);
hc_Ltemp_g1 = mean(hc_Ltemp_g1,3); hc_Ltemp_g1 = mean(hc_Ltemp_g1,2);
hc_Ltemp_g2 = mean(hc_Ltemp_g2,3); hc_Ltemp_g2 = mean(hc_Ltemp_g2,2);
hc_Rtemp_g1 = mean(hc_Rtemp_g1,3); hc_Rtemp_g1 = mean(hc_Rtemp_g1,2);
hc_Rtemp_g2 = mean(hc_Rtemp_g2,3); hc_Rtemp_g2 = mean(hc_Rtemp_g2,2);
hc_cent_g1 = mean(hc_cent_g1,3); hc_cent_g1 = mean(hc_cent_g1,2);
hc_cent_g2 = mean(hc_cent_g2,3); hc_cent_g2 = mean(hc_cent_g2,2);

ts_front_g1 = mean(ts_front_g1,3); ts_front_g1 = mean(ts_front_g1,2);
ts_front_g2 = mean(ts_front_g2,3); ts_front_g2 = mean(ts_front_g2,2);
ts_par_g1 = mean(ts_par_g1,3);ts_par_g1 = mean(ts_par_g1,2);
ts_par_g2 = mean(ts_par_g2,3);ts_par_g2 = mean(ts_par_g2,2);
ts_Ltemp_g1 = mean(ts_Ltemp_g1,3);ts_Ltemp_g1 = mean(ts_Ltemp_g1,2);
ts_Ltemp_g2 = mean(ts_Ltemp_g2,3);ts_Ltemp_g2 = mean(ts_Ltemp_g2,2);
ts_Rtemp_g1 = mean(ts_Rtemp_g1,3);ts_Rtemp_g1 = mean(ts_Rtemp_g1,2);
ts_Rtemp_g2 = mean(ts_Rtemp_g2,3);ts_Rtemp_g2 = mean(ts_Rtemp_g2,2);
ts_cent_g1 = mean(ts_cent_g1,3); ts_cent_g1 = mean(ts_cent_g1,2);
ts_cent_g2 = mean(ts_cent_g2,3); ts_cent_g2 = mean(ts_cent_g2,2);

clear hc_front hc_par hc_Ltemp hc_Rtemp ts_front ts_par ts_Ltemp ts_Rtemp hc_cent ts_cent

hc_tact_gating = [hc_front_a1,hc_front_a2,hc_par_a1,hc_par_a2,hc_Ltemp_a1,hc_Ltemp_a2,...
    hc_Rtemp_a1,hc_Rtemp_a2,hc_cent_a1,hc_cent_a2,...
    hc_front_b1,hc_front_b2,hc_par_b1,hc_par_b2,hc_Ltemp_b1,hc_Ltemp_b2,...
    hc_Rtemp_b1,hc_Rtemp_b2,hc_cent_b1,hc_cent_b2,...
    hc_front_g1,hc_front_g2,hc_par_g1,hc_par_g2,hc_Ltemp_g1,hc_Ltemp_g2,...
    hc_Rtemp_g1,hc_Rtemp_g2,hc_cent_g1,hc_cent_g2];
ts_tact_gating = [ts_front_a1,ts_front_a2,ts_par_a1,ts_par_a2,ts_Ltemp_a1,ts_Ltemp_a2,...
    ts_Rtemp_a1,ts_Rtemp_a2,ts_cent_a1,ts_cent_a2,...
    ts_front_b1,ts_front_b2,ts_par_b1,ts_par_b2,ts_Ltemp_b1,ts_Ltemp_b2,...
    ts_Rtemp_b1,ts_Rtemp_b2,ts_cent_b1,ts_cent_b2,...
    ts_front_g1,ts_front_g2,ts_par_g1,ts_par_g2,ts_Ltemp_g1,ts_Ltemp_g2,...
    ts_Rtemp_g1,ts_Rtemp_g2,ts_cent_g1,ts_cent_g2];

clear hc_front_a1 hc_front_a2 hc_par_a1 hc_par_a2 hc_Ltemp_a1 hc_Ltemp_a2 hc_Rtemp_a1 hc_Rtemp_a2 hc_cent_a1 hc_cent_a2
clear ts_front_a1 ts_front_a2 ts_par_a1 ts_par_a2 ts_Ltemp_a1 ts_Ltemp_a2 ts_Rtemp_a1 ts_Rtemp_a2 ts_cent_a1 ts_cent_a2
clear hc_front_b1 hc_front_b2 hc_par_b1 hc_par_b2 hc_Ltemp_b1 hc_Ltemp_b2 hc_Rtemp_b1 hc_Rtemp_b2 hc_cent_b1 hc_cent_b2
clear hc_front_g1 hc_front_g2 hc_par_g1 hc_par_g2 hc_Ltemp_g1 hc_Ltemp_g2 hc_Rtemp_g1 hc_Rtemp_g2 hc_cent_g1 hc_cent_g2
clear ts_front_b1 ts_front_b2 ts_par_b1 ts_par_b2 ts_Ltemp_b1 ts_Ltemp_b2 ts_Rtemp_b1 ts_Rtemp_b2 ts_cent_b1 ts_cent_b2
clear ts_front_g1 ts_front_g2 ts_par_g1 ts_par_g2 ts_Ltemp_g1 ts_Ltemp_g2 ts_Rtemp_g1 ts_Rtemp_g2 ts_cent_g1 ts_cent_g2

%% Load and extract AERP N100 data for S1 and S2
% Beta and Gamma power at 100-200ms following S1 and S2
% S1 times 100-200 = 564:615  S2 times 100-200 = 769:820
% beta = frex(13:29); gamma = frex(30:54);
% Load data for t-test in section at line 600

% Alpha

hc_front_a1 = hc_front(:,7:12,564:615);hc_front_a2 = hc_front(:,7:12,769:820); 
hc_par_a1 = hc_par(:,7:12,564:615);hc_par_a2 = hc_par(:,7:12,769:820); 
hc_Ltemp_a1 = hc_Ltemp(:,7:12,564:615);hc_Ltemp_a2 = hc_Ltemp(:,7:12,769:820); 
hc_Rtemp_a1 = hc_Rtemp(:,7:12,564:615);hc_Rtemp_a2 = hc_Rtemp(:,7:12,769:820); 
hc_cent_a1 = hc_cent(:,7:12,564:615);hc_cent_a2 = hc_cent(:,7:12,769:820);

ts_front_a1 = ts_front(:,7:12,564:615);ts_front_a2 = ts_front(:,7:12,769:820); 
ts_par_a1 = ts_par(:,7:12,564:615);ts_par_a2 = ts_par(:,7:12,769:820); 
ts_Ltemp_a1 = ts_Ltemp(:,7:12,564:615);ts_Ltemp_a2 = ts_Ltemp(:,7:12,769:820); 
ts_Rtemp_a1 = ts_Rtemp(:,7:12,564:615);ts_Rtemp_a2 = ts_Rtemp(:,7:12,769:820); 
ts_cent_a1 = ts_cent(:,7:12,564:615);ts_cent_a2 = ts_cent(:,7:12,769:820);

hc_front_a1 = mean(hc_front_a1,3); hc_front_a1 = mean(hc_front_a1,2);
hc_front_a2 = mean(hc_front_a2,3); hc_front_a2 = mean(hc_front_a2,2);
hc_par_a1 = mean(hc_par_a1,3); hc_par_a1 = mean(hc_par_a1,2);
hc_par_a2 = mean(hc_par_a2,3); hc_par_a2 = mean(hc_par_a2,2);
hc_Ltemp_a1 = mean(hc_Ltemp_a1,3); hc_Ltemp_a1 = mean(hc_Ltemp_a1,2);
hc_Ltemp_a2 = mean(hc_Ltemp_a2,3); hc_Ltemp_a2 = mean(hc_Ltemp_a2,2);
hc_Rtemp_a1 = mean(hc_Rtemp_a1,3); hc_Rtemp_a1 = mean(hc_Rtemp_a1,2);
hc_Rtemp_a2 = mean(hc_Rtemp_a2,3); hc_Rtemp_a2 = mean(hc_Rtemp_a2,2);
hc_cent_a1 = mean(hc_cent_a1,3); hc_cent_a1 = mean(hc_cent_a1,2);
hc_cent_a2 = mean(hc_cent_a2,3); hc_cent_a2 = mean(hc_cent_a2,2);

ts_front_a1 = mean(ts_front_a1,3); ts_front_a1 = mean(ts_front_a1,2);
ts_front_a2 = mean(ts_front_a2,3); ts_front_a2 = mean(ts_front_a2,2);
ts_par_a1 = mean(ts_par_a1,3);ts_par_a1 = mean(ts_par_a1,2);
ts_par_a2 = mean(ts_par_a2,3);ts_par_a2 = mean(ts_par_a2,2);
ts_Ltemp_a1 = mean(ts_Ltemp_a1,3);ts_Ltemp_a1 = mean(ts_Ltemp_a1,2);
ts_Ltemp_a2 = mean(ts_Ltemp_a2,3);ts_Ltemp_a2 = mean(ts_Ltemp_a2,2);
ts_Rtemp_a1 = mean(ts_Rtemp_a1,3);ts_Rtemp_a1 = mean(ts_Rtemp_a1,2);
ts_Rtemp_a2 = mean(ts_Rtemp_a2,3);ts_Rtemp_a2 = mean(ts_Rtemp_a2,2);
ts_cent_a1 = mean(ts_cent_a1,3); ts_cent_a1 = mean(ts_cent_a1,2);
ts_cent_a2 = mean(ts_cent_a2,3); ts_cent_a2 = mean(ts_cent_a2,2);

% Beta
hc_front_b1 = hc_front(:,13:29,513:564);hc_front_b2 = hc_front(:,13:29,769:820); 
hc_par_b1 = hc_par(:,13:29,513:564);hc_par_b2 = hc_par(:,13:29,769:820); 
hc_Ltemp_b1 = hc_Ltemp(:,13:29,513:564);hc_Ltemp_b2 = hc_Ltemp(:,13:29,769:820); 
hc_Rtemp_b1 = hc_Rtemp(:,13:29,513:564);hc_Rtemp_b2 = hc_Rtemp(:,13:29,769:820); 
hc_cent_b1 = hc_cent(:,13:29,513:564);hc_cent_b2 = hc_cent(:,13:29,769:820);

ts_front_b1 = ts_front(:,13:29,513:564);ts_front_b2 = ts_front(:,13:29,769:820); 
ts_par_b1 = ts_par(:,13:29,513:564);ts_par_b2 = ts_par(:,13:29,769:820); 
ts_Ltemp_b1 = ts_Ltemp(:,13:29,513:564);ts_Ltemp_b2 = ts_Ltemp(:,13:29,769:820); 
ts_Rtemp_b1 = ts_Rtemp(:,13:29,513:564);ts_Rtemp_b2 = ts_Rtemp(:,13:29,769:820); 
ts_cent_b1 = ts_cent(:,13:29,513:564);ts_cent_b2 = ts_cent(:,13:29,769:820);

hc_front_b1 = mean(hc_front_b1,3); hc_front_b1 = mean(hc_front_b1,2);
hc_front_b2 = mean(hc_front_b2,3); hc_front_b2 = mean(hc_front_b2,2);
hc_par_b1 = mean(hc_par_b1,3); hc_par_b1 = mean(hc_par_b1,2);
hc_par_b2 = mean(hc_par_b2,3); hc_par_b2 = mean(hc_par_b2,2);
hc_Ltemp_b1 = mean(hc_Ltemp_b1,3); hc_Ltemp_b1 = mean(hc_Ltemp_b1,2);
hc_Ltemp_b2 = mean(hc_Ltemp_b2,3); hc_Ltemp_b2 = mean(hc_Ltemp_b2,2);
hc_Rtemp_b1 = mean(hc_Rtemp_b1,3); hc_Rtemp_b1 = mean(hc_Rtemp_b1,2);
hc_Rtemp_b2 = mean(hc_Rtemp_b2,3); hc_Rtemp_b2 = mean(hc_Rtemp_b2,2);
hc_cent_b1 = mean(hc_cent_b1,3); hc_cent_b1 = mean(hc_cent_b1,2);
hc_cent_b2 = mean(hc_cent_b2,3); hc_cent_b2 = mean(hc_cent_b2,2);

ts_front_b1 = mean(ts_front_b1,3); ts_front_b1 = mean(ts_front_b1,2);
ts_front_b2 = mean(ts_front_b2,3); ts_front_b2 = mean(ts_front_b2,2);
ts_par_b1 = mean(ts_par_b1,3);ts_par_b1 = mean(ts_par_b1,2);
ts_par_b2 = mean(ts_par_b2,3);ts_par_b2 = mean(ts_par_b2,2);
ts_Ltemp_b1 = mean(ts_Ltemp_b1,3);ts_Ltemp_b1 = mean(ts_Ltemp_b1,2);
ts_Ltemp_b2 = mean(ts_Ltemp_b2,3);ts_Ltemp_b2 = mean(ts_Ltemp_b2,2);
ts_Rtemp_b1 = mean(ts_Rtemp_b1,3);ts_Rtemp_b1 = mean(ts_Rtemp_b1,2);
ts_Rtemp_b2 = mean(ts_Rtemp_b2,3);ts_Rtemp_b2 = mean(ts_Rtemp_b2,2);
ts_cent_b1 = mean(ts_cent_b1,3); ts_cent_b1 = mean(ts_cent_b1,2);
ts_cent_b2 = mean(ts_cent_b2,3); ts_cent_b2 = mean(ts_cent_b2,2);

% Gamma
hc_front_g1 = hc_front(:,30:54,513:564);hc_front_g2 = hc_front(:,30:54,769:820); 
hc_par_g1 = hc_par(:,30:54,513:564);hc_par_g2 = hc_par(:,30:54,769:820); 
hc_Ltemp_g1 = hc_Ltemp(:,30:54,513:564);hc_Ltemp_g2 = hc_Ltemp(:,30:54,769:820); 
hc_Rtemp_g1 = hc_Rtemp(:,30:54,513:564);hc_Rtemp_g2 = hc_Rtemp(:,30:54,769:820); 
hc_cent_g1 = hc_cent(:,30:54,513:564);hc_cent_g2 = hc_cent(:,30:54,769:820); 

ts_front_g1 = ts_front(:,30:54,513:564);ts_front_g2 = ts_front(:,30:54,769:820); 
ts_par_g1 = ts_par(:,30:54,513:564);ts_par_g2 = ts_par(:,30:54,769:820); 
ts_Ltemp_g1 = ts_Ltemp(:,30:54,513:564);ts_Ltemp_g2 = ts_Ltemp(:,30:54,769:820); 
ts_Rtemp_g1 = ts_Rtemp(:,30:54,513:564);ts_Rtemp_g2 = ts_Rtemp(:,30:54,769:820); 
ts_cent_g1 = ts_cent(:,30:54,513:564);ts_cent_g2 = ts_cent(:,30:54,769:820); 

hc_front_g1 = mean(hc_front_g1,3); hc_front_g1 = mean(hc_front_g1,2);
hc_front_g2 = mean(hc_front_g2,3); hc_front_g2 = mean(hc_front_g2,2);
hc_par_g1 = mean(hc_par_g1,3); hc_par_g1 = mean(hc_par_g1,2);
hc_par_g2 = mean(hc_par_g2,3); hc_par_g2 = mean(hc_par_g2,2);
hc_Ltemp_g1 = mean(hc_Ltemp_g1,3); hc_Ltemp_g1 = mean(hc_Ltemp_g1,2);
hc_Ltemp_g2 = mean(hc_Ltemp_g2,3); hc_Ltemp_g2 = mean(hc_Ltemp_g2,2);
hc_Rtemp_g1 = mean(hc_Rtemp_g1,3); hc_Rtemp_g1 = mean(hc_Rtemp_g1,2);
hc_Rtemp_g2 = mean(hc_Rtemp_g2,3); hc_Rtemp_g2 = mean(hc_Rtemp_g2,2);
hc_cent_g1 = mean(hc_cent_g1,3); hc_cent_g1 = mean(hc_cent_g1,2);
hc_cent_g2 = mean(hc_cent_g2,3); hc_cent_g2 = mean(hc_cent_g2,2);

ts_front_g1 = mean(ts_front_g1,3); ts_front_g1 = mean(ts_front_g1,2);
ts_front_g2 = mean(ts_front_g2,3); ts_front_g2 = mean(ts_front_g2,2);
ts_par_g1 = mean(ts_par_g1,3);ts_par_g1 = mean(ts_par_g1,2);
ts_par_g2 = mean(ts_par_g2,3);ts_par_g2 = mean(ts_par_g2,2);
ts_Ltemp_g1 = mean(ts_Ltemp_g1,3);ts_Ltemp_g1 = mean(ts_Ltemp_g1,2);
ts_Ltemp_g2 = mean(ts_Ltemp_g2,3);ts_Ltemp_g2 = mean(ts_Ltemp_g2,2);
ts_Rtemp_g1 = mean(ts_Rtemp_g1,3);ts_Rtemp_g1 = mean(ts_Rtemp_g1,2);
ts_Rtemp_g2 = mean(ts_Rtemp_g2,3);ts_Rtemp_g2 = mean(ts_Rtemp_g2,2);
ts_cent_g1 = mean(ts_cent_g1,3); ts_cent_g1 = mean(ts_cent_g1,2);
ts_cent_g2 = mean(ts_cent_g2,3); ts_cent_g2 = mean(ts_cent_g2,2);

clear hc_front hc_par hc_Ltemp hc_Rtemp ts_front ts_par ts_Ltemp ts_Rtemp hc_cent ts_cent

hc_aud_n100 = [hc_front_a1,hc_front_a2,hc_par_a1,hc_par_a2,hc_Ltemp_a1,hc_Ltemp_a2,...
    hc_Rtemp_a1,hc_Rtemp_a2,hc_cent_a1,hc_cent_a2,...
    hc_front_b1,hc_front_b2,hc_par_b1,hc_par_b2,hc_Ltemp_b1,hc_Ltemp_b2,...
    hc_Rtemp_b1,hc_Rtemp_b2,hc_cent_b1,hc_cent_b2,...
    hc_front_g1,hc_front_g2,hc_par_g1,hc_par_g2,hc_Ltemp_g1,hc_Ltemp_g2,...
    hc_Rtemp_g1,hc_Rtemp_g2,hc_cent_g1,hc_cent_g2];
ts_aud_n100 = [ts_front_a1,ts_front_a2,ts_par_a1,ts_par_a2,ts_Ltemp_a1,ts_Ltemp_a2,...
    ts_Rtemp_a1,ts_Rtemp_a2,ts_cent_a1,ts_cent_a2,...
    ts_front_b1,ts_front_b2,ts_par_b1,ts_par_b2,ts_Ltemp_b1,ts_Ltemp_b2,...
    ts_Rtemp_b1,ts_Rtemp_b2,ts_cent_b1,ts_cent_b2,...
    ts_front_g1,ts_front_g2,ts_par_g1,ts_par_g2,ts_Ltemp_g1,ts_Ltemp_g2,...
    ts_Rtemp_g1,ts_Rtemp_g2,ts_cent_g1,ts_cent_g2];

clear hc_front_a1 hc_front_a2 hc_par_a1 hc_par_a2 hc_Ltemp_a1 hc_Ltemp_a2 hc_Rtemp_a1 hc_Rtemp_a2 hc_cent_a1 hc_cent_a2
clear ts_front_a1 ts_front_a2 ts_par_a1 ts_par_a2 ts_Ltemp_a1 ts_Ltemp_a2 ts_Rtemp_a1 ts_Rtemp_a2 ts_cent_a1 ts_cent_a2
clear hc_front_b1 hc_front_b2 hc_par_b1 hc_par_b2 hc_Ltemp_b1 hc_Ltemp_b2 hc_Rtemp_b1 hc_Rtemp_b2 hc_cent_b1 hc_cent_b2
clear hc_front_g1 hc_front_g2 hc_par_g1 hc_par_g2 hc_Ltemp_g1 hc_Ltemp_g2 hc_Rtemp_g1 hc_Rtemp_g2 hc_cent_g1 hc_cent_g2
clear ts_front_b1 ts_front_b2 ts_par_b1 ts_par_b2 ts_Ltemp_b1 ts_Ltemp_b2 ts_Rtemp_b1 ts_Rtemp_b2 ts_cent_b1 ts_cent_b2
clear ts_front_g1 ts_front_g2 ts_par_g1 ts_par_g2 ts_Ltemp_g1 ts_Ltemp_g2 ts_Rtemp_g1 ts_Rtemp_g2 ts_cent_g1 ts_cent_g2

%% Load and extract SERP N100 data for S1 and S2
% Alpha, Beta and Gamma power at 100-200ms following S1 and S2
% S1 times 100-200 = 564:615  S2 times 100-200 = 820:871
% beta = frex(13:29); gamma = frex(30:54);
% Load data for t-test in section at line 620

% Alpha
hc_front_a1 = hc_front(:,7:12,564:615);hc_front_a2 = hc_front(:,7:12,820:871); 
hc_par_a1 = hc_par(:,7:12,564:615);hc_par_a2 = hc_par(:,7:12,820:871); 
hc_Ltemp_a1 = hc_Ltemp(:,7:12,564:615);hc_Ltemp_a2 = hc_Ltemp(:,7:12,820:871); 
hc_Rtemp_a1 = hc_Rtemp(:,7:12,564:615);hc_Rtemp_a2 = hc_Rtemp(:,7:12,820:871); 
hc_cent_a1 = hc_cent(:,7:12,564:615);hc_cent_a2 = hc_cent(:,7:12,820:871);

ts_front_a1 = ts_front(:,7:12,564:615);ts_front_a2 = ts_front(:,7:12,820:871); 
ts_par_a1 = ts_par(:,7:12,564:615);ts_par_a2 = ts_par(:,7:12,820:871); 
ts_Ltemp_a1 = ts_Ltemp(:,7:12,564:615);ts_Ltemp_a2 = ts_Ltemp(:,7:12,820:871); 
ts_Rtemp_a1 = ts_Rtemp(:,7:12,564:615);ts_Rtemp_a2 = ts_Rtemp(:,7:12,820:871);
ts_cent_a1 = ts_cent(:,7:12,564:615);ts_cent_a2 = ts_cent(:,7:12,820:871);

hc_front_a1 = mean(hc_front_a1,3); hc_front_a1 = mean(hc_front_a1,2);
hc_front_a2 = mean(hc_front_a2,3); hc_front_a2 = mean(hc_front_a2,2);
hc_par_a1 = mean(hc_par_a1,3); hc_par_a1 = mean(hc_par_a1,2);
hc_par_a2 = mean(hc_par_a2,3); hc_par_a2 = mean(hc_par_a2,2);
hc_Ltemp_a1 = mean(hc_Ltemp_a1,3); hc_Ltemp_a1 = mean(hc_Ltemp_a1,2);
hc_Ltemp_a2 = mean(hc_Ltemp_a2,3); hc_Ltemp_a2 = mean(hc_Ltemp_a2,2);
hc_Rtemp_a1 = mean(hc_Rtemp_a1,3); hc_Rtemp_a1 = mean(hc_Rtemp_a1,2);
hc_Rtemp_a2 = mean(hc_Rtemp_a2,3); hc_Rtemp_a2 = mean(hc_Rtemp_a2,2);
hc_cent_a1 = mean(hc_cent_a1,3); hc_cent_a1 = mean(hc_cent_a1,2);
hc_cent_a2 = mean(hc_cent_a2,3); hc_cent_a2 = mean(hc_cent_a2,2);

ts_front_a1 = mean(ts_front_a1,3); ts_front_a1 = mean(ts_front_a1,2);
ts_front_a2 = mean(ts_front_a2,3); ts_front_a2 = mean(ts_front_a2,2);
ts_par_a1 = mean(ts_par_a1,3);ts_par_a1 = mean(ts_par_a1,2);
ts_par_a2 = mean(ts_par_a2,3);ts_par_a2 = mean(ts_par_a2,2);
ts_Ltemp_a1 = mean(ts_Ltemp_a1,3);ts_Ltemp_a1 = mean(ts_Ltemp_a1,2);
ts_Ltemp_a2 = mean(ts_Ltemp_a2,3);ts_Ltemp_a2 = mean(ts_Ltemp_a2,2);
ts_Rtemp_a1 = mean(ts_Rtemp_a1,3);ts_Rtemp_a1 = mean(ts_Rtemp_a1,2);
ts_Rtemp_a2 = mean(ts_Rtemp_a2,3);ts_Rtemp_a2 = mean(ts_Rtemp_a2,2);
ts_cent_a1 = mean(ts_cent_a1,3); ts_cent_a1 = mean(ts_cent_a1,2);
ts_cent_a2 = mean(ts_cent_a2,3); ts_cent_a2 = mean(ts_cent_a2,2);

% Beta
hc_front_b1 = hc_front(:,13:29,564:615);hc_front_b2 = hc_front(:,13:29,820:871); 
hc_par_b1 = hc_par(:,13:29,564:615);hc_par_b2 = hc_par(:,13:29,820:871); 
hc_Ltemp_b1 = hc_Ltemp(:,13:29,564:615);hc_Ltemp_b2 = hc_Ltemp(:,13:29,820:871); 
hc_Rtemp_b1 = hc_Rtemp(:,13:29,564:615);hc_Rtemp_b2 = hc_Rtemp(:,13:29,820:871); 
hc_cent_b1 = hc_cent(:,13:29,564:615);hc_cent_b2 = hc_cent(:,13:29,820:871);

ts_front_b1 = ts_front(:,13:29,564:615);ts_front_b2 = ts_front(:,13:29,820:871); 
ts_par_b1 = ts_par(:,13:29,564:615);ts_par_b2 = ts_par(:,13:29,820:871); 
ts_Ltemp_b1 = ts_Ltemp(:,13:29,564:615);ts_Ltemp_b2 = ts_Ltemp(:,13:29,820:871); 
ts_Rtemp_b1 = ts_Rtemp(:,13:29,564:615);ts_Rtemp_b2 = ts_Rtemp(:,13:29,820:871);
ts_cent_b1 = ts_cent(:,13:29,564:615);ts_cent_b2 = ts_cent(:,13:29,820:871);

hc_front_b1 = mean(hc_front_b1,3); hc_front_b1 = mean(hc_front_b1,2);
hc_front_b2 = mean(hc_front_b2,3); hc_front_b2 = mean(hc_front_b2,2);
hc_par_b1 = mean(hc_par_b1,3); hc_par_b1 = mean(hc_par_b1,2);
hc_par_b2 = mean(hc_par_b2,3); hc_par_b2 = mean(hc_par_b2,2);
hc_Ltemp_b1 = mean(hc_Ltemp_b1,3); hc_Ltemp_b1 = mean(hc_Ltemp_b1,2);
hc_Ltemp_b2 = mean(hc_Ltemp_b2,3); hc_Ltemp_b2 = mean(hc_Ltemp_b2,2);
hc_Rtemp_b1 = mean(hc_Rtemp_b1,3); hc_Rtemp_b1 = mean(hc_Rtemp_b1,2);
hc_Rtemp_b2 = mean(hc_Rtemp_b2,3); hc_Rtemp_b2 = mean(hc_Rtemp_b2,2);
hc_cent_b1 = mean(hc_cent_b1,3); hc_cent_b1 = mean(hc_cent_b1,2);
hc_cent_b2 = mean(hc_cent_b2,3); hc_cent_b2 = mean(hc_cent_b2,2);

ts_front_b1 = mean(ts_front_b1,3); ts_front_b1 = mean(ts_front_b1,2);
ts_front_b2 = mean(ts_front_b2,3); ts_front_b2 = mean(ts_front_b2,2);
ts_par_b1 = mean(ts_par_b1,3);ts_par_b1 = mean(ts_par_b1,2);
ts_par_b2 = mean(ts_par_b2,3);ts_par_b2 = mean(ts_par_b2,2);
ts_Ltemp_b1 = mean(ts_Ltemp_b1,3);ts_Ltemp_b1 = mean(ts_Ltemp_b1,2);
ts_Ltemp_b2 = mean(ts_Ltemp_b2,3);ts_Ltemp_b2 = mean(ts_Ltemp_b2,2);
ts_Rtemp_b1 = mean(ts_Rtemp_b1,3);ts_Rtemp_b1 = mean(ts_Rtemp_b1,2);
ts_Rtemp_b2 = mean(ts_Rtemp_b2,3);ts_Rtemp_b2 = mean(ts_Rtemp_b2,2);
ts_cent_b1 = mean(ts_cent_b1,3); ts_cent_b1 = mean(ts_cent_b1,2);
ts_cent_b2 = mean(ts_cent_b2,3); ts_cent_b2 = mean(ts_cent_b2,2);

% Gamma
hc_front_g1 = hc_front(:,30:54,564:615);hc_front_g2 = hc_front(:,30:54,820:871); 
hc_par_g1 = hc_par(:,30:54,564:615);hc_par_g2 = hc_par(:,30:54,820:871); 
hc_Ltemp_g1 = hc_Ltemp(:,30:54,564:615);hc_Ltemp_g2 = hc_Ltemp(:,30:54,820:871); 
hc_Rtemp_g1 = hc_Rtemp(:,30:54,564:615);hc_Rtemp_g2 = hc_Rtemp(:,30:54,820:871);
hc_cent_g1 = hc_cent(:,30:54,564:615);hc_cent_g2 = hc_cent(:,30:54,820:871);

ts_front_g1 = ts_front(:,30:54,564:615);ts_front_g2 = ts_front(:,30:54,820:871); 
ts_par_g1 = ts_par(:,30:54,564:615);ts_par_g2 = ts_par(:,30:54,820:871); 
ts_Ltemp_g1 = ts_Ltemp(:,30:54,564:615);ts_Ltemp_g2 = ts_Ltemp(:,30:54,820:871); 
ts_Rtemp_g1 = ts_Rtemp(:,30:54,564:615);ts_Rtemp_g2 = ts_Rtemp(:,30:54,820:871); 
ts_cent_g1 = ts_cent(:,30:54,564:615);ts_cent_g2 = ts_cent(:,30:54,820:871);

hc_front_g1 = mean(hc_front_g1,3); hc_front_g1 = mean(hc_front_g1,2);
hc_front_g2 = mean(hc_front_g2,3); hc_front_g2 = mean(hc_front_g2,2);
hc_par_g1 = mean(hc_par_g1,3); hc_par_g1 = mean(hc_par_g1,2);
hc_par_g2 = mean(hc_par_g2,3); hc_par_g2 = mean(hc_par_g2,2);
hc_Ltemp_g1 = mean(hc_Ltemp_g1,3); hc_Ltemp_g1 = mean(hc_Ltemp_g1,2);
hc_Ltemp_g2 = mean(hc_Ltemp_g2,3); hc_Ltemp_g2 = mean(hc_Ltemp_g2,2);
hc_Rtemp_g1 = mean(hc_Rtemp_g1,3); hc_Rtemp_g1 = mean(hc_Rtemp_g1,2);
hc_Rtemp_g2 = mean(hc_Rtemp_g2,3); hc_Rtemp_g2 = mean(hc_Rtemp_g2,2);
hc_cent_g1 = mean(hc_cent_g1,3); hc_cent_g1 = mean(hc_cent_g1,2);
hc_cent_g2 = mean(hc_cent_g2,3); hc_cent_g2 = mean(hc_cent_g2,2);

ts_front_g1 = mean(ts_front_g1,3); ts_front_g1 = mean(ts_front_g1,2);
ts_front_g2 = mean(ts_front_g2,3); ts_front_g2 = mean(ts_front_g2,2);
ts_par_g1 = mean(ts_par_g1,3);ts_par_g1 = mean(ts_par_g1,2);
ts_par_g2 = mean(ts_par_g2,3);ts_par_g2 = mean(ts_par_g2,2);
ts_Ltemp_g1 = mean(ts_Ltemp_g1,3);ts_Ltemp_g1 = mean(ts_Ltemp_g1,2);
ts_Ltemp_g2 = mean(ts_Ltemp_g2,3);ts_Ltemp_g2 = mean(ts_Ltemp_g2,2);
ts_Rtemp_g1 = mean(ts_Rtemp_g1,3);ts_Rtemp_g1 = mean(ts_Rtemp_g1,2);
ts_Rtemp_g2 = mean(ts_Rtemp_g2,3);ts_Rtemp_g2 = mean(ts_Rtemp_g2,2);
ts_cent_g1 = mean(ts_cent_g1,3); ts_cent_g1 = mean(ts_cent_g1,2);
ts_cent_g2 = mean(ts_cent_g2,3); ts_cent_g2 = mean(ts_cent_g2,2);

clear hc_front hc_par hc_Ltemp hc_Rtemp ts_front ts_par ts_Ltemp ts_Rtemp

clear hc_front hc_par hc_Ltemp hc_Rtemp ts_front ts_par ts_Ltemp ts_Rtemp

hc_tact_n100 = [hc_front_a1,hc_front_a2,hc_par_a1,hc_par_a2,hc_Ltemp_a1,hc_Ltemp_a2,...
    hc_Rtemp_a1,hc_Rtemp_a2,hc_cent_a1,hc_cent_a2,...
    hc_front_b1,hc_front_b2,hc_par_b1,hc_par_b2,hc_Ltemp_b1,hc_Ltemp_b2,...
    hc_Rtemp_b1,hc_Rtemp_b2,hc_cent_b1,hc_cent_b2,...
    hc_front_g1,hc_front_g2,hc_par_g1,hc_par_g2,hc_Ltemp_g1,hc_Ltemp_g2,...
    hc_Rtemp_g1,hc_Rtemp_g2,hc_cent_g1,hc_cent_g2];
ts_tact_n100 = [ts_front_a1,ts_front_a2,ts_par_a1,ts_par_a2,ts_Ltemp_a1,ts_Ltemp_a2,...
    ts_Rtemp_a1,ts_Rtemp_a2,ts_cent_a1,ts_cent_a2,...
    ts_front_b1,ts_front_b2,ts_par_b1,ts_par_b2,ts_Ltemp_b1,ts_Ltemp_b2,...
    ts_Rtemp_b1,ts_Rtemp_b2,ts_cent_b1,ts_cent_b2,...
    ts_front_g1,ts_front_g2,ts_par_g1,ts_par_g2,ts_Ltemp_g1,ts_Ltemp_g2,...
    ts_Rtemp_g1,ts_Rtemp_g2,ts_cent_g1,ts_cent_g2];

clear hc_front_a1 hc_front_a2 hc_par_a1 hc_par_a2 hc_Ltemp_a1 hc_Ltemp_a2 hc_Rtemp_a1 hc_Rtemp_a2 hc_cent_a1 hc_cent_a2
clear ts_front_a1 ts_front_a2 ts_par_a1 ts_par_a2 ts_Ltemp_a1 ts_Ltemp_a2 ts_Rtemp_a1 ts_Rtemp_a2 ts_cent_a1 ts_cent_a2
clear hc_front_b1 hc_front_b2 hc_par_b1 hc_par_b2 hc_Ltemp_b1 hc_Ltemp_b2 hc_Rtemp_b1 hc_Rtemp_b2 hc_cent_b1 hc_cent_b2
clear hc_front_g1 hc_front_g2 hc_par_g1 hc_par_g2 hc_Ltemp_g1 hc_Ltemp_g2 hc_Rtemp_g1 hc_Rtemp_g2 hc_cent_g1 hc_cent_g2
clear ts_front_b1 ts_front_b2 ts_par_b1 ts_par_b2 ts_Ltemp_b1 ts_Ltemp_b2 ts_Rtemp_b1 ts_Rtemp_b2 ts_cent_b1 ts_cent_b2
clear ts_front_g1 ts_front_g2 ts_par_g1 ts_par_g2 ts_Ltemp_g1 ts_Ltemp_g2 ts_Rtemp_g1 ts_Rtemp_g2 ts_cent_g1 ts_cent_g2

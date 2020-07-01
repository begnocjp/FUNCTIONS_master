%% Set up parameters
clear all;close all;clc;
datain = 'E:\fieldtrip\WAVELET_OUTPUT_DIR\';
dataout = 'E:\fieldtrip\WAVELET_OUTPUT_DIR\results\';
frex=2:55;
freqs = {1:3;4:7;8:12;13:29;30:54};%delta theta alpha beta lo-gamma
freq_labels ={'DELTA','THETA','ALPHA','BETA','LO-GAMMA'};
times = -900:0.5:4000;
channels = 1:128;
labels = {'A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','A12','A13','A14','A15','A16',...
    'A17','A18','A19','A20','A21','A22','A23','A24','A25','A26','A27','A28','A29','A30','A31','A32',...
    'B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','B11','B12','B13','B14','B15','B16',...
    'B17','B18','B19','B20','B21','B22','B23','B24','B25','B26','B27','B28','B29','B30','B31','B32',...
    'C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16',...
    'C17','C18','C19','C20','C21','C22','C23','C24','C25','C26','C27','C28','C29','C30','C31','C32',...
    'D1','D2','D3','D4','D5','D6','D7','D8','D9','D10','D11','D12','D13','D14','D15','D16',...
    'D17','D18','D19','D20','D21','D22','D23','D24','D25','D26','D27','D28','D29','D30','D31','D32'};

names = {'PilotSubjectAERP'}; %'PilotSubjectSERP';;'Subject3_AERP'

conditions = {'long','short','vis'}; % AUD task
% conditions = {'long','long_sham','short','short_sham','vis'}; %TACT task
clusternames = {'L_temporal','R_temporal'}; % {'Frontal','Parietal'};
addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
stats = zeros(length(names),5,5,5);
%% Load in data fo each subject for individual cluster avgs
% clusters={{'76','84','85','86','89'},... % Numbers of these electrodes: 'C21','C20','C22','C12','C25'
%     {'4','5','18','19','20','31','32'}}; % Numbers of these electrodes:  'A19','A4','A5','A18','A20','A31','A32'
% frontal = clusters{1};
% parietal = clusters{2};

clusters={{'104','105','118','119','120','121'},... % Numbers of these electrodes: 'D23','D22','D8','D9','D24','D25'
    {'46','47','57','58','59','60'}}; % Numbers of these electrodes:  'B26','B25','B15','B14','B27','B28'

% frontal = clusters{1};
% parietal = clusters{2};
L_temporal = clusters{1};
R_temporal = clusters{2};

% for
%     block_i = 1; % single
    count1 = 0; % long
    count2 = 0; % short
    count3 = 0; % vis
    cond_mwtf1 = zeros(54,9801); % long
    cond_mwtf2 = zeros(54,9801); % short
    cond_mwtf3 = zeros(54,9801);
    

    L_temporal_long_PilotSubjectAERP = zeros(54,9801);
    R_temporal_long_PilotSubjectAERP = zeros(54,9801);
    L_temporal_short_PilotSubjectAERP = zeros(54,9801);
    R_temporal_short_PilotSubjectAERP = zeros(54,9801);
    L_temporal_vis_PilotSubjectAERP = zeros(54,9801);
    R_temporal_vis_PilotSubjectAERP = zeros(54,9801);
    


%     for name_i = 1:length(names)
        fprintf('\n%s\t%s','Working on subject:',names{1});
        % % Long
        tempdata = zeros(54,9801);%for
         cluster_i = 2;%:length(clusters)
            clusterelec = clusters{cluster_i};
            for elec_i = 1:length(clusterelec)
                fprintf('.');
                load([datain names{1} filesep conditions{1} filesep names{1} '_' conditions{1} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf1 = cond_mwtf1 + mw_tf;
                count1 = count1+1;
                tempdata = tempdata+mw_tf;
            end
%         end
%        L_temporal_long_PilotSubjectAERP = tempdata./(length(clusterelec));%*length(conditions));
       R_temporal_long_PilotSubjectAERP = tempdata./(length(clusterelec));%*length(conditions));
        
        % % Short

        tempdata2 = zeros(54,9801);%for
         cluster_i = 2;%:length(clusters)
            clusterelec = clusters{cluster_i};
            for elec_i = 1:length(clusterelec)
                fprintf('.');
                load([datain names{1} filesep conditions{2} filesep names{1} '_' conditions{2} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf2 = cond_mwtf2 + mw_tf;
                count2 = count2+1;
                tempdata2 = tempdata2+mw_tf;
            end
%         end
%          L_temporal_short_PilotSubjectAERP = tempdata2./(length(clusterelec));%*length(conditions));
         R_temporal_short_PilotSubjectAERP = tempdata2./(length(clusterelec));%*length(conditions));


        % % Vis
        tempdata3 = zeros(54,9801);%for
         cluster_i = 2;%:length(clusters)
            clusterelec = clusters{cluster_i};
            for elec_i = 1:length(clusterelec)
                fprintf('.');
                load([datain names{1} filesep conditions{3} filesep names{1} '_' conditions{3} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf3 = cond_mwtf3 + mw_tf;
                count3 = count3+1;
                tempdata3 = tempdata3+mw_tf;
            end
%         end
%         L_temporal_vis_PilotSubjectAERP = tempdata2./(length(clusterelec));%*length(conditions));
        R_temporal_vis_PilotSubjectAERP = tempdata2./(length(clusterelec));%*length(conditions));
        
        
        
%     end
  
 
    clear cond_mw_tf1 cond_mw_tf2 tempdata tempdata2 count1 count2 mw_tf count3 tempdata2 cond_mw_tf3
    
    % end
%  At the end should have 8 files; 2 Sub x 2 Conds x 2 Clusters
    
    
    
    

%% Plot Individual Data
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        %             subplot(1,2,1);contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        %         mask_data_young=zeros(size(young_avg(1:68,801:6801)));
        %         temp_data_young=young_avg(1:68,801:6801);
        %         mask_data_young(p_thresh_young(1:68,:)==1)=temp_data_young(p_thresh_young(1:68,:)==1);
        subplot(1,2,1);contourf(times(1601:8801),frex(1:54),R_temporal_long_PilotSubjectAERP(1:54,1601:8801),50,'linecolor','none');caxis([-4 4]);colormap(parula)
        hold on;
        %        subplot(1,2,1);contour(times(801:6801),frex(1:68),p_thresh_young(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['Right Temporal Long']);axis square;%conditions{1}
        
        %         mask_data_old=zeros(size(old_avg(1:68,801:6801)));
        %         temp_data_old=old_avg(1:68,801:6801);
        %         mask_data_old(p_thresh_old(1:68,:)==1)=temp_data_old(p_thresh_old(1:68,:)==1);
        subplot(1,2,2);contourf(times(1601:5801),frex(1:54),R_temporal_short_PilotSubjectAERP(1:54,1601:5801),50,'linecolor','none');caxis([-4 4]);colormap(parula)
        
        %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
        %         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['Right Temporal Short']);axis square;%conditions{2}
        
%         subplot(1,3,3);contourf(times(1601:3801),frex(1:54),L_temporal_vis_PilotSubjectAERP(1:54,1601:3801),50,'linecolor','none');caxis([-3 3]);colormap(parula)
%         
%         %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
%         hold on;
% %         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
%         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
%         set(gca,'FontSize',18);title(['Visual ' ]);axis square;%conditions{3}
% %         saveas(gcf,[dataout 'Incidental_Memory_Control' conditions{block_i} '_Power.pdf'],'pdf');
%         close

%%



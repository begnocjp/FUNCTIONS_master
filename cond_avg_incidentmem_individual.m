%% Set up parameters
clear all;close all;clc;
datain = 'E:\fieldtrip\WAVELET_OUTPUT_DIR\';
dataout = 'E:\fieldtrip\WAVELET_OUTPUT_DIR\results\';
frex=logspace(log10(2),log10(50),80);
freqs = {1:18;19:35;36:49;50:68;69:80};%delta theta alpha beta lo-gamma
freq_labels ={'DELTA','THETA','ALPHA','BETA','LO-GAMMA'};
times = -1000:4:2000;
channels = 1:128;
labels = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26',...
    '27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52',...
    '53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75','76','77','78',...
    '79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99','100','101','102','103','104',...
    '105','106','107','108','109','110','111','112','113','114','115','116','117','118','119','120','121','122','123','124','125','126','127','128'}';

names = {'CD_07_nonword002','rett06_nonword002'};

% groupinds = [24,57];
% young = [1:24];
% old =  [25:length(names)];
% age_group = {young, old};
conditions = {'single','repeat'};
% blocknames = {'nogo'};%,'dir',nogo,nondir};
clusternames = {'Frontal','Parietal'};
addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
stats = zeros(length(names),5,5,5);
%% Load in data fo each subject for individual cluster avgs
clusters={{'4','5','6','11','12','13','20','21','25','29','113','118','119','124'},...
    {'53','54','60','61','62','67','68','78','79','80','86','87'}};%,...
frontal = clusters{1};
parietal = clusters{2};

% for
%     block_i = 1; % single
    count1 = 0; % frontal
    count2 = 0; % parietal
    cond_mwtf1 = zeros(80,751); % frontal
    cond_mwtf2 = zeros(80,751); % parietal
%     frontal_single_CD_07 = zeros(80,751);
%     parietal_single_CD_07 = zeros(80,751);
%     frontal_rept_CD_07 = zeros(80,751);
%     parietal_rept_CD_07 = zeros(80,751);

    frontal_single_rett06 = zeros(80,751);
    parietal_single_rett06 = zeros(80,751);
%     frontal_rept_rett06 = zeros(80,751);
%     parietal_rept_rett06 = zeros(80,751);

%     for name_i = 1:length(names)
        fprintf('\n%s\t%s','Working on subject:',names{2});
        tempdata = zeros(80,751);
%         for 
            cluster_i = 1;%:length(clusters);
            clusterelec = clusters{cluster_i};
            for elec_i = 1:length(clusterelec)
                fprintf('.');
                load([datain names{2} filesep conditions{1} filesep names{2} '_' conditions{1} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf1 = cond_mwtf1 + mw_tf;
                count1 = count1+1;
                tempdata = tempdata+mw_tf;
            end
%         end        
%         frontal_single_CD_07 = tempdata./(length(clusterelec));%*length(conditions));
%         frontal_rept_CD_07 = tempdata./(length(clusterelec));%*length(conditions));
        frontal_single_rett06 = tempdata./(length(clusterelec));%*length(conditions));
%         frontal_rept_rett06 = tempdata./(length(clusterelec));%*length(conditions));
        
        tempdata2 = zeros(80,751);
        cluster_i = 2;
            clusterelec = clusters{cluster_i};
            for elec_i = 1:length(clusterelec)
                fprintf('.');
                load([datain names{2} filesep conditions{1} filesep names{2} '_' conditions{1} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf2 = cond_mwtf2 + mw_tf;
                count2 = count2+1;
                tempdata2 = tempdata2+mw_tf;
            end
%         end
%         parietal_single_CD_07 = tempdata2./(length(clusterelec));%*length(conditions));
%         parietal_rept_CD_07 = tempdata2./(length(clusterelec));%*length(conditions));
        parietal_single_rett06 = tempdata2./(length(clusterelec));%*length(conditions));
%         parietal_rept_rett06 = tempdata2./(length(clusterelec));%*length(conditions));

%     end
  
 
    clear cond_mw_tf1 cond_mw_tf2 tempdata tempdata2 count1 count2 mw_tf
    
    % end
%  At the end should have 8 files; 2 Sub x 2 Conds x 2 Clusters
    
    
    
    

%% Plot Individual Data
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        %             subplot(1,2,1);contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
%         mask_data_young=zeros(size(young_avg(1:68,801:6801)));
%         temp_data_young=young_avg(1:68,801:6801);
%         mask_data_young(p_thresh_young(1:68,:)==1)=temp_data_young(p_thresh_young(1:68,:)==1);
        subplot(1,2,1);contourf(times(201:501),frex(1:68),frontal_rept_CD_07(1:68,201:501),50,'linecolor','none');caxis([-2.5 2.5]);colormap(parula);
        hold on;
%        subplot(1,2,1);contour(times(801:6801),frex(1:68),p_thresh_young(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['Frontal ' conditions{2}]);axis square;
        
%         mask_data_old=zeros(size(old_avg(1:68,801:6801)));
%         temp_data_old=old_avg(1:68,801:6801);
%         mask_data_old(p_thresh_old(1:68,:)==1)=temp_data_old(p_thresh_old(1:68,:)==1);
        subplot(1,2,2);contourf(times(201:501),frex(1:68),parietal_rept_CD_07(1:68,201:501),50,'linecolor','none');caxis([-2.5 2.5])
        
        %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
%         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['Parietal ' conditions{2}]);axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_Control' conditions{block_i} '_Power.pdf'],'pdf');
%         close
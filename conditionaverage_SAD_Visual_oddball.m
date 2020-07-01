%% Set up parameters
clear all;close all;clc;
datain = 'E:\fieldtrip\WAVELET_OUTPUT_DIR\';
dataout = 'E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\';
frex=logspace(log10(2),log10(50),80);
freqs = {1:18;19:35;36:49;50:68};%delta theta alpha beta
freq_labels ={'DELTA','THETA','ALPHA','BETA'};
times = -1000:4:1000;
channels = 1:128;
labels = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26',...
    '27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52',...
    '53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75','76','77','78',...
    '79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99','100','101','102','103','104',...
    '105','106','107','108','109','110','111','112','113','114','115','116','117','118','119','120','121','122','123','124','125','126','127','128'}';

Vis Oddball
names = {'wlb101_visodd_t1002','wlb101_visodd_t2002','jal_102_visodd_t1002','JAL_102_visodd_t2002',...
    'SMM-103_vis_t1002','SMM_103_vis_t2002','MBC_104_vis_t1002','MBC104_vis_t2002','JCS105_vis_t1_002','JCS105_vis_t2_002',...
    'GES106_vis_t1_002','GES106_vis_t2_002','RTU107_vis_t1_002','RTU107_vis_t2_002','GLS108_vis_t1_002','GLS108_vis_t2_002',...
    'TJB201_vis_t1_002','TJB201_vis_t2_002','J-K203_vis_t1_002','J-K203_vis_t2_002','BRM204_vis_t1_002','BRM204_vis_t2_002',...
    'RKT205_vis_t1_002','RKT205_vis_t2_002','MDL206_vis_t1_002','MDL206_vis_t2_002','CE208_vis_t1_002','CE208_vis_t2_002',...
    'CMB301_vis_t1_002','CMB301_vis_t2_002','DSK302_vis_t1_002','DSK302_vis_t2_002','KAL303_vis_t1_002','KAL303_vis_t2_002',...
    'DMG304_vis_t1_002','DMG304_vis_t2_002','WMS305_vis_t1_002','WMS305_vis_t2_002','DJK306_vis_t1_002','DJK306_vis_t2_002',... 
    'TAG307_vis_t1_002','TAG307_vis_t2_002','GGL308_vis_t1_002','GGL308_vis_t2_002','JWL401_vis_t1_002','JWL401_vis_t2_002',...
    'PHD402_vis_t1_002','PHD402_vis_t2_002','JCC403_vis_t1_002','JCC403_vis_t2_002','DFM404_vis_t1_002','DFM404_vis_t2_002',...
    'MLM405_vis_t1_002','MLM405_vis_t2_002','BMT407_vis_t1_002','BMT407_vis_t2_002','RWD408_vis_t1_002','RWD408_vis_t2_002',...
    'DAB501_vis_t1_002','DAB501_vis_t1-1_002','DAB501_vis_t2_002',...
    'DJR502_vis_t1_002','DJR502_vis_t2_002','DLN503_vis_t1_002','DLN503_vis_t2_002',...
    'SKM504_vis_t1_002','SKM504_vis_t2_002','DMS505_vis_t1_002''DMS505_vis_t2_002','AMJ506_vis_t1_002','AMJ506_vis_t2_002',...
    'CMW507_vis_t1_002','CMW507_vis_t2_002','JNH508_vis_t1_002','JNH508_vis_t2_002'};


Vis Oddball Cohorts
placebo = {'MBC_104_vis_t1002','GLS108_vis_t1_002','TJB201_vis_t1_002','CMB301_vis_t1_002','DJK306_vis_t1_002',...
'PHD402_vis_t1_002','RWD408_vis_t1_002','DJR502_vis_t1_002','SKM504_vis_t1_002',
'MBC104_vis_t2002','GLS108_vis_t2_002','TJB201_vis_t2_002','CMB301_vis_t2_002','DJK306_vis_t2_002','PHD402_vis_t2_002',...
'RWD408_vis_t2_002','DJR502_vis_t2_002','SKM504_vis_t2_002',};

cohort_1 = {'wlb101_visodd_t1002','jal_102_visodd_t1002','SMM-103_vis_t1002','JCS105_vis_t1_002','GES106_vis_t1_002',...
'RTU107_vis_t1_002','wlb101_visodd_t2002','JAL_102_visodd_t2002','SMM_103_vis_t2002','JCS105_vis_t2_002',...
'GES106_vis_t2_002','RTU107_vis_t2_002',};
cohort_2 = {'J-K203_vis_t1_002','BRM204_vis_t1_002','RKT205_vis_t1_002','MDL206_vis_t1_002','CE208_vis_t1_002',
'J-K203_vis_t2_002','BRM204_vis_t2_002','RKT205_vis_t2_002','MDL206_vis_t2_002','CE208_vis_t2_002'};
cohort_3 = {'DSK302_vis_t1_002','KAL303_vis_t1_002','DMG304_vis_t1_002','WMS305_vis_t1_002','TAG307_vis_t1_002',...
'GGL308_vis_t1_002','DSK302_vis_t2_002','KAL303_vis_t2_002','DMG304_vis_t2_002','WMS305_vis_t2_002',...
'TAG307_vis_t2_002','GGL308_vis_t2_002'};
cohort_4 = {'JWL401_vis_t1_002','JCC403_vis_t1_002','DFM404_vis_t1_002','MLM405_vis_t1_002','BMT407_vis_t1_002'...
'JWL401_vis_t2_002','JCC403_vis_t2_002','DFM404_vis_t2_002','MLM405_vis_t2_002','BMT407_vis_t2_002'};
cohort_5 = {'DAB501_vis_t1_002','DAB501_vis_t1-1_002',
'DLN503_vis_t1_002','DMS505_vis_t1_002','AMJ506_vis_t1_002','CMW507_vis_t1_002','JNH508_vis_t1_002',...
'DAB501_vis_t2_002','DLN503_vis_t2_002','DMS505_vis_t2_002','AMJ506_vis_t2_002','CMW507_vis_t2_002','JNH508_vis_t2_002'};


blocks={'std+','trgt'};
clusternames={'Frontal','Parietal'};%'F''FC','C','CP'};
addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
stats = zeros(length(names),5,5,5);

%% Plot Single Subject Data


% load([datain names{2} filesep blocks{2} filesep names{2} '_' blocks{2} '_68_imagcoh_mwtf.mat'],'mw_tf');

% contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
% figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
% contourf(times(1500:3000),frex(1:68),mw_tf(1:68,1500:3000),50, 'linecolor','none'); caxis([0 5]); %,'DatetimeTickFormat','HH:mm:ss');
% hold on;
% xlabel('Time','FontSize',18);ylabel('Frequency','FontSize',18);
% set(gca,'FontSize',18);title(['Post-Treatment Power following Target']);axis square;

%
% load([datain names{1} filesep blocks{2} filesep names{1} '_' blocks{2} '_68_imagcoh_mwtf.mat'],'mw_tf');

% contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
% figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
% contourf(times(1500:3000),frex(1:68),mw_tf(1:68,1500:3000),50, 'linecolor','none'); caxis([0 5]); %,'DatetimeTickFormat','HH:mm:ss');
% hold on;
% xlabel('Time','FontSize',18);ylabel('Frequency','FontSize',18);
% set(gca,'FontSize',18);title(['Baseline Power following Target']);axis square;


%% Load in data

clusters={{'4','5','6','11','12','13','20','21','25','29','113','118','119','124'},...
    {'53','54','60','61','62','67','68','78','79','80','86','87'}};%,...

frontal = clusters{1};
parietal = clusters{2};

for block_i =1:length(blocks)
    %     conditions=blocks{block_i};
    
    count1 = 0;
    count2 = 0;
    cond_mwtf1 = zeros(80,4001);
    cond_mwtf2 = zeros(80,4001);
%     frontal_data_forttest = zeros(length(1:30),80,4001);
%     parietal_data_forttest = zeros(length(1:30),80,4001);
    
    
    for cluster_i=1%1:length(clusters)
        clusterelec = clusters{cluster_i};
        electrodes = find(ismember(labels,clusterelec));
        count1 = 0;
        count2 = count1;
        cond_mwtf1 = zeros(80,4001);
        cond_mwtf2 = cond_mwtf1;
        
        bldata_forttest = zeros(length(1:8),80,4001);
        ptdata_forttest =zeros(length(9:length(names)),80,4001);
        
        % for group_i = 1:length(age_group)
        for name_i = 1:8
            fprintf('\n%s\t%s','Working on subject:',names{name_i});
            tempdata = zeros(80,4001);
            %             for cond_i = 1:length(blocks)
            for elec_i = 1:length(electrodes)
                fprintf('.');
                load([datain names{name_i} filesep blocks{block_i} filesep names{name_i} '_' blocks{block_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf1 = cond_mwtf1 + mw_tf;
                count1 = count1+1;
                tempdata = tempdata+mw_tf;
            end
            %             end
            bldata_forttest(name_i,:,:) = tempdata./(length(electrodes));
            
        end
        save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\bldata' blocks{block_i} '_frontal.mat'],'bldata_forttest');
%         save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\bldata' blocks{block_i} '_parietal.mat'],'bldata_forttest');

        num = 1;
        for name_i = 9:length(names)
            
            fprintf('\n%s\t%s','Working on subject:',names{name_i});
            tempdata = zeros(80,4001);
            %             for cond_i = 1:length(blocks)
            for elec_i = 1:length(electrodes)
                fprintf('.');
                load([datain names{name_i} filesep blocks{block_i} filesep names{name_i} '_' blocks{block_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf2 = cond_mwtf2 + mw_tf;
                count2 = count2+1;
                tempdata = tempdata+mw_tf;
            end
            
            %             end
            ptdata_forttest(num,:,:) = tempdata./(length(electrodes));
            num = num+1;
            
        end
        save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\ptdata' blocks{block_i} '_frontal.mat'],'ptdata_forttest');
%         save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\ptdata' blocks{block_i} '_parietal.mat'],'ptdata_forttest');
        
        %         if strcmpi(clusternames{cluster_i},'P')
        %             p_bl = zeros(68,length(1:4001));
        %             for freq = 1:68
        %                 [~,p_bl(freq,:)] = ttest(squeeze(bldata_forttest(:,freq,1:4001)));
        %             end
        %
        %             p_pt = zeros(68,length(1:4001));
        %             for freq = 1:68
        %                 [~,p_pt(freq,:)] = ttest(squeeze(ptdata_forttest(:,freq,1:4001)));
        %             end
        %
        %             addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox\'));
        %             thresh =0.005;
        %             [~,crit_p]=fdr_bky(p_bl,thresh,'no');
        %             p_thresh_bl=zeros(size(p_bl));
        %             p_thresh_bl(p_bl<crit_p)=1;
        %             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\p_thresh_bl' blocks{block_i} '_Pz.mat'],'p_thresh_bl');
        %
        %             [~,crit_p]=fdr_bky(p_pt,thresh,'no');
        %             p_thresh_pt=zeros(size(p_pt));
        %             p_thresh_pt(p_pt<crit_p)=1;
        %             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\p_thresh_pt' blocks{block_i} '_Pz.mat'],'p_thresh_pt');
        %         end

    end
    
end        
% save('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\tgt_avg_parietal_power.mat','tgt_avg');
% save('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\std_avg_parietal_power.mat','std_avg');

clear cond_mwtf1 cond_mwtf2 tempdata tempdata2 count1 count2 mw_tf

%% Analyse time point*frex for Condition Avgs collapsed over time    

count1 = 0;
%     count2 = 0;
cond_mwtf1 = zeros(80,4001);
%     cond_mwtf2 = zeros(80,6001);
data_forttest = zeros(length(1:16),80,4001);
%     parietal_data_forttest = zeros(length(1:30),80,6001);
for block_i = 1%:length(blocks)
    for name_i = 1:length(names)
        fprintf('\n%s\t%s','Working on subject:',names{name_i});
        tempdata = zeros(80,4001);
        clusterelec = clusters{1};
        for elec_i = 1:length(clusterelec)
            fprintf('.');
            load([datain names{name_i} filesep blocks{block_i} filesep names{name_i} '_' blocks{block_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
            cond_mwtf1 = cond_mwtf1 + mw_tf;
            count1 = count1+1;
            tempdata = tempdata+mw_tf;
        end
        data = tempdata;
    data_forttest(name_i,:,:) = tempdata./(length(clusterelec));%*length(conditions));
    end
    
        %% Avg across names for each trial type
%         tgt_avg = cond_mwtf1./count1;
        std_avg = cond_mwtf1./count1;
%         % avg_group = cond_mwtf/length(names);
    
%     save('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\tgt_avg_frontal_power.mat','tgt_avg');
    save('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\std_avg_parietal_power.mat','std_avg');
    save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\' blocks{block_i} '_ttestdata.mat'],'data_forttest');
    
    clear data_forttest
    
end
  clear cond_mw_tf1 cond_mw_tf2 tempdata tempdata2 count1 count2 mw_tf
  
%% Analyse time point*frex for Condition Avg

stnd = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\std+_ttestdata.mat'], 'data_forttest');
trgt = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\trgt_ttestdata.mat'], 'data_forttest');

std = stnd.data_forttest;
tgt = trgt.data_forttest;

std_avg = load('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\std_avg_power.mat', 'avg');
tgt_avg = load('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\tgt_avg_power.mat', 'avg');

std_mean = std_avg;%.avg;
tgt_mean = tgt_avg;%.avg;

p_std = zeros(68,length(2001:4001));
p_tgt = zeros(68,length(2001:4001));

for freq = 1:68
    [~,p_std(freq,:)] = ttest(squeeze(std(:,freq,2001:4001)));%,'Alpha', 0.05);
end

for freq = 1:68
    [~,p_tgt(freq,:)] = ttest(squeeze(tgt(:,freq,2001:4001)));%,'Alpha', 0.05);
end

% Apply FDR Corrections
addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox\'));
thresh =0.005;

p_crit = zeros(size(p_std));
crit_p = zeros(size(p_crit));

for freq = 1:68
    [~,p_crit(freq,:)]=fdr_bky(p_std(freq,:),thresh,'no');
end

for freq = 1:68
    [~,crit_p(freq,:)]=fdr_bky(p_tgt(freq,:),thresh,'no');
end
    
p_thresh_std=zeros(size(p_std));
p_thresh_std(p_std<p_crit)=1;
% save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\p_thresh_avg_std.mat'],'p_thresh_std');

p_thresh_tgt=zeros(size(p_tgt));
p_thresh_tgt(p_tgt<crit_p)=1;
% save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\p_thresh_avg_tgt.mat'],'p_thresh_tgt');


%% Plot Session Avg

% Standard
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        subplot(1,2,1);contourf(times(1601:4001),frex(1:68),std_mean(1:68,1601:4001),50,'linecolor','none');caxis([-2.5 2.5]);colormap(jet)
        mask_data_std=zeros(size(std_mean(1:68,2001:4001)));
        temp_data_std=std_mean(1:68,2001:4001);
        mask_data_std(p_thresh_std(1:68,:)==1)=temp_data_std(p_thresh_std(1:68,:)==1);
%         subplot(1,2,1);contourf(times(1601:4001),frex(1:68),frontal_avg(1:68,1601:4001),50,'linecolor','none');caxis([-2 2]);colormap(jet);
        hold on;
       subplot(1,2,1);contour(times(2001:4001),frex(1:68),p_thresh_std(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2.5 2.5])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title('Standard');axis square;
        
% Target
        mask_data_tgt=zeros(size(tgt_mean(1:68,2001:4001)));
        temp_data_tgt=tgt_mean(1:68,2001:4001);
        mask_data_tgt(p_thresh_tgt(1:68,:)==1)=temp_data_tgt(p_thresh_tgt(1:68,:)==1);
        subplot(1,2,2);contourf(times(1601:4001),frex(1:68),tgt_mean(1:68,1601:4001),50,'linecolor','none');caxis([-2.5 2.5])
        
%         subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
        subplot(1,2,2);contour(times(2001:4001),frex(1:68),p_thresh_tgt(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2.5 2.5])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title('Target');axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_TaskAvg_Power_005.pdf'],'pdf');
%         close    

%% Plot
        
        %         block_i = 2;
        
        %         figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        %             subplot(1,2,1);contourf(times(1501:3001),frex(1:68),bl_avg(1:68,1501:3001),50,'linecolor','none');caxis([-2 2])
        %         mask_data_bl=zeros(size(bl_avg(1:68,1:3001)));
        %         temp_data_bl=bl_avg(1:68,1501:3001);
        %         mask_data_bl(p_thresh_bl(1:68,:)==1)=temp_data_bl(p_thresh_bl(1:68,:)==1);
        %         subplot(1,2,1);contourf(times(1501:3001),frex(1:68),bl_avg(1:68,1501:3001),50,'linecolor','none');caxis([-2 2])
        %         hold on;
        %        subplot(1,2,1);contour(times(1:4001),frex(1:68),p_thresh_bl(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        %         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        %         set(gca,'FontSize',18);title(['BASELINE ' clusternames{cluster_i} ' ' blocks{block_i}]);axis square;
        
        %         mask_data_pt=zeros(size(pt_avg(1:68,1501:3001)));
        %         temp_data_pt=pt_avg(1:68,1501:3001);
        %         mask_data_pt(p_thresh_pt(1:68,:)==1)=temp_data_pt(p_thresh_pt(1:68,:)==1);
        %         subplot(1,2,2);contourf(times(1501:3001),frex(1:68),pt_avg(1:68,1501:3001),50,'linecolor','none');caxis([-2 2])
        
        %             subplot(1,2,2);contourf(times(1501:3001),frex(1:68),pt_avg(1:68,1501:3001),50,'linecolor','none');caxis([-2 2])
        %         hold on;
        %         subplot(1,2,2);contour(times(1501:3001),frex(1:68),p_thresh_pt(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        %         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        %         set(gca,'FontSize',18);title(['POST-TREATMENT ' clusternames{cluster_i} ' ' blocks{block_i}]);axis square;
        %         saveas(gcf,[dataout 'TIMEF_' clusternames{cluster_i} '_' blocks{block_i} '_Power.pdf'],'pdf');
        %         close
        


%% Export avg values between 100-500ms that fall in task avg FDR
% For Std: 100-400; For Tgt: 200-500

tmp1 = load([datain filesep 'results\bldatastd+_frontal'],'bldata_forttest');
tmp2 = load([datain filesep 'results\ptdatastd+_frontal'],'ptdata_forttest');
tmp3 = load([datain filesep 'results\bldatatrgt_frontal'],'bldata_forttest');
tmp4 = load([datain filesep 'results\ptdatatrgt_frontal'],'ptdata_forttest');
bl_std = tmp1.bldata_forttest;
pt_std = tmp2.ptdata_forttest;
bl_tgt = tmp3.bldata_forttest;
pt_tgt = tmp4.ptdata_forttest;
clear tmp1 tmp2 tmp3 tmp4

std_diff = bl_std - pt_std;
tgt_diff = bl_tgt - pt_tgt;

% Std: 100-400
std_data = zeros(8,68,601);

for name_i = 1:8%length(names)
    for freq_i = 1:68
        for time_i = 1:601
            if p_thresh_std(freq_i,time_i+600)==1
                std_data(name_i,freq_i,time_i) = bl_std(name_i,freq_i,time_i+2200);
            end
        end
    end
end

% Tgt: 200-500
tgt_data = zeros(8,68,601);

for name_i = 1:8%length(names)
    for freq_i = 1:68
        for time_i = 1:601
            if p_thresh_tgt(freq_i,time_i+600)==1
                tgt_data(name_i,freq_i,time_i) = bl_tgt(name_i,freq_i,time_i+2400);
            end
        end
    end
end


bl_stnd = mean(std_data,3);
% pt_stnd = mean(std_data,3);
bl_trgt = mean(tgt_data,3);
% pt_trgt = mean(tgt_data,3);

clear tgt_data std_data

for freq_i = 1:68
    [~,p_standard(1,freq_i),~,t_standard(1,freq_i)] = ttest(bl_stnd(:,freq_i),pt_stnd(:,freq_i));%,'Alpha', 0.05));
end

for freq_i = 1:68
    [~,p_target(1,freq_i),~,t_target(1,freq_i)] = ttest(bl_trgt(:,freq_i),pt_trgt(:,freq_i));%,'Alpha', 0.05));
end


            
        %% Create Avgs
        
tmp1 = load([datain filesep 'results\DepMind_Oddball_Parietal\bldatastd+_parietal'],'bldata_forttest');
tmp2 = load([datain filesep 'results\DepMind_Oddball_Parietal\ptdatastd+_parietal'],'ptdata_forttest');
tmp3 = load([datain filesep 'results\DepMind_Oddball_Parietal\bldatatrgt_parietal'],'bldata_forttest');
tmp4 = load([datain filesep 'results\DepMind_Oddball_Parietal\ptdatatrgt_parietal'],'ptdata_forttest');
bl_std = tmp1.bldata_forttest;
pt_std = tmp2.ptdata_forttest;
bl_tgt = tmp3.bldata_forttest;
pt_tgt = tmp4.ptdata_forttest;
clear tmp1 tmp2 tmp3 tmp4       
        
bl_std_mean = mean(bl_std,1);         
bl_std_mean = squeeze(bl_std_mean);        
pt_std_mean = mean(pt_std,1);         
pt_std_mean = squeeze(pt_std_mean);  
bl_tgt_mean = mean(bl_tgt,1);         
bl_tgt_mean = squeeze(bl_tgt_mean);  
pt_tgt_mean = mean(pt_tgt,1);         
pt_tgt_mean = squeeze(pt_tgt_mean);  


%% Plot Avg Data

% Baseline Standard
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        subplot(1,2,1);contourf(times(1601:4001),frex(1:68),bl_std_mean(1:68,1601:4001),50,'linecolor','none');caxis([-2.5 2.5]);colormap(jet)
%         mask_data_std=zeros(size(std_mean(1:68,2001:4001)));
%         temp_data_std=std_mean(1:68,2001:4001);
%         mask_data_std(p_thresh_std(1:68,:)==1)=temp_data_std(p_thresh_std(1:68,:)==1);
%         subplot(1,2,1);contourf(times(1601:4001),frex(1:68),frontal_avg(1:68,1601:4001),50,'linecolor','none');caxis([-2 2]);colormap(jet);
        hold on;
%        subplot(1,2,1);contour(times(2001:4001),frex(1:68),p_thresh_std(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2.5 2.5])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title('Pre-Treatment Standard');axis square;
        
% Treatment Standard
%         mask_data_tgt=zeros(size(tgt_mean(1:68,2001:4001)));
%         temp_data_tgt=tgt_mean(1:68,2001:4001);
%         mask_data_tgt(p_thresh_tgt(1:68,:)==1)=temp_data_tgt(p_thresh_tgt(1:68,:)==1);
        subplot(1,2,2);contourf(times(1601:4001),frex(1:68),pt_std_mean(1:68,1601:4001),50,'linecolor','none');caxis([-2.5 2.5]);colormap(jet)
        
%         subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
%         subplot(1,2,2);contour(times(2001:4001),frex(1:68),p_thresh_tgt(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2.5 2.5])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title('Post-Treatment Standard');axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_TaskAvg_Power_005.pdf'],'pdf');
%         close    

% Baseline Target
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        subplot(1,2,1);contourf(times(1601:4001),frex(1:68),bl_tgt_mean(1:68,1601:4001),50,'linecolor','none');caxis([-2.5 2.5]);colormap(jet)
%         mask_data_std=zeros(size(std_mean(1:68,2001:4001)));
%         temp_data_std=std_mean(1:68,2001:4001);
%         mask_data_std(p_thresh_std(1:68,:)==1)=temp_data_std(p_thresh_std(1:68,:)==1);
%         subplot(1,2,1);contourf(times(1601:4001),frex(1:68),frontal_avg(1:68,1601:4001),50,'linecolor','none');caxis([-2 2]);colormap(jet);
        hold on;
%        subplot(1,2,1);contour(times(2001:4001),frex(1:68),p_thresh_std(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2.5 2.5])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title('Pre-Treatment Target');axis square;
        
% Treatment Target
%         mask_data_tgt=zeros(size(tgt_mean(1:68,2001:4001)));
%         temp_data_tgt=tgt_mean(1:68,2001:4001);
%         mask_data_tgt(p_thresh_tgt(1:68,:)==1)=temp_data_tgt(p_thresh_tgt(1:68,:)==1);
        subplot(1,2,2);contourf(times(1601:4001),frex(1:68),pt_tgt_mean(1:68,1601:4001),50,'linecolor','none');caxis([-2.5 2.5]);colormap(jet)
        
%         subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
%         subplot(1,2,2);contour(times(2001:4001),frex(1:68),p_thresh_tgt(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2.5 2.5])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title('Post-Treatment Target');axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_TaskAvg_Power_005.pdf'],'pdf');
%         close  

        %% Pause
        %         freqs = {1:18;19:35;36:48;49:67};
        %         fprintf('\n\n%s\t','**********EXTRACTING AVERAGE VALUES**********');
        % %         if strcmpi(clusternames{cluster_i},'FC')
        %             for freq_i = 1:length(freqs)
        %                 fprintf('.');
        %                 tmp_p = squeeze(p_thresh_young(freqs{freq_i},:));
        %                 tmp_data = zeros(length(freqs{freq_i}),length(801:6801));
        %                 tmp_data(tmp_p ~= 1) = NaN;
        %                 tmp_inds = ~isnan(tmp_data);
        %                 for name_i = 1:24
        %                     for cond_i = 1:length(conditions)
        %                         load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
        %                         tmp_data_squeezed = squeeze(mw_tf(freqs{freq_i},801:6801));
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
        %                 tmp_p = squeeze(p_thresh_old(freqs{freq_i},:));
        %                 tmp_data = zeros(length(freqs{freq_i}),length(801:6801));
        %                 tmp_data(tmp_p ~= 1) = NaN;
        %                 tmp_inds = ~isnan(tmp_data);
        %                 for name_i = 25:length(names)
        %                     for cond_i = 1:length(conditions)
        %                         load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
        %                         tmp_data_squeezed = squeeze(mw_tf(freqs{freq_i},801:6801));
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
        
        
%         end
% end
%% plot
close all
subjs1 = 1:24;
subjs2=25:length(names);
for cluster_i=1:length(clusternames)
    figure();
    for freq_i=1:5
        subplot(2,3,freq_i);bar([squeeze(mean(stats(subjs1,:,cluster_i,freq_i),1)),squeeze(mean(stats(subjs2,:,cluster_i,freq_i),1))]);
        ylim([-2.5 2.5]);title(['freq: ' num2str(freq_i) ' ' clusternames{cluster_i}]);
    end
end
%% headplots
clear cond_mwtf1 cond_mwtf2 count* mw_tf olddata_forttest youngdata_forttest tempdata old_avg young_avg
% load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_young.mat');
% load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_old.mat');
timesets = {(1801:2801),(2801:6801)};
timeind = {1:length(1801:2801),1:length(2801:6801)};
% TIMECUTOFF = [2801;1001;4001];
for block_i =1:length(blocks)
    conditions=blocks{block_i};
    load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_data' blocknames{block_i} '.mat']);
    load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_data' blocknames{block_i} '.mat']);
    
    for cond_i = 1:length(blocks{block_i})
        fprintf('\n%s', conditions{cond_i})
        filename = ['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\' conditions{cond_i} '_topovals.txt'];
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
                        if name_i < 25
                            %                             mask_data_young=zeros(1,size(freqs{freq_i}),length(timesets{time_i}));
                            temp_data_young = mw_tf(freqs{freq_i},timesets{time_i});
                            dataval=mean(temp_data_young(p_thresh_young(freqs{freq_i},timesets{time_i})==1));
                            fprintf(fid, '%2.4f\t', dataval);
                            
                        else
                            %                             mask_data_young=zeros(1,size(freqs{freq_i}),length(timesets{time_i}));
                            temp_data_old = mw_tf(freqs{freq_i},timesets{time_i});
                            dataval=mean(temp_data_old(p_thresh_old(freqs{freq_i},timesets{time_i})==1));
                            fprintf(fid, '%2.4f\t', dataval);
                            
                        end
                    end
                    
                end
            end
            %             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies' conditions{cond_i} 'matrix.mat',condmatrix]);
            %             clear condmatrix
        end
        fclose(fid);
    end
end

%     if block_i == 1
%         load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_young' blocknames{block_i} '_Pz.mat']);
%         load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_old' blocknames{block_i} '_Pz.mat']);
%     else
%         load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_youngNONDIR.mat');
%         load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_oldNONDIR.mat');
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
%         young_data = zeros(64,80,9801);
%         for name_i = 1:24
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             tic;
%             for cond_i = 1:length(conditions)
%                 fprintf('.');
%                 for elec_i = 1:length(electrodes)
%                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     temp = squeeze(young_data(elec_i,:,:))+mw_tf;
%                     young_data(elec_i,:,:) = temp;
%                     clear temp;
% %                     for f=1:80
% %                         for t = 1:9801
% %                             young_data(elec_i,f,t) = young_data(elec_i,f,t)+mw_tf(f,t);
% %                         end
% %                     end
%                 end
%             end
%             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
%         end
%         young_data = young_data./(length(conditions)*24);
%         save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_data' blocknames{block_i} '.mat'],'young_data');
load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_data' blocknames{block_i} '.mat']);

%         old_data = zeros(64,80,9801);for name_i = 25:length(names)
%             tic;
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             for cond_i = 1:length(conditions)
%                 fprintf('.');
%                 for elec_i = 1:length(electrodes)
%                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     temp = squeeze(old_data(elec_i,:,:))+mw_tf;
%                     old_data(elec_i,:,:) = temp;
%                     clear temp;
% %                     for f=1:80
% %                         for t = 1:9801
% %                             old_data(elec_i,f,t) = old_data(elec_i,f,t)+mw_tf(f,t);
% %                         end
% %                     end
%                 end
%
%             end
%             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
%         end
%
%         old_data = old_data./length(conditions)*33;

%         old_data = zeros(64,80,9801);
%         for name_i = 25:length(names)
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             tic;
%             for cond_i = 1:length(conditions)
%                 fprintf('.');
%                 for elec_i = 1:length(electrodes)
%                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     temp = squeeze(old_data(elec_i,:,:))+mw_tf;
%                     old_data(elec_i,:,:) = temp;
%                     clear temp;
% %                     for f=1:80
% %                         for t = 1:9801
% %                             young_data(elec_i,f,t) = young_data(elec_i,f,t)+mw_tf(f,t);
% %                         end
% %                     end
%                 end
%             end
%             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
%         end
%         old_data = old_data./(length(conditions)*33);
%         save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_data' blocknames{block_i} '.mat'],'old_data');
load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_data' blocknames{block_i} '.mat']);

%% Avg across names
%         young_avg = squeeze(mean(young_data,1));
%         old_avg = squeeze(mean(old_data,1));
% avg_group = cond_mwtf/length(names);
TIMECUTOFF=[2801;1001;2001];
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
    
    for time_i = 1:2
        switch time_i
            case 1%less than 500ms
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
                %                         mask_data_young=zeros(size(young_data(:,freqs{freq_i},1801:TIMECUTOFF(1))));
                %                         temp_data_young=young_data(:,freqs{freq_i},1801:TIMECUTOFF(1));
                %                         mask_data_young(:,p_thresh_young(freqs{freq_i},1:TIMECUTOFF(2))==1)=temp_data_young(:,p_thresh_young(freqs{freq_i},1:TIMECUTOFF(2))==1);
                %                         dat.avg=[squeeze(mean(mean(mask_data_young,2),3));0;0;0;0;0;0;0;0];
                % %                         dat.avg=[squeeze(mean(mean(temp_data_young,2),3));0;0;0;0;0;0;0;0];
                %                         subplot(4,2,count);ft_topoplotER(cfg,dat);
                
                dat.avg = zeros(72,1);
                mask_data_old=zeros(size(old_data(:,freqs{freq_i},1801:TIMECUTOFF(1))));
                temp_data_old=old_data(:,freqs{freq_i},1801:TIMECUTOFF(1));
                mask_data_old(:,p_thresh_old(freqs{freq_i},1:TIMECUTOFF(2))==1)=temp_data_old(:,p_thresh_old(freqs{freq_i},1:TIMECUTOFF(2))==1);
                dat.avg=[squeeze(mean(mean(mask_data_old,2),3));0;0;0;0;0;0;0;0];
                subplot(4,2,count);ft_topoplotER(cfg,dat);
                %
            case 2%above 500ms
                count = count + 1;
                %                         cfg =[];%set up config
                %                         cfg.highlight = 'off';
                %                         cfg.layout = 'biosemi64.lay';
                %                         cfg.marker = 'off';
                %                         cfg.parameter = 'avg';
                %                         cfg.comment = 'no';
                %                         cfg.contournum = 2;
                %                         cfg.gridscale = 50;
                %                         cfg.shading = 'interp';
                %                         cfg.interactive = 'no';
                %                         dat.var = zeros(72,1);
                %                         dat.label = labels(:,1);
                %                         dat.time = 1;
                %                         dat.dimord = 'chan_time';
                %                         cfg.zlim = scale;
                % %                         cfg.zlim ='maxmin';
                dat.avg = zeros(72,1);
                %                         mask_data_young=zeros(size(young_data(:,freqs{freq_i},TIMECUTOFF(1):6801)));
                %                         temp_data_young=young_data(:,freqs{freq_i},TIMECUTOFF(1):6801);
                %                         mask_data_young(:,p_thresh_young(freqs{freq_i},TIMECUTOFF(3):end)==1)=temp_data_young(:,p_thresh_young(freqs{freq_i},TIMECUTOFF(3):end)==1);
                %                         dat.avg=[squeeze(mean(mean(mask_data_young,2),3));0;0;0;0;0;0;0;0];
                % %                         dat.avg=[squeeze(mean(mean(temp_data_young,2),3));0;0;0;0;0;0;0;0];
                %                         subplot(4,2,count);ft_topoplotER(cfg,dat);
                
                mask_data_old=zeros(size(old_data(:,freqs{freq_i},TIMECUTOFF(1):6801)));
                temp_data_old=old_data(:,freqs{freq_i},TIMECUTOFF(1):6801);
                mask_data_old(:,p_thresh_old(freqs{freq_i},TIMECUTOFF(3):end)==1)=temp_data_old(:,p_thresh_old(freqs{freq_i},TIMECUTOFF(3):end)==1);
                dat.avg=[squeeze(mean(mean(mask_data_old,2),3));0;0;0;0;0;0;0;0];
                subplot(4,2,count);ft_topoplotER(cfg,dat);
        end
    end
end%freq_i loop

%   saveas(gcf,['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\youngHeadplots' blocknames{block_i} 'v2.pdf'],'pdf');
saveas(gcf,['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\oldHeadplots' blocknames{block_i} 'v2.pdf'],'pdf');

%     end
% end

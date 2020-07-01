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

names = {'wlb101_memory t1002','jal_102_memory_t1002','SMM-103_mem_t1002','MBC104_mem_t1002','JCS_105_memory_t1_002',...
    'GES106_mem_t1_002','RTU107_mem_t1_002','GLS108_mem_t1_002','TJB201_mem_t1_002','J-K203_mem_t1_002',...
    'BRM204_mem_t1_002','RKT205_mem_t1_002','MDL206_mem_t1_002','SNE207_mem_t1_002','CE208_mem_t1_002',...
    'CMB301_mem_t1_002','DSK302_mem_t1_002','KAL303_mem_t1_002','DMG304_mem_t1_002','WMS305_mem_t1_002',...
    'DJK306_mem_t1_002','TAG307_mem_t1_002','GGL308_mem_t1_002','JWL401_mem_t1_002','PHD402_mem_t1_002',...
    'JCC403_mem_t1_002','DFM404_mem_t1_002','MLM405_mem_t1_002','MBC406_mem_t1_002','BMT407_mem_t1_002',...
    'RWD408_mem_t1_002','DAB501_mem_t1_002','DJR502_mem_t1_002','DLN503_mem_t1_002','SKM504_mem_t1_002',...
    'DMS505_mem_t1_002','AMJ506_mem_t1_002','CMW507_mem_t1_002','JNH508_mem_t1_002',...    
    'wlb101_memory_t2002','JAL_102_mem_t2002','SMM_103_mem_t2002','MBC104_mem_t2002','JCS105_mem_t2_002',...
    'GES106_mem_t2_002','RTU107_mem_t2_002','GLS108_mem_t2_002','TJB201_mem_t2_002','J-K203_mem_t2_002',...
    'BRM204_mem_t2_002','RKT205_mem_t2_002','MDL206_mem_t2_002','207SNE_mem_t2_002','CE208_mem_t2_002',...
    'CMB301_mem_t2_002','DSK302_mem_t2_002','KAL303_mem_t2_002','DMG304_mem_t2_002',...
    'WMS305_mem_t2_002','DJK306_mem_t2_002','TAG307_mem_t2_002','GGL308_mem_t2_002','JWL401_mem_t2_002',...
    'PHD402_mem_t2_002','JCC403_mem_t2_002','DFM404_mem_t2_002','MLM405_mem_t2_002','MBC406_mem_t2_002',...
    'BMT407_mem_t2_002','RWD408_mem_t2_002','DAB501_mem_t2_002','DJR502_mem_t2_002','DLN503_mem_t2_002',...
    'SKM504_mem_t2_002','DMS505_mem_t2_002','AMJ506_mem_t2_002','CMW507_mem_t2_002','JNH508_mem_t2_002'};

% Split into Pre/Post-VU319
pre_drug = 1:39;
post_drug = 40:78;

placebo_pre = {'MBC104_mem_t1002','GLS108_mem_t1_002','TJB201_mem_t1_002','SNE207_mem_t1_002','CMB301_mem_t1_002',...
    'DJK306_mem_t1_002','PHD402_mem_t1_002','RWD408_mem_t1_002','DJR502_mem_t1_002','SKM504_mem_t1_002'};
placebo_post = {'MBC104_mem_t2002','GLS108_mem_t2_002','TJB201_mem_t2_002','207SNE_mem_t2_002','CMB301_mem_t2_002',...
    'DJK306_mem_t2_002','PHD402_mem_t2_002','RWD408_mem_t2_002','DJR502_mem_t2_002','SKM504_mem_t2_002'};
cohort_1_pre = {'wlb101_memory t1002','jal_102_memory_t1002','SMM-103_mem_t1002','JCS_105_memory_t1_002',...
    'GES106_mem_t1_002','RTU107_mem_t1_002'};
cohort_1_post = {'wlb101_memory_t2002','JAL_102_mem_t2002','SMM_103_mem_t2002','JCS105_mem_t2_002',...
    'GES106_mem_t2_002','RTU107_mem_t2_002'};
cohort_2_pre = {'J-K203_mem_t1_002','BRM204_mem_t1_002','RKT205_mem_t1_002','MDL206_mem_t1_002','CE208_mem_t1_002'};
cohort_2_post = {'J-K203_mem_t2_002','BRM204_mem_t2_002','RKT205_mem_t2_002','MDL206_mem_t2_002','CE208_mem_t2_002'};
cohort_3_pre = {'DSK302_mem_t1_002','KAL303_mem_t1_002','DMG304_mem_t1_002','WMS305_mem_t1_002','TAG307_mem_t1_002',...
    'GGL308_mem_t1_002'};
cohort_3_post = {'DSK302_mem_t2_002','KAL303_mem_t2_002','DMG304_mem_t2_002','WMS305_mem_t2_002','TAG307_mem_t2_002',...
    'GGL308_mem_t2_002'};
cohort_4_pre = {'JWL401_mem_t1_002','JCC403_mem_t1_002','DFM404_mem_t1_002','MLM405_mem_t1_002',...
    'MBC406_mem_t1_002','BMT407_mem_t1_002'};
cohort_4_post = {'JWL401_mem_t2_002','JCC403_mem_t2_002','DFM404_mem_t2_002','MLM405_mem_t2_002',...
    'MBC406_mem_t2_002','BMT407_mem_t2_002',};
cohort_5_pre = {'DAB501_mem_t1_002','DLN503_mem_t1_002','DMS505_mem_t1_002','AMJ506_mem_t1_002',...
    'CMW507_mem_t1_002','JNH508_mem_t1_002'}; 
cohort_5_post = {'DAB501_mem_t2_002','DLN503_mem_t2_002','DMS505_mem_t2_002',...
    'AMJ506_mem_t2_002','CMW507_mem_t2_002','JNH508_mem_t2_002'};

cohorts = {placebo_pre,placebo_post,cohort_1_pre,cohort_1_post,cohort_2_pre,cohort_2_post,cohort_3_pre,...
    cohort_3_post,cohort_4_pre,cohort_4_post,cohort_5_pre,cohort_5_post};
cohortnames = {'placebo_pre','placebo_post','cohort_1_pre','cohort_1_post','cohort_2_pre','cohort_2_post',...
    'cohort_3_pre','cohort_3_post','cohort_4_pre','cohort_4_post','cohort_5_pre','cohort_5_post'};
conditions = {'single','repeat'};
% blocknames = {'nogo'};%,'dir',nogo,nondir};
clusternames = {'Frontal','Parietal'};
addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
stats = zeros(length(names),5,5,5);

clusters={{'4','5','6','11','12','13','20','21','25','29','113','118','119','124'},...
    {'53','54','60','61','62','67','68','78','79','80','86','87'}};%,...

%% Load in data
clusters={{'4','5','6','11','12','13','20','21','25','29','113','118','119','124'},...
    {'53','54','60','61','62','67','68','78','79','80','86','87'}};%,...

frontal = clusters{1};
parietal = clusters{2};

for block_i = 2%:length(conditions)
    %     conditions=blocks{block_i};
    
    count1 = 0;
    count2 = 0;
    cond_mwtf1 = zeros(80,6001);
    cond_mwtf2 = zeros(80,6001);
    frontal_data_forttest = zeros(length(1:30),80,6001);
    parietal_data_forttest = zeros(length(1:30),80,6001);
    
    for name_i = 1:length(names)
        fprintf('\n%s\t%s','Working on subject:',names{name_i});
        tempdata = zeros(80,6001);
        for cluster_i = 1%:length(clusters)
            clusterelec = clusters{cluster_i};
            for elec_i = 1:length(clusterelec)
                fprintf('.');
                load([datain names{name_i} filesep conditions{block_i} filesep names{name_i} '_' conditions{block_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf1 = cond_mwtf1 + mw_tf;
                count1 = count1+1;
                tempdata = tempdata+mw_tf;
            end
        end        
        frontal_data_forttest(name_i,:,:) = tempdata./(length(clusterelec));%*length(conditions));
        
        tempdata2 = zeros(80,6001);
        for cluster_i = 2%:length(clusters)
            clusterelec = clusters{cluster_i};
            for elec_i = 1:length(clusterelec)
                fprintf('.');
                load([datain names{name_i} filesep conditions{block_i} filesep names{name_i} '_' conditions{block_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf2 = cond_mwtf2 + mw_tf;
                count2 = count2+1;
                tempdata2 = tempdata2+mw_tf;
            end
        end
        parietal_data_forttest(name_i,:,:) = tempdata2./(length(clusterelec));%*length(conditions));
        
    end
    
    frontal_avg = cond_mwtf1./count1;
    parietal_avg = cond_mwtf2./count2;
    
    clear cond_mw_tf1 cond_mw_tf2 tempdata tempdata2 count1 count2 mw_tf
    
    save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_avg_' conditions{block_i} '_' clusternames{1} '_power.mat'],'frontal_avg');
    save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_avg_' conditions{block_i} '_' clusternames{2} '_power.mat'],'parietal_avg');
    save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_data_' conditions{block_i} '_' clusternames{1} '_power.mat'],'frontal_data_forttest');
    save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_' conditions{block_i} '_' clusternames{2} '_power.mat'],'parietal_data_forttest');  
end

%% Plot
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        %             subplot(1,2,1);contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
%         mask_data_young=zeros(size(young_avg(1:68,801:6801)));
%         temp_data_young=young_avg(1:68,801:6801);
%         mask_data_young(p_thresh_young(1:68,:)==1)=temp_data_young(p_thresh_young(1:68,:)==1);
        subplot(1,2,1);contourf(times(1601:4001),frex(1:68),frontal_avg(1:68,1601:4001),50,'linecolor','none');caxis([-3 3]);colormap(jet);
        hold on;
%        subplot(1,2,1);contour(times(801:6801),frex(1:68),p_thresh_young(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['Frontal ' conditions{block_i}]);axis square;
        
%         mask_data_old=zeros(size(old_avg(1:68,801:6801)));
%         temp_data_old=old_avg(1:68,801:6801);
%         mask_data_old(p_thresh_old(1:68,:)==1)=temp_data_old(p_thresh_old(1:68,:)==1);
        subplot(1,2,2);contourf(times(1601:4001),frex(1:68),parietal_avg(1:68,1601:4001),50,'linecolor','none');caxis([-3 3])
        
        %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
%         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['Parietal ' conditions{block_i}]);axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_' conditions{block_i} '_Power.pdf'],'pdf');
%         close

%% Analyse time point*frex
% NOT THE CONDITION AVERAGE!!!
%Frontal
single_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_data_single_Frontal_power.mat'], 'frontal_data_forttest');
repeat_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_data_repeat_Frontal_power.mat'], 'frontal_data_forttest');

sf = single_frontal.frontal_data_forttest;
rf = repeat_frontal.frontal_data_forttest;

p_front = zeros(68,length(2001:4001));
% t_frontal = zeros(68,length(1:6001));
for freq = 1:68
    [~,p_front(freq,:)] = ttest(squeeze(sf(:,freq,2001:4001)),squeeze(rf(:,freq,2001:4001)),'Alpha', 0.05);
end

% Pareital
% clear all

single_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_single_Parietal_power.mat'], 'parietal_data_forttest');
repeat_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_repeat_Parietal_power.mat'], 'parietal_data_forttest');

sp = single_parietal.parietal_data_forttest;
rp = repeat_parietal.parietal_data_forttest;

p_pariet = zeros(68,length(2001:4001));
% t_parietal.tstat = zeros(68,length(1:6001));
for freq = 1:68
    [~,p_pariet(freq,:)] = ttest(squeeze(sp(:,freq,2001:4001)),squeeze(rp(:,freq,2001:4001)),'Alpha', 0.05);
end


%% Apply FDR corrections

addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox\'));
thresh =0.05;

p_crit = zeros(size(p_frontal));
h_crit = zeros(size(p_crit));

for freq = 1:68
    [~,p_crit(freq,:)]=fdr_bky(p_frontal(freq,:),thresh,'no');
end

p_thresh_frontal=zeros(size(p_frontal));
p_thresh_frontal(p_frontal<crit_p)=1;
% save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\p_thresh_young' blocknames{block_i} '_Pz.mat'],'p_thresh_young');

[~,crit_p]=fdr_bky(p_parietal,thresh,'no');
p_thresh_parietal=zeros(size(p_parietal));
p_thresh_parietal(p_parietal<crit_p)=1;
% save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_old' blocknames{block_i} '_Pz.mat'],'p_thresh_old');


%% Load in data - avg over trial types 
clusters={{'4','5','6','11','12','13','20','21','25','29','113','118','119','124'},...
    {'53','54','60','61','62','67','68','21','25','29','113','118','119','124'}};%,...

frontal = clusters{1};
parietal = clusters{2};

for cluster_i = 1:length(clusters)
    %     conditions=blocks{block_i};
    
    count1 = 0;
%     count2 = 0;
    cond_mwtf1 = zeros(80,6001);
%     cond_mwtf2 = zeros(80,6001);
    data_forttest = zeros(length(1:30),80,6001);
%     parietal_data_forttest = zeros(length(1:30),80,6001);
    
    for name_i = 1:length(names)
        fprintf('\n%s\t%s','Working on subject:',names{name_i});
        tempdata = zeros(80,6001);
        for cond_i = 1:length(conditions)
            clusterelec = clusters{cluster_i};
            for elec_i = 1:length(clusterelec)
                fprintf('.');
                load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf1 = cond_mwtf1 + mw_tf;
                count1 = count1+1;
                tempdata = tempdata+mw_tf;
            end
        end        
        data_forttest(name_i,:,:) = tempdata./(length(clusterelec));%*length(conditions));
        
%         tempdata2 = zeros(80,6001);
%         for cluster_i = 2%:length(clusters)
%             clusterelec = clusters{cluster_i};
%             for elec_i = 1:length(clusterelec)
%                 fprintf('.');
%                 load([datain names{name_i} filesep conditions{block_i} filesep names{name_i} '_' conditions{block_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
%                 cond_mwtf2 = cond_mwtf2 + mw_tf;
%                 count2 = count2+1;
%                 tempdata2 = tempdata2+mw_tf;
%             end
%         end
%         parietal_data_forttest(name_i,:,:) = tempdata2./(length(clusterelec));%*length(conditions));
        
    end
    
   avg = cond_mwtf1./count1;
%     parietal_avg = cond_mwtf2./count2;
    
    clear cond_mw_tf1 cond_mw_tf2 tempdata tempdata2 count1 count2 mw_tf
    
    save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\' clusternames{cluster_i} '_power.mat'],'avg');
%     save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_avg_' conditions{block_i} '_' clusternames{2} '_power.mat'],'parietal_avg');
    save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\' clusternames{cluster_i} '_ttestdata.mat'],'data_forttest');
%     save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_' conditions{block_i} '_' clusternames{2} '_power.mat'],'parietal_data_forttest');  
end

%% Analyse time point*frex for Condition Avg

frontal = load('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Frontal_ttestdata.mat', 'data_forttest');
parietal = load('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Parietal_ttestdata.mat', 'data_forttest');

front = frontal.data_forttest;
back = parietal.data_forttest;

front_avg = load('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Frontal_power.mat', 'avg');
parietal_avg = load('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Parietal_power.mat', 'avg');

front_mean = front_avg.avg;
parietal_mean = parietal_avg.avg;

p_frontal = zeros(68,length(2001:4001));
p_parietal = zeros(68,length(2001:4001));

for freq = 1:68
    [~,p_frontal(freq,:)] = ttest(squeeze(front(:,freq,2001:4001)));%,'Alpha', 0.05);
end

for freq = 1:68
    [~,p_parietal(freq,:)] = ttest(squeeze(back(:,freq,2001:4001)));%,'Alpha', 0.05);
end

% Apply FDR Corrections
addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox\'));
thresh =0.001;

p_crit = zeros(size(p_frontal));
crit_p = zeros(size(p_crit));

for freq = 1:68
    [~,p_crit(freq,:)]=fdr_bky(p_frontal(freq,:),thresh,'no');
end

for freq = 1:68
    [~,crit_p(freq,:)]=fdr_bky(p_parietal(freq,:),thresh,'no');
end
    
p_thresh_frontal=zeros(size(p_frontal));
p_thresh_frontal(p_frontal<p_crit)=1;
save('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\p_thresh_TaskAvg_frontal.mat','p_thresh_frontal');

p_thresh_parietal=zeros(size(p_parietal));
p_thresh_parietal(p_parietal<crit_p)=1;
save('E:\fieldtrip\WAVELET_OUTPUT_DIR\results\p_thresh_TaskAvg_parietal.mat','p_thresh_parietal');


%% Plot

% Frontal
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        subplot(1,2,1);contourf(times(1601:4001),frex(1:68),front_mean(1:68,1601:4001),50,'linecolor','none');caxis([-2.5 2.5]);colormap(jet)
        mask_data_front=zeros(size(front_mean(1:68,2001:4001)));
        temp_data_front=front_mean(1:68,2001:4001);
        mask_data_front(p_thresh_frontal(1:68,:)==1)=temp_data_front(p_thresh_frontal(1:68,:)==1);
%         subplot(1,2,1);contourf(times(1601:4001),frex(1:68),frontal_avg(1:68,1601:4001),50,'linecolor','none');caxis([-2 2]);colormap(jet);
        hold on;
       subplot(1,2,1);contour(times(2001:4001),frex(1:68),p_thresh_frontal(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2.5 2.5])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title('Frontal');axis square;
        
% Parietal
        mask_data_parietal=zeros(size(parietal_mean(1:68,2001:4001)));
        temp_data_parietal=parietal_mean(1:68,2001:4001);
        mask_data_parietal(p_thresh_parietal(1:68,:)==1)=temp_data_parietal(p_thresh_parietal(1:68,:)==1);
        subplot(1,2,2);contourf(times(1601:4001),frex(1:68),parietal_mean(1:68,1601:4001),50,'linecolor','none');caxis([-2.5 2.5])
        
%         subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
        subplot(1,2,2);contour(times(2001:4001),frex(1:68),p_thresh_parietal(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2.5 2.5])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title('Parietal');axis square;
        saveas(gcf,[dataout 'Incidental_Memory_TaskAvg_Power_005.pdf'],'pdf');
%         close

%% Cohort Avg Loop
% Take the 12 groups for each dose pre and post recording.
% Need to collate data for each cluster and trial type. 

clusters={{'4','5','6','11','12','13','20','21','25','29','113','118','119','124'},...
    {'53','54','60','61','62','67','68','78','79','80','86','87'}};%,...

% frontal = clusters{1};
% parietal = clusters{2};

for cohort_i = 1:length(cohorts) % Looping thru dose groups
    
    session = cohortnames{cohort_i}; % Define dose group names
    
%     % Define session splits, pre/post-drug NOT NEEDED
%     pre = num2cell(1:(length(cohorts{cohort_i})/2)); 
%     post = num2cell((length(cohorts{cohort_i})/2)+1:length(cohorts{cohort_i}));
%     session = {pre,post};
%     sessionname = {'pre','post'};
    
%     for session_i = 1:length(session) % Looping thru pre/post-drug

        for block_i = 1:length(conditions) % Looping thru trial types
            %     conditions=blocks{block_i};
            
            count1 = 0; % Frontal cluster
            count2 = 0; % Parietal cluster
            cond_mwtf1 = zeros(80,6001); 
            cond_mwtf2 = zeros(80,6001);
            frontal_data_forttest = zeros(length(cohorts{cohort_i}),80,6001);
            parietal_data_forttest = zeros(length(cohorts{cohort_i}),80,6001);
            
            for name_i = 1:length(cohorts{cohort_i})
                fprintf('\n%s\t%s','Working on subject:',cohorts{cohort_i}{name_i});
                tempdata = zeros(80,6001);
                for cluster_i = 1%:length(clusters)
                    clusterelec = clusters{cluster_i};
                    for elec_i = 1:length(clusterelec)
                        fprintf('.');
                        load([datain cohorts{cohort_i}{name_i} filesep conditions{block_i} filesep cohorts{cohort_i}{name_i} '_' conditions{block_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                        cond_mwtf1 = cond_mwtf1 + mw_tf;
                        count1 = count1+1;
                        tempdata = tempdata+mw_tf;
                    end
                end
                frontal_data_forttest(name_i,:,:) = tempdata./(length(clusterelec));%*length(conditions));
                
                tempdata2 = zeros(80,6001);
                for cluster_i = 2%:length(clusters)
                    clusterelec = clusters{cluster_i};
                    for elec_i = 1:length(clusterelec)
                        fprintf('.');
                        load([datain cohorts{cohort_i}{name_i} filesep conditions{block_i} filesep cohorts{cohort_i}{name_i} '_' conditions{block_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                        cond_mwtf2 = cond_mwtf2 + mw_tf;
                        count2 = count2+1;
                        tempdata2 = tempdata2+mw_tf;
                    end
                end
                parietal_data_forttest(name_i,:,:) = tempdata2./(length(clusterelec));%*length(conditions));
                
            end
            
            frontal_avg = cond_mwtf1./count1;
            parietal_avg = cond_mwtf2./count2;
            
            clear cond_mw_tf1 cond_mw_tf2 tempdata tempdata2 count1 count2 mw_tf
            
            save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\' session '_frontal_avg_' conditions{block_i} '_power.mat'],'frontal_avg');
            save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\' session '_parietal_avg_' conditions{block_i} '_power.mat'],'parietal_avg');
            save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\' session '_frontal_data_' conditions{block_i} '_power.mat'],'frontal_data_forttest');
            save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\' session '_parietal_data_' conditions{block_i} '_power.mat'],'parietal_data_forttest');
            
            clear frontal_avg parietal_avg frontal_data_forttest parietal_data_forttest
            
        end
        
        
        
        
%     end
end


%% Export avg values between 300-600ms that fall in task avg FDR
% 
% Loop through Cohorts, Conditions, Clusters, load in FDR corrected p-value thresholds
% Then average over time window of interest, and save averaged data
% Then export to Excel
% Optional to avg columns for each freq band
%


for cohort_i = 1:length(cohorts)
    session = cohortnames{cohort_i};
    clusternames = {'frontal','parietal'};
    
    for cond_i = 1:length(conditions)
        
        for cluster_i = 1:length(clusters)
            roi = clusternames{cluster_i};
            
            tmp_data = zeros(length(cohorts{cohort_i}),68,601);
            power = zeros(length(cohorts{cohort_i}),68);
            
            temp = load([dataout session '_' roi '_data_' conditions{cond_i} '_power.mat'], [roi '_data_forttest']);
            temp1 = temp.([roi '_data_forttest']);
            
            %             single_frontal = load([dataout filesep 'frontal_data_single_Frontal_power.mat'],'frontal_data_forttest');
            %             repeat_parietal = load([dataout filesep 'pareital_data_repeat_Parietal_power.mat'],'parietal_data_forttest');
            %             single_frontal =  single_frontal.frontal_data_forttest;
            %             single_parietal = single_parietal.parietal_data_forttest;
            
            thresh = load([dataout 'p_thresh_TaskAvg_' roi '.mat'], [ 'p_thresh_' roi]);
            thresh1 = thresh.([ 'p_thresh_' roi]);
            
            for name_i = 1:length(cohorts{cohort_i})
                fprintf('\n%s\t%s','Working on subject:',cohorts{cohort_i}{name_i});
                for freq_i = 1:68
                    for time_i = 1:401 % time_i starts at 2001, as thats's when p_thresh begins
                        if thresh1(freq_i,time_i+600)==1
                            tmp_data(name_i,freq_i,time_i) = temp1(name_i,freq_i,time_i+2600); % 2600 = 300ms post-stimulus
                        end
                    end
                end
            end
            
            power = mean(tmp_data,3);
            
            % sf_avg = mean(tmp_data,3);
            % sp_avg = mean(tmp_data,3);
            % rf_avg = mean(tmp_data,3);
            % rp_avg = mean(tmp_data,3);
            clear temp temp1 thresh thresh1 tmp_data
            
            % Average across four freq bands - first, split power data into
            % 4 different files; 
            deltatab = power(:,1:18);
            thetatab = power(:,19:35);
            alphatab = power(:,36:49);
            betatab = power(:,50:end);
            tab = {deltatab,thetatab,alphatab,betatab};
            % Then average over freq comlumns; Then recombine into 1 file
            tab1 = [];tab2 = [];powertab=[];
            for tab_i = 1:4
                for freq_i = 1:length(tab{tab_i})
                    if tab{tab_i}(:,freq_i) ~= 0
                        tab1 = [tab1,tab{tab_i}(:,freq_i)];
                    end
                end
                tab2 = mean(tab1,2);
                powertab = [powertab,tab2];
            end
                
            clear tab1 tab2
                        
            % Write the power to a CSV file
%             filename = [session '_' roi '_data_' conditions{cond_i} '_300-600_power.csv'];
%             csvwrite(filename,power);

            % Write the avg freq band power to a CSV file
            filename = [session '_' roi '_data_' conditions{cond_i} '_300-600_avgpower.csv'];
            csvwrite(filename,powertab);            
            
%             save([dataout session '_' roi '_data_' conditions{cond_i} '_300-600_power.mat'],'power');
            
            clear power filename powertab
            % save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_single_200-400_power.mat'],'sp_avg');
            % save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_repeat_200-400_power.mat'],'rf_avg');
            
            % load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_single_300-600_power.mat'],'sf_avg');
            % load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_single_300-600_power.mat'],'sp_avg');
            
            %             for freq_i = 1:68
            %                 [~,p_frontal(1,freq_i),~,t_frontal(1,freq_i)] = ttest(sf_avg(:,freq_i),rf_avg(:,freq_i));%,'Alpha', 0.05));
            %             end
            %
            %             for freq_i = 1:68
            %                 [~,p_parietal(1,freq_i),~,t_parietal(1,freq_i)] = ttest(sp_avg(:,freq_i),rp_avg(:,freq_i));%,'Alpha', 0.05));
            %             end
            
            % save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_pval_250-500_power.mat'],'p_frontal');
            % save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_pval_250-500_power.mat'],'p_parietal');
            
        end
    end
end

%%

% Getting pvals/tvals for the regions

% Better idea to follow Cooper et al 2016 (NeuroImage) - take the avg power
% for each trial type/each cluster/freq band that passes task avg FDR
% correction 


% single_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_data_single_Frontal_power.mat'], 'frontal_data_forttest');
% repeat_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_data_repeat_Frontal_power.mat'], 'frontal_data_forttest');
% 
% single_frontal = single_frontal.frontal_data_forttest;
% repeat_frontal = repeat_frontal.frontal_data_forttest;
% 
% pvals_frontal = zeros(68,length(2001:4001));
% tvals_frontal.tstat = zeros(68,length(2001:4001));


single_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_avg_single_Frontal_power.mat'], 'frontal_avg');
repeat_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_avg_repeat_Frontal_power.mat'], 'frontal_avg');

single_frontal = single_frontal;
repeat_frontal = repeat_frontal;

frontal_diff = zeros(68,length(2001:4001));

for freq_i = 1:68
    for time_i = 1:2001
        if p_thresh_frontal(freq_i,time_i)==1
%             frontal_diff(freq_i,time_i) = single_frontal(freq_i,time_i+2000) - repeat_frontal(freq_i,time_i+2000); 
            [~,pvals_frontal(freq_i,time_i)] = ttest(single_frontal(:,freq,2001:4001),repeat_frontal(:,freq,2001:4001),'Alpha', 0.05);
        end
    end

end

for freq_i = 1:68
    for time_1 = 1:2001
        [~,pvals_parietal(freq_i,time_i),] = ttest(parietal_diff(freq_i,time_i));
    end
end
% single_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_single_Parietal_power.mat'], 'parietal_data_forttest');
% repeat_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_repeat_Parietal_power.mat'], 'parietal_data_forttest');
% 
% single_parietal = single_parietal.parietal_data_forttest;
% repeat_parietal = repeat_parietal.parietal_data_forttest;

pvals_parietal = zeros(68,length(2001:4001));
tvals_parietal.tstat = zeros(68,length(2001:4001));

single_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_avg_single_Parietal_power.mat'], 'parietal_avg');
repeat_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_avg_repeat_Parietal_power.mat'], 'parietal_avg');

single_parietal = single_parietal.parietal_avg;
repeat_parietal = repeat_parietal.parietal_avg;

parietal_diff = zeros(68,length(2001:4001));

for freq_i = 1:68
    for time_i = 1:2001
        if p_thresh_parietal(freq_i,time_i)==1;
%             parietal_diff(freq_i,time_i) = single_parietal(freq_i,time_i+2000) - repeat_parietal(freq_i,time_i+2000);
            [~,pvals_parietal(freq_i,time_i)] = ttest(single_parietal(freq,2001:4001),repeat_parietal(freq,2001:4001),'Alpha', 0.05);
        end
    end

end

for freq_i = 1:68
    for time_1 = 1:2001
        [~,pvals_parietal(freq_i,time_i),] = ttest(parietal_diff(freq_i,time_i));
    end
end

%%
%     for cluster_i= 1 :length(clusters)
%         clusterelec = clusters{cluster_i};
%         electrodes = find(ismember(labels,clusterelec));
        count1 = 0;
%         count2 = count1;
        cond_mwtf1 = zeros(80,6001);
%         cond_mwtf2 = cond_mwtf1;
        
        data_forttest = zeros(length(1:30),80,6001);
%         olddata_forttest =zeros(length(25:length(names)),80,6001);
        
        % for group_i = 1:length(age_group)
        for name_i = 1:length
            fprintf('\n%s\t%s','Working on subject:',names{name_i});
            tempdata = zeros(80,6001);
            for cond_i = 1:length(blocks)
                for elec_i = 1:length(electrodes)
                    fprintf('.');
                    load([datain names{name_i} filesep blocks{cond_i} filesep names{name_i} '_' blocks{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                    cond_mwtf1 = cond_mwtf1 + mw_tf;
                    count1 = count1+1;
                    tempdata = tempdata+mw_tf;
                end
            end
            youngdata_forttest(name_i,:,:) = tempdata./(length(electrodes)*length(conditions));
        end
        
        
%         for name_i = 25:length(names)
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             tempdata = zeros(80,6001);
%             for cond_i = 1:length(blocks)
%                 for elec_i = 1:length(electrodes)
%                     fprintf('.');
%                     load([datain names{name_i} filesep blocks{cond_i} filesep names{name_i} '_' blocks{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     cond_mwtf2 = cond_mwtf2 + mw_tf;
%                     count2 = count2+1;
%                     tempdata = tempdata+mw_tf;
%                 end
%                 
%             end
%             olddata_forttest(name_i,:,:) = tempdata./(length(electrodes)*length(conditions));
%         end
%         if strcmpi(clusternames{cluster_i},'P')
%             p_young = zeros(68,length(1:9801));
%             for freq = 1:68
%                 [~,p_young(freq,:)] = ttest(squeeze(youngdata_forttest(:,freq,1:9801)));
%             end
%             
%             p_old = zeros(68,length(1:9801));
%             for freq = 1:68
%                 [~,p_old(freq,:)] = ttest(squeeze(olddata_forttest(:,freq,1:9801)));
%             end
%             
%             addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox\'));
%             thresh =0.005;
%             [~,crit_p]=fdr_bky(p_young,thresh,'no');
%             p_thresh_young=zeros(size(p_young));
%             p_thresh_young(p_young<crit_p)=1;
%             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_young' blocknames{block_i} '_Pz.mat'],'p_thresh_young');
%             
%             [~,crit_p]=fdr_bky(p_old,thresh,'no');
%             p_thresh_old=zeros(size(p_old));
%             p_thresh_old(p_old<crit_p)=1;
%             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_old' blocknames{block_i} '_Pz.mat'],'p_thresh_old');
%         end
        %% Avg across names
        young_avg = cond_mwtf1./count1;
        old_avg = cond_mwtf2./count2;
        % avg_group = cond_mwtf/length(names);
        
        save(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_avg' blocknames{block_i} '_' clusternames{cluster_i} '_power.mat'],'young_avg');
        save(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_avg' blocknames{block_i} '_' clusternames{cluster_i} '_power.mat'],'old_avg');
        
        
        %% filter sig for plotting outlines
        
        %% Plot
%         figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
%         %             subplot(1,2,1);contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
% %         mask_data_young=zeros(size(young_avg(1:68,801:6801)));
% %         temp_data_young=young_avg(1:68,801:6801);
% %         mask_data_young(p_thresh_young(1:68,:)==1)=temp_data_young(p_thresh_young(1:68,:)==1);
%         subplot(1,2,1);contourf(times(1401:6201),frex(1:68),young_avg(1:68,1401:6201),50,'linecolor','none');caxis([-2 2])
%         hold on;
% %        subplot(1,2,1);contour(times(801:6801),frex(1:68),p_thresh_young(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
%         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
%         set(gca,'FontSize',18);title(['YOUNG ' clusternames{cluster_i} ' ' blocknames{block_i}]);axis square;
%         
% %         mask_data_old=zeros(size(old_avg(1:68,801:6801)));
% %         temp_data_old=old_avg(1:68,801:6801);
% %         mask_data_old(p_thresh_old(1:68,:)==1)=temp_data_old(p_thresh_old(1:68,:)==1);
%         subplot(1,2,2);contourf(times(1401:6201),frex(1:68),old_avg(1:68,1401:6201),50,'linecolor','none');caxis([-2 2])
%         
%         %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
%         hold on;
% %         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
%         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
%         set(gca,'FontSize',18);title(['OLD ' clusternames{cluster_i} ' ' blocknames{block_i}]);axis square;
%         saveas(gcf,[dataout 'TIMEF_' clusternames{cluster_i} '_' blocknames{block_i} '_Power.pdf'],'pdf');
%         close
%         
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
        
%         
%     end
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

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

names = {'wc01_scenes_002','wc115_scenes_002','wc1102_scenes_002','wc1103_scenes_002','wc1104_scenes_002',...
    'wc1105_scenes_002','wc1107_scenes_002','wc1108_scenes_002','wc1109_scenes_002',...
    'wc1110_scenes_002','wc1111_scenes_002','wc1112_scenes_002','wc1113_scenes_002','wc1114_scenes_002','wc1115_scenes_002',...
    'wc1116_scenes_002','wc1117_scenes_002','wc1118_scenes_002','wc1119_scenes_002','wc1120_scenes_002','wc1121_scenes_002',...
    'wc1122_scenes_002','wc1123_scenes_002','wc1124_scenes_002','wc1125_scenes_002','wc1126_scenes_002','wc1128_scenes_002',...
    'wc1129_scenes_002','wc1130_scenes_002','wc1131_scenes_002'}; %	'wc1106_scenes_002',

% groupinds = [24,57];
% young = [1:24];
% old =  [25:length(names)];
% age_group = {young, old};
conditions = {'single','repeat'};
% blocknames = {'nogo'};%,'dir',nogo,nondir};
clusternames = {'Frontal','Parietal'};
addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
stats = zeros(length(names),5,5,5);
%% Load in data - Mainly for initial data structures
clusters={{'4','5','6','11','12','13','20','21','25','29','113','118','119','124'},...
    {'53','54','60','61','62','67','68','78','79','80','86','87'}};%,...

frontal = clusters{1};
parietal = clusters{2};

for block_i = 2%:length(conditions)
    %     conditions=blocks{block_i};
    
    count1 = 0;
    count2 = 0;
    cond_mwtf1 = zeros(80,751);
    cond_mwtf2 = zeros(80,751);
    frontal_data_forttest = zeros(length(1:30),80,751);
    parietal_data_forttest = zeros(length(1:30),80,751);
    
    for name_i = 1:length(names)
        fprintf('\n%s\t%s','Working on subject:',names{name_i});
        tempdata = zeros(80,751);
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
        
        tempdata2 = zeros(80,751);
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

%% Plot - Averages of Overall Data
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        %             subplot(1,2,1);contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
%         mask_data_young=zeros(size(young_avg(1:68,801:6801)));
%         temp_data_young=young_avg(1:68,801:6801);
%         mask_data_young(p_thresh_young(1:68,:)==1)=temp_data_young(p_thresh_young(1:68,:)==1);
        subplot(1,2,1);contourf(times(201:501),frex(1:68),frontal_avg(1:68,201:501),50,'linecolor','none');caxis([-2 2]);colormap(parula);
        hold on;
%        subplot(1,2,1);contour(times(801:6801),frex(1:68),p_thresh_young(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['Frontal ' conditions{block_i}]);axis square;
        
%         mask_data_old=zeros(size(old_avg(1:68,801:6801)));
%         temp_data_old=old_avg(1:68,801:6801);
%         mask_data_old(p_thresh_old(1:68,:)==1)=temp_data_old(p_thresh_old(1:68,:)==1);
        subplot(1,2,2);contourf(times(201:501),frex(1:68),parietal_avg(1:68,201:501),50,'linecolor','none');caxis([-2 2])
        
        %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
%         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title(['Parietal ' conditions{block_i}]);axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_' conditions{block_i} '_Power.pdf'],'pdf');
%         close

%% Analyse time point*frex - LEAVE THIS SECTION; 

%Frontal
single_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_data_single_Frontal_power.mat'], 'frontal_data_forttest');
repeat_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_data_repeat_Frontal_power.mat'], 'frontal_data_forttest');

sf = single_frontal.frontal_data_forttest;
rf = repeat_frontal.frontal_data_forttest;

p_front = zeros(68,length(251:501));
% t_frontal = zeros(68,length(1:6001));
for freq = 1:68
    [~,p_front(freq,:)] = ttest(squeeze(sf(:,freq,251:501)),squeeze(rf(:,freq,251:501)),'Alpha', 0.05);
end

% Pareital
% clear all

single_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_single_Parietal_power.mat'], 'parietal_data_forttest');
repeat_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_repeat_Parietal_power.mat'], 'parietal_data_forttest');

sp = single_parietal.parietal_data_forttest;
rp = repeat_parietal.parietal_data_forttest;

p_pariet = zeros(68,length(251:501));
% t_parietal.tstat = zeros(68,length(1:6001));
for freq = 1:68
    [~,p_pariet(freq,:)] = ttest(squeeze(sp(:,freq,251:501)),squeeze(rp(:,freq,251:501)),'Alpha', 0.05);
end

% Apply FDR corrections - LEAVE THIS SECTION

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
    cond_mwtf1 = zeros(80,751);
%     cond_mwtf2 = zeros(80,751);
    data_forttest = zeros(length(1:30),80,751);
%     parietal_data_forttest = zeros(length(1:30),80,751);
    
    for name_i = 1:length(names)
        fprintf('\n%s\t%s','Working on subject:',names{name_i});
        tempdata = zeros(80,751);
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

frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Frontal_ttestdata.mat'], 'data_forttest');
parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Parietal_ttestdata.mat'], 'data_forttest');

front = frontal.data_forttest;
back = parietal.data_forttest;

front_avg = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Frontal_power.mat'], 'avg');
parietal_avg = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Parietal_power.mat'], 'avg');

front_mean = front_avg.avg;
parietal_mean = parietal_avg.avg;

p_frontal = zeros(68,length(251:501));
p_parietal = zeros(68,length(251:501));

for freq = 1:68
    [~,p_frontal(freq,:)] = ttest(squeeze(front(:,freq,251:501)));%,'Alpha', 0.05);
end

for freq = 1:68
    [~,p_parietal(freq,:)] = ttest(squeeze(back(:,freq,251:501)));%,'Alpha', 0.05);
end

% Apply FDR Corrections
addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox\'));
thresh =0.005;

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
save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\p_thresh_TaskAvg_frontal.mat'],'p_thresh_frontal');

p_thresh_parietal=zeros(size(p_parietal));
p_thresh_parietal(p_parietal<crit_p)=1;
save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\p_thresh_TaskAvg_parietal.mat'],'p_thresh_parietal');


%% Plot

% Frontal
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
        subplot(1,2,1);contourf(times(201:501),frex(1:68),front_mean(1:68,201:501),50,'linecolor','none');caxis([-2 2]);colormap(parula)
        mask_data_front=zeros(size(front_mean(1:68,251:501)));
        temp_data_front=front_mean(1:68,201:501);
        mask_data_front(p_thresh_frontal(1:68,:)==1)=temp_data_front(p_thresh_frontal(1:68,:)==1);
%         subplot(1,2,1);contourf(times(1601:4001),frex(1:68),frontal_avg(1:68,1601:4001),50,'linecolor','none');caxis([-2 2]);colormap(jet);
        hold on;
       subplot(1,2,1);contour(times(251:501),frex(1:68),p_thresh_frontal(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title('Frontal');axis square;
        
% Parietal
        mask_data_parietal=zeros(size(parietal_mean(1:68,251:501)));
        temp_data_parietal=parietal_mean(1:68,251:501);
        mask_data_parietal(p_thresh_parietal(1:68,:)==1)=temp_data_parietal(p_thresh_parietal(1:68,:)==1);
        subplot(1,2,2);contourf(times(201:501),frex(1:68),parietal_mean(1:68,201:501),50,'linecolor','none');caxis([-2 2])
        
%         subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
        hold on;
        subplot(1,2,2);contour(times(251:501),frex(1:68),p_thresh_parietal(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
        xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
        set(gca,'FontSize',18);title('Parietal');axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_TaskAvg_Power_005.pdf'],'pdf');
%         close

%% Export avg values between after 0ms that fall in task avg FDR
% Previously: For all vals between 200-400ms 
% Previously: For all vals between 300-600ms
tmp_data = zeros(30,68,251);
 
single_frontal = load([dataout '\Incidental_Mem30' filesep 'frontal_data_single_Frontal_power.mat'],'frontal_data_forttest');
single_parietal = load([dataout '\Incidental_Mem30' filesep 'pareital_data_single_Parietal_power.mat'],'parietal_data_forttest');
repeat_frontal = load([dataout '\Incidental_Mem30' filesep 'frontal_data_repeat_Frontal_power.mat'],'frontal_data_forttest');
repeat_parietal = load([dataout '\Incidental_Mem30' filesep 'pareital_data_repeat_Parietal_power.mat'],'parietal_data_forttest');

single_frontal =  single_frontal.frontal_data_forttest;
single_parietal = single_parietal.parietal_data_forttest;
repeat_frontal = repeat_frontal.frontal_data_forttest;
repeat_parietal = repeat_parietal.parietal_data_forttest;

trials = {single_frontal,single_parietal,repeat_frontal,repeat_parietal};

% cluster_i = 1;%:length(clusters);
% cond_i = 1;%:length(conditions);

for name_i = 1:length(names)
    for freq_i = 1:68
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

% save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Incidental_Mem30\frontal_single_0-1000_power.mat'],'sf_avg');
% save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Incidental_Mem30\pareital_single_0-1000_power.mat'],'sp_avg');
% save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Incidental_Mem30\frontal_repeat_0-1000_power.mat'],'rf_avg');
save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\Incidental_Mem30\pareital_repeat_0-1000_power.mat'],'rp_avg');

% load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_single_300-600_power.mat'],'sf_avg');
% load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_single_300-600_power.mat'],'sp_avg');
% load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_repeat_300-600_power.mat'],'rf_avg');
% load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_repeat_300-600_power.mat'],'rp_avg');
% 
% for freq_i = 1:68
%     [~,p_frontal(1,freq_i),~,t_frontal(1,freq_i)] = ttest(sf_avg(:,freq_i),rf_avg(:,freq_i));%,'Alpha', 0.05));
% end
% 
% for freq_i = 1:68
%     [~,p_parietal(1,freq_i),~,t_parietal(1,freq_i)] = ttest(sp_avg(:,freq_i),rp_avg(:,freq_i));%,'Alpha', 0.05));
% end

% save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_pval_250-500_power.mat'],'p_frontal');
% save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_pval_250-500_power.mat'],'p_parietal');


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
% pvals_frontal = zeros(68,length(251:501));
% tvals_frontal.tstat = zeros(68,length(251:501));


single_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_avg_single_Frontal_power.mat'], 'frontal_avg');
repeat_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_avg_repeat_Frontal_power.mat'], 'frontal_avg');

single_frontal = single_frontal;
repeat_frontal = repeat_frontal;

frontal_diff = zeros(68,length(251:501));

for freq_i = 1:68
    for time_i = 1:251
        if p_thresh_frontal(freq_i,time_i)==1
%             frontal_diff(freq_i,time_i) = single_frontal(freq_i,time_i+2000) - repeat_frontal(freq_i,time_i+2000); 
            [~,pvals_frontal(freq_i,time_i)] = ttest(single_frontal(:,freq,251:501),repeat_frontal(:,freq,251:501),'Alpha', 0.05);
        end
    end

end

for freq_i = 1:68
    for time_1 = 1:251
        [~,pvals_parietal(freq_i,time_i),] = ttest(parietal_diff(freq_i,time_i));
    end
end
% single_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_single_Parietal_power.mat'], 'parietal_data_forttest');
% repeat_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_repeat_Parietal_power.mat'], 'parietal_data_forttest');
% 
% single_parietal = single_parietal.parietal_data_forttest;
% repeat_parietal = repeat_parietal.parietal_data_forttest;

pvals_parietal = zeros(68,length(251:501));
tvals_parietal.tstat = zeros(68,length(251:501));

single_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_avg_single_Parietal_power.mat'], 'parietal_avg');
repeat_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_avg_repeat_Parietal_power.mat'], 'parietal_avg');

single_parietal = single_parietal.parietal_avg;
repeat_parietal = repeat_parietal.parietal_avg;

parietal_diff = zeros(68,length(251:501));

for freq_i = 1:68
    for time_i = 1:251
        if p_thresh_parietal(freq_i,time_i)==1
%             parietal_diff(freq_i,time_i) = single_parietal(freq_i,time_i+2000) - repeat_parietal(freq_i,time_i+2000);
            [~,pvals_parietal(freq_i,time_i)] = ttest(single_parietal(freq,251:501),repeat_parietal(freq,251:501),'Alpha', 0.05);
        end
    end

end

for freq_i = 1:68
    for time_1 = 1:251
        [~,pvals_parietal(freq_i,time_i),] = ttest(parietal_diff(freq_i,time_i));
    end
end

%% OLDER DATASET COMPARISONS %%

%     for cluster_i= 1 :length(clusters)
%         clusterelec = clusters{cluster_i};
%         electrodes = find(ismember(labels,clusterelec));
        count1 = 0;
%         count2 = count1;
        cond_mwtf1 = zeros(80,751);
%         cond_mwtf2 = cond_mwtf1;
        
        data_forttest = zeros(length(1:30),80,7511);
%         olddata_forttest =zeros(length(25:length(names)),80,6001);
        
        % for group_i = 1:length(age_group)
        for name_i = 1:length
            fprintf('\n%s\t%s','Working on subject:',names{name_i});
            tempdata = zeros(80,751);
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

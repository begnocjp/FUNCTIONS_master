%% Set up parameters
% 1. Extract cluster average mw_tf power for each subject, create data
% structure / whole sample mean
% 2. Run one sample t-tests to test difference between each condition and zero (find
% significant difference in mw_tf power across subjects separately for each
% condition, so make a heat map blob for each condition
% 3. FDR correction
% 4. Plot corrected blobs over whole sample heat map activity of
% condition "Cooper et al 2016 (NeuroImage) - take the avg power
% for each trial type/each cluster/freq band that passes task avg FDR
% correction"
% 5. Export avg values between 0ms-1000ms that fall in FDR corrected
% clusters
%
% Cooper et al 2016 (NeuroImage) - take the avg power
% for each trial type/each cluster/freq band that passes task avg FDR
% correction

clear all;close all;clc;
wpms.dirs  = struct('CWD','./','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS/','RAW','/INPUTS/RAW/','preproc','PREPROC_OUTPUT/', 'ERP','ERP/', ...
    'DATA_DIR','EEGLAB_FORMAT/','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR/', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT/','EEGDispOutput','EEGDISPLAY_OUTPUT/', ...
    'TIMELOCK','TIMELOCK/','GA_TIMELOCK','GA_TIMELOCK/');
wpms.names = dir('./INPUTS/RAW/*');
t = struct2table(wpms.names)
t = t.name
disp(1:length(wpms.names))
wpms.names = {t}
wpms.names{1, 1}(1:3) = []

for i = 1:length(wpms.names{1, 1})
    wpms.names{1, 1}{i, 1} = erase(wpms.names{1, 1}{i, 1},'.raw')
    wpms.names(1)
end

Control_group = ...
    {'FAST_c001_memory_20190410_081334002', ...
    'FAST_c002_memory_20190410_082939002','FAST_c003_memory_20190422_034503002', ...
    'FAST_c004_memory_20190425_101929002','FAST_c005_memory_20190425_110111002', ...
    'FAST_c006_memory_20190425_040746002','FAST_c007_memory_20190426_124602002', ...
    'FAST_c008_memory_20190426_011502002','FAST_c009_memory_20190501_083429002', ...
    'FAST_c010_memory_20190501_035324002','FAST_c011_memory_20190506_031028002', ...
    'FAST_c012_memory_20190506_033701002','FAST_c013_memory_20190507_033506002', ...
    'FAST_c014_memory_20190509_040256002','FAST_c015_memory_20190509_043039002', ...
    'FAST_c016_memory_20190515_044301002','FAST_c017_memory_20190520_023536002', ...
    'FAST_c018_memory_20190528_103019002','FAST_c019_memory_20190528_021127002', ...
    'FAST_c020_memory_20190528_023657002','FAST_c021_memory_20190529_015547002', ...
    'FAST_c022_memory_20190529_025137002','FAST_c023_memory_20190603_093141002', ...
    'FAST_c024_memory_20190603_095826002','FAST_c025_memory_20190603_112252002', ...
    'FAST_c026_memory_20190603_115004002','FAST_c027_memory_20190603_121604002', ...
    'FAST_c028_memory_20190603_123846002','FAST_c029_memory_20190611_092502002', ...
    'FAST_c030_memory_20190611_095238002','FAST_c031_memory_20190617_112926002', ...
    'FAST_c032_memory_20190729_105106002','FAST_c033_memory_20190729_111502002'}
%leaving out 'FAST_c034_memory_20190729_114331002' - only four trials,
%FAST_001 - not control?

Angelman_group_low_artrej_thresh = ...
    {'as_002_memory_ABOM_20170713_111013002', ...
    'as_003_memory_ABOM_20170713_124013002', ...
    'as_004_memory_ABOM_20170713_022047002', ...
    'as_005_memory_ABOM_20170713_032520002', ...
    'as_007_memory_ABOM_20170713_054349002', ...
    'as_008_memory_ABOM_20170713_065339002', ...
    'as_009_memory_ABOM_20170714_112117002', ...
    'as_010_memory_ABOM_20170714_015600002', ...
    'as_011_memory_ABOM_20170714_041812002', ...
    'as_012_memory_ABOM_20170714_050158002', ...
    'as_013_memory_ABOM_20170714_053926002', ...
    'as_015_memory_ABOM_20170911_120223002', ...
    'as_016_memory_ABOM_20170911_023110002', ...
    'as_110_memory_FAST_20190722_105830002', ...
    'as_112_memory_FAST_20190724_125752002', ...
    'as_113_memory_FAST_20190724_030559002', ...
    'as_122_memory_FAST_20190725_110502002', ...
    'as_123_memory_FAST_20190725_044139002', ...
    'as_124_memory_FAST_20190726_070722002', ...
    'as_125_memory_FAST_20190726_084618002', ...
    'as_128_memory_FAST_20190726_014653002', ...
    'as_129_memory_FAST_20190726_022356002', ...
    'as_130_memory_FAST_20190726_025301002', ...
    'as_131_memory_FAST_20190726_035604002', ...
    'as_132_memory_FAST_20190726_044105002', ...
    'as_133_memory_FAST_20190726_051106002', ...
    'as_134_memory_FAST_20190726_054406002', ...
    'as_135_memory_FAST_20190727_080149002', ...
    'as_136_memory_FAST_20190727_084810002', ...
    'as_201_memory_Duis_20181127_013101002', ...
    'as_202_memory_Duis_20181105_022650002', ...
    'as_204_memory_Duis_20181126_013749002', ...
    'as_205_memory_Duis_20190104_125954002', ...
    'as_206_memory_Duis_20190222_115628002', ...
    'as_208_memory_Duis_20190308_011108002', ...
    'as_210_memory_Duis_20190211_combined', ...
    'as_211_memory_Duis_20190222_013804002', ...
    'as_213_memory_Duis_20191008_012721002', ...
    'as_215_memory_Duis_20190415_101241002', ...
    'as_219_memory_Duis_20190913_123025002', ...
    'as_220_memory_Duis_20190710_012558002', ...
    'as_221_memory_Duis_20190830_011505002', ...
    'as_222_memory_Duis_20190916_020101002', ...
    'as_225_memory_Duis_20191015_023350002', ...
    'as_226_memory_Duis_20191111_123224002'}
%several subjects excluded due to low/no trials after trial rejection

all_names = cat(2,Angelman_group_low_artrej_thresh,Control_group)

%several subjects excluded due to low/no trials after trial rejection
datain = './WAVELET_OUTPUT_DIR_Angelman_exp_high_artrej_thresh/';
dataout = './statistics_output_Angelman_high_threshold/';
conditions = {'sing','rept'};
clusternames = {'Frontal','Parietal','Central'};
clusters={{'19','10','20','11','4','12','5'},...
         {'7','107','32','81','54','55','80'},...
         {'67','73','78','72','76','77'}};
frontal = clusters{1};
parietal = clusters{2};
central = clusters{3};
data_forttest = {'frontal_data_forttest','parietal_data_forttest','central_data_forttest'}
% data_sing = {,'p_frontal_sing','p_parietal_sing','p_central_sing'}
% data_rept= {,'p_frontal_rept','p_parietal_rept','p_central_rept'}
bins = 80
time_length = 551
freq_range = 30
sample = length(all_names)
frex=logspace(log10(2),log10(freq_range),bins); %change to match wavelet
freqs = {1:22;23:42;43:56;57:80};%delta theta alpha beta lo-gamma
freq_labels ={'DELTA','THETA','ALPHA','BETA'}; % frequencies are 2-4; 4-8; 9-13; 14-30
%freq_labels ={'DELTA','THETA','ALPHA','BETA','LO-GAMMA'};
times = -700:4:1500; %determined by mw_tf window
ttime_start = 176;  %here setting time window for t-tests, reference 'times' variable to determine, e.g. 0 - 1000 is ttime_start = 176 / ttime_stop = 426;
ttime_stop = 426;
channels = 1:128;
labels = transpose(num2cell(1:128));
stats = zeros(length(all_names),5,5,5);
ttest_data = {'frontal_data_forttest','parietal_data_forttest','central_data_forttest'}
count = {0,0,0};
cond_mwtf1 = zeros(bins,time_length); %80 equals bins, 251 equals times variable,
cond_mwtf = repmat({cond_mwtf1},[1 3]);
tempdata1 = zeros(bins,time_length);
data_store = repmat({tempdata1},[1 3]);
out = repmat({tempdata1},1,3);
tempdata = repmat({tempdata1},1,3);
data_forttest1 = zeros(length(1:freq_range),bins,time_length);
data_forttest = repmat({data_forttest1,data_forttest1,data_forttest1},[sample 1]); %here sample size of sample
addpath /Users/patrick/Desktop/fieldtrip-20200423
thresh =0.005;
save_avg = {'frontal_avg','parietal_avg','central_avg'}
save_dat = {'frontal_data_forttest','parietal_data_forttest','central_data_forttest'}
save_sing = {'p_thresh_frontal_sing','p_thresh_parietal_sing','p_thresh_central_sing'}
save_rept = {'p_thresh_frontal_rept','p_thresh_parietal_rept','p_thresh_central_rept'}
%addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
%% Load in data - Mainly for initial data structures
%Channels used as ROIs, GSN128, will also
%be used in clusters
for block_i = 1:length(conditions)
    for name_i = 1:length(all_names)
        fprintf('\n%s\t%s','Working on subject:',all_names{name_i})
        for cluster_i = 1:length(clusters)
            clusterelec = clusters{cluster_i};
            %             data_store = {tempdata1,tempdata1,tempdata1}
            tempdata   = out
            for elec_i = 1:length(clusterelec)
                load([datain all_names{name_i} filesep conditions{block_i} filesep all_names{name_i} '_REPAIRED_AND_REFERENCED_Incidental_' conditions{block_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
                cond_mwtf{cluster_i} = cond_mwtf{cluster_i}+mw_tf;
                count{cluster_i} = count{cluster_i}+1;
                tempdata{cluster_i} = tempdata{cluster_i}+mw_tf;
            end
            data_store{1,cluster_i}= tempdata{1,cluster_i}./(length(clusterelec));%*length(conditions));
        end
        data_forttest(name_i,:,:)= data_store
        clear data_store tempdata
    end
    frontal_avg = cond_mwtf{1}./count{1};
    parietal_avg = cond_mwtf{2}./count{2};
    central_avg = cond_mwtf{3}./count{3};
    frontal_data_forttest  = double(permute(cat(3,cell2mat(reshape(data_forttest(:,1,:),1,1,[]))),[3,1,2]));
    parietal_data_forttest = double(permute(cat(3,cell2mat(reshape(data_forttest(:,2,:),1,1,[]))),[3,1,2]));
    central_data_forttest  = double(permute(cat(3,cell2mat(reshape(data_forttest(:,3,:),1,1,[]))),[3,1,2]));
   % need_save = p_thresh_sing{i}
    save([dataout 'avg_' conditions{block_i} '_' clusternames{1} '_power.mat'],'frontal_avg');
    save([dataout 'avg_' conditions{block_i} '_' clusternames{2} '_power.mat'],'parietal_avg');
    save([dataout 'avg_' conditions{block_i} '_' clusternames{3} '_power.mat'],'central_avg');
    save([dataout 'data_' conditions{block_i} '_' clusternames{1} '_power.mat'],'frontal_data_forttest');
    save([dataout 'data_' conditions{block_i} '_' clusternames{2} '_power.mat'],'parietal_data_forttest');
    save([dataout 'data_' conditions{block_i} '_' clusternames{3} '_power.mat'],'central_data_forttest');

end
    clear cond_mwtf cond_mwtf1 tempdata tempdata1 count data_forttest data_forttest1 data_store clusterelec ...
        clusters cluster_i elec_i frontal_avg parietal_avg central_avg frontal_data_forttest parietal_data_forttest ...
        central_data_forttest frontal parietal central mw_tf
%% Analyse time point*frex for Condition Avg
% analyze time*fex for each condition and cluster within the whole sample,
% load in each, like single frontal, repeat frontal, single parietal etc...
% Testing the full sample's difference in power from 0
for i = 1:length(ttest_data);
    for freq = 1:bins;
        ttest_sing{i} = struct2cell(load([dataout 'data_' conditions{1} '_' clusternames{i} '_power.mat'], ttest_data{i}));
        ttest_sing(i) = [ttest_sing{1,i}];
        [~,p_sing{i}(freq,:)] = ttest(squeeze(ttest_sing{i}(:,freq,ttime_start:ttime_stop)));
        ttest_rept{i} = struct2cell(load([dataout 'data_' conditions{2} '_' clusternames{i} '_power.mat'], ttest_data{i}));
        ttest_rept(i) = [ttest_rept{1,i}];
        [~,p_rept{i}(freq,:)] = ttest(squeeze(ttest_rept{i}(:,freq,ttime_start:ttime_stop)));
    end;
end;

% Apply FDR Corrections %now correct to make sure no false positives
p_crit  = zeros(size(ttest_sing{1,1}));
pcrit_sing = repmat(p_crit,1,3)
pcrit_rept = repmat(p_crit,1,3)

for freq = 1:bins
    for  i = 1:length(ttest_sing)
        [~,p_crit_sing{i}(freq,:)]=fdr_bky(p_sing{i}(freq,:),thresh,'no');
    end
end

for freq = 1:bins
    for  i = 1:length(ttest_rept)
        [~,p_crit_rept{i}(freq,:)]=fdr_bky(p_rept{i}(freq,:),thresh,'no');
    end
end

p_thresh_sing1=zeros(size(p_sing{1}));
p_thresh_sing = {p_thresh_sing1,p_thresh_sing1,p_thresh_sing1}
p_thresh_rept1=zeros(size(p_rept{1}));
p_thresh_rept = {p_thresh_rept1,p_thresh_rept1,p_thresh_rept1}

for i=1:length(p_crit_sing)
    p_thresh_sing{i}(p_sing{i}<p_crit_sing{i})=1;
    need_save = p_thresh_sing{i}
    save([[dataout,save_sing{i}] '.mat'],'need_save')
end


for i = 1:length(p_crit_rept)
    p_thresh_rept{i}(p_rept{i}<p_crit_rept{i})=1;
    need_save = p_thresh_rept{i}
    save([[dataout,save_rept{i}] '.mat'],'need_save')
end

%% Plot masked data against whole sample average

front_mean_sing = cell2mat(struct2cell(load([dataout 'avg_sing_' clusternames{1} '_power.mat'],'frontal_avg')));
front_mean_rept = cell2mat(struct2cell(load([dataout 'avg_rept_' clusternames{1} '_power.mat'],'frontal_avg')));

parietal_mean_sing = cell2mat(struct2cell(load([dataout 'avg_sing_' clusternames{2} '_power.mat'],'parietal_avg')));
parietal_mean_rept = cell2mat(struct2cell(load([dataout 'avg_rept_' clusternames{2} '_power.mat'],'parietal_avg')));

central_mean_sing = cell2mat(struct2cell(load([dataout 'avg_sing_' clusternames{3} '_power.mat'],'central_avg')));
central_mean_rept = cell2mat(struct2cell(load([dataout 'avg_rept_' clusternames{3} '_power.mat'],'central_avg')));

p_thresh_frontal_sing = p_thresh_sing{1}

% Frontal Sing
figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
subplot(1,2,1);contourf(times(ttime_start:ttime_stop),frex(1:bins),front_mean_sing(1:bins,ttime_start:ttime_stop),50,'linecolor','none');caxis([-2 2]);colormap(parula)
mask_data_front_sing=zeros(size(front_mean_sing(1:bins,ttime_start:ttime_stop)));
temp_data_front_sing=front_mean_sing(1:bins,ttime_start:ttime_stop);
mask_data_front_sing(p_thresh_frontal_sing(1:bins,:)==1)=temp_data_front_sing(p_thresh_frontal_sing(1:bins,:)==1);
hold on;
subplot(1,2,1);contour(times(ttime_start:ttime_stop),frex(1:bins),p_thresh_frontal_sing(1:bins,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
set(gca,'FontSize',18);title('Frontal');axis square;

% Frontal Rept
figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
subplot(1,2,1);contourf(times(ttime_start:ttime_stop),frex(1:bins),front_mean_rept(1:bins,ttime_start:ttime_stop),50,'linecolor','none');caxis([-2 2]);colormap(parula)
mask_data_front_rept=zeros(size(front_mean_rept(1:bins,ttime_start:ttime_stop)));
temp_data_front_rept=front_mean_rept(1:bins,ttime_start:ttime_stop);
mask_data_front_rept(p_thresh_frontal_rept(1:bins,:)==1)=temp_data_front_rept(p_thresh_frontal_rept(1:bins,:)==1);
hold on;
subplot(1,2,1);contour(times(ttime_start:ttime_stop),frex(1:bins),p_thresh_frontal_rept(1:bins,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
set(gca,'FontSize',18);title('Frontal');axis square;

% Parietal Sing
figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
subplot(1,2,1);contourf(times(ttime_start:ttime_stop),frex(1:bins),parietal_mean_sing(1:bins,ttime_start:ttime_stop),50,'linecolor','none');caxis([-2 2]);colormap(parula)
mask_data_parietal_sing=zeros(size(parietal_mean_sing(1:bins,ttime_start:ttime_stop)));
temp_data_parietal_sing=parietal_mean_sing(1:bins,ttime_start:ttime_stop);
mask_data_parietal_sing(p_thresh_parietal_sing(1:bins,:)==1)=temp_data_parietal_sing(p_thresh_parietal_sing(1:bins,:)==1);
hold on;
subplot(1,2,1);contour(times(ttime_start:ttime_stop),frex(1:bins),p_thresh_parietal_sing(1:bins,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
set(gca,'FontSize',18);title('Parietal');axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_TaskAvg_Power_005.pdf'],'pdf');
%         close

% Parietal Rept
figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
subplot(1,2,1);contourf(times(ttime_start:ttime_stop),frex(1:bins),parietal_mean_rept(1:bins,ttime_start:ttime_stop),50,'linecolor','none');caxis([-2 2]);colormap(parula)
mask_data_parietal_rept=zeros(size(parietal_mean_rept(1:bins,ttime_start:ttime_stop)));
temp_data_parietal_rept=parietal_mean_rept(1:bins,ttime_start:ttime_stop);
mask_data_parietal_rept(p_thresh_parietal_rept(1:bins,:)==1)=temp_data_parietal_rept(p_thresh_parietal_rept(1:bins,:)==1);
hold on;
subplot(1,2,1);contour(times(ttime_start:ttime_stop),frex(1:bins),p_thresh_parietal_rept(1:bins,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
set(gca,'FontSize',18);title('Parietal');axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_TaskAvg_Power_005.pdf'],'pdf');
%         close

% Central Sing
figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
subplot(1,2,1);contourf(times(ttime_start:ttime_stop),frex(1:bins),central_mean_sing(1:bins,ttime_start:ttime_stop),50,'linecolor','none');caxis([-2 2]);colormap(parula)
mask_data_central_sing=zeros(size(central_mean_sing(1:bins,ttime_start:ttime_stop)));
temp_data_central_sing=central_mean_sing(1:bins,ttime_start:ttime_stop);
mask_data_central_sing(p_thresh_central_sing(1:bins,:)==1)=temp_data_central_sing(p_thresh_central_sing(1:bins,:)==1);
hold on;
subplot(1,2,1);contour(times(ttime_start:ttime_stop),frex(1:bins),p_thresh_central_sing(1:bins,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
set(gca,'FontSize',18);title('Parietal');axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_TaskAvg_Power_005.pdf'],'pdf');
%         close

% Central Rept
figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
subplot(1,2,1);contourf(times(ttime_start:ttime_stop),frex(1:bins),central_mean_rept(1:bins,ttime_start:ttime_stop),50,'linecolor','none');caxis([-2 2]);colormap(parula)
mask_data_central_rept=zeros(size(central_mean_rept(1:bins,ttime_start:ttime_stop)));
temp_data_central_rept=central_mean_rept(1:bins,ttime_start:ttime_stop);
mask_data_central_rept(p_thresh_central_rept(1:bins,:)==1)=temp_data_central_rept(p_thresh_central_rept(1:bins,:)==1);
hold on;
subplot(1,2,1);contour(times(ttime_start:ttime_stop),frex(1:bins),p_thresh_central_rept(1:bins,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
set(gca,'FontSize',18);title('Parietal');axis square;
%         saveas(gcf,[dataout 'Incidental_Memory_TaskAvg_Power_005.pdf'],'pdf');
%         close

%% Export avg values between after 0ms that fall in task avg FDR
% Previously: For all vals between 200-400ms
% Previously: For all vals between 300-600ms


tmp_data1 = zeros(sample,bins,time_length); % for 78 subjects
tmp_data2 = zeros(sample,bins,time_length);
tmp_data3 = zeros(sample,bins,time_length);
tmp_data4 = zeros(sample,bins,time_length);
tmp_data5 = zeros(sample,bins,time_length);
tmp_data6 = zeros(sample,bins,time_length);

for name_i = 1:length(all_names)
    for freq_i = 1:bins
        for time_i = ttime_start:ttime_stop
            if p_thresh_frontal_sing(freq_i,time_i)==1
                tmp_data1(name_i,freq_i,time_i) = singf(name_i,freq_i,time_i);
            end
        end
    end
end

for name_i = 1:length(all_names)
    for freq_i = 1:bins
        for time_i = ttime_start:ttime_stop
            if p_thresh_frontal_rept(freq_i,time_i)==1
                tmp_data2(name_i,freq_i,time_i) = reptf(name_i,freq_i,time_i);
            end
        end
    end
end

for name_i = 1:length(all_names)
    for freq_i = 1:bins
        for time_i = ttime_start:ttime_stop
            if p_thresh_parietal_sing(freq_i,time_i)==1
                tmp_data3(name_i,freq_i,time_i) = sp(name_i,freq_i,time_i);
            end
        end
    end
end



for name_i = 1:length(all_names)
    for freq_i = 1:bins
        for time_i = ttime_start:ttime_stop
            if p_thresh_parietal_rept(freq_i,time_i)==1
                tmp_data4(name_i,freq_i,time_i) = rp(name_i,freq_i,time_i);
            end
        end
    end
end


for name_i = 1:length(all_names)
    for freq_i = 1:bins
        for time_i = ttime_start:ttime_stop
            if p_thresh_central_sing(freq_i,time_i)==1
                tmp_data5(name_i,freq_i,time_i) = sc(name_i,freq_i,time_i);
            end
        end
    end
end

for name_i = 1:length(all_names)
    for freq_i = 1:bins
        for time_i = ttime_start:ttime_stop
            if p_thresh_central_rept(freq_i,time_i)==1
                tmp_data6(name_i,freq_i,time_i) = rc(name_i,freq_i,time_i);
            end
        end
    end
end


singf_avg = mean(tmp_data1,3);
reptf_avg = mean(tmp_data2,3);
sp_avg = mean(tmp_data3,3);
rp_avg = mean(tmp_data4,3);
sc_avg = mean(tmp_data5,3);
rc_avg = mean(tmp_data6,3);
%clear tmp_data1  tmp_data2 tmp_data3 tmp_data4 tmp_data5 tmp_data6

save([dataout 'frontal_single_0-1000_power.mat'],'singf_avg');
save([dataout 'frontal_repeat_0-1000_power.mat'],'reptf_avg');
save([dataout 'parietal_single_0-1000_power.mat'],'sp_avg');
save([dataout 'parietal_repeat_0-1000_power.mat'],'rp_avg');
save([dataout 'central_single_0-1000_power.mat'],'sc_avg');
save([dataout 'central_repeat_0-1000_power.mat'],'rc_avg');

%%
%
% % Getting pvals/tvals for the regions
%
% % Better idea to follow Cooper et al 2016 (NeuroImage) - take the avg power
% % for each trial type/each cluster/freq band that passes task avg FDR
% % correction
%
%
% % single_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_data_single_Frontal_power.mat'], 'frontal_data_forttest');
% % repeat_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_data_repeat_Frontal_power.mat'], 'frontal_data_forttest');
% %
% % single_frontal = single_frontal.frontal_data_forttest;
% % repeat_frontal = repeat_frontal.frontal_data_forttest;
% %
% % pvals_frontal = zeros(bins,length(ttime_start:ttime_stop));
% % tvals_frontal.tstat = zeros(bins,length(ttime_start:ttime_stop));
%
%
% single_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_avg_single_Frontal_power.mat'], 'frontal_avg');
% repeat_frontal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\frontal_avg_repeat_Frontal_power.mat'], 'frontal_avg');
%
% single_frontal = single_frontal;
% repeat_frontal = repeat_frontal;
%
% frontal_diff = zeros(bins,length(ttime_start:ttime_stop));
%
% for freq_i = 1:bins
%     for time_i = ttime_start:ttime_stop
%         if p_thresh_frontal(freq_i,time_i)==1
% %             frontal_diff(freq_i,time_i) = single_frontal(freq_i,time_i+2000) - repeat_frontal(freq_i,time_i+2000);
%             [~,pvals_frontal(freq_i,time_i)] = ttest(single_frontal(:,freq,ttime_start:ttime_stop),repeat_frontal(:,freq,ttime_start:ttime_stop),'Alpha', 0.05);
%         end
%     end
%
% end
%
% for freq_i = 1:bins
%     for time_1 = ttime_start:ttime_stop
%         [~,pvals_parietal(freq_i,time_i),] = ttest(parietal_diff(freq_i,time_i));
%     end
% end
% % single_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_single_Parietal_power.mat'], 'parietal_data_forttest');
% % repeat_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_data_repeat_Parietal_power.mat'], 'parietal_data_forttest');
% %
% % single_parietal = single_parietal.parietal_data_forttest;
% % repeat_parietal = repeat_parietal.parietal_data_forttest;
%
% pvals_parietal = zeros(bins,length(ttime_start:ttime_stop));
% tvals_parietal.tstat = zeros(bins,length(ttime_start:ttime_stop));
%
% single_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_avg_single_Parietal_power.mat'], 'parietal_avg');
% repeat_parietal = load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\results\pareital_avg_repeat_Parietal_power.mat'], 'parietal_avg');
%
% single_parietal = single_parietal.parietal_avg;
% repeat_parietal = repeat_parietal.parietal_avg;
%
% parietal_diff = zeros(bins,length(ttime_start:ttime_stop));
%
% for freq_i = 1:bins
%     for time_i = ttime_start:ttime_stop
%         if p_thresh_parietal(freq_i,time_i)==1
% %             parietal_diff(freq_i,time_i) = single_parietal(freq_i,time_i+2000) - repeat_parietal(freq_i,time_i+2000);
%             [~,pvals_parietal(freq_i,time_i)] = ttest(single_parietal(freq,ttime_start:ttime_stop),repeat_parietal(freq,1:251),'Alpha', 0.05);
%         end
%     end
%
% end
%
% for freq_i = 1:bins
%     for time_1 = 1:251
%         [~,pvals_parietal(freq_i,time_i),] = ttest(parietal_diff(freq_i,time_i));
%     end
% end
%
% %% OLDER DATASET COMPARISONS %%
%
% %     for cluster_i= 1 :length(clusters)
% %         clusterelec = clusters{cluster_i};
% %         electrodes = find(ismember(labels,clusterelec));
%         count1 = 0;
% %         count2 = count1;
%         cond_mwtf1 = zeros(bins,501);
% %         cond_mwtf2 = cond_mwtf1;
%
%         data_forttest = zeros(length(1:freq_range),bins,5011);
% %         olddata_forttest =zeros(length(25:length(names)),bins,6001);
%
%         % for group_i = 1:length(age_group)
%         for name_i = 1:length
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             tempdata = zeros(bins,501);
%             for cond_i = 1:length(blocks)
%                 for elec_i = 1:length(electrodes)
%                     fprintf('.');
%                     load([datain names{name_i} filesep blocks{cond_i} filesep names{name_i} '_' blocks{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     cond_mwtf1 = cond_mwtf1 + mw_tf;
%                     count1 = count1+1;
%                     tempdata = tempdata+mw_tf;
%                 end
%             end
%             youngdata_forttest(name_i,:,:) = tempdata./(length(electrodes)*length(conditions));
%         end
%
%
% %         for name_i = 25:length(names)
% %             fprintf('\n%s\t%s','Working on subject:',names{name_i});
% %             tempdata = zeros(80,6001);
% %             for cond_i = 1:length(blocks)
% %                 for elec_i = 1:length(electrodes)
% %                     fprintf('.');
% %                     load([datain names{name_i} filesep blocks{cond_i} filesep names{name_i} '_' blocks{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
% %                     cond_mwtf2 = cond_mwtf2 + mw_tf;
% %                     count2 = count2+1;
% %                     tempdata = tempdata+mw_tf;
% %                 end
% %
% %             end
% %             olddata_forttest(name_i,:,:) = tempdata./(length(electrodes)*length(conditions));
% %         end
% %         if strcmpi(clusternames{cluster_i},'P')
% %             p_young = zeros(bins,length(1:9801));
% %             for freq = 1:bins
% %                 [~,p_young(freq,:)] = ttest(squeeze(youngdata_forttest(:,freq,1:9801)));
% %             end
% %
% %             p_old = zeros(bins,length(1:9801));
% %             for freq = 1:bins
% %                 [~,p_old(freq,:)] = ttest(squeeze(olddata_forttest(:,freq,1:9801)));
% %             end
% %
% %             addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox\'));
% %             thresh =0.005;
% %             [~,crit_p]=fdr_bky(p_young,thresh,'no');
% %             p_thresh_young=zeros(size(p_young));
% %             p_thresh_young(p_young<crit_p)=1;
% %             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_young' blocknames{block_i} '_Pz.mat'],'p_thresh_young');
% %
% %             [~,crit_p]=fdr_bky(p_old,thresh,'no');
% %             p_thresh_old=zeros(size(p_old));
% %             p_thresh_old(p_old<crit_p)=1;
% %             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_old' blocknames{block_i} '_Pz.mat'],'p_thresh_old');
% %         end
%         %% Avg across names
%         young_avg = cond_mwtf1./count1;
%         old_avg = cond_mwtf2./count2;
%         % avg_group = cond_mwtf/length(names);
%
%         save(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_avg' blocknames{block_i} '_' clusternames{cluster_i} '_power.mat'],'young_avg');
%         save(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_avg' blocknames{block_i} '_' clusternames{cluster_i} '_power.mat'],'old_avg');
%
%
%         %% filter sig for plotting outlines
%
%         %% Plot
% %         figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
% %         %             subplot(1,2,1);contourf(times(801:8001),frex(1:80),young_avg(1:80,801:8001),50,'linecolor','none');caxis([-2 2])
% % %         mask_data_young=zeros(size(young_avg(1:80,801:8001)));
% % %         temp_data_young=young_avg(1:80,801:8001);
% % %         mask_data_young(p_thresh_young(1:80,:)==1)=temp_data_young(p_thresh_young(1:80,:)==1);
% %         subplot(1,2,1);contourf(times(1401:6201),frex(1:80),young_avg(1:80,1401:6201),50,'linecolor','none');caxis([-2 2])
% %         hold on;
% % %        subplot(1,2,1);contour(times(801:8001),frex(1:80),p_thresh_young(1:80,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
% %         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
% %         set(gca,'FontSize',18);title(['YOUNG ' clusternames{cluster_i} ' ' blocknames{block_i}]);axis square;
% %
% % %         mask_data_old=zeros(size(old_avg(1:80,801:8001)));
% % %         temp_data_old=old_avg(1:68,801:6801);
% % %         mask_data_old(p_thresh_old(1:68,:)==1)=temp_data_old(p_thresh_old(1:68,:)==1);
% %         subplot(1,2,2);contourf(times(1401:6201),frex(1:68),old_avg(1:68,1401:6201),50,'linecolor','none');caxis([-2 2])
% %
% %         %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
% %         hold on;
% % %         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
% %         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
% %         set(gca,'FontSize',18);title(['OLD ' clusternames{cluster_i} ' ' blocknames{block_i}]);axis square;
% %         saveas(gcf,[dataout 'TIMEF_' clusternames{cluster_i} '_' blocknames{block_i} '_Power.pdf'],'pdf');
% %         close
% %
%         %         freqs = {1:18;19:35;36:48;49:67};
%         %         fprintf('\n\n%s\t','**********EXTRACTING AVERAGE VALUES**********');
%         % %         if strcmpi(clusternames{cluster_i},'FC')
%         %             for freq_i = 1:length(freqs)
%         %                 fprintf('.');
%         %                 tmp_p = squeeze(p_thresh_young(freqs{freq_i},:));
%         %                 tmp_data = zeros(length(freqs{freq_i}),length(801:6801));
%         %                 tmp_data(tmp_p ~= 1) = NaN;
%         %                 tmp_inds = ~isnan(tmp_data);
%         %                 for name_i = 1:24
%         %                     for cond_i = 1:length(conditions)
%         %                         load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%         %                         tmp_data_squeezed = squeeze(mw_tf(freqs{freq_i},801:6801));
%         %                         tmp_data_val = mean(tmp_data_squeezed(tmp_inds==1));
%         %                         if strcmpi(blocknames{block_i},'nondir')
%         %                             stats(name_i,(cond_i+length(blocknames{1})),cluster_i,freq_i) = tmp_data_val;
%         %                         else
%         %                             stats(name_i,cond_i,cluster_i,freq_i) = tmp_data_val;
%         %                         end
%         %
%         %                     end
%         %                 end
%         %             end
%         %             fprintf('\n');
%         %             for freq_i = 1:length(freqs)
%         %                 fprintf('.');
%         %                 tmp_p = squeeze(p_thresh_old(freqs{freq_i},:));
%         %                 tmp_data = zeros(length(freqs{freq_i}),length(801:6801));
%         %                 tmp_data(tmp_p ~= 1) = NaN;
%         %                 tmp_inds = ~isnan(tmp_data);
%         %                 for name_i = 25:length(names)
%         %                     for cond_i = 1:length(conditions)
%         %                         load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%         %                         tmp_data_squeezed = squeeze(mw_tf(freqs{freq_i},801:6801));
%         %                         tmp_data_val = mean(tmp_data_squeezed(tmp_inds==1));
%         %                         if strcmpi(blocknames{block_i},'nondir')
%         %                             stats(name_i,(cond_i+length(blocknames{1})),cluster_i,freq_i) = tmp_data_val;
%         %                         else
%         %                             stats(name_i,cond_i,cluster_i,freq_i) = tmp_data_val;
%         %                         end
%         %                     end
%         %                 end
%         %             end
%         %         end
%
% %
% %     end
% % end
% %% plot
% close all
% subjs1 = 1:24;
% subjs2=25:length(names);
% for cluster_i=1:length(clusternames)
%     figure();
%     for freq_i=1:5
%         subplot(2,3,freq_i);bar([squeeze(mean(stats(subjs1,:,cluster_i,freq_i),1)),squeeze(mean(stats(subjs2,:,cluster_i,freq_i),1))]);
%         ylim([-2.5 2.5]);title(['freq: ' num2str(freq_i) ' ' clusternames{cluster_i}]);
%     end
% end
% %% headplots
% clear cond_mwtf1 cond_mwtf2 count* mw_tf olddata_forttest youngdata_forttest tempdata old_avg young_avg
% % load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_young.mat');
% % load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_old.mat');
% timesets = {(1801:2801),(2801:6801)};
% timeind = {1:length(1801:2801),1:length(2801:6801)};
% % TIMECUTOFF = [2801;1001;4001];
% for block_i =1:length(blocks)
%     conditions=blocks{block_i};
%     load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_data' blocknames{block_i} '.mat']);
%     load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_data' blocknames{block_i} '.mat']);
%
%     for cond_i = 1:length(blocks{block_i})
%         fprintf('\n%s', conditions{cond_i})
%         filename = ['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\' conditions{cond_i} '_topovals.txt'];
%         header = {};
%
%         for elec_i = 1:length(labels)
%             for freq_i = 1:length(freqs)
%                 for time_i = 1:length(timesets)
%                     header = [header; labels{elec_i} '.' freq_labels{freq_i} '.' num2str(time_i)];
%                 end
%             end
%         end
%         header = header';
%         fid = fopen(filename, 'w');
%         fprintf(fid, '%s\t', 'Subject');
%         for header_i = 1:length(header)
%             if header_i ~= length(header)
%                 fprintf(fid, '%s\t', header{header_i})
%             elseif header_i == length(header)
%                 fprintf(fid, '%s', header{header_i})
%             end
%         end
%
%         for name_i = 1:length(names)
%             fprintf('.')
%             fprintf(fid, '\n%s\t', names{name_i});
%             for elec_i = 1:length(labels)
%                 load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(elec_i) '_imagcoh_mwtf.mat'],'mw_tf');
%                 for freq_i = 1:length(freqs)
%                     for time_i = 1:length(timesets)
%                         if name_i < 25
%                             %                             mask_data_young=zeros(1,size(freqs{freq_i}),length(timesets{time_i}));
%                             temp_data_young = mw_tf(freqs{freq_i},timesets{time_i});
%                             dataval=mean(temp_data_young(p_thresh_young(freqs{freq_i},timesets{time_i})==1));
%                             fprintf(fid, '%2.4f\t', dataval);
%
%                         else
%                             %                             mask_data_young=zeros(1,size(freqs{freq_i}),length(timesets{time_i}));
%                             temp_data_old = mw_tf(freqs{freq_i},timesets{time_i});
%                             dataval=mean(temp_data_old(p_thresh_old(freqs{freq_i},timesets{time_i})==1));
%                             fprintf(fid, '%2.4f\t', dataval);
%
%                         end
%                     end
%
%                 end
%             end
% %             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies' conditions{cond_i} 'matrix.mat',condmatrix]);
% %             clear condmatrix
%         end
%         fclose(fid);
%     end
% end
%
% %     if block_i == 1
% %         load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_young' blocknames{block_i} '_Pz.mat']);
% %         load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_old' blocknames{block_i} '_Pz.mat']);
% %     else
% %         load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_youngNONDIR.mat');
% %         load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_oldNONDIR.mat');
% %     end
%     conditions=blocks{block_i};
%     clusters={labels};
%
%     % clusterelec = {'F1','Fz','F2'};
%     % clusterelec = {'FC1','FCz','FC2'};
% %     for cluster_i=1:length(clusters)
% %         clusterelec = clusters{cluster_i};
% %         electrodes = find(ismember(labels,clusterelec));
% %         count1 = 0;
% %         count2 = count1;
% %         % for group_i = 1:length(age_group)
% %         young_data = zeros(64,80,9801);
% %         for name_i = 1:24
% %             fprintf('\n%s\t%s','Working on subject:',names{name_i});
% %             tic;
% %             for cond_i = 1:length(conditions)
% %                 fprintf('.');
% %                 for elec_i = 1:length(electrodes)
% %                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
% %                     temp = squeeze(young_data(elec_i,:,:))+mw_tf;
% %                     young_data(elec_i,:,:) = temp;
% %                     clear temp;
% % %                     for f=1:80
% % %                         for t = 1:9801
% % %                             young_data(elec_i,f,t) = young_data(elec_i,f,t)+mw_tf(f,t);
% % %                         end
% % %                     end
% %                 end
% %             end
% %             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
% %         end
% %         young_data = young_data./(length(conditions)*24);
% %         save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_data' blocknames{block_i} '.mat'],'young_data');
%         load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_data' blocknames{block_i} '.mat']);
%
% %         old_data = zeros(64,80,9801);for name_i = 25:length(names)
% %             tic;
% %             fprintf('\n%s\t%s','Working on subject:',names{name_i});
% %             for cond_i = 1:length(conditions)
% %                 fprintf('.');
% %                 for elec_i = 1:length(electrodes)
% %                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
% %                     temp = squeeze(old_data(elec_i,:,:))+mw_tf;
% %                     old_data(elec_i,:,:) = temp;
% %                     clear temp;
% % %                     for f=1:80
% % %                         for t = 1:9801
% % %                             old_data(elec_i,f,t) = old_data(elec_i,f,t)+mw_tf(f,t);
% % %                         end
% % %                     end
% %                 end
% %
% %             end
% %             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
% %         end
% %
% %         old_data = old_data./length(conditions)*33;
%
% %         old_data = zeros(64,80,9801);
% %         for name_i = 25:length(names)
% %             fprintf('\n%s\t%s','Working on subject:',names{name_i});
% %             tic;
% %             for cond_i = 1:length(conditions)
% %                 fprintf('.');
% %                 for elec_i = 1:length(electrodes)
% %                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
% %                     temp = squeeze(old_data(elec_i,:,:))+mw_tf;
% %                     old_data(elec_i,:,:) = temp;
% %                     clear temp;
% % %                     for f=1:80
% % %                         for t = 1:9801
% % %                             young_data(elec_i,f,t) = young_data(elec_i,f,t)+mw_tf(f,t);
% % %                         end
% % %                     end
% %                 end
% %             end
% %             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
% %         end
% %         old_data = old_data./(length(conditions)*33);
% %         save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_data' blocknames{block_i} '.mat'],'old_data');
%         load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_data' blocknames{block_i} '.mat']);
%
%         %% Avg across names
% %         young_avg = squeeze(mean(young_data,1));
% %         old_avg = squeeze(mean(old_data,1));
%         % avg_group = cond_mwtf/length(names);
%         TIMECUTOFF=[2801;1001;2001];
%         scale = [-2 2];
%         count = 0;
%         cfg =[];%set up config
%         cfg.highlight = 'off';
%         cfg.layout = 'biosemi64.lay';
%         cfg.marker = 'off';
%         cfg.parameter = 'avg';
%         cfg.comment = 'no';
%         cfg.contournum = 2;
%         cfg.gridscale = 150;
%         cfg.shading = 'interp';
%         cfg.interactive = 'no';
%         dat.var = zeros(72,1);
%         dat.label = labels(:,1);
%         dat.time = 1;
%         dat.dimord = 'chan_time';
%         cfg.zlim = scale;
%         figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
%
%         %topoplot
%         for freq_i =length(freq_labels):-1:1
%
%             for time_i = 1:2
%                 switch time_i
%                     case 1%less than 500ms
%                         count = count + 1;
% %                         cfg =[];%set up config
% %                         cfg.highlight = 'off';
% %                         cfg.layout = 'biosemi64.lay';
% %                         cfg.marker = 'off';
% %                         cfg.parameter = 'avg';
% %                         cfg.comment = 'no';
% %                         cfg.contournum = 2;
% %                         cfg.gridscale = 150;
% %                         cfg.shading = 'interp';
% %                         cfg.interactive = 'no';
% %                         dat.var = zeros(72,1);
% %                         dat.label = labels(:,1);
% %                         dat.time = 1;
% %                         dat.dimord = 'chan_time';
% %                         cfg.zlim = scale;
% %                         cfg.zlim ='maxmin';
% %                         dat.avg = zeros(72,1);
% %                         mask_data_young=zeros(size(young_data(:,freqs{freq_i},1801:TIMECUTOFF(1))));
% %                         temp_data_young=young_data(:,freqs{freq_i},1801:TIMECUTOFF(1));
% %                         mask_data_young(:,p_thresh_young(freqs{freq_i},1:TIMECUTOFF(2))==1)=temp_data_young(:,p_thresh_young(freqs{freq_i},1:TIMECUTOFF(2))==1);
% %                         dat.avg=[squeeze(mean(mean(mask_data_young,2),3));0;0;0;0;0;0;0;0];
% % %                         dat.avg=[squeeze(mean(mean(temp_data_young,2),3));0;0;0;0;0;0;0;0];
% %                         subplot(4,2,count);ft_topoplotER(cfg,dat);
%
%                         dat.avg = zeros(72,1);
%                         mask_data_old=zeros(size(old_data(:,freqs{freq_i},1801:TIMECUTOFF(1))));
%                         temp_data_old=old_data(:,freqs{freq_i},1801:TIMECUTOFF(1));
%                         mask_data_old(:,p_thresh_old(freqs{freq_i},1:TIMECUTOFF(2))==1)=temp_data_old(:,p_thresh_old(freqs{freq_i},1:TIMECUTOFF(2))==1);
%                         dat.avg=[squeeze(mean(mean(mask_data_old,2),3));0;0;0;0;0;0;0;0];
%                         subplot(4,2,count);ft_topoplotER(cfg,dat);
% %
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
% %                         mask_data_young=zeros(size(young_data(:,freqs{freq_i},TIMECUTOFF(1):6801)));
% %                         temp_data_young=young_data(:,freqs{freq_i},TIMECUTOFF(1):6801);
% %                         mask_data_young(:,p_thresh_young(freqs{freq_i},TIMECUTOFF(3):end)==1)=temp_data_young(:,p_thresh_young(freqs{freq_i},TIMECUTOFF(3):end)==1);
% %                         dat.avg=[squeeze(mean(mean(mask_data_young,2),3));0;0;0;0;0;0;0;0];
% % %                         dat.avg=[squeeze(mean(mean(temp_data_young,2),3));0;0;0;0;0;0;0;0];
% %                         subplot(4,2,count);ft_topoplotER(cfg,dat);
%
%                         mask_data_old=zeros(size(old_data(:,freqs{freq_i},TIMECUTOFF(1):6801)));
%                         temp_data_old=old_data(:,freqs{freq_i},TIMECUTOFF(1):6801);
%                         mask_data_old(:,p_thresh_old(freqs{freq_i},TIMECUTOFF(3):end)==1)=temp_data_old(:,p_thresh_old(freqs{freq_i},TIMECUTOFF(3):end)==1);
%                         dat.avg=[squeeze(mean(mean(mask_data_old,2),3));0;0;0;0;0;0;0;0];
%                         subplot(4,2,count);ft_topoplotER(cfg,dat);
%                 end
%             end
%         end%freq_i loop
%
% %   saveas(gcf,['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\youngHeadplots' blocknames{block_i} 'v2.pdf'],'pdf');
%   saveas(gcf,['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\oldHeadplots' blocknames{block_i} 'v2.pdf'],'pdf');
%
% %     end
% % end
%
%
% %%%%%%%%%%%%%%%%%
%
%     for group_i = 1:length(groups)
%
%         for block_i = 1:length(conditions)
%
%             for name_i = 1:length(groups{group_i})
%                 fprintf('\n%s\t%s','Working on subject:',groups{group_i}{name_i});
%                 tempdata = zeros(80,251);
%                 for cluster_i = 1%:length(clusters)
%                     clusterelec = clusters{cluster_i};
%                     for elec_i = 1:length(clusterelec)
%                         fprintf('.');
%                         load([datain groups{group_i}{name_i} filesep conditions{block_i} filesep groups{group_i}{name_i} '_REPAIRED_AND_REFERENCED_Incidental_' conditions{block_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
%                         cond_mwtf1 = cond_mwtf1 + mw_tf;
%                         count1 = count1+1;
%                         tempdata = tempdata+mw_tf;
%                     end
%                 end
%                 frontal_data_forttest(name_i,:,:) = tempdata./(length(clusterelec));%*length(conditions));
%
%                 tempdata2 = zeros(80,251);
%                 for cluster_i = 2%:length(clusters)
%                     clusterelec = clusters{cluster_i};
%                     for elec_i = 1:length(clusterelec)
%                         fprintf('.');
%                         load([datain groups{group_i}{name_i} filesep conditions{block_i} filesep groups{group_i}{name_i} '_REPAIRED_AND_REFERENCED_Incidental_' conditions{block_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
%                         cond_mwtf2 = cond_mwtf2 + mw_tf;
%                         count2 = count2+1;
%                         tempdata2 = tempdata2+mw_tf;
%                     end
%                 end
%                 parietal_data_forttest(name_i,:,:) = tempdata2./(length(clusterelec));%*length(conditions));
%
%                 tempdata3 = zeros(80,251);
%                 for cluster_i = 3%:length(clusters)
%                     clusterelec = clusters{cluster_i};
%                     for elec_i = 1:length(clusterelec)
%                         fprintf('.');
%                         load([datain groups{group_i}{name_i} filesep conditions{block_i} filesep groups{group_i}{name_i} '_REPAIRED_AND_REFERENCED_Incidental_' conditions{block_i} '_' clusterelec{elec_i} '_imagcoh_mwtf.mat'],'mw_tf');
%                         cond_mwtf3 = cond_mwtf3 + mw_tf;
%                         count3 = count3+1;
%                         tempdata3 = tempdata3+mw_tf;
%                     end
%                 end
%                 central_data_forttest(name_i,:,:) = tempdata./(length(clusterelec));%*length(conditions));
%
%             end
%
%             frontal_avg = cond_mwtf1./count1;
%             parietal_avg = cond_mwtf2./count2;
%             central_avg = cond_mwtf3./count3;
%
%
%             save([dataout 'frontal_avg_' conditions{block_i} '_' clusternames{1} '_power.mat'],'frontal_avg');
%             save([dataout 'parietal_avg_' conditions{block_i} '_' clusternames{2} '_power.mat'],'parietal_avg');
%             save([dataout 'central_avg_' conditions{block_i} '_' clusternames{3} '_power.mat'],'central_avg');
%             save([dataout 'frontal_data_' conditions{block_i} '_' clusternames{1} '_power.mat'],'frontal_data_forttest');
%             save([dataout 'parietal_data_' conditions{block_i} '_' clusternames{2} '_power.mat'],'parietal_data_forttest');
%             save([dataout 'central_data_' conditions{block_i} '_' clusternames{3} '_power.mat'],'central_data_forttest');
%         end
%
%     end
%
% clear cond_mw_tf1 cond_mw_tf2 cond_mw_tf3 tempdata tempdata2 tempdata3 count1 count2 count3 mw_tf mw_tf2 mw_tf3
%
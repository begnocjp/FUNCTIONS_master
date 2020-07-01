%% Set up parameters
clear all;close all;clc;
datain = 'F:\fieldtrip\WAVELET_OUTPUT_DIR\';
dataout = 'F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\';
frex=logspace(log10(2),log10(50),80);
freqs = {1:18;19:35;36:49;50:68};%delta theta alpha beta
freq_labels ={'DELTA','THETA','ALPHA','BETA'};
times = -900:0.5:4000;
channels = 64;
labels = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5',...
    'T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
    'POz','Pz','CPz','Fpz','Fp2','AF8','AF4','AFz','Fz','F2','F4','F6','F8','FT8','FC6',...
    'FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6',...
    'P8','P10','PO8','PO4','O2'}';

names = {'DCR102'	'DCR103'	'DCR204'	'DCR205'	'DCR106'	'DCR207'	'DCR108'	'DCR109'	'DCR210'	'DCR211'	'DCR212'	'DCR113'	'DCR114'	'DCR215'	'DCR116'	'DCR117'	'DCR218'	'DCR219'	'DCR120'	'DCR121'	'DCR222'	'DCR123'	'DCR224'	'DCR225'...
    'S1B'	'S3'	'S5'	'S6'	'S7'	'S8B'	'S10B'	'S11'	'S12B'	'S13'	'S14B'	'S15'	'S16'	'S17B'	'S18B'	'S20B'	'S21B'	'S22'	'S23'	'S24B'	'S25'	'S27B'	'S28'	'S29'	'S30B'	'S31B'	'S33'	'S34'	'S36B'	'S37'	'S38'	'S39B'	'S40B'};
groupinds = [24,57];
young = [1:24];
old =  [25:length(names)];
age_group = {young, old};
conditions={'nogo'};%'dirleft','dirright',,'nondirleft','nondirright'
blocknames = {'dir','nondir'};
clusternames={'F','FC','C','CP','P'};
addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
clusters={{'F1','Fz','F2'},...
        {'FC1','FCz','FC2'},...
        {'C1','Cz','C2'},...
        {'CP1','CPz','CP2'},...
        {'P1','Pz','P2'}};
%%
youngdata_forttest = zeros(length(young), 80, 9801);
olddata_forttest = zeros(length(old), 80, 9801);
    
for cluster_i = 1:length(clusters)
    current_chan = find(ismember(labels,clusters{cluster_i}));
    
    for name_i = 1:length(young)
        fprintf('.')
        tmp = zeros(length(current_chan), 1, 80, 9801);
        for chan_i = 1:length(current_chan)
            for cond_i = 1%:2
                load ([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(current_chan(chan_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                tmp(chan_i, cond_i, :,:) = mw_tf;
                
            end
        end
        youngdata_forttest(name_i,:,:) = squeeze(mean(mean(tmp,1),2));
    end
    
    fprintf('\n')
    for name_i = 1:length(old)
        fprintf('.')
        tmp = zeros(length(current_chan), 1, 80, 9801);
        for chan_i = 1:length(current_chan)
            for cond_i = 1%:2
                load ([datain names{old(name_i)} filesep conditions{cond_i} filesep names{old(name_i)} '_' conditions{cond_i} '_' num2str(current_chan(chan_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                tmp(chan_i, cond_i, :,:) = mw_tf;
                
            end
        end
        olddata_forttest(name_i,:,:) = squeeze(mean(mean(tmp,1),2));
    end
    pvals = zeros(80,9801);
    tstat = pvals;
    for freq_i = 1:80
        x = squeeze(youngdata_forttest(:,freq_i,:));
        y = squeeze(olddata_forttest(:,freq_i,:));
        [~,pvals(freq_i,:),~,STATS] = ttest2(x,y);
        tstat(freq_i,:) = STATS.tstat;
    end
    contourf(times,frex, tstat,50,'linecolor','none');caxis([-5 5]);
    saveas(gcf,['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\' clusternames{cluster_i} '_NGcontour.pdf'],'pdf');
    save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\' clusternames{cluster_i} '_NGpvals.mat'],'pvals');
    save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\' clusternames{cluster_i} '_NGtvals.mat'],'tstat');
    clear pvals tstat 
end
%%
addpath(genpath('F:\fieldtrip\FUNCTIONS\'));

figure();
set(gcf,'Position',[0 0 1920 1080],'Color', [1 1 1]);
ha = tight_subplot(5, 3, 0.025);
count = 1;
block = {'DIR' 'NONDIR' 'NOGO'};
blocknames = {'DIR','NON', 'NG'};

for block_i = 2:length(block)
    count = 1;
    figure();
    set(gcf,'Position',[0 0 1920 1080],'Color', [1 1 1]);
    ha = tight_subplot(5, 3, 0.025);
    for cluster_i = 1:length(clusters)
        load(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\' clusternames{cluster_i} '_' blocknames{block_i} 'pvals.mat']);
        load(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\' clusternames{cluster_i} '_' blocknames{block_i} 'tvals.mat']);
        load(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_avg' block{block_i} '_' clusternames{cluster_i} '_power.mat']);
        load(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_avg' block{block_i} '_' clusternames{cluster_i} '_power.mat']);
       
        pvalswindow = pvals(1:67,1401:6201);
        tvalswindow = tstat(1:67,1401:6201);
        young_avgwindow = young_avg(1:67,1401:6201);
        old_avgwindow = old_avg(1:67,1401:6201);
        
        thresh = 0.01;
        [~,crit_p] = fdr_bky(pvalswindow,thresh,'no');
        
        p_thresh = zeros(size(pvalswindow));
        p_thresh(pvalswindow<crit_p) = 1;
        
        t_thresh = zeros(size(tvalswindow));
        t_thresh(p_thresh == 1) = tvalswindow(p_thresh==1);
        
        % for freq_i = 1:67
        %     for time_i = 1:size(tvalswindow, 2)
        %         if p_thresh(freq_i,time_i) == 1
        %             t_thresh(freq_i,time_i) = tvalswindow(freq_i,time_i);
        %         end
        %     end
        % end
        
               
        axes(ha(count));
        contourf(times(1401:6201),frex(1:67), young_avgwindow,50,'linecolor','none');caxis([-3 3]); axis square
        count = count+1;
        axes(ha(count));
        contourf(times(1401:6201),frex(1:67), old_avgwindow,50,'linecolor','none');caxis([-3 3]); axis square
        count = count+1;
        axes(ha(count));
        contourf(times(1401:6201),frex(1:67), tvalswindow,50,'linecolor','none');caxis([-7 7]); hold on
        contour(times(1401:6201),frex(1:67), p_thresh,1,'k', 'LineWidth', 4);axis square %caxis([-5 5]);
%         saveas(gcf,['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\' clusternames{cluster_i} '_' block{block_i} 'outlined.pdf'],'pdf');
        count = count + 1;

        
        clear pvals pvalswindow tvals tvalswindow young_avg young_avgwindow old_avg old_avgwindow
%         close all
    end
    saveas(gcf,['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\power&sigdiffs_' block{block_i} '.pdf'],'pdf');
    
    close all
end

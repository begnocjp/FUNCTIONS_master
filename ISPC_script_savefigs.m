clear all;close all;clc;
% addpath(rmpath('E:\fieldtrip\PACKAGES\fieldtrip'));
addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox'));
datadir = 'E:\fieldtrip\EEGLAB_FORMAT\';
names = {'DCR104' 'DCR107' 'DCR110' 'DCR111' 'DCR112' 'DCR115' 'DCR118' 'DCR119'...
    'DCR122' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR206' 'DCR208' 'DCR209'...
    'DCR213' 'DCR214' 'DCR217' 'DCR220' 'DCR221' 'DCR223'...
    'DCR204' 'DCR207' 'DCR210' 'DCR211' 'DCR212'  'DCR215' 'DCR218' 'DCR219' 'DCR222'...
    'DCR224' 'DCR225' 'DCR102' 'DCR103'  'DCR106' 'DCR108' 'DCR109' 'DCR113' 'DCR114' ...
    'DCR117' 'DCR120' 'DCR121' 'DCR123'  ...
    'S1' 'S6B' 'S8' 'S11B' 'S15B' 'S16B' 'S18' 'S21' 'S25B' 'S29B'...
    'S31B' 'S36' 'S39' 'S40'...
    'S1B' 'S6' 'S8B' 'S11' 'S15' 'S16' 'S18B' 'S21B' 'S25' 'S29' 'S31' ...
    'S36B' 'S39B' 'S40B'...
    'S4' 'S5B' 'S7B' 'S10' 'S12' 'S14' 'S17' 'S22B' 'S23B' 'S27' 'S28B' 'S30'...
    'S4B' 'S5' 'S7' 'S10B' 'S12B' 'S14B' 'S17B' 'S22' 'S23' 'S27B'...
    'S28' 'S30B'};
groups = {{names{1:22}},{names{23:44}},{names{45:58}},{names{59:72}},{names{73:84}},{names{85:96}}};
conditions = {'dirleft','dirright','nondirleft','nondirright'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
%% Power
group_i = 5;
group_ii =6;
data1 = zeros(length(groups{group_i}),length(conditions),2,80,9801);
data2 = zeros(length(groups{group_ii}),length(conditions),2,80,9801);
for cond_i = 1:length(conditions)
    fprintf('\n');
    names1 =groups{group_i};
    names2 = groups{group_ii};
    freqx = logspace(log10(2),log10(30),80);
    for name_i = 1:length(names1)
        count = 0;
        for chann = 50%13
            count = count+1;
            fprintf('.');
            A = load([datadir(1:strfind(datadir,'p\')+1) 'WAVELET_OUTPUT_DIR' filesep names1{name_i} filesep conditions{cond_i} filesep names1{name_i} '_' conditions{cond_i} '_' num2str(chann) '_imagcoh_mwtf.mat']);
            B = load([datadir(1:strfind(datadir,'p\')+1) 'WAVELET_OUTPUT_DIR' filesep names2{name_i} filesep conditions{cond_i} filesep names2{name_i} '_' conditions{cond_i} '_' num2str(chann) '_imagcoh_mwtf.mat']);
            data1(name_i,cond_i,count,:,:) = A.mw_tf;
            data2(name_i,cond_i,count,:,:) = B.mw_tf;
        end
    end
end
data1(data1==Inf)=NaN;
data2(data2==Inf)=NaN;
avdata_act = squeeze(nanmean(data1,3));
avdata_sham = squeeze(nanmean(data2,3));
%%
warning off
rmpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
count = -1;
clims = [-1 1];
cond_label = {'Directional Left','Directional Right','Non Directional Left','Non Directional Right'};
fs = 8;
figure(1);set(gcf,'OuterPosition',[0 0 1920 1080],'Color',[1 1 1]);
for cond_i = 1:length(conditions)
    fprintf('\n%s\t%s','Working on condition',conditions{cond_i});
    count = count+2;
    x = zeros(length(freqx),length(462:1537));
    y = zeros(size(x));
    fprintf('\n%s','Computing t-tests ');
    for freq_i = 1:length(freqx);
        fprintf('.');
        actdat = squeeze(avdata_act(:,cond_i,freq_i,462:1537));
        [~,p] = ttest(actdat);
        %[h,~,adj_p] = fdr_bh(p,0.05,'pdep');
        actvals = zeros(size(p<0.05));
        av_actdat = mean(actdat,1);
        actvals(p<0.05) = av_actdat(p<0.05);
        x(freq_i,:) = actvals;
        shadat = squeeze(avdata_sham(:,cond_i,freq_i,462:1537));
        [~,p] = ttest(shadat);
        %[h,~,adj_p] = fdr_bh(p,0.05,'pdep');
        shavals = zeros(size(p<0.05));
        av_shadat = mean(shadat,1);
        shavals(p<0.05) = av_shadat(p<0.05);
        y(freq_i,:) = shavals;
    end
    plot_act_dat = squeeze(nanmean(avdata_act(:,cond_i,80:-1:1,462:1537),1));
    plot_act_dat(x==0) = 0;
    plot_sha_dat = squeeze(nanmean(avdata_sham(:,cond_i,80:-1:1,462:1537),1));
    plot_sha_dat(y==0) = 0;
    clims = [-1.5 1.5];
    figure(1);subplot(length(conditions),2,count);contourf(plot_act_dat);hold on;caxis(clims);colormap jet;set(gca,'YDir','reverse');
    y_label = sprintf('%s\n%s\n',cond_label{cond_i},'Frequency (Hz)');
    ylabel(y_label,'FontSize',fs);xlabel('Time (ms)','FontSize',fs);
    set(gca,'YTick',1:10:80,'YTickLabel',{round(freqx(80:-10:1))});
    set(gca,'XTick',1:200:1200,'XTickLabel',{-100:500:2600})%time = -100:2600ms
    set(gca,'FontSize',fs);
    if count==1;
        title('Active','FontSize',fs+2);
        text(45,-10,'Cue','FontSize',fs);
        text(650,-10,'Target','FontSize',fs);
        text(2450,-10,'Power (dB)','FontSize',fs);
    end
    figure(1);subplot(length(conditions),2,count);plot(ones(1,80)*51,1:80,'--k','LineWidth',1);
    figure(1);subplot(length(conditions),2,count);plot(ones(1,80)*651,1:80,'--k','LineWidth',1);
    figure(1);subplot(length(conditions),2,(count+1));contourf(plot_sha_dat);hold on;caxis(clims);colormap jet;set(gca,'YDir','reverse');
    figure(1);subplot(length(conditions),2,(count+1));plot(ones(1,80)*51,1:80,'--k','LineWidth',1);
    figure(1);subplot(length(conditions),2,(count+1));plot(ones(1,80)*651,1:80,'--k','LineWidth',1);
    %     y_label = sprintf('%s\n%s\n',cond_label{cond_i},'Frequency (Hz)');
    xlabel('Time (ms)','FontSize',fs);
    set(gca,'YTick',1:10:80,'YTickLabel',{round(freqx(80:-10:1))});
    set(gca,'XTick',1:200:1200,'XTickLabel',{-100:500:2600})%time = -100:2600ms
    set(gca,'FontSize',fs);
    if (count+1) ==2;
        title('Sham','FontSize',fs+2);
        text(45,-5,'Cue','FontSize',fs);
        text(650,-5,'Target','FontSize',fs);
    end
end
saveas(gcf,'E:\fieldtrip\ANALYSES\NeuroImage_SpecialIssue\OldDom_Power_Over_Site_fdr_corrected.pdf','pdf');
close;
%% make headplot
addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
labels = {'Fp1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3'; ...
    'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3'; ...
    'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz'; ...
    'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8'; ...
    'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6'; ...
    'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2'};
cfg = [];
cfg.layout = 'biosemi64.lay';
cfg.comment = 'no';
cfg.zlim = [-1.5 1.5];
cfg.marker = 'off';
cfg.highlight = 'on';
cfg.highlightcolor = [0 0 0];
cfg.highlightsize = 36;
cfg.highlightsymbol = '.';
cfg.interplimits = 'head';
cfg.highlightchannel = {'C2','C4'};
cfg.colorbar = 'yes';
dat.avg = zeros(64,1);
dat.var = zeros(64,1);
dat.dimord = 'chan_time';
dat.time = 1;
dat.label = labels;
ft_topoplotER(cfg,dat);
saveas(gcf,'E:\fieldtrip\ANALYSES\NeuroImage_SpecialIssue\Head_with_Locations_nondom.pdf','pdf');
close;
%%
labels = {'Fp1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3'; ...
    'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3'; ...
    'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz'; ...
    'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8'; ...
    'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6'; ...
    'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2'};
warning off;
frequencies = {1:18;19:40;41:55;56:80};
time_labels = -400:50:2600;
figure();

%% ISPC
addpath(genpath('E:\fieldtrip\FUNCTIONS\mass_uni_toolbox\'));
for cond_i = 1:4
    names1 =groups{1};
    names2 = groups{2};
    data1 = zeros(length(names1),2,2,64,80,61);
    data2 = zeros(length(names2),2,2,64,80,61);
    freqx = logspace(log10(2),log10(30),80);
    for name_i = 1:length(names1)
        fprintf('.');
        A = load([datadir names1{name_i} filesep conditions{cond_i} filesep names1{name_i} '_ISPC.mat']);
        B = load([datadir names2{name_i} filesep conditions{cond_i} filesep names2{name_i} '_ISPC.mat']);
        data1(name_i,:,:,:,:,:) = A.synchOverTrials;
        data2(name_i,:,:,:,:,:) = B.synchOverTrials;
    end
    labels = {'Fp1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3'; ...
        'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3'; ...
        'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz'; ...
        'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8'; ...
        'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6'; ...
        'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2'};
    warning off;
    frequencies = {1:18;19:40;41:55;56:80};
    time_labels = -400:50:2600;
    figure();set(gcf,'OuterPosition',[0 0 1920 1080],'Color',[1 1 1]);
    ha=tight_subplot(8,ceil(51/2),0);
    for freq_i = 1:length(frequencies);
        count = 0;
        for time_i = 1:2:51
            count = count+1;
            cfg = [];
            cfg.layout = 'biosemi64.lay';
            cfg.comment = 'no';
            cfg.zlim = [0 0.2];
            cfg.marker = 'off';
            cfg.highlight = 'on';
            cfg.highlightcolor = [0 1 0];
            cfg.highlightsize = 24;
            cfg.highlightsymbol = '.';
            cfg.interplimits = 'head';
            cfg.colormap = 'hot';
            x = squeeze(mean(mean(fisherz(data1(:,:,1,:,frequencies{freq_i},time_i)),2),5));
            y = squeeze(mean(mean(fisherz(data2(:,:,1,:,frequencies{freq_i},time_i)),2),5));
            [~,p,~,stats] = ttest2(fisherz(abs(x)),fisherz(abs(y)));
            [h,~,adj_p] = fdr_bh(p,0.05,'pdep');
            ind = h==1;
            tpos = stats.tstat(ind)>0;
            tneg = stats.tstat(ind)<0;
            cfg.highlightchannel = {labels(tpos==1)};
            data = squeeze(mean(data1(:,:,1,:,frequencies{freq_i},time_i),1));
            dat.avg = squeeze(mean(mean(abs(data),3),1))';
            dat.var = zeros(64,1);
            dat.dimord = 'chan_time';
            dat.time = 1;
            dat.label = labels;
            if freq_i ==1
                axes(ha(count));ft_topoplotER(cfg,dat);title(num2str(time_labels(time_i)));
            elseif freq_i==2
                axes(ha(count+(((freq_i-1)*ceil(51/2))*freq_i)));ft_topoplotER(cfg,dat);title(num2str(time_labels(time_i)));
            elseif freq_i ==3
                axes(ha(count+(((freq_i)*ceil(51/2))+((freq_i-1)*ceil(51/2))))-ceil(51/2)*(freq_i-2));ft_topoplotER(cfg,dat);title(num2str(time_labels(time_i)));
            else
                axes(ha(count+(((freq_i)*ceil(51/2))+((freq_i-1)*ceil(51/2))))-ceil(51/2));ft_topoplotER(cfg,dat);title(num2str(time_labels(time_i)));
            end
            %             axes(ha(time_i*freq_i));ft_topoplotER(cfg,dat);title([conditions{cond_i} ' Time: ', num2str(time_labels(time_i))])
            %             subplot(length(frequencies),2,count);ft_topoplotER(cfg,dat);
            cfg.highlightchannel = {labels(tneg==1)};
            data = squeeze(mean(data2(:,:,1,:,frequencies{freq_i},time_i),1));
            dat.avg = squeeze(mean(mean(abs(data),3),1))';
            if freq_i ==1
                axes(ha(count+ceil(51/2)));ft_topoplotER(cfg,dat);title(num2str(time_labels(time_i)));
            elseif freq_i ==2
                axes(ha(count+ceil(51/2)+(((freq_i-1)*ceil(51/2))*freq_i)));ft_topoplotER(cfg,dat);title(num2str(time_labels(time_i)));
            elseif freq_i ==3
                axes(ha(count+ceil(51/2)+(((freq_i)*ceil(51/2))+((freq_i-1)*ceil(51/2))))-ceil(51/2)*(freq_i-2));ft_topoplotER(cfg,dat);title(num2str(time_labels(time_i)));
            else
                axes(ha(count+(((freq_i)*ceil(51/2))+((freq_i-1)*ceil(51/2)))));ft_topoplotER(cfg,dat);title(num2str(time_labels(time_i)));
            end
        end
        pause(0.1);
    end
    saveas(gcf,['E:\fieldtrip\ANALYSES\NeuroImage_SpecialIssue\Old_nondom' conditions{cond_i} 'ISPC.pdf'],'pdf');
    close
end
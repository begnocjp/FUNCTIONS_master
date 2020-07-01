%create theta movies
%set up globals
clear all;close all;clc;
datain = 'E:\fieldtrip\WAVELET_OUTPUT\';
dataout = 'E:\fieldtrip\WAVELET_OUTPUT\Movies\';
conditions = {'standard','duration_deviant','frequency_deviant','intensity_deviant','duration_std',...
    'frequency_std','intensity_std','std_aftDev','preStd','init_Idev','init_Fdev','init_Ddev'};
frex=logspace(log10(2),log10(100),160);
% DELTA, THETA, ALPHA, BETA, LOW GAMMA, HIGH GAMMA
theta =134:151;%1:29;%30:57;%58:80;%81:111;%112:130;%134:151;
times = -500:0.5:900;
%% first get list of participants
% cd(datain);listing = dir();
% names = {};
% for list_i = 1:length(listing)
%     if ~ismember('.',listing(list_i).name)
%         if ~ismember('Movies',listing(list_i).name)%don't want directory
%             names = [names listing(list_i).name];
%         end
%     end
% end
names = {'AH1958','AH1977','AO1954','AS1972','BM1967','DS1963_MMN','JI1972','JK1961','KB1967','KF1959','MY1969','SS1963','ZN1977',...
    'BH1975','DG1965','DJ1963','RT1986','SD1951'};
% Removed due to high # reinterpolated sites: 'DD1985',
%% now create average power matrix
% power = zeros(length(names),length(conditions),2,64,49);ISPC
power = zeros(length(names),length(conditions),64,length(times));
for name_i = 1:length(names)
    fprintf('%s\t%s','Working on subject:',names{name_i});
    tic;
    for cond_i = 1:length(conditions)
        fprintf('\n%s\t',conditions{cond_i});
        for chan_i = 1:64
            fprintf('.');
            %             filename = [datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_ISPC.mat'];
            filename = [datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(chan_i) '_imagcoh_mwtf.mat'];
            matobj = matfile(filename);
%             for idx = 1:ncols
%                 avgs(idx) = mean(matObj.stocks(:,idx));
%             end
            %load(filename,'mw_tf');
            %             power(name_i,cond_i,:,:,:) = squeeze(mean(percent_change_sync(:,:,theta,:),3));
            %power(name_i,cond_i,chan_i,:) = squeeze(mean(mw_tf(theta,:),1));
            dat = squeeze(matobj.mw_tf(theta,:));
            power(name_i,cond_i,chan_i,:) = mean(dat,1);
            %power(name_i,cond_i,chan_i,:) = squeeze(mean(matobj.mw_tf(theta,:),1));
        end
    end
    toc
end

%%
% startime = find(times==0);
% endtime  = find(times==500);
% times2show = startime:endtime;
% MFLABS = [4,11,12,38,39,46:48];
% data = zeros(length(names),length(conditions));
% for name_i = [1:150, 152:length(names)];
%     for cond_i = 1:length(conditions)
%         data(name_i,cond_i) = squeeze(mean(mean(power(name_i,cond_i,MFLABS,times2show),4),3));
%     end
% end
% 
% save('MFPower_N3.txt','data','-ascii','-tabs');
% 
% labels = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5',...
%     'T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
%     'POz','Pz','CPz','Fpz','Fp2','AF8','AF4','Afz','Fz','F2','F4','F6','F8','FT8','FC6',...
%     'FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6',...
%     'P8','P10','PO8','PO4','O2'}';
% %% make power movie
% 
% addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
% addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox'));
% startime = find(times==-100);
% endtime  = find(times==500);
% times2show = startime:endtime;
% timeslabel = -100:500;
% 
% %times2save = -400:50:2000; % in ms
% inds = 25:length(names);
% % for seed_i = 1:size(power,3);
% %     avpower = squeeze(nanmean(power(inds,:,seed_i,:,:),1));
% avpower = squeeze(nanmean(power(inds,:,:,:),1));
% labels = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5',...
%     'T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
%     'POz','Pz','CPz','Fpz','Fp2','AF8','AF4','Afz','Fz','F2','F4','F6','F8','FT8','FC6',...
%     'FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6',...
%     'P8','P10','PO8','PO4','O2'}';
% %for plotting
% cfg =[];
% %cfg.highlight = 'on';
% cfg.layout = 'biosemi64.lay';
% cfg.marker = 'off';
% cfg.parameter = 'avg';
% cfg.comment = 'no';
% cfg.contournum = 2;
% %cfg.gridscale = 400;
% %cfg.shading = 'interp';
% cfg.interactive = 'no';
% dat.var = zeros(64,1);
% dat.label = labels(:,1);
% dat.time = 1;
% dat.dimord = 'chan_time';
% cfg.zlim = [-3 3];%[-2.5 2.5];
% %     timelabels = -100:1600;
% %cfg.highlightcolor = [0 0 0];
% %cfg.highlight = 'on';
% condshort = {'DL','DR','NDL','NDR','NGO'};
% 
% 
% count = 1;
% for time_i = [floor(length(times2show)/2),1:20:length(times2show)/2]
%     figure();set(gcf,'Position',[100 100 500 500],'Color',[1 1 1]);
%     for cond_i =1:length(conditions)
% %         p = zeros(1, 64);
% %         t = zeros(1, 64);
% %        highlightlabels={};
%         for chan_i = 1:length(labels)
%             young(chan_i,1) = squeeze(nanmean(power(1:12,cond_i, chan_i, times2show(time_i),1)));
%             old(chan_i,1) = squeeze(nanmean(power(25:57,cond_i, chan_i, times2show(time_i),1)));
%             %             [p(1, chan_i), h, stats] = ranksum(young, old, 'method','approximate');
%             %[h, p(1,chan_i),~, stats] = ttest2(young, old);
%             %t(1, chan_i) = stats.tstat;
%             
%         end
%         %[h, critp, adjp]=fdr_bh(p, 0.05, 'pdep');
%         %t(p>0.05)= 0;
% %         for chan_i = 1:length(labels)
% %             if adjp(1, chan_i)<0.05
% %                 highlightlabels = [highlightlabels;labels{chan_i}];
% %                 
% %             end
% %         end
% %        cfg.highlightchannel = highlightlabels;
%         dat.avg = young;
%         subplot(2,3,cond_i,'replace');ft_topoplotER(cfg,dat);
%         title(condshort{cond_i},'FontSize',16);
%         subplot(2,3,6);title([num2str((timeslabel(time_i))) ' ms'],'FontSize',16);
%         axis off;pause(0.1);
%     end
%     if count == 1
%         colorbar;
%     end
%     f = getframe(gcf);
%     if count == 1
%         [im,map] = rgb2ind(f.cdata,256,'nodither');
%         im(1,1,1,21) = 0;
%     end
%     if count ~=1
%         im(:,:,1,count-1) = rgb2ind(f.cdata,map,'nodither');
%     end
%     count = count +1;
%     close all;
% end
% mkdir(dataout)
% filename = [dataout 'YOUNG_THETA_Movie.gif'];
% imwrite(im,map,filename,'gif','DelayTime',0.3,'LoopCount',inf);
% % end
% 
% %% look at cz
% names = {'AH1958','AH1977','AO1954','AS1972','BM1967','DS1963_MMN','JI1972','JK1961','KB1967','KF1959','SS1963','ZN1977',...
%     'BH1975','DD1985','DG1965','DJ1963','RT1986','SD1951'};
% %% now create average power matrix
% czpower = zeros(length(names),length(conditions),160,length(times));
% for name_i = [1:150, 152:length(names)]
%     fprintf('%s\t%s','Working on subject:',names{name_i});
%     tic;
%     for cond_i = 1:length(conditions)
%         fprintf('\n%s\t',conditions{cond_i});
%         fprintf('.');
%         filename = [datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(50) '_imagcoh_mwtf.mat'];
%         load(filename,'mw_tf');
%         czpower(name_i,cond_i,:,:) = mw_tf;
%     end
%     toc
% end
% %% plot
% figure();
% for cond_i = 1:length(conditions)
%     subplot(2,3,cond_i);imagesc(squeeze(nanmean(czpower(:,cond_i,:,:),1)),[-2 3.5]);
%     set(gca,'YDir','normal');
%     set(gca,'YTick',1:160,'YTickLabels',round(frex));
% end
% 
% %% Significant Difference Movies
% 
% addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
% addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox'));
% startime = find(times==-100);
% endtime  = find(times==500);
% times2show = startime:endtime;
% timeslabel = -100:2000;
% 
% %times2save = -400:50:2000; % in ms
% inds = 25:length(names);
% % for seed_i = 1:size(power,3);
% %     avpower = squeeze(nanmean(power(inds,:,seed_i,:,:),1));
% avpower = squeeze(nanmean(power(inds,:,:,:),1));
% labels = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5',...
%     'T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
%     'POz','Pz','CPz','Fpz','Fp2','AF8','AF4','Afz','Fz','F2','F4','F6','F8','FT8','FC6',...
%     'FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6',...
%     'P8','P10','PO8','PO4','O2'}';
% %for plotting
% cfg =[];
% cfg.highlight = 'on';
% cfg.layout = 'biosemi64.lay';
% cfg.marker = 'off';
% cfg.parameter = 'avg';
% cfg.comment = 'no';
% cfg.contournum = 2;
% %cfg.gridscale = 400;
% %cfg.shading = 'interp';
% cfg.interactive = 'no';
% dat.var = zeros(64,1);
% dat.label = labels(:,1);
% dat.time = 1;
% dat.dimord = 'chan_time';
% cfg.zlim = [-5 5];%[-2.5 2.5];
% %     timelabels = -100:1600;
% %cfg.highlightcolor = [0 0 0];
% %cfg.highlight = 'on';
% condshort = {'DL','DR','NDL','NDR','NGO'};
% 
% 
% count = 1;
% for time_i = [floor(length(times2show)/2),1:20:length(times2show)/2]
%     figure();set(gcf,'Position',[100 100 500 500],'Color',[1 1 1]);
%     for cond_i =1:length(conditions)
%         p = zeros(1, 64);
%         t = zeros(1, 64);
%         highlightlabels={};
%         for chan_i = 1:length(labels)
%             young = squeeze(power(1:24,cond_i, chan_i, times2show(time_i)));
%             old = squeeze(power(25:57,cond_i, chan_i, times2show(time_i)));
%             %             [p(1, chan_i), h, stats] = ranksum(young, old, 'method','approximate');
%             [h, p(1,chan_i),~, stats] = ttest2(young, old);
%             t(1, chan_i) = stats.tstat;
%             
%         end
%         [h, critp, adjp]=fdr_bh(p, 0.05, 'pdep');
%         t(p>0.05)= 0;
%         for chan_i = 1:length(labels)
%             if adjp(1, chan_i)<0.05
%                 highlightlabels = [highlightlabels;labels{chan_i}];
%                 
%             end
%         end
%         cfg.highlightchannel = highlightlabels;
%         dat.avg = t';
%         subplot(4,3,cond_i,'replace');ft_topoplotER(cfg,dat);
%         title(condshort{cond_i},'FontSize',16);
%         subplot(4,3,6);title([num2str((timeslabel(time_i))) ' ms'],'FontSize',16);
%         axis off;pause(0.1);
%     end
%     if count == 1
%         colorbar;
%     end
%     f = getframe(gcf);
%     if count == 1
%         [im,map] = rgb2ind(f.cdata,256,'nodither');
%         im(1,1,1,21) = 0;
%     end
%     if count ~=1
%         im(:,:,1,count-1) = rgb2ind(f.cdata,map,'nodither');
%     end
%     count = count +1;
%     close all;
% end
% mkdir(dataout)
% filename = [dataout 'DIFF_BETA_Movie.gif'];
% imwrite(im,map,filename,'gif','DelayTime',0.3,'LoopCount',inf);
% % end
%% make reduced figures
% For Significant Differences

addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox'));
labels = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5',...
    'T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
    'POz','Pz','CPz','Fpz','Fp2','AF8','AF4','Afz','Fz','F2','F4','F6','F8','FT8','FC6',...
    'FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6',...
    'P8','P10','PO8','PO4','O2'}';
%for plotting
cfg =[];
cfg.highlight = 'on';
cfg.layout = 'biosemi64.lay';
cfg.marker = 'off';
cfg.parameter = 'avg';
cfg.comment = 'no';
cfg.contournum = 2;
cfg.gridscale = 1000;
cfg.shading = 'interp';
cfg.interactive = 'no';
dat.var = zeros(64,1);
dat.label = labels(:,1);
dat.time = 1;
dat.dimord = 'chan_time';
cfg.zlim = [-3 3];%[-2.5 2.5];
%     timelabels = -100:1600;
%cfg.highlightcolor = [0 0 0];
%cfg.highlight = 'on';
cfg.highlightsymbol = '.';
cfg.highlightsize = 10;
condshort = {'St','DD','FD','ID','Ds','Fs','Is','saD','pS','iID','iFD','iDD'};
alpha = 0.05;

cuetimes = [50];
cuelabels = {'PostTarget'};
cueconds = condshort;
for cuetime_i = 1:length(cuetimes)
    startime = find(times==cuetimes(cuetime_i));
    endtime  = find(times==cuetimes(cuetime_i)+200);
    times2show = startime:endtime;
    timeslabel = -100:900;
    figure();set(gcf,'Position',[100 100 1920 1080],'Color',[1 1 1]);
    for cond_i =1:length(cueconds)
        cfg.colorbar = 'no';
        p = zeros(1, 64);
        t = zeros(1, 64);
        highlightlabels={};
        
        for chan_i = 1:length(labels)
            clinical = squeeze(nanmean(power(1:13,cond_i, chan_i, times2show),4));
            control = squeeze(nanmean(power(14:18,cond_i, chan_i, times2show),4));
            [~, p(1,chan_i),~, stats] = ttest2(clinical, control);
            t(1, chan_i) = stats.tstat;
        end
        [h, critp, adjp]=fdr_bh(p, alpha, 'pdep');
        t(p>0.05)= 0;
        for chan_i = 1:length(labels)
            if adjp(1, chan_i)<alpha
                highlightlabels = [highlightlabels;labels{chan_i}];
            end
        end
        cfg.highlightchannel = highlightlabels;
        dat.avg = t';
        subplot(4,3,cond_i,'replace');ft_topoplotER(cfg,dat);
        title(cueconds{cond_i},'FontSize',16);
    end
    subplot(4,3,length(cueconds));%title(cuelabels{cuetime_i},'FontSize',16);
    axis off;pause(0.1);
    filename = [dataout 'TMAPS_DIFF.05_HI-GAMMA_' cuelabels{cuetime_i} '.pdf'];
    saveas(gcf,filename,'pdf');close all;
end

%% Reduced Figures
% For individual conditions

addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox'));
labels = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5',...
    'T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
    'POz','Pz','CPz','Fpz','Fp2','AF8','AF4','Afz','Fz','F2','F4','F6','F8','FT8','FC6',...
    'FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6',...
    'P8','P10','PO8','PO4','O2'}';
%for plotting
cfg =[];
%cfg.highlight = 'on';
cfg.layout = 'biosemi64.lay';
cfg.marker = 'off';
cfg.parameter = 'avg';
cfg.comment = 'no';
cfg.contournum = 2;
cfg.gridscale = 1000;
cfg.shading = 'interp';
cfg.interactive = 'no';
dat.var = zeros(64,1);
dat.label = labels(:,1);
dat.time = 1;
dat.dimord = 'chan_time';
cfg.zlim = [-3 3];%[-2.5 2.5];
%     timelabels = -100:1600;
%cfg.highlightcolor = [0 0 0];
%cfg.highlight = 'on';
%cfg.highlightsymbol = '.';
%cfg.highlightsize = 10;
condshort = {'St','DD','FD','ID','Ds','Fs','Is','saD','pS','iID','iFD','iDD'};
alpha = 0.05;

cuetimes = [50];
cuelabels = {'PostTarget'};
cueconds = condshort;
for cuetime_i = 1:length(cuetimes)
    startime = find(times==cuetimes(cuetime_i));
    endtime  = find(times==cuetimes(cuetime_i)+200);
    times2show = startime:endtime;
    timeslabel = -100:900;
    figure();set(gcf,'Position',[100 100 1920 1080],'Color',[1 1 1]);
    for cond_i =1:length(cueconds)
        cfg.colorbar = 'no';
%         p = zeros(1, 64);
%         t = zeros(1, 64);
        highlightlabels={};
        clinical = zeros(length(labels),1);
        control = clinical;
        for chan_i = 1:length(labels)
                clinical(chan_i,1) = squeeze(nanmean(nanmean(power(1:13,cond_i, chan_i, times2show),4),1));
                control(chan_i,1) = squeeze(nanmean(nanmean(power(14:19,cond_i, chan_i, times2show),4),1));
%             [~, p(1,chan_i),~, stats] = ttest2(young, old);
%             t(1, chan_i) = stats.tstat;
        end
%         [h, critp, adjp]=fdr_bh(p, alpha, 'pdep');
%         t(p>0.05)= 0;
%         for chan_i = 1:length(labels)
%             if adjp(1, chan_i)<alpha
%                 highlightlabels = [highlightlabels;labels{chan_i}];
%             end
%         end
        cfg.highlightchannel = highlightlabels;
        dat.avg =clinical;
        subplot(4,3,cond_i,'replace');ft_topoplotER(cfg,dat);
%         dat.avg = control;
%         subplot(4,3,cond_i,'replace');ft_topoplotER(cfg,dat);
         title(cueconds{cond_i},'FontSize',16);       
    end
    subplot(4,3,length(cueconds));%title(cuelabels{cuetime_i},'FontSize',16);
    %axis off;pause(0.1);
    filename = [dataout 'TMAPS_CLIN.05_LO-GAMMA_' cuelabels{cuetime_i} '.pdf'];
    saveas(gcf,filename,'pdf');close all;
end

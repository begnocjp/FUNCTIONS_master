%% Baseline Power Analysis

clear all;close all;clc;
% addpath(rmpath('E:\fieldtrip\PACKAGES\fieldtrip'));
wpms.dirs.cwd    = ['E:' filesep 'fieldtrip' filesep];
wpms.dirs.datain = [wpms.dirs.cwd 'WAVELET_OUTPUT_DIR' filesep];
wpms.conditions  = {'dirleft','dirright','nondirleft','nondirright'};
wpms.frequency.names = {'delta','theta','loweralpha','upperalpha','beta'};
wpms.frequency.range = {[{1:18},{19:31},{35:40},{41:47},{48:68}]};
labels = {'Fp1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3'; ...
    'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3'; ...
    'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz'; ...
    'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8'; ...
    'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6'; ...
    'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2'};
names = { 'DCR107' 'DCR110' 'DCR111' 'DCR112' 'DCR115' 'DCR118' 'DCR119'...
    'DCR122' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR206' 'DCR208' 'DCR209'...
    'DCR213' 'DCR214' 'DCR217' 'DCR220' 'DCR221' 'DCR223'...
    'DCR207' 'DCR210' 'DCR211' 'DCR212'  'DCR215' 'DCR218' 'DCR219' 'DCR222'...
    'DCR224' 'DCR225' 'DCR102' 'DCR103'  'DCR106' 'DCR108' 'DCR109' 'DCR113' 'DCR114' ...
    'DCR117' 'DCR120' 'DCR121' 'DCR123'  ...
    'S1' 'S6B' 'S8' 'S11B' 'S15B' 'S16B' 'S18' 'S21' 'S25B' 'S29B'...
    'S31B' 'S36' 'S39'... %'S40'...
    'S1B' 'S6' 'S8B' 'S11' 'S15' 'S16' 'S18B' 'S21B' 'S25' 'S29' 'S31' ...
    'S36B' 'S39B'... %'S40B'...
    'S5B' 'S7B' 'S10' 'S12' 'S14' 'S17' 'S22B' 'S23B' 'S27' 'S28B' 'S30'...
    'S5' 'S7' 'S10B' 'S12B' 'S14B' 'S17B' 'S22' 'S23' 'S27B'...
    'S28' 'S30B'};
groups = {{names{1:21}},{names{22:42}},{names{43:55}},{names{56:68}},{names{69:79}},{names{80:90}}};
groupinds = {[1:21],[22:42],[43:55],[56:68],[69:79],[80:90]};
% conditions = {'dirleft','dirright','nondirleft','nondirright'};
% freq_names = {'delta','theta','loweralpha','upperalpha','beta'};
% freq = [{1:18},{19:31},{35:40},{41:47},{48:68}];
%freqx = logspace(log10(2),log10(30),80);
nchannels = 64;

%% Load Data
data1 = zeros(length(names),length(wpms.conditions),nchannels, 80, 257);

for name_i = 1:length(names);
    fprintf ('\n%s\t', names{name_i})
    for cond_i = 1:length(wpms.conditions)
        fprintf ('.')
        for chan_i = 1:nchannels
            filename = [wpms.dirs.datain names{name_i} filesep wpms.conditions{cond_i} filesep names{name_i} '_' wpms.conditions{cond_i} '_' num2str(chan_i) '_baseline_mwtf.mat'];
            load(filename)
            data1(name_i, cond_i, chan_i,:,:) = baseline_data;              
        end
    end
end

%% Create global power matrix v1
avbase1 = zeros(length(groups), nchannels, length(wpms.conditions), length(wpms.frequency.names));

for group_i = 1:length(groups)
    fprintf('\n%s\t%s\t', 'groups', num2str(group_i))
    for chan_i = 1:nchannels
        for cond_i = 1:length(wpms.conditions)
            fprintf('.')
            for freq_i = 1:length(wpms.frequency.names)
                avbase1(group_i,chan_i,cond_i,freq_i) = squeeze(mean(mean(mean(data1(groupinds{group_i},cond_i,chan_i,wpms.frequency.range{1}{freq_i},:),1),4),5));
            end
        end
    end
end

%% Collapse power across conditions
dat2 = zeros(length(names), 2, nchannels, length(wpms.frequency.names));
condnames = {'directional','nondirectional'};

for chan_i = 1:nchannels
    for freq_i = 1:length(wpms.frequency.names)
        d1 = squeeze(mean(mean(data1(:,1,chan_i,wpms.frequency.range{1}{freq_i},:),4),5));
        d2 = squeeze(mean(mean(data1(:,2,chan_i,wpms.frequency.range{1}{freq_i},:),4),5));
        d3 = squeeze(mean(mean(data1(:,3,chan_i,wpms.frequency.range{1}{freq_i},:),4),5));
        d4 = squeeze(mean(mean(data1(:,4,chan_i,wpms.frequency.range{1}{freq_i},:),4),5));
        D1 = squeeze(mean([d1 d2],2));
        D2 = squeeze(mean([d3 d4],2));
        conds = [D1 D2];
        dat2(:,1,chan_i,freq_i) = conds(:,1);
        dat2(:,2,chan_i,freq_i) = conds(:,2);
    end
end

%% Create global power matrix v2

avbase2 = zeros(length(groups), length(condnames), nchannels, length(wpms.frequency.names));

for group_i = 1:length(groups)
    fprintf('\n%s\t%s\t', 'groups', num2str(group_i))
    for chan_i = 1:nchannels
        for conds = 1:length(condnames)
            fprintf('.')
            for freq_i = 1:length(wpms.frequency.names)
                avbase2(group_i,conds,chan_i,freq_i) = squeeze(mean(dat2(groupinds{group_i},conds,chan_i,freq_i),1));
                %squeeze(mean(mean(dat2(groupinds{group_i},conds,chan_i,wpms.frequency.range{1}{freq_i}),1),4));
            end
        end
    end
end


%% Save global power

delta = [squeeze(dat2(:,1,:,1)) squeeze(dat2(:,2,:,1))];
theta = [squeeze(dat2(:,1,:,2)) squeeze(dat2(:,2,:,2))];
lowalpha = [squeeze(dat2(:,1,:,3)) squeeze(dat2(:,2,:,3))];
upalpha = [squeeze(dat2(:,1,:,4)) squeeze(dat2(:,2,:,4))];
beta = [squeeze(dat2(:,1,:,5)) squeeze(dat2(:,2,:,5))];

save('delta.txt','delta','-ascii','-tabs')
save('theta.txt','theta','-ascii','-tabs')
save('lowalpha.txt','lowalpha','-ascii','-tabs')
save('upalpha.txt','upalpha','-ascii','-tabs')
save('beta.txt','beta','-ascii','-tabs')

header = [labels,condnames{1}];

%% Plot global power

channs = 1:64;%[2,3,5,6,7];
cfg.layout = 'biosemi64.lay';
cfg.marker = 'off';
cfg.highlight = 'off';
cfg.comment  = 'auto';
cfg.zlim = [4.5 6.5]; %'maxmin';
cfg.colormap = 'jet';

dat.var = zeros(64,1);
dat.label = labels;
dat.avg = zeros(64,1);
dat.dimord = 'chan_time';
dat.time = 1;

for group_i = 1:length(groups);
    for conds = 1:length(condnames)
        figure()
        for freq_i =  1:length(wpms.frequency.names)
           dat.avg = squeeze(avbase2(group_i, conds, :, freq_i));
           dat.avg = dat.avg/10;
%           dat.avg = (dat.avg).^10;
           cfg.comment = num2str(dat.avg(13));
           subplot(3, 3, freq_i);
           ft_topoplotER(cfg, dat)
           title([num2str(group_i), ' ', condnames{conds}, ' ', wpms.frequency.names{freq_i}]) 
           
        end
        saveas(gcf,['E:\fieldtrip\ANALYSES\NeuroImage_SpecialIssue\', num2str(group_i), '_', condnames{conds}, '_jetpow.pdf'],'pdf');
    end
end

%% One Sample t-test of either active or sham power
pvals = zeros(length(groups), nchannels, length(condnames), length(wpms.frequency.names));
tvals = zeros(length(groups), nchannels, length(condnames), length(wpms.frequency.names));
n_perm = 5000;
alpha_level = 0.05;
tail = 0;
mu = 0;
reports = 0;
% seed_state = 0


for group_i = 1:2:length(groups)
    fprintf('\n%s\t%s\t', 'groups', num2str(group_i))
    for chan_i = 1:nchannels
        for conds = 1:length(condnames)
            fprintf('.')
            for freq_i = 1:length(wpms.frequency.names)
                glob = squeeze(mean(mean(dat2(groupinds{group_i},conds,:,freq_i,:),3),4));
                
                %x = squeeze(mean(dat2(groupinds{group_i},conds,chan_i,freq_i,:),4));
                y = squeeze(mean(dat2(groupinds{group_i},conds,chan_i,freq_i,:),4));
                data2 = [y-glob];
                [pvals(group_i, chan_i, conds, freq_i), tvals(group_i, chan_i, conds, freq_i), ~, ~]=mult_comp_perm_t1(data2,n_perm,tail,alpha_level,mu,reports);
                %[~, pvals(group_i, chan_i, cond_i, freq_i), ~, stats] = ttest(x,y);
                %tvals(group_i, chan_i, cond_i, freq_i) = stats.tstat;
            end
        end
    end
end

save('PVALUES_ActBL_POWER.mat','pvals','-v7.3');
save('TVALUES_ActBL_POWER.mat','tvals','-v7.3');
%savename = [datadir names{name_i} filesep conditions{cond_i} filesep names{name_i} '_ISPC.mat']


%% Permutation t-test on the difference between active and sham
pvals = zeros(length(groups), nchannels, length(wpms.conditions), length(wpms.frequency.names));
tvals = zeros(length(groups), nchannels, length(wpms.conditions), length(wpms.frequency.names));
n_perm = 5000;
alpha_level = 0.05;
tail = 0;
mu = 0;
reports = 0;
% seed_state = 0


for group_i = 1:2:length(groups)
    fprintf('\n%s\t%s\t', 'groups', num2str(group_i))
    for chan_i = 1:nchannels
        for cond_i = 1:2:length(wpms.conditions)
            fprintf('.')
            for freq_i = 1:length(wpms.frequency.names)
                x1 = squeeze(mean(mean(data1(groupinds{group_i},cond_i,chan_i,wpms.frequency.range{1}{freq_i},:),4),5));
                x2 = squeeze(mean(mean(data1(groupinds{group_i},(cond_i+1),chan_i,wpms.frequency.range{1}{freq_i},:),4),5));
                y1 = squeeze(mean(mean(data1(groupinds{group_i+1},cond_i,chan_i,wpms.frequency.range{1}{freq_i},:),4),5));
                y2 = squeeze(mean(mean(data1(groupinds{group_i+1},(cond_i+1),chan_i,wpms.frequency.range{1}{freq_i},:),4),5));
                x = mean([x1, x2],2);
                y = mean([y1, y2],2); 
                data2 = [x-y];
                [pvals(group_i, chan_i, cond_i, freq_i), tvals(group_i, chan_i, cond_i, freq_i), ~, ~]=mult_comp_perm_t1(data2,n_perm,tail,alpha_level,mu,reports);
                %[~, pvals(group_i, chan_i, cond_i, freq_i), ~, stats] = ttest(x,y);
                %tvals(group_i, chan_i, cond_i, freq_i) = stats.tstat;
            end
        end
    end
end

save('PVALUES_BLK_POWER.mat','pvals','-v7.3');
save('TVALUES_BLK_POWER.mat','tvals','-v7.3');
%savename = [datadir names{name_i} filesep conditions{cond_i} filesep names{name_i} '_ISPC.mat']

%%

cpvals = zeros(size(pvals));
addpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox');

for group_i = 1:2:length(groups)
    for cond_i = 1:length(wpms.conditions)
        for freq_i = 1:length(wpms.frequency.names)
            [~, ~, cpvals(group_i,:,cond_i,freq_i)] = fdr_bh(squeeze(pvals(group_i,:,cond_i,freq_i)),0.05, 'pdep');
        end
    end
end
%%
figure()
for chan_i = 1:nchannels
    fprintf('\n');
    for freq_i = 1:length(wpms.frequency.names)
    subplot(2,3,freq_i);
    bar(squeeze(tvals(:,chan_i,3,freq_i))) 
    title(num2str(chan_i));
    ylim([-2 2])
    %fprintf('%s\t%s\t%s\t%s\t%s\t',num2str(chan_i), wpms.frequency.names{freq_i}, num2str(squeeze(tvals(:,chan_i,3,freq_i))), num2str(squeeze(pvals(:,chan_i,3,freq_i))));
    end
    pause(0.5)
end

%% Plot significant electrodes in topoplot
cfg = [];
channs = 1:64;%[2,3,5,6,7];
cfg.layout = 'biosemi64.lay';
cfg.marker = 'off';
cfg.highlight = 'on';
cfg.highlightsymbol = '.';
cfg.highlightsize = 15;
cfg.comment  = 'no';
cfg.zlim = [-3 3];
cfg.colormap = 'hot';
cfg.contournum = 2;
cfg.gridscale = 300;
dirnames = {'directional','','nondirectional',''};

dat.var = zeros(64,1);
dat.label = labels;
dat.avg = zeros(64,1);
dat.dimord = 'chan_time';
dat.time = 1;
% 
% timesint = [0:0.5:500; 500:0.5:1000; 1000:0.5:1500; 1500:0.5:2000];
% v = timesint*2+1801;

for group_i = 1:2:length(groups);
        figure()
        count = 0;
    for cond_i = 1:2:length(dirnames)
        for freq_i =  1:length(wpms.frequency.names)
           pind = find(squeeze(pvals(group_i,:,cond_i,freq_i))'<0.05);
           cfg.highlightchannel = labels(pind);           
           dat.avg = squeeze(tvals(group_i, :, cond_i, freq_i))';
           count = count+1;
           subplot(2, 5, count);
           ft_topoplotER(cfg, dat)
           title([num2str(group_i), ' ', dirnames{cond_i}, ' ', wpms.frequency.names{freq_i}]) 
        end
         %cfg.colorbar = 'no';
%        saveas(gcf,['E:\fieldtrip\ANALYSES\NeuroImage_SpecialIssue\', num2str(group_i), '_sigsites.pdf'],'pdf');
    end
end



% With times
% for group_i = 1:2:5;
%     for cond_i = 1:length(wpms.conditions)
%         figure()
%         for freq_i =  1:length(wpms.frequency.names)
%             timewin = v(4);
%            dat.avg = 1-squeeze(mean(pvalues(group_i, :, cond_i, freq_i,timewin),5))';
%            subplot(3, 3, freq_i);
%            ft_topoplotER(cfg, dat)
%            title([num2str(group_i), ' ', wpms.conditions{cond_i}, ' ', wpms.frequency.names{freq_i}]) 
%            
%         end
%     end
% end

% plot(pvals(1,:,3,4)); hold on
% plot(cpvals(1,:,3,4), 'r');

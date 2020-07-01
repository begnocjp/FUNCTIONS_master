% Create Topoplots for tDCs data
% Patrick Cooper, 2014
% Functional Neuroimaging Laboratory, University of Newcastle
clear all
close all
warning off
%% Set up sig-pval structures:
% CUE
% for active, and for sham
%times = 1200-1400, 1700-1900ms
% for beta
% for directional right and nondirectional right
CWD = 'F:\fieldtrip\TOPO_GRAPH\';
stim = {'SHAM' 'ACTIVE'};
% 4     5     19     64
% cond, freq, time, channel
cond = {'dirleft' 'dirright' 'nonleft' 'nonright'};
freq = {'delta','theta','loweralpha','upperalpha','beta'};
conditionsofinterest = {cond{2} cond{4}};
times = [11 16];
powerdata = zeros(length(stim),length(conditionsofinterest),length(times),64);
for stim_i = 1:length(stim)
%     load([CWD 'POWER_' stim{stim_i}]);
    for cond_i = [2 4]
        for time_i = 1:length(times)
            if stim_i == 1
                powerdata(stim_i,cond_i,time_i,:) = sham_pvals(time_i,cond_i,5,:);
            elseif stim_i == 2
                powerdata(stim_i,cond_i,time_i,:) = active_pvals(time_i,cond_i,5,:);
            end
        end%
    end
end
%reset pvals to one if they weren't significant
alpha = 0.01;
bonfcorrection = alpha/size(sham_pvals,4);
sigind = powerdata < bonfcorrection;
nonsigind = powerdata >= bonfcorrection;
powerdata(sigind) = 1;
powerdata(nonsigind) = 0;
%% Set up globals:
% COLOURS
WHITE = [1 1 1];
% ELECTRODE LABELS
labels = {'FP1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3'; ...
    'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3'; ...
    'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz'; ...
    'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8'; ...
    'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6'; ...
    'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2';'M1'; ...
    'M2';'LO1';'LO2';'SO1';'SO2';'IO1';'IO2';};
% SUBPLOT ROWxCOL DIMENSIONS (i.e. do you want a 1xn set of plots or a 2x3?)
ROW = (length(stim));%rows
COL = (length(conditionsofinterest)*length(times));%cols
%% DATA PLOTTING
figure();
contrasts = {'SHAM Directional Right 1200-1400ms' , ...
             'SHAM Directional Right 1700-1900ms' , ...
             'SHAM NonDirectional Right 1200-1400ms' , ...
             'SHAM NonDirectional Right 1700-1900ms' , ...
             'ACTIVE Directional Right 1200-1400ms' , ...
             'ACTIVE Directional Right 1700-1900ms' , ...
             'ACTIVE NonDirectional Right 1200-1400ms' , ...
             'ACTIVE NonDirectional Right 1700-1900ms'};

cfg             = [];
cfg.zlim        = [0 1];
cfg.parameter   = 'avg';
cfg.layout      = 'biosemi64.lay';
cfg.comment     = 'no';
data = [];
data.var = zeros(72,1);
data.time = 1;
data.label = labels;
data.dimord = 'chan_time';
data.cov = zeros(72,72);
count = 0;
for stim_i = 1:size(powerdata,1)
    for cond_i = [2,4]
        for time_i = 1:size(powerdata,3)
            count = count+1;
            data.avg = zeros(72,1);
            data.avg(1:64) = squeeze(powerdata(stim_i,cond_i,time_i,:));
            subplot(ROW,COL,count); ft_topoplotER(cfg, data);
            set(gcf,'Color',WHITE);
            title(contrasts{count});
        end
    end
end

saveas(gcf,'SigPowerPlotstDCs.jpg','jpg');

for contrasts_i = 1:length(contrasts)
    cfg = [];
    cfg.zlim = [0 1];
    cfg.parameter   = 'avg';
    %     cfg.xlim = [0.10 0.25]; %150-200ms %[513 513+256];
    cfg.layout      = 'biosemi64.lay';
    cfg.comment   = 'no';
    data =[];
    data.avg = zeros(72,1);
    %sig vals channels
    data.avg(1:64) = squeeze(powerdata());%here
    data.var = zeros(72,1);
    data.time = 1;
    data.label = labels;
    data.dimord = 'chan_time';
    data.cov = zeros(72,72);
    subplot(ROW,COL,contrasts_i); ft_topoplotER(cfg, data);
    set(gcf,'Color',WHITE);
    title(contrasts{contrasts_i});
end
%% CUE DATA PLOT
figure();
for contrasts_i = 1:length(contrasts_cue)
    cfg = [];
    cfg.zlim = [0 1];
    cfg.parameter   = 'avg';
    %     cfg.xlim = [0.10 0.25]; %150-200ms %[513 513+256];
    cfg.layout      = 'biosemi64.lay';
    cfg.comment   = 'no';
    data =[];
    data.avg = zeros(72,1);
    %sig vals channels
    eval(['currentfile = ' datastruct_cue{(contrasts_i)} ';']);
    for pval_i = 1:length(currentfile)
        data.avg(currentfile(pval_i)) = 1;
    end%pval_i loop
    clear pval_i
    data.var = zeros(72,1);
    data.time = 1;
    data.label = labels;
    data.dimord = 'chan_time';
    data.cov = zeros(72,72);
    subplot(ROW,COL,contrasts_i); ft_topoplotER(cfg, data);
    set(gcf,'Color',WHITE);
    title(contrasts_cue{contrasts_i});
end
%% TARGET DATA PLOT
figure();
for contrasts_i = 1:length(contrasts_target)
    cfg = [];
    cfg.zlim = [0 1];
    cfg.parameter   = 'avg';
    %     cfg.xlim = [0.10 0.25]; %150-200ms %[513 513+256];
    cfg.layout      = 'biosemi64.lay';
    cfg.comment   = 'no';
    data =[];
    data.avg = zeros(72,1);
    %sig vals channels
    eval(['currentfile = ' datastruct_target{(contrasts_i)} ';']);
    for pval_i = 1:length(currentfile)
        data.avg(currentfile(pval_i)) = 1;
    end%pval_i loop
    clear pval_i
    data.var = zeros(72,1);
    data.time = 1;
    data.label = labels;
    data.dimord = 'chan_time';
    data.cov = zeros(72,72);
    subplot(ROW,COL,contrasts_i); ft_topoplotER(cfg, data);
    set(gcf,'Color',WHITE);
    title(contrasts_target{contrasts_i});
end
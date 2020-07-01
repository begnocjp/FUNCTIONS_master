%% Check significance of difference between power in active and sham conditions
%
% working environment
clear all;close all;clc;
wpms.dirs.cwd    = ['F:' filesep 'fieldtrip' filesep];
wpms.dirs.datain = [wpms.dirs.cwd 'WAVELET_OUTPUT_DIR' filesep];
wpms.conditions  = {'dirleft','dirright','nondirleft','nondirright'};
wpms.frequency.names = {'delta','theta','loweralpha','upperalpha','beta'};
wpms.frequency.range = {[{1:18},{19:31},{35:40},{41:47},{48:68}]};
names = { 'DCR107' 'DCR110' 'DCR111' 'DCR112' 'DCR115' 'DCR118' 'DCR119'...
    'DCR122' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR206' 'DCR208' 'DCR209'...
    'DCR213' 'DCR214' 'DCR217' 'DCR220' 'DCR221' 'DCR223'...
    'DCR207' 'DCR210' 'DCR211' 'DCR212'  'DCR215' 'DCR218' 'DCR219' 'DCR222'...
    'DCR224' 'DCR225' 'DCR102' 'DCR103'  'DCR106' 'DCR108' 'DCR109' 'DCR113' 'DCR114' ...
    'DCR117' 'DCR120' 'DCR121' 'DCR123'  ...
    'S1' 'S6B' 'S8' 'S11B' 'S15B' 'S16B' 'S18' 'S21' 'S25B' 'S29B'...
    'S31B' 'S36' 'S39' 'S40'...
    'S1B' 'S6' 'S8B' 'S11' 'S15' 'S16' 'S18B' 'S21B' 'S25' 'S29' 'S31' ...
    'S36B' 'S39B' 'S40B'...
    'S5B' 'S7B' 'S10' 'S12' 'S14' 'S17' 'S22B' 'S23B' 'S27' 'S28B' 'S30'...
    'S5' 'S7' 'S10B' 'S12B' 'S14B' 'S17B' 'S22' 'S23' 'S27B'...
    'S28' 'S30B'};
groups = {{names{1:21}},{names{22:42}},{names{43:56}},{names{57:70}},{names{71:81}},{names{82:92}}};
groupinds = {[1:21],[22:42],[43:56],[57:70],[71:81],[82:92]};
% load([wpms.dirs.cwd 'FUNCTIONS' filesep 'LIST_ACTIVE_SHAM']);
% wpms.names.active = ACTIVE;
% wpms.names.sham   = SHAM;
% clear ACTIVE SHAM
% groupinds = {[1:23],...
%     [24,28,30,32,35,36,38,41,45,49,55,58,59],...
%     [26,27,29,31,33,34,37,42,43,47,48,50]};
nchannels = 64;

%%
n_perm = 5000;
alpha_level = 0.05;
tail = 0;
mu = 0;
reports = 0;
addpath('F:\fieldtrip\FUNCTIONS');

pvalues = zeros(length(groups),nchannels,length(wpms.conditions),length(wpms.frequency.names),9801);
tvalues = zeros(size(pvalues));

for group_i = 1:2:length(groups)
    fprintf('%s %s\n','Group',num2str(group_i))
    for  chan_i = 1:nchannels
        fprintf('%s\n',num2str(chan_i))
        for cond_i = 1:length(wpms.conditions)
            fprintf('%s\t',wpms.conditions{cond_i})
            tmp1 = zeros(length(groups{group_i}),80,9801);
            tmp2 = zeros(size(tmp1));
            for name_i = 1:length(groups{group_i})
                fprintf('.');
                A = load([wpms.dirs.datain(1:strfind(wpms.dirs.datain,'p\')+1) 'WAVELET_OUTPUT_DIR' filesep groups{group_i}{name_i} filesep wpms.conditions{cond_i} filesep groups{group_i}{name_i} '_' wpms.conditions{cond_i} '_' num2str(chan_i) '_imagcoh_mwtf.mat']);
                B = load([wpms.dirs.datain(1:strfind(wpms.dirs.datain,'p\')+1) 'WAVELET_OUTPUT_DIR' filesep groups{group_i+1}{name_i} filesep wpms.conditions{cond_i} filesep groups{group_i+1}{name_i} '_' wpms.conditions{cond_i} '_' num2str(chan_i) '_imagcoh_mwtf.mat']);
                tmp1(name_i,:,:) = A.mw_tf;
                tmp2(name_i,:,:) = B.mw_tf;            
            end
            avdata1 = zeros(length(groups{group_i}),length(wpms.frequency.names),9801);
            avdata2 = zeros(length(groups{group_i}),length(wpms.frequency.names),9801);
            for freq_i = 1:length(wpms.frequency.names)
                avdata1(:,freq_i,:) = squeeze(mean(tmp1(:,wpms.frequency.range{1}{freq_i},:),2));
                avdata2(:,freq_i,:) = squeeze(mean(tmp2(:,wpms.frequency.range{1}{freq_i},:),2));
            end
            clear tmp1 tmp2
            for freq_i = 1:length(wpms.frequency.names)
                data2 = [squeeze(avdata1(:,freq_i,:))-squeeze(avdata2(:,freq_i,:))];
                [pvalues(group_i, chan_i, cond_i, freq_i,:), tvalues(group_i, chan_i, cond_i, freq_i,:), ~, ~]=mult_comp_perm_t1(data2,n_perm,tail,alpha_level,mu,reports);
                clear data2
            end
            clear avdata1 avdata2
        end
    end
end

 save('PVALUES_EPOCH_POWER.mat','pvalues','-v7.3');
 save('TVALUES_EPOCH_POWER.mat','tvalues','-v7.3');
%%


% group_i = 1;
% group_ii =2;
% data1 = single(zeros(length(groups{group_i}),length(wpms.conditions),64,80,9801));
% data2 = single(zeros(length(groups{group_ii}),length(wpms.conditions),64,80,9801));
% for cond_i = 1:length(wpms.conditions)
%     fprintf('\n');
%     names1 =groups{group_i};
%     names2 = groups{group_ii};
%     freqx = logspace(log10(2),log10(30),80);
%     for name_i = 1:length(names1)
%         %count = 0;
%         for chan_i = 1:nchannels
%             %count = count+1;
%             fprintf('.');
%             A = load([wpms.dirs.datain(1:strfind(wpms.dirs.datain,'p\')+1) 'WAVELET_OUTPUT_DIR' filesep names1{name_i} filesep wpms.conditions{cond_i} filesep names1{name_i} '_' wpms.conditions{cond_i} '_' num2str(chan_i) '_imagcoh_mwtf.mat']);
%             B = load([wpms.dirs.datain(1:strfind(wpms.dirs.datain,'p\')+1) 'WAVELET_OUTPUT_DIR' filesep names2{name_i} filesep wpms.conditions{cond_i} filesep names2{name_i} '_' wpms.conditions{cond_i} '_' num2str(chan_i) '_imagcoh_mwtf.mat']);
%             data1(name_i,cond_i,chan_i,:,:) = A.mw_tf;
%             data2(name_i,cond_i,chan_i,:,:) = B.mw_tf;
%         end
%     end
% end
% 
% 
% %%
% avbase1 = zeros(length(group_i), nchannels, length(wpms.conditions), length(wpms.frequency.names));
% avbase2 = zeros(length(group_ii), nchannels, length(wpms.conditions), length(wpms.frequency.names));
% 
% % for group_i = 1:length(groups)
% %     fprintf('\n%s\t%s\t', 'groups', num2str(group_i))
%     for chan_i = 1:nchannels
%         for cond_i = 1:length(wpms.conditions)
%             fprintf('.')
%             for freq_i = 1:length(wpms.frequency.names)
%                 avbase1(group_i,chan_i,cond_i,freq_i) = squeeze(mean(mean(mean(data1(group_i,cond_i,chan_i,wpms.frequency.range{1}{freq_i},:),1),4),5));
%                 avbase2(group_ii,chan_i,cond_i,freq_i) = squeeze(mean(mean(mean(data2(group_ii,cond_i,chan_i,wpms.frequency.range{1}{freq_i},:),1),4),5));
%             end
%         end
%     end
% % end
% 
% %%
% pvalues = zeros(length(groups), nchannels, length(wpms.conditions), length(wpms.frequency.names),9801);
% tvalues = zeros(size(pvalues));
% 
% n_perm = 5000;
% alpha_level = 0.05;
% tail = 0;
% mu = 0;
% reports = 0;
% addpath('E:\fieldtrip\FUNCTIONS')
% 
% for group_i = 1:2:length(groups)
%     fprintf('\n%s\t%s\t', 'groups', num2str(group_i))
%     for chan_i = 1:nchannels
%         for cond_i = 1:length(wpms.conditions)
%             fprintf('.')
%             for freq_i = 1:length(wpms.frequency.names)
%                 x = squeeze(mean(mean(data1(groupinds{group_i},cond_i,chan_i,wpms.frequency.range{1}{freq_i},:),4),5));
%                 y = squeeze(mean(mean(data1(groupinds{group_i+1},cond_i,chan_i,wpms.frequency.range{1}{freq_i},:),4),5));
%                 data2 = [x-y];
%                 [pvalues(group_i, chan_i, cond_i, freq_i), tvalues(group_i, chan_i, cond_i, freq_i), ~, ~]=mult_comp_perm_t1(data2,n_perm,tail,alpha_level,mu,reports);
%             end
%         end
%     end
% end
% 
% save('PVALUES_EPOCH_POWER.mat','pvals','-v7.3');
% save('TVALUES_EPOCH_POWER.mat','tvals','-v7.3');


% for groups = 1:length(groupinds)
%     fprintf('%s %s\n\n\n','Working on group:',num2str(groups));
%     for cond_i = 1:length(wpms.conditions)
%         tic;
%         fprintf('%s %s','Condition:',wpms.conditions{cond_i});
%         for channel = 1:nchannels
%             fprintf('\n%s %s\t','Channel:',num2str(channel));
%             activedata = zeros(length(wpms.names.active{name_i}),80,9801);
%             shamdata   = zeros(length(wpms.names.sham{name_i}),80,9801);
%             for name_i = groupinds{groups}(1):groupinds{groups}(end)
%                 active_filename = [wpms.dirs.datain wpms.names.active{name_i} ...
%                     filesep wpms.conditions{cond_i} filesep ...
%                     wpms.names.active{name_i} '_' wpms.conditions{cond_i} ...
%                     '_' num2str(channel) '_' 'imagcoh_mwtf.mat'];
%                 sham_filename = [wpms.dirs.datain wpms.names.sham{name_i} ...
%                     filesep wpms.conditions{cond_i} filesep ...
%                     wpms.names.sham{name_i} '_' wpms.conditions{cond_i} ...
%                     '_' num2str(channel) '_' 'imagcoh_mwtf.mat'];
%                 if exist(active_filename,'file') ==0;
%                     fprintf('x')
%                 else
%                     fprintf('.');
%                     A=load(active_filename);%active
%                     S=load(sham_filename);%sham
%                     activedata(name_i,:,:) = A.mw_tf;
%                     shamdata(name_i,:,:)  = S.mw_tf;
%                     clear A S active_filename sham_filename
%                 end
%             end%name loop
%             fprintf('\t%s\t','Performing t-tests');
%             for freq_i = 1:length(wpms.frequency.names)
%                 fprintf('*');
%                 act  = squeeze(mean(activedata(:,wpms.frequency.range{1}{freq_i},:),2));
%                 sham = squeeze(mean(shamdata(:,wpms.frequency.range{1}{freq_i},:),2));
%                 data2 = act-sham;
%                 [pvalues(groupinds(group_i), channel, cond_i, freq_i), tvalues(groupinds(group_i), chanel, cond_i, freq_i), ~, ~]=mult_comp_perm_t1(data2,n_perm,tail,alpha_level,mu,reports);
%                 %tvalues(groups,cond_i,freq_i,channel,:) = stats.tstat;
%             end
%             clear act sham
%             clear data2
%         end%channel loop
%         toc
%     end%cond_i loop
% end%groups loop
% save('PVALUES_POWER.mat','pvalues','-v7.3');
% save('TVALUES_POWER.mat','tvalues','-v7.3');
% clear shamdata activedata stats
%% apply fdr correction
alpha = 0.05;%correction values for FDR
adj_p = zeros(size(pvalues));
for groups = 1:length(groupinds)
    fprintf('%s %s\n\n\n','Working on group:',num2str(groups));
    for cond_i = 1:length(wpms.conditions)
        tic;
        fprintf('%s %s','Condition:',wpms.conditions{cond_i});
        for freq_i = 1:length(wpms.frequency.names)
            fprintf('\n')
            for channel = 1:nchannels
                fprintf('*');
                [~,~,adj_p(groups,cond_i,freq_i,channel,:)] = fdr_bh(squeeze(pvalues(groups,cond_i,freq_i,channel,:)),alpha,'pdep');
            end%channel loop
        end
        toc
    end%cond_i loop
end%groups loop
%% view headplots
labels = {'Fp1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3'; ...
    'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3'; ...
    'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz'; ...
    'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8'; ...
    'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6'; ...
    'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2'};
addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip\'));
cfg = [];
cfg.zlim = [0.95 1];
cfg.parameter   = 'avg';
cfg.marker = 'off';
%     cfg.xlim = [0.10 0.25]; %150-200ms %[513 513+256];
cfg.layout      = 'biosemi64.lay';
cfg.gridscale   = 30;
cfg.contournum = 1;
cfg.comment   = 'no';%[group_names{1},' ',conditions{1},' ',num2str((1-1)*20),' ms'];
cfg.colormap = 'hot';
%cfg.highlight = ['FCZ';'FPZ';'FC1'];
data_plot =[];

data_plot.var = zeros(64,1);
data_plot.time = 1;
data_plot.label = labels;
data_plot.dimord = 'chan_time';
data_plot.cov = zeros(64,64);
for group = 1:3;
    for freq = 1:length(wpms.frequency)
        for time_i =1000:50:4000%size(adj_p,5);
            for cond_i = 1:length(wpms.conditions)
                datavector = squeeze(double(pvalues(group,cond_i,freq,:,time_i)));
                data_plot.avg = 1-datavector;
                subplot(2,2,cond_i);ft_topoplotER(cfg, data_plot);title([wpms.conditions{cond_i}, ' ',num2str(time_i-1000)]);
            end
            pause(0.001);
        end
    end
end
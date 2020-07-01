%af7 af3 f5 f7 f3
addpath(genpath('/Volumes/Elements/fieldtrip/PACKAGES/fieldtrip/'));
rmpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip\'));
addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox'));
datadir = 'E:\fieldtrip\EEGLAB_FORMAT\';
labels = {'Fp1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3'; ...
    'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3'; ...
    'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz'; ...
    'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8'; ...
    'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6'; ...
    'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2'};
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
%%
channs = 1:64;%[2,3,5,6,7];
cfg.layout = 'biosemi64.lay';
cfg.marker = 'off';
cfg.highlight = 'on';
cfg.highlightcolor = [1 1 1];
dat.var = zeros(64,1);
dat.label = labels;
dat.avg = zeros(64,1);
dat.dimord = 'chan_time';
dat.time = 1;
sitesforcomparison = [4,5,10,11,39,40,45,46];
for group_i = 1:2:5;
    figure();ha=tight_subplot(length(sitesforcomparison),length(conditions)+1,[.01,.01],[.01,.01],[.01,.01]);
    seeds = {'C3' '' 'C3' '' 'C4'};
    names1 =groups{group_i};
    names2 = groups{group_i+1};
    seed = seeds{group_i};
    for cond_i = 1:length(conditions)
        pos=(cond_i-5);%used to index subplot call
        data1 = zeros(length(names1),2,2,64,80,61);
        data2 = zeros(length(names2),2,2,64,80,61);
        freqx = logspace(log10(2),log10(30),80);
        for name_i = 1:length(names1)
            fprintf('.');
            A = load([datadir names1{name_i} filesep conditions{cond_i} filesep names1{name_i} '_ISPC.mat']);
            B = load([datadir names2{name_i} filesep conditions{cond_i} filesep names2{name_i} '_ISPC.mat']);
            data1(name_i,:,:,:,:,:) = abs(A.synchOverTrials);
            data2(name_i,:,:,:,:,:) = abs(B.synchOverTrials);
        end
        for chann_i = sitesforcomparison
            pos = pos+5;
            a = squeeze(mean(mean(abs(data1(:,1,2,channs(chann_i),:,1:40)),2),4));
            b = squeeze(mean(mean(abs(data2(:,1,2,channs(chann_i),:,1:40)),2),4));
            h=zeros(length(freqx),40);p=zeros(length(freqx),40);t=zeros(length(freqx),40);%preallocate
            for freq_i = 1:length(freqx)
                [h(freq_i,:),p(freq_i,1:40),~,stats] = ttest(squeeze(a(:,freq_i,1:40)),squeeze(b(:,freq_i,1:40)));
                t(freq_i,:) = stats.tstat;
            end
            fdr = true;
            if fdr == true
                adj_p = 100000*ones(size(p));
                q = 0.10;
                for freq_i = 1:length(freqx)
                    [rows,cols,vals] = find((p(freq_i,:)<q));
                    values = [];
                    for col_i = 1:length(cols)
                        values = [values;p(freq_i,col_i)];
                    end
                    if numel (values)>0
                        
                        [h,crit_p,tmp_adj_p] = fdr_bh(values,q,'pdep');
                        if numel(tmp_adj_p) > 0
                            for adj_p_i = 1:size(tmp_adj_p)
                                adj_p(freq_i,cols(adj_p_i))=tmp_adj_p(adj_p_i);
                            end
                        end
                    end
                end
                sig = zeros(size(p));
                sig(adj_p<q) = t(adj_p<q);
            else
                q = 0.05;
                sig = zeros(size(p));
                sig(p<q) = t(p<q);
             end
            rmpath(genpath('/Volumes/Elements/fieldtrip/PACKAGES/fieldtrip/'));
            tmp = sig(80:-1:1,:);
            tmp(end,end) = -10.0;
            tmp(1,1) = 10.0;
            axes(ha(pos));contourf(tmp,10);axis square;hold on;
            set(gca,'YDir','reverse','YTick',10:10:80,'YTickLabel',{floor(freqx(80:-10:10))})
            caxis([-3 3]);colormap jet
            cfg.highlightchannel = {seed;labels{chann_i}};
            switch pos
                case 1
                    axes(ha(pos+4));ft_topoplotER(cfg,dat);colormap jet;axis square
                case 6
                    axes(ha(pos+4));ft_topoplotER(cfg,dat);colormap jet;axis square
                case 11
                    axes(ha(pos+4));ft_topoplotER(cfg,dat);colormap jet;axis square
                case 16
                    axes(ha(pos+4));ft_topoplotER(cfg,dat);colormap jet;axis square
                case 21
                    axes(ha(pos+4));ft_topoplotER(cfg,dat);colormap jet;axis square
                case 26
                    axes(ha(pos+4));ft_topoplotER(cfg,dat);colormap jet;axis square
                case 31
                    axes(ha(pos+4));ft_topoplotER(cfg,dat);colormap jet;axis square
                case 36
                    axes(ha(pos+4));ft_topoplotER(cfg,dat);colormap jet;axis square
            end
        end
    end
end

%af7 af3 f5 f7 f3
addpath(genpath('/Volumes/Elements/fieldtrip/PACKAGES/fieldtrip/'));
%%
channs = 1:64;%[2,3,5,6,7];
labels = {'Fp1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3'; ...
    'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3'; ...
    'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz'; ...
    'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8'; ...
    'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6'; ...
    'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2'};
cfg.layout = 'biosemi64.lay';
cfg.marker = 'off';
cfg.highlight = 'on';
cfg.highlightcolor = [1 1 1];
cfg.comment = 'no';
dat.var = zeros(64,1);
dat.label = labels;
dat.avg = zeros(64,1);
dat.dimord = 'chan_time';
dat.time = 1;
for cond_i = 2%1:4
    names1 =groups{3};
    names2 = groups{4};
    seed = 'C3';
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
    
    for chann_i = [4,5,10,11,39,40,45,46]%1:64
        figure()
        a = squeeze(mean(mean(abs(data1(:,1,2,channs(chann_i),:,1:40)),2),4));
        b = squeeze(mean(mean(abs(data2(:,1,2,channs(chann_i),:,1:40)),2),4));
        h=[];p=[];
        for freq_i = 1:80
            [h(freq_i,:),p(freq_i,1:40),~,stats] = ttest(squeeze(a(:,freq_i,1:40)),squeeze(b(:,freq_i,1:40)));
            t(freq_i,:) = stats.tstat;
        end
        %[~,~,adj_p] = fdr_bh(p,.05,'pdep');
        sig = zeros(size(p));
        sig(p<.05) = t(p<.05);
        rmpath(genpath('/Volumes/Elements/fieldtrip/PACKAGES/fieldtrip/'));
        subplot(1,2,1);contourf(sig(80:-1:1,:),2);title(['channel =', labels{chann_i}]);hold on;
        set(gca,'YDir','reverse','YTick',10:10:80,'YTickLabel',{floor(freqx(80:-10:10))});
        caxis([-3 3]);colormap jet
        cfg.highlightchannel = {seed;labels{chann_i}};
        addpath(genpath('/Volumes/Elements/fieldtrip/PACKAGES/fieldtrip/'));
        subplot(1,2,2);ft_topoplotER(cfg,dat);colormap jet
        pause(0.5);
        subplot(1,2,1);imagesc(zeros(size(p)));colormap jet
        hold off;
    end
end


%% Avg Imag Coherence
clear all
close all
warning off;
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
     'S28' 'S30B'}; %artefact rejection list
groups = {{names{1:22}},{names{23:44}},{names{45:58}},{names{59:72}},{names{73:84}},{names{85:96}}};
conditions = {'dirleft','dirright','nondirleft','nondirright'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
times = {};
starttime = -500:100:2500;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%adjust these
endtime   = starttime+200;
for time_i = 1:length(starttime)
    times{time_i} = strcat(num2str(starttime(time_i)),'to',num2str(endtime(time_i)));
end
CWD   = 'E:\fieldtrip';
% NWD = 'F:\fieldtrip';

IMAG ='\IMAGCOH_OUTPUT';
addpath(genpath('F:\fieldtrip\FUNCTIONS\mass_uni_toolbox')); %for FDR correction
addpath('F:\fieldtrip\FUNCTIONS');
addpath([CWD,IMAG]);
GROUPS = {'YOUNG_ACT','YOUNG_SHAM','DOM_ACT','DOM_SHAM','NONDOM_ACT','NONDOM_SHAM'};
IMAVALS = zeros(3,length(conditions),length(frequencies),length(times),2);
IMAERRS = zeros(3,length(conditions),length(frequencies),length(times),2);
for group_i = 1:2:(length(GROUPS)-1)
    fprintf('\n');
    A= load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ALLDATA_' GROUPS{group_i}]);%active
    S= load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ALLDATA_' GROUPS{group_i+1}]);%sham
    for cond_i = 1:length(conditions)
        fprintf('.');
        for time_i = 1:length(times)
            for freq_i = 1:length(frequencies)
                x = squeeze(median(squeeze(abs(A.ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(:,time_i,:,:))),1));
                dat = squeeze(A.ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(:,time_i,:,:));
                clear avconn
                for i = 1:size(dat,1)
                    avconn(i) = mean(mean(dat(i,:,:)));
                end
                IMAERRS(group_i,cond_i,freq_i,time_i,1) = std(avconn)/(sqrt(size(avconn,2)));
                IMAVALS(group_i,cond_i,freq_i,time_i,1) = mean(mean(tril(x)));
                y = squeeze(median(squeeze(abs(S.ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(:,time_i,:,:))),1));
                IMAVALS(group_i,cond_i,freq_i,time_i,2) = mean(mean(tril(y)));
                dat = squeeze(S.ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(:,time_i,:,:));
                clear avconn
                for i = 1:size(dat,1)
                    avconn(i) = mean(mean(dat(i,:,:)));
                end
                IMAERRS(group_i,cond_i,freq_i,time_i,2) = std(avconn)/(sqrt(size(avconn,2)));
            end
        end%time_i loop
    end%cond_i loop
end%group_i loop

for groups = [1,3,5]
    figure();set(gcf,'Color',[1 1 1]);title(['GROUP:',num2str(groups)]);
    count=0;
    for cond_i =1:length(conditions)
        for freq_i =1:length(frequencies);
            count = count+1;
            subplot(4,5,count);errorbar(1:length(times),squeeze(IMAVALS(groups,cond_i,freq_i,:,1)),squeeze(IMAERRS(groups,cond_i,freq_i,:,1)),'-r');hold on;set(gca,'YLim',[0.05 0.25]);
            errorbar(1:length(times),squeeze(IMAVALS(groups,cond_i,freq_i,:,2)),squeeze(IMAERRS(groups,cond_i,freq_i,:,2)),'-b');title(frequencies{freq_i});
%             plot(squeeze(IMAVALS(groups,cond_i,freq_i,:,1)),'-r');hold on;plot(squeeze(IMAVALS(groups,cond_i,freq_i,:,2)),'-b');title(frequencies{freq_i});
        end
    end
end
%% average connectivity no time
clc
for groups = [1,3,5]
    figure();set(gcf,'Color',[1 1 1]);title(['GROUP:',num2str(groups)]);
    count=0;
    for cond_i =1:length(conditions)
        for freq_i =1:length(frequencies);
            count = count+1;
            act_av = mean(squeeze(IMAVALS(groups,cond_i,freq_i,:,1)),1);
            sha_av = mean(squeeze(IMAVALS(groups,cond_i,freq_i,:,2)),1);
            act_sd = std(squeeze(IMAVALS(groups,cond_i,freq_i,:,1)));
            sha_sd = std(squeeze(IMAVALS(groups,cond_i,freq_i,:,2)));
            [h,p,~,stats] = ttest(squeeze(IMAVALS(groups,cond_i,freq_i,:,1)),squeeze(IMAVALS(groups,cond_i,freq_i,:,2)));
%             if h == 1;
                fprintf('\n%s\t%s\t%s\t%s','Significant Difference Found for Group:',num2str(groups),conditions{cond_i},frequencies{freq_i});
                fprintf('\t%s\t%s\t%s\t%s','MEAN ACTIVE:',num2str(act_sd),'MEAN SHAM:',num2str(sha_sd));
                fprintf('\t%s\t%s\t%s\t%s','pval:',num2str(p),'tval:',num2str(stats.tstat));
%             end
            subplot(4,5,count);bar([sha_av;act_av]);set(gca,'YLim',[0 0.25],'XTickLabels',{'SHAM','ACTIVE'});
%             subplot(4,5,count);errorbar(1:length(times),squeeze(IMAVALS(groups,cond_i,freq_i,:,1)),squeeze(IMAERRS(groups,cond_i,freq_i,:,1)),'-r');hold on;set(gca,'YLim',[0.05 0.25]);
%             errorbar(1:length(times),squeeze(IMAVALS(groups,cond_i,freq_i,:,2)),squeeze(IMAERRS(groups,cond_i,freq_i,:,2)),'-b');title(frequencies{freq_i});
%             plot(squeeze(IMAVALS(groups,cond_i,freq_i,:,1)),'-r');hold on;plot(squeeze(IMAVALS(groups,cond_i,freq_i,:,2)),'-b');title(frequencies{freq_i});
        end
    end
end

%% Avg Electrode Imag Coherence

p = zeros(3,length(conditions),length(frequencies),length(times),64,2);
BAKLAVALS = zeros(3,length(conditions),length(frequencies),length(times),64,2);
TVALS = zeros(3,length(conditions),length(frequencies),length(times),64,2);
for group_i = 1:2:(length(GROUPS)-1)
    fprintf('\n');
    A= load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ALLDATA_' GROUPS{group_i}]);%active
    S= load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ALLDATA_' GROUPS{group_i+1}]);%sham
    for cond_i = 1:length(conditions)
        fprintf('.');
        for time_i = 1:length(times)
            for freq_i = 1:length(frequencies)                
                x = squeeze(mean(squeeze(abs(A.ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(:,time_i,:,:))),1));                
                y = squeeze(median(squeeze(abs(S.ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(:,time_i,:,:))),1));
                for chan_i = 1:64
                    BAKLAVALS(group_i,cond_i,freq_i,time_i,chan_i,1) = mean(x(chan_i,:));
                    BAKLAVALS(group_i,cond_i,freq_i,time_i,chan_i,2) = mean(y(chan_i,:));
                end
                avactconn = mean(BAKLAVALS(group_i,cond_i,freq_i,time_i,:,1),5);
                shactconn = mean(BAKLAVALS(group_i,cond_i,freq_i,time_i,:,2),5);
                xt = squeeze(squeeze(abs(A.ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(:,time_i,:,:))));
                yt = squeeze(squeeze(abs(S.ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(:,time_i,:,:))));
                for chan_i = 1:64
                    data = squeeze(xt(:,chan_i,:));
                    data = squeeze(mean(data,2));
                    dats = squeeze(yt(:,chan_i,:));
                    dats = squeeze(mean(dats,2));
                    data = abs(data/avactconn);
                    dats = abs(dats/shactconn);
                    data = data';dats=dats';
                    [~,p(group_i,cond_i,freq_i,time_i,chan_i,1),~,stat] = ttest(data,dats);
                    if p(group_i,cond_i,freq_i,time_i,chan_i,1) < 0.05; 
                        TVALS(group_i,cond_i,freq_i,time_i,chan_i,1) = stat.tstat;
                    else
                        TVALS(group_i,cond_i,freq_i,time_i,chan_i,1) = 0;
                    end
                end
            end
        end%time_i loop
    end%cond_i loop
end%group_i loop
TVALS2 = TVALS;
%% FDR CORRECTION
h = zeros(size(p));
crit_p = zeros(size(p));
adj_p = zeros(size(p));
addpath(genpath('F:\fieldtrip\FUNCTIONS\mass_uni_toolbox'));
for group_i = [1,3,5];
    fprintf('.')
    for cond_i = 1:length(conditions)
        for freq_i = 1:length(frequencies)
            for time_i = 1:length(times)
                [h(group_i,cond_i,freq_i,time_i,:,1),crit_p(group_i,cond_i,freq_i,time_i,:,1),adj_p(group_i,cond_i,freq_i,time_i,:,1)] = fdr_bh(squeeze(p(group_i,cond_i,freq_i,time_i,:,1)),0.05,'pdep') ;
            end
        end
    end
end

%% Reordering
labelinds = [1;33;34;2;3;37;36;35;7;6;5;4;38;39;40;41;42;8;9;10;11;47;46;45;44;43;15;14;13;12;48;49;50;51;52;16;17;18;19;32;56;55;54;53;24;23;22;21;20;31;57;58;59;60;61;25;26;30;63;62;27;29;64;28];

for group_i = [1,3,5]
    fprintf('\n');
    for cond_i = 1:length(conditions)
        fprintf('.');
        for freq_i = 1:length(frequencies)
            for time_i = 1:length(times)
                for chan_i = 1:64
                    if adj_p(group_i,cond_i,freq_i,time_i,chan_i,1) > 0.05;
                       TVALS(group_i,cond_i,freq_i,time_i,chan_i,1) = 0;
                    end
                end
            end
        end
    end
end

REKTVALS = zeros(size(TVALS));
for group_i = [1,3,5]
    fprintf('\n');
    for cond_i = 1:length(conditions)
        fprintf('.');
        for freq_i = 1:length(frequencies)
            rowcount = 0;
            for row = 1:length(labelinds);
                rowcount = rowcount+1;
                REKTVALS(group_i,cond_i,freq_i,:,rowcount,1) = TVALS(group_i,cond_i,freq_i,:,labelinds(row),1);
            end
        end
    end
end
%%
freqnames = {'\delta','\theta','\alpha_1','\alpha_2','\beta'};
for groups = [1,3,5]
    figure();set(gcf,'Color',[1 1 1]);title(['GROUP:',num2str(groups)]);
    count=0;
    for cond_i =1:length(conditions)
        for freq_i =1:length(frequencies);
            count = count+1;
            subplot(4,5,count);
            imagesc(squeeze(REKTVALS(groups,cond_i,freq_i,:,:,1))',[-6 6]);
            set(gca,'YTickLabels',{'F5','FC3','C1','CPz','Pz','PO8'});title(freqnames{freq_i});
        end
    end
end

%% Generate Topoplots

addpath(genpath('F:\fieldtrip\PACKAGES\fieldtrip'))
%%
conditions = {'Directional Left','Directional Right','Non-Directional Left','Non-Directional Right'};
times = {'-500 to -300 ms','-400 to -200 ms','-300 to -100 ms','-200 to 0','-100 to 100 ms','0 to 200 ms','100 to 300 ms','200 to 400 ms','300 to 500 ms','400 to 600 ms','500 to 700 ms','600 to 800 ms','700 to 900 ms','800 to 1000 ms','900 to 1100 ms','1000 to 1200 ms','1100 to 1300 ms','1200 to 1400 ms','1300 to 1500 ms','1400 to 1600 ms','1500 to 1700 ms','1600 to 1800 ms','1700 to 1900 ms','1800 to 2000 ms','1900 to 2100 ms','2000 to 2200 ms','2100 to 2300 ms','2200 to 2400 ms','2300 to 2500 ms','2400 to 2600 ms','2500 to 2700 ms';};
fsize = 11;
cfg =[];
cfg.layout = 'biosemi64.lay';
cfg.parameter = 'avg';
cfg.comment = 'no';
dat.var = zeros(72,1);
dat.label = labels(:,1);
dat.time = 1;
dat.dimord = 'chan_time';
cfg.zlim = [-5 5];
for time_i = 1:length(times)
    count = 0;
    figure('units','normalized','outerposition',[0 0 1 1]);set(gcf,'Color',[1 1 1]);
    for group_i = [1,3,5]
        for cond_i = 1:length(conditions)
            count = count+1;
            temp = squeeze(TVALS(group_i,cond_i,5,time_i,:,1));
            temp = [temp;0;0;0;0;0;0;0;0];
            dat.avg = temp;
            if count < 5
                subplot(3,4,count);
                ft_topoplotER(cfg,dat);
                title(conditions{cond_i},'FontSize',fsize);
            else
                subplot(3,4,count);
                ft_topoplotER(cfg,dat);
            end
            if count == 1;
                text(-1.7,0,{'Younger Adult'; 'Dominant'; 'Hemisphere'},'FontSize',fsize)%YOUNG
            elseif count == 5;
                text(-1.7,0,{'Older Adult' ;'Dominant'; 'Hemisphere'},'FontSize',fsize)%YOUNG
            elseif count == 10;
                text(0.25,-0.8,times{time_i},'FontSize',round(fsize*1.25))%YOUNG
            elseif count == 9;
                text(-1.7,0,{'Older Adult' ;'Non-Dominant'; 'Hemisphere'},'FontSize',fsize)%YOUNG
            end
        end
    end
%     pause(0.5);
%     f = getframe(gcf);
%         if time_i == 1
%             [im,map] = rgb2ind(f.cdata,256,'nodither');
%             im(1,1,1,31) = 0;
%         end
%         im(:,:,1,time_i) = rgb2ind(f.cdata,map,'nodither');
%     imwrite(im,map,['E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\NeuroImage_TMap_HeadPlots\BETA.gif'],'DelayTime',1,'LoopCount',inf)
     saveas(gcf,['E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\NeuroImage_TMap_HeadPlots\BETA_' times{time_i} '.pdf'],'pdf');
    close;
end
%% Avg T-Map Connections
CONN_COUNT = zeros(3,length(conditions), length(frequencies), length(times), 2);
for group_i =   1:2:(length(GROUPS)-1)
    cd(['E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\ABS\' GROUPS{group_i}]);
    for cond_i = 1:length(conditions)
        for freq_i = 1:length(frequencies)
            for time_i = 1:length(times)
                load(['E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\ABS\' GROUPS{group_i} ...
                    '\' conditions{cond_i} '-' frequencies{freq_i} '-' times{time_i} ...
                    '_pairlist.mat']);
                ACTIVE_COUNT = 0;
                SHAM_COUNT = 0;
                for pair_i = 1:size(pairlist,1)
                    %             name{26} = 'Afz';
                    if pairlist{pair_i,3} < 0;
                        SHAM_COUNT = SHAM_COUNT+1;
                    elseif pairlist{pair_i,3} > 0;
                        ACTIVE_COUNT = ACTIVE_COUNT+1;
                    end
                    CONN_COUNT(group_i, cond_i, freq_i, time_i, 1) = ACTIVE_COUNT;
                    CONN_COUNT(group_i, cond_i, freq_i, time_i, 2) = SHAM_COUNT;
                    
                end
            end
        end
    end
end%group_i loop
for groups = [1,3,5]
    figure();set(gcf,'Color',[1 1 1]);title(['GROUP:',num2str(groups)]);
    count=0;
    for cond_i =1:length(conditions)
        for freq_i =1:length(frequencies);
            count = count+1;
            subplot(4,5,count);plot(squeeze(CONN_COUNT(groups,cond_i,freq_i,:,1)),'-r');hold on;plot(squeeze(CONN_COUNT(groups,cond_i,freq_i,:,2)),'-b');title(frequencies{freq_i});
        end
    end
end
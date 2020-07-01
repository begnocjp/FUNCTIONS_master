% t-test between Baseline and Time-bins 1200-1400 and 1700-1900ms
% Using ALL_POWER_SHAM and ALL_POWER_ACTIVE from tDCS_GenereateTopoplot
%

%% Setup:

clear all;
load('LIST_ACTIVE_SHAM')
YOUNGLENGTH = 22;%only want young participants
names = struct('pnum',{ 'DCR102' 'DCR103' 'DCR104' 'DCR106' 'DCR107' 'DCR108' 'DCR109' 'DCR110' 'DCR111' ... 
    'DCR112' 'DCR113' 'DCR114' 'DCR115' 'DCR117' 'DCR118' 'DCR119' 'DCR120' 'DCR121' ...
    'DCR122' 'DCR123' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR204' 'DCR206' 'DCR207' ... 
    'DCR208' 'DCR209' 'DCR210' 'DCR211' 'DCR212' 'DCR213' 'DCR214' 'DCR215' 'DCR217' ... 
    'DCR218' 'DCR219' 'DCR220' 'DCR221' 'DCR222' 'DCR223' 'DCR224' 'DCR225'});

SHAM = [SHAM(1:13) SHAM(15:23)];
ACTIVE = [ACTIVE(1:13) ACTIVE(15:23)];
%                     
CHANNELS = 1:64;

CONDITIONS = [{'dirleft'},{'dirright'},{'nondirleft'},{'nondirright'}];

CWD = 'F:\fieldtrip\';
load([CWD 'TOPO_GRAPH\ALL_POWER_ACTIVE'])
load([CWD 'TOPO_GRAPH\ALL_POWER_SHAM'])
DATA_DIR = 'TOPO_GRAPH\';
SAVE_DIR = 'TOPO_GRAPH\';
%Setup time windows
%        -200:100:1100 ms
%times = -400:0.5:2200;
times  = 1200:0.5:4000;% = 200to400ms post cue 

%start_intervals = 800:200:(2200-200);
%end_intervals = start_intervals+200;
start_intervals = 1200:200:(5000-200);
end_intervals = start_intervals+200;

srate = 512;
bins = 80;
frex=logspace(log10(2),log10(50),bins);     % Hz

start_freq  = [1,19,35,41,48];
end_freq    = [18,31,40,47,68];
freqname = [{'Delta'},{'Theta'},{'Lower Alpha'},{'Upper Alpha'},{'Beta'}];
timename = [{'1200-1400ms'},{'1700-1900ms'}];
% timename = [{'0200-400ms'},{'0300-500ms'},{'0400-600ms'},{'0500-700ms'},{'0600-800ms'},{'0700-900ms'},{'0800-1000ms'},{'0900-1100ms'},{'1000-1200ms'},{'1100-1300ms'},{'1200-1400ms'},{'1300-1500ms'},{'1400-1600ms'},{'1500-1700ms'},{'1600-1800ms'},{'1700-1900ms'},{'1800-2000ms'},{'1900-2100ms'},{'2000-2200ms'},{'2100-2300ms'},{'2200-2400ms'},{'2300-2500ms'},{'2400-2600ms'},{'2500-2700ms'}];


%% Run t-tests for SHAM
sham_pvals = ones(length(timename),length(CONDITIONS),length(freqname),size(ALL_POWER_SHAM,5));
sham_tvals = ones(length(timename),length(CONDITIONS),length(freqname),size(ALL_POWER_SHAM,5));
count=0;
for time_i = [12 17]%1:length(start_intervals)%[1,4]
    count = count+1;
    for cond_i = 1:length(CONDITIONS)
        for channel = 1:size(ALL_POWER_SHAM,5)
            for freq_i = 1:length(freqname)
                [~,sham_pvals(count,cond_i,freq_i,channel),~,STATS] = ttest(ALL_POWER_SHAM(:,cond_i,freq_i,time_i,channel),(ALL_POWER_SHAM(:,cond_i,freq_i,1,channel)));%(mean(mean(ALL_POWER_SHAM(:,cond_i,freq_i,time_i,:)))));
            sham_tvals(count,cond_i,freq_i,channel) = STATS.tstat;
            end
        end
    end
end
%% Run t-tests for ACTIVE
active_pvals = ones(length(timename),length(CONDITIONS),length(freqname),size(ALL_POWER_SHAM,5));
active_tvals = ones(length(timename),length(CONDITIONS),length(freqname),size(ALL_POWER_SHAM,5));
count=0;
% h = waitbar(0,'Computing t-tests');
for time_i = [12,17]
%     waitbar(time_i/length(timename),h);
    count = count+1;
    for cond_i = 1:length(CONDITIONS)
        for channel = 1:size(ALL_POWER_ACTIVE,5)
            for freq_i = 1:length(freqname)
                [~,active_pvals(count,cond_i,freq_i,channel),~,STATS] = ttest(ALL_POWER_ACTIVE(:,cond_i,freq_i,time_i,channel),(ALL_POWER_ACTIVE(:,cond_i,freq_i,1,channel)));%(mean(mean(ALL_POWER_ACTIVE(:,cond_i,freq_i,time_i,:)))));
            active_tvals(count,cond_i,freq_i,channel) = STATS.tstat;
            end
        end
    end
end

%% need maketopoplotsforTDCS here
%SHAM
load([CWD,SAVE_DIR,'ALL_POWER_SHAM.mat']);
locname = [CWD,'TOPO_GRAPH\10-2064chan.locs'];
% for sham_i = 1:length(SHAM)
    for cond_i = 1:length(CONDITIONS)
        for freq_i = 1:length(start_freq)
            for time_i = 1:length(start_intervals)
                a = squeeze(sham_pvals(cond_i,freq_i,time_i,:));
                topoplot(a,locname,'maplimits',[-1,1]);
                colorbar();
                s_name = strcat('SHAME_',CONDITIONS{cond_i},' ', freqname{freq_i}, ' ', timename{time_i});
                title(s_name{1,1});
                saveas(gcf,[s_name{1,1},'.jpg']);
                close all;
            end
        end%freq_i loop
    end%cond_i loop
% end%sham_i loop

%ACTIVE
load([CWD,SAVE_DIR,'ALL_POWER_ACTIVE.mat']);
locname = [CWD,SAVE_DIR,'\10-2064chan.locs'];
% for sham_i = 1:length(SHAM)
    for cond_i = 1:length(CONDITIONS)
        for freq_i = 1:length(start_freq)
            for time_i = 1:length(start_intervals)
                a = squeeze(active_pvals(cond_i,freq_i,time_i,:));
                topoplot(a,locname,'maplimits',[-1,1]);
                colorbar();
                s_name = strcat('ACTIVE',CONDITIONS{cond_i},' ', freqname{freq_i}, ' ', timename{time_i});
                title(s_name{1,1});
                saveas(gcf,[s_name{1,1},'.jpg']);
                close all;
            end
        end%freq_i loop
    end%cond_i loop
% end%sham_i loop

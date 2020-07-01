% Load File:
%   - Files are in Wavelet_output\Participant\condition\channel.m
%   - For each Condition, we need to colaspse (find average) of all participants/channel
%   - We should end up with 4 matricies (1 for each condition).
%   - 

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
cd(CWD)
DATA_DIR = 'WAVELET_OUTPUT\';
SAVE_DIR = 'TOPO_GRAPH\';

%Setup time windows
%        -200:100:1100 ms
%times = -400:0.5:2200;
times  = 800:0.5:4000;% = 200ms pre cue 

%start_intervals = 800:200:(2200-200);
%end_intervals = start_intervals+200;
start_intervals = 800:200:(5000-200);
end_intervals = start_intervals+200;

srate = 512;
bins = 80;
frex=logspace(log10(2),log10(50),bins);     % Hz

start_freq  = [1,19,35,41,48];
end_freq    = [18,31,40,47,68];
freqname = [{'Delta'},{'Theta'},{'Lower Alpha'},{'Upper Alpha'},{'Beta'}];
timename = [{{'-0200-0ms'},{'0200-400ms'},{'0300-500ms'},{'0400-600ms'},{'0500-700ms'},{'0600-800ms'},{'0700-900ms'},{'0800-1000ms'},{'0900-1100ms'},{'1000-1200ms'},{'1100-1300ms'},{'1200-1400ms'},{'1300-1500ms'},{'1400-1600ms'},{'1500-1700ms'},{'1600-1800ms'},{'1700-1900ms'},{'1800-2000ms'},{'1900-2100ms'},{'2000-2200ms'},{'2100-2300ms'},{'2200-2400ms'},{'2300-2500ms'},{'2400-2600ms'},{'2500-2700ms'}}];

    

%% BEGIN: 
% Sum all data points
% divide by number of datapoints
%Load File:
% FOR SHAM
POWER_SHAM = zeros(length(CONDITIONS),length(start_freq),length(start_intervals),length(CHANNELS));
ALL_POWER_SHAM = zeros(length(SHAM),length(CONDITIONS),length(start_freq),length(start_intervals),length(CHANNELS));
for cond_i = 1:length(CONDITIONS);
    tic;
    for chan_i = 1:length(CHANNELS)

        for name_i = 1:length(SHAM);
        temp_dir = [CWD,DATA_DIR,SHAM{name_i},'\',CONDITIONS{cond_i},'\'];
        filename = [SHAM{name_i},'_',CONDITIONS{cond_i},'_',num2str(CHANNELS(chan_i)),'_imagcoh_mwtf.mat'];
        temp_mwtf = load([temp_dir,filename],'mw_tf');
        sum_data = temp_mwtf.mw_tf;
%         for sham_i = 1:length(SHAM)
            temp_dir = strcat(CWD,DATA_DIR,SHAM(name_i),'\',CONDITIONS{cond_i},'\');
            filename = strcat(SHAM(name_i),'_',CONDITIONS{cond_i},'_',num2str(chan_i),'_imagcoh_mwtf.mat');
            fprintf('%s\n',filename{1,1});
            temp_mwtf = load([temp_dir{1,1},filename{1,1}],'mw_tf');
            sum_data = sum_data + temp_mwtf.mw_tf;
%         end
        average_data_SHAM = sum_data./length(SHAM);

        %segment the intervals:
        for time_i = 1:length(start_intervals)
            for freq_i = 1:length(start_freq)
                POWER_SHAM(cond_i,freq_i,time_i,chan_i) = mean(mean(average_data_SHAM(start_freq(freq_i):end_freq(freq_i),start_intervals(time_i):end_intervals(time_i))));
                ALL_POWER_SHAM(name_i,cond_i,freq_i,time_i,chan_i) = mean(mean(average_data_SHAM(start_freq(freq_i):end_freq(freq_i),start_intervals(time_i):end_intervals(time_i))));
            end
        end
        end
    end
    toc
end
save([CWD,SAVE_DIR,'ALL_POWER_SHAM.mat'],'ALL_POWER_SHAM')
save([CWD,SAVE_DIR,'POWER_SHAM.mat'],'POWER_SHAM')


%% for ACTIVE
POWER_ACTIVE = zeros(length(CONDITIONS),length(start_freq),length(start_intervals),length(CHANNELS));
ALL_POWER_ACTIVE = zeros(length(ACTIVE),length(CONDITIONS),length(start_freq),length(start_intervals),length(CHANNELS));
for cond_i = 1:length(CONDITIONS);
    tic;
    for chan_i = 1:length(CHANNELS)

        for name_i = 1:length(ACTIVE);
        temp_dir = [CWD,DATA_DIR,ACTIVE{name_i},'\',CONDITIONS{cond_i},'\'];
        filename = [ACTIVE{name_i},'_',CONDITIONS{cond_i},'_',num2str(CHANNELS(chan_i)),'_imagcoh_mwtf.mat'];
        temp_mwtf = load([temp_dir,filename],'mw_tf');
        sum_data = temp_mwtf.mw_tf;
%         for sham_i = 1:length(SHAM)
            temp_dir = strcat(CWD,DATA_DIR,ACTIVE(name_i),'\',CONDITIONS{cond_i},'\');
            filename = strcat(ACTIVE(name_i),'_',CONDITIONS{cond_i},'_',num2str(chan_i),'_imagcoh_mwtf.mat');
            fprintf('%s\n',filename{1,1});
            temp_mwtf = load([temp_dir{1,1},filename{1,1}],'mw_tf');
            sum_data = sum_data + temp_mwtf.mw_tf;
%         end
        average_data_ACTIVE = sum_data./length(ACTIVE);

        %segment the intervals:
        for time_i = 1:length(start_intervals)
            for freq_i = 1:length(start_freq)
                POWER_ACTIVE(cond_i,freq_i,time_i,chan_i) = mean(mean(average_data_ACTIVE(start_freq(freq_i):end_freq(freq_i),start_intervals(time_i):end_intervals(time_i))));
                ALL_POWER_ACTIVE(name_i,cond_i,freq_i,time_i,chan_i) = mean(mean(average_data_ACTIVE(start_freq(freq_i):end_freq(freq_i),start_intervals(time_i):end_intervals(time_i))));
            end
        end
        end
    end
    toc
end
save([CWD,SAVE_DIR,'ALL_POWER_ACTIVE.mat'],'ALL_POWER_ACTIVE')
save([CWD,SAVE_DIR,'POWER_ACTIVE.mat'],'POWER_ACTIVE')
%% Draw Graphs:
%SHAM
load([CWD,SAVE_DIR,'POWER_SHAM.mat']);
locname = [CWD,SAVE_DIR,'\10-2064chan.locs'];
% for sham_i = 1:length(SHAM)
    for cond_i = 1:length(CONDITIONS)
        for freq_i = 1:length(start_freq)
            for time_i = 1:length(start_intervals)
                a = squeeze(POWER_SHAM(cond_i,freq_i,time_i,:));
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
load([CWD,SAVE_DIR,'POWER_ACTIVE.mat']);
locname = [CWD,SAVE_DIR,'\10-2064chan.locs'];
% for sham_i = 1:length(SHAM)
    for cond_i = 1:length(CONDITIONS)
        for freq_i = 1:length(start_freq)
            for time_i = 1:length(start_intervals)
                a = squeeze(POWER_ACTIVE(cond_i,freq_i,time_i,:));
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

%% Draw Contrast Graphs:


for cond_i = 1:length(CONDITIONS)-1
    for freq_i = 1:length(start_freq)
        for time_i = 1:length(start_intervals)
        
            a = squeeze(POWER(cond_i,freq_i,time_i,:));
            b = squeeze(POWER(4,freq_i,time_i,:));
            data = a-b;
            topoplot(data,locname,'maplimits',[-1,1]);
            colorbar();
            s_name = [CONDITIONS{cond_i},' vs Mixed-Repeat ', freqname{freq_i}, ' ', timename{time_i}];
            title(s_name);
            saveas(gcf,[s_name,'.jpg']);
            close all;
        end
    end
end






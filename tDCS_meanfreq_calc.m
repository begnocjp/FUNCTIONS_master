%% Script to Calculate mean frequency of collected wavelet data

% Clear all precvious work and close all windows
clear all;
close all;


% disable all warnings
warning('off','all')


%% Path Setup
% CWD = Current working Directory:
% homedir = Home Directory of top level directory.
% Filename = Name of file

CWD = 'E:\fieldtrip\';
DATA_DIR = 'EEGLAB_FORMAT\';
% WAVELET_OUTPUT_DIR = 'WAVELET_OUTPUT\';

load ('E:\fieldtrip\FUNCTIONS\LIST_ACTIVE_SHAM');

CHANNELS = 1:64;

names = struct('pnum',{ 'DCR102' 'DCR103' 'DCR104' 'DCR106' 'DCR107' 'DCR108' 'DCR109' 'DCR110' 'DCR111' ... 
    'DCR112' 'DCR113' 'DCR114' 'DCR115' 'DCR117' 'DCR118' 'DCR119' 'DCR120' 'DCR121' ...
    'DCR122' 'DCR123' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR204' 'DCR206' 'DCR207' ... 
    'DCR208' 'DCR209' 'DCR210' 'DCR211' 'DCR212' 'DCR213' 'DCR214' 'DCR215' 'DCR217' ... 
    'DCR218' 'DCR219' 'DCR220' 'DCR221' 'DCR222' 'DCR223' 'DCR224' 'DCR225'});
%     'S1' 'S1B' ... 
%     'S4' 'S4B' 'S5' 'S5B' 'S6' 'S6B' 'S7' 'S7B' 'S8' 'S8B' 'S10' 'S10B' 'S11' 'S11B' 'S12' 'S12B' 'S13' 'S13-1' 'S13B' ...
%     'S14' 'S14B' 'S15' 'S15B' 'S16' 'S16B' 'S17' 'S17B' 'S18' 'S18B' 'S20' 'S20B' 'S21' 'S21B' ...
%     'S22' 'S22B' 'S23' 'S23B' 'S24' 'S24B' 'S25' 'S25B' 'S26' 'S26B' 'S27' 'S27B' 'S28' 'S28B' 'S29' 'S29B' ...
%     'S30' 'S30B' 'S31' 'S31B' 'S34' 'S34B' 'S36' 'S36B' 'S37' 'S37B' 'S38' 'S38B' ...
%     'S39' 'S39B' 'S40' 'S40B'}); %artefact rejection list

conditions = {'dirleft' 'dirright' 'nondirleft' 'nondirright'};
channels = 1:64;
 SHAM = [SHAM(1:13) SHAM(15:23)];
 ACTIVE = [ACTIVE(1:13) ACTIVE(15:23)];

CWD = 'E:\fieldtrip\WAVELET_OUTPUT\';
addpath('E:\fieldtrip\FUNCTIONS');

%%
%load in each subjects power data
%for each condition, for each channel
%get the mean of mw_tf dimension 1 e.g. mean(mw_tf,1);
%save this mean value into a matrix and move on to

%% Average SHAM
times = 6801;
SHAM_AP = zeros(length(names),length(conditions),length(channels),times); %22*4*64*6801

for name_i = 1:length(SHAM) 
    fprintf('.');
    for cond_i = 1:length(conditions)
    for chan_i = 1:length(channels)
        load([CWD names(name_i).pnum '\' conditions{cond_i} '\' names(name_i).pnum '_' conditions{cond_i} '_' num2str(channels(chan_i)) '_imagcoh_mwtf.mat'])
        SHAM_AP(name_i,cond_i,chan_i,:) = mean(mw_tf,1);
    end    
    end    
end
save([CWD 'SHAM_mean_freq.mat'],'SHAM_AP');
            
%% Average ACTIVE
times = 6801;
ACT_AP = zeros(length(names),length(conditions),length(channels),times); %22*4*64*6801

for name_i = 1:length(ACTIVE) 
    fprintf('.');
    for cond_i = 1:length(conditions)
    for chan_i = 1:length(channels)
        load([CWD names(name_i).pnum '\' conditions{cond_i} '\' names(name_i).pnum '_' conditions{cond_i} '_' num2str(channels(chan_i)) '_imagcoh_mwtf.mat'])
        ACT_AP(name_i,cond_i,chan_i,:) = mean(mw_tf,1);
    end    
    end    
end    

save([CWD 'ACTVE_mean_freq.mat'],'ACT_AP');     



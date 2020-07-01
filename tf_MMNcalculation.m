%% Time-Freq MMN Calculation

clear all;close all;clc;
CWD = 'E:\fieldtrip\'; 
cd('E:\fieldtrip\');
datain = 'E:\fieldtrip\WAVELET_OUTPUT\';
dataout = 'E:\fieldtrip\WAVELET_OUTPUT\';
frex=logspace(log10(2),log10(100),160);
freqs = {1:29;30:57;58:80;81:111;112:130;134:151};%delta theta alpha beta lo_gamma hi_gamma
freq_labels ={'DELTA','THETA','ALPHA','BETA','LO_GAMMA','HI_GAMMA'};
times = -500:0.5:900;
channels = 64;
labels = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5',...
    'T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
    'POz','Pz','CPz','Fpz','Fp2','AF8','AF4','AFz','Fz','F2','F4','F6','F8','FT8','FC6',...
    'FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6',...
    'P8','P10','PO8','PO4','O2'}';

names = {'AH1958','AH1977','AO1954','AS1972','BM1967','DS1963_MMN','JI1972','JK1961','KB1967','KF1959','MY1969','SS1963','ZN1977',...
    'BH1975','DG1965','DJ1963','RT1986','SD1951'};
conditions = {'standard','duration_deviant','frequency_deviant','intensity_deviant',}; %'std_aftDev'

%% Load in and subtract Std from Deviants

deviant = {'a','durMMN','freqMMN','intMMN'};

for name_i =  1:length(names)
     fprintf('\n%s\t%s','Working on subject:',names{name_i});
    for cond_i = 2:length(conditions)
%        for dev_i = 1:length(deviant)
%            mkdir([datain names{name_i} filesep deviant{dev_i}]);
            for elec_i = 1:64
                fprintf('.');
                std = load([datain names{name_i} filesep conditions{1} filesep names{name_i} '_' conditions{1} '_' num2str(elec_i) '_imagcoh_mwtf.mat'],'mw_tf');
                dev = load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(elec_i) '_imagcoh_mwtf.mat'],'mw_tf');
                
                mw_tf = dev.mw_tf - std.mw_tf;
                save([datain names{name_i} filesep deviant{cond_i} filesep names{name_i} '_' deviant{cond_i} '_' num2str(elec_i) '_imagcoh_mwtf.mat'],'mw_tf');
            end
%        end
    end
end

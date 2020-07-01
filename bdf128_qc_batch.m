%% BioSemi 128-channel QC batch script
%  Modified by Alexander Conley - December 2019
%% Set-up working parameters
close all
clear all
warning off;
wpms       = [];%working parameters
wpms.dirs  = struct('CWD','E:\fieldtrip\','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS\','RAW','RAW\','preproc','PREPROC_OUTPUT\', ...
    'DATA_DIR','EEGLAB_FORMAT\','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR\', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT\','EEGDispOutput','EEGDISPLAY_OUTPUT\');
wpms.names = {'AERP_QCTest_Mike_101'}; %	'SERP_QCTest_Mike_201'
    

% add path
cd([wpms.dirs.CWD]);
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
%% Import Data

name_i = 1;
[dat] = bdf128_qc_importeeg(wpms,'bdf',name_i);

% Extract Microphone Signal

%% Modified Trial def
% Import microphone signal and run peak analysis on microphone signal
% following each trigger
% 

trialfunction = 'tourette_aud'; % ' tourette_tact
trdat = fnl_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial);
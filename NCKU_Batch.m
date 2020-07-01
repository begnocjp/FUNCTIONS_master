%% University of Newcastle Processing Pipeline - adapted for use at NCKU, Tainan
%  Wrtten by Patrick Cooper and Aaron Wong
%  Modified by Alexander Conley, January 2016
%% Set-up working parameters
close all
clear all
warning off;
wpms       = [];%working parameters
wpms.dirs  = struct('CWD',          'F:\FNL\NCKU_PROCESSING_PIPELINE\',...
                    'packages',     'PACKAGES\', ...
                    'FUNCTIONS',    'FUNCTIONS\',...
                    'RAW',          'RAW\',...
                    'preproc',      'PREPROC_OUTPUT\', ...
                    'DATA_DIR',     'EEGLAB_FORMAT\',...
                    'WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR\',...
                    'COHERENCE_DIR',    'COHERENCE_OUTPUT_DIR\',...
                    'CONNECTIVITY_DIR',  'ANALYSES\CONNECTIVITY_MATRICES\');

wpms.names = {  'O01' };%...



% add path
cd([wpms.dirs.CWD]);
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));

%% Preprocessing I
%  Import, downsample and re-reference
for name_i = 1:length(wpms.names)
    sampling_frequency = 512; %hz
    [dat] = fnl_importeeg(wpms,'cnt',name_i);
    %[refdat] = fnl_rereference(dat,[18,24]);
    % Probably do not have to downsample as the data is recorded at 500Hz
    [dat] = fnl_downsample(dat,sampling_frequency);
    
    [data] = fnl_preproc_filter(dat,'yes',[48 52],'yes',0.1,'onepass',1,'but');
    clear dat
    %mkdir([wpms.dirs.CWD wpms.dirs.preproc]);
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
    clear refdat data cfg %tidying
end

%% Visual Inspection of Data:
for name_i = 1:length(wpms.names)   
    fnl_bad_channel_inspection(wpms,name_i);
end

%% Remove Bad Channels out from Data:
for name_i = 1:length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
end

%% Trial Definition and ICA
%baseline = 0.2;
for name_i = 1:length(wpms.names)   
    pre_trial = 0.5;                    %BASELINE
    post_trial = 1.5;                   %Epoch time after stim onset.
    trialfunction = 'NCKU_tswt'; 
    eventvalues   = []; %Will let the internal code work it our for itself
    eventtypes    = ''; %Will let the internal code work it our for itself
    trdat = fnl_trial_definition(wpms,'cnt',name_i,trialfunction,pre_trial,post_trial,eventvalues,eventtypes);
    clear post_trial pre_trial trialfunction
    fnl_ICA(wpms,name_i,trdat);        
end
%% Remove EOG Components from ICA
for name_i = 1:length(wpms.names)
    fnl_ICA_inspection(wpms,name_i);
end
%% Apply artifact rejection
for name_i = 1:length(wpms.names)
    fnl_artifact_rejection_auto(wpms,name_i,true,30,-100,100)%Olivia try this with -120 and 120 as the last values instead -Patrick
end
%% Reinterpolate bad channels
for name_i = 1:length(wpms.names)
    fnl_reinterpolate_v2(wpms,name_i);
end
%% Apply scalp current density montage
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\CSDtoolbox']));
for name_i = 1:length(wpms.names)
    fnl_csd_transformation_v2(wpms,name_i);
end
%% CONVERT FROM FIELDTRIP TO EEG STRUCT
%SaveOffIndividualConditions;
%SaveOffIndividualConditions_altbiosemicodes;

%These are all the conditions that are present in the code:
conditions = wpms.conditions;%{  'combined_06','combined_24','combined_30','combined_36','combined_80'};
%shorthand for naming files and data structure:
cond = wpms.conditions;%{'comb06','comb24','comb30','comb36','comb80'};
%These are all possible codes for a condition that we would like to group
%together:

GA = 1:10;
GN = 11:20;
RA = 21:30;
RN = 31:40;

STIM_TYPE = [GA;GN;RA;RN];

CON = 1;
CON_SEM_INCON_THREAT = 2;
INCON_SEM_CON_THREAT = 3;
INCON_SEM_INCON_THREAT = 4;
COND_TYPES = [CON;CON_SEM_INCON_THREAT;INCON_SEM_CON_THREAT;INCON_SEM_INCON_THREAT];

COND_NAMES      = {  'GA_Cong','GA_IncongTHR','GA_IncongSEM','GA_IncongBOTH',...
                     'GN_Cong','GN_IncongTHR','GN_IncongSEM','GN_IncongBOTH',...
                     'RA_Cong','RA_IncongTHR','RA_IncongSEM','RA_IncongBOTH',...
                     'RN_Cong','RN_IncongTHR','RN_IncongSEM','RN_IncongBOTH'};
count = 1;
ACCEPT_TRIGGEER_CODES = [];
for i = 1:size(STIM_TYPE,1);
    for j = 1:size(COND_TYPES,1);
        fprintf('%s :',COND_NAMES{count});
        a = STIM_TYPE(i,:)*5+COND_TYPES(j);
        ACCEPT_TRIGGEER_CODES = [ACCEPT_TRIGGEER_CODES;a];
        fprintf('------\n');
        count = count+1;
    end
end

condition_code_values.GA_Cong = ACCEPT_TRIGGEER_CODES(1,:);
condition_code_values.GA_IncongTHR = ACCEPT_TRIGGEER_CODES(2,:);
condition_code_values.GA_IncongSEM = ACCEPT_TRIGGEER_CODES(3,:);
condition_code_values.GA_IncongBOTH = ACCEPT_TRIGGEER_CODES(4,:);

condition_code_values.GN_Cong = ACCEPT_TRIGGEER_CODES(5,:);
condition_code_values.GN_IncongTHR = ACCEPT_TRIGGEER_CODES(6,:);
condition_code_values.GN_IncongSEM = ACCEPT_TRIGGEER_CODES(7,:);
condition_code_values.GN_IncongBOTH = ACCEPT_TRIGGEER_CODES(8,:);

condition_code_values.RA_Cong = ACCEPT_TRIGGEER_CODES(9,:);
condition_code_values.RA_IncongTHR = ACCEPT_TRIGGEER_CODES(10,:);
condition_code_values.RA_IncongSEM = ACCEPT_TRIGGEER_CODES(11,:);
condition_code_values.RA_IncongBOTH = ACCEPT_TRIGGEER_CODES(12,:);

condition_code_values.RN_Cong = ACCEPT_TRIGGEER_CODES(13,:);
condition_code_values.RN_IncongTHR = ACCEPT_TRIGGEER_CODES(14,:);
condition_code_values.RN_IncongSEM = ACCEPT_TRIGGEER_CODES(15,:);
condition_code_values.RN_IncongBOTH = ACCEPT_TRIGGEER_CODES(16,:);


for name_i =1:length(wpms.names)
    fnl_saveOffIndividualConditions(wpms,conditions,cond,condition_code_values,name_i);
    fnl_setup_eegstructure(wpms,conditions,cond,name_i);
end
%% Begin FFT
% add eeglab to path
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\eeglab']));

%These are all the conditions that are present in the code:
conditions = wpms.conditions;%{  'combined_06','combined_24','combined_30','combined_36','combined_80'};
%shorthand for naming files and data structure:
%cond = wpms.cond;%{'comb06','comb24','comb30','comb36','comb80'};

times = -400:0.5:1400;
windowsize = 20;
bins = 200;
freqrange = [2 30];
channels = 1:64;
%conditions = [{'switchto'},{'switchaway'},{'noninf'},{'mixrepeat'}];
for name_i = 1:length(wpms.names)
    fnl_wavelet_analysis(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %this is falling over at multiple stages:
    %1. doesn't like a structure called EEG within first parfor loop
    %2. doesn't like reshape (line 84) as number of elements changes
    % I removed parfor loops to try and fix it - thought it might be a
    % problem with how variable names were passed into the loop but reshape
    % error persits...
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%% DRAW Power HEAD PLOTS:

for name_i = 1:length(wpms.names)
    fprintf('Processing: %s\n',wpms.names{name_i});
    fnl_DrawTopoplots(wpms,name_i);
end

%% DRAW AVERAGE TOPOPLOTS:

fnl_AvgDrawTopoplots(wpms);


%% Imaginary Coherence:
%These are all the conditions that are present in the code:
conditions = wpms.conditions;%{  'combined_06','combined_24','combined_30','combined_36','combined_80'};
%shorthand for naming files and data structure:
%cond = wpms.cond;%{'comb06','comb24','comb30','comb36','comb80'};
channels = 1:30;
mkdir([wpms.dirs.CWD wpms.dirs.COHERENCE_DIR]);
for name_i = 5:length(wpms.names) 
    fnl_imaginarycoherence_analysis(wpms,channels,conditions,name_i);
end

% Generate Conectivity Matrix:

conditions = wpms.conditions;
%conditions = {  'combined_06','combined_24','combined_30','combined_36','combined_80'};
%shorthand for naming files and data structure:
%cond = {'comb06','comb24','comb30','comb36','comb80'};
channels = 1:30;
starttimes = [0:50:1000];
endtime = 50;
freq_names = wpms.frequencies;
freq = {[140:175] , [176:200]};
channelcount = max(channels);
for name_i = 1:length(wpms.names)
    fnl_genconnmatrix(wpms,channelcount,conditions,starttimes,endtime,freq_names,freq,name_i);
end;
%% Compute Significant Group Connectivity : Cannabis - Control 

fnl_CalculateSignificantConnectivity(wpms);

fnl_connectivity_montage_plot(wpms,'fnl_neuroscan30_ELENA.loc');


%% PRODUCE TIMELOCK ERP - Not for Coherency analysis

for name_i = 1:length(wpms.names)
    
    %baseline is from -200 to 0 (cue)
    % We know that Data starts is 1 second before Cue. (512)
    sampling_frequency = 1000;
    baseline_start = floor(sampling_frequency*0)+1;
    baseline_end = floor(sampling_frequency*0.2)+1;
 
    condition_name = 'combined_06';
    timelock_comb06 = fnl_timelockanalysis(wpms,name_i,condition_name,baseline_start,baseline_end);
 
    condition_name = 'combined_24';
    timelock_comb24 = fnl_timelockanalysis(wpms,name_i,condition_name,baseline_start,baseline_end);
 
    condition_name = 'combined_30';
    timelock_comb30 = fnl_timelockanalysis(wpms,name_i,condition_name,baseline_start,baseline_end);
 
    condition_name = 'combined_36';
    timelock_comb36 = fnl_timelockanalysis(wpms,name_i,condition_name,baseline_start,baseline_end);
 
    condition_name = 'combined_80';
    timelock_comb80 = fnl_timelockanalysis(wpms,name_i,condition_name,baseline_start,baseline_end);
    
    
    
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK.mat'],'timelock*','-v7.3');
end

%% Draw TIMELOCK ERP:
close all;
for name_i = 1:length(wpms.names)
    isreverse_ydir = true; %true or false
    for channel = 1:30;
    fnl_plotERP(wpms,name_i,channel,isreverse_ydir);
    end
end




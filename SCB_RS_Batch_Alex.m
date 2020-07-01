%% Subconcussive Blows RS
Processing Pipeline
%  Uses a 10 minute Resting State EEG Paradigm
%  Task has two 5min blocks, one eyes open, one eyes closed 
%  Which are counterbalanced across subjects
%  Adapted by Aaron Wong, Alexander Conley
%  January - 2016, Functional Neuroimaging Laboratory
%% Set-up working parameters
close all;
clear all;
clc;
warning off;

cd('F:\fieldtrip');

% GENERAL DIRECTORY SETUP OF ANALYSIS:
wpms       = [];
wpms.dirs  = struct('CWD',                  [pwd,'\'],...
                    'packages',             'PACKAGES\', ...
                    'FUNCTIONS',            'FUNCTIONS\',...
                    'RAW',                  'RAW\',...
                    'preproc',              'PREPROC_OUTPUT\', ...
                    'DATA_DIR',             'EEGLAB_FORMAT\', ...
                    'WAVELET_OUTPUT',       'WAVELET_OUTPUT\',...
                    'EEGDispOutput',        'EEGDISPLAY_OUTPUT\');

%FILENAMES FOR EACH PARTICIPANT:
wpms.names = {'SBA101_RS'};      % testing dataset

%   wpms.names =     {'SBA101_RS','SBA102_RS','SBA103_RS','SBA104_RS','SBA105_RS','SBA106_RS' , ...
%                     'SBA107_RS','SBA108_RS','SBA109_RS','SBA110_RS','SBA111_RS','SBA112_RS', ...
%                     'SBA113_RS','SBA114_RS','SBA115_RS','SBA116_RS','SBA118_RS','SBA119_RS', ...
%                     'SBA120_RS','SBA121_RS','SBA122_RS','SBA123_RS','SBA124_RS','SBA125_RS','SBA126_RS', ...
%                     'SBA127_RS','SBA128_RS','SBA129_RS','SBA130_RS','SBA131_RS','SBA132_RS','SBA133_RS'};


% Group 1: Open/Closed
GRP1 = {'SBA101_RS','SBA102_RS','SBA103_RS','SBA104_RS','SBA109_RS','SBA111_RS',...
    'SBA112_RS','SBA116_RS','SBA116_RS','SBA117_RS','SBA118_RS','SBA120_RS','SBA121_RS',...
    'SBA123_RS','SBA125_RS','SBA126_RS','SBA127_RS','SBA128_RS','SBA130_RS','SBA131_RS','SBA133_RS'};

% Group 2: Closed/Open
GRP2 = {'SBA105_RS','SBA106_RS','SBA107_RS','SBA108_RS','SBA110_RS','SBA113_RS',...
    'SBA114_RS','SBA119_RS','SBA122_RS','SBA124_RS','SBA129_RS','SBA132_RS'};



% add path
cd([wpms.dirs.CWD]);
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
%addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages 'eeglab13_4_4b']));



%% Preprocessing I
%       Import, downsample and re-reference
%       Downsample to 512 hz
%       Set to AvMastoid Reference.
%       Filter Bandstop 48-52Hz for Line Noise
%       Filter High pass 0.1Hz, one pass, order 4 butterworth filter.
% 
%       Juanita said that it would be fine to use the mastoid rereference
%       to do the processing from the start, which will mean that the
%       rereferencing later will be obsolete, but this will mean the couple
%       of participants which have not worked might be able to be
%       processed. Taking a look at this the noise in the mastoids seems to
%       be too large.
for name_i = 1:length(wpms.names)
    sampling_frequency = 512; %hz
    [dat] = fnl_importeeg_and_downsample(wpms,'bdf',name_i,sampling_frequency);
    [refdat] = fnl_rereference(dat,1:64);
    
    clear dat
    
    [data] = fnl_preproc_filter(refdat,'yes',[48 52],'yes',0.1,'onepass',4,'but');
    % may need to cut the bandstop for larger window
    
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
    clear refdat data cfg %tidying
end

%% Visual Inspection of Data:
% Select the bad channels in data.
% After visual inspection, a prompt will appear, and you can enter a list
% of bad channels, e.g. C1,P3,Cz,CP2 etc.

for name_i = 1:length(wpms.names)
    fnl_bad_channel_inspection(wpms,name_i,100);
end

%% Remove Bad Channels out from Data:
% Automatically remove bad channels for Trial Definition, and ICA
% calculation.

for name_i = 1:length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
    
end


%% Trial Definition 
% Get Trial Epochs, 
%       Block_start = 154 (event_values)
%       (pre-event) -0.1 to (post-event) 300.0 Seconds

for name_i = 1:length(wpms.names)
    pre_trial = 0.1;
    post_trial = 300.0;
    trialfunction = 'REST'; 
    eventvalues   = 254;
    eventtypes    = 'trigger'; 
    trdat = RS_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial);%(wpms,'bdf',name_i,trialfunction,pre_trial,post_trial,eventvalues,eventtypes)
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TRDAT'],'-v7.3')
    clear post_trial pre_trial trialfunction
end


%% RUN ICA
for name_i = 1:length(wpms.names)
    load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TRDAT']);
    wpms.conditions = {'open','closed'};
    if ismember(wpms.names{name_i},GRP1) == 1 % Check to see if that subject is in Group1
        wpms.conditions{'open'} = trdat.trial{1,1};
        wpms.conditions{'closed'} = trdat.trial{1,2};
    elseif  ismember(wpms.names{name_i},GRP2) == 1% Group 2
        wpms.conditions{'open'} = trdat.trial{1,2};
        wpms.conditions{'closed'} = trdat.trial{1,1};
    else
        error('Participant not found in either GRP');
    end
    for cond_i = 1:length(wpms.conditions)
        
        fnl_ICA_RS(wpms,name_i,cond_i); % need to edit
        
    end
    
end


%% Remove EOG Components from ICA
% Load ICA, find the compoent that is an EYEBLINK, and insert component number that
% is the Eyeblink, into prompt, when finnsihed inpsection.
for name_i = 1:length(wpms.names)
    fnl_ICA_inspection(wpms,name_i);
    % put the artifact rejection browser in here to look for bad channels
    % and then add this to the list later or rerun... 
end

% at the end of the ICA inspection there will be a viewer for the data.
% Check this viewer to ascertain whether there are any more channels which
% need to be removed from "%% Visual Inspection of Data:" section.

%% Apply artifact rejection
% Load the EOG Corrected data, then perform a low pass filter of 100Hz, then
% perform automatic artifact correction -/+ 100uV.
% Save Data.

for name_i = 1:length(wpms.names)
    
    fnl_artifact_rejection_auto(wpms,name_i,true,100,-100,100);
end

%% Reinterpolate bad channels
% Bad channels are reinterpolated into the montage here.

for name_i = 1:length(wpms.names)
    fnl_reinterpolate_v2(wpms,name_i);%,'biosemi');
end

%% Apply scalp current density montage
%%%% ONLY FOR TIME-FREQ ANALYSIS, for ERPs just move on to exporting data %%%%

labels = {'FP1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3';...
    'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3';'P5';...
    'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz';'Fpz';'Fp2';...
    'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8';'FC6';'FC4';'FC2';...
    'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6';'CP4';'CP2';'P2';'P4';...
    'P6';'P8';'P10';'PO8';'PO4';'O2'};
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\CSDtoolbox']));
for name_i = 1:length(wpms.names)
    performCSD_transformation(wpms,name_i,labels)
%     fnl_csd_transformation(wpms,name_i,'biosemi');
end


%% Export to EEGDisplay: MAY NOT USE FOR RESTING STATE TASK
% A file for each condition is generated in this section, and is then saved
% off to EEGDisplay format. The exported file can then be loaded into
% EEGDisplay.
% Each Condition per file: (Mat File), (EEGDisplay)
% for name_i =1:length(wpms.names)
%     fnl_saveOffIndividualConditions_UHRMMN(wpms,wpms.conditions,wpms.cond,wpms.condition_code_values,name_i);
% end

%% CONVERT FROM FIELDTRIP TO EEG STRUCT
% SaveOffIndividualConditions;
% SaveOffIndividualConditions_altbiosemicodes;
% This is for TimeFrequency analysis of data only

% These are all the conditions that are present in the code:
wpms.conditions = {'open','closed'};
wpms.cond = {'op','cl'};
%These are all possible codes for a condition that we would like to group
%together:

% wpms.condition_code_values.blk = 154;  % block_start 
% ***** Do not know if this is needed as there are no triggers during the task

for name_i =1:length(wpms.names)
    fnl_saveOffIndividualConditions(wpms,conditions,cond,condition_code_values,name_i);
    fnl_setup_eegstructure(wpms,conditions,cond,name_i);
end

%% Begin FFT
% Using one wide FFT, to capture data around bandstop
% add eeglab to path
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\eeglab']));
times = -100:0.5:300000; % May need to widen this significantly
windowsize = 20;
bins = 160; % bins of 0.6125 Hz instead of 0.6 Hz
freqrange = [2 100]; 

channels = 1:64;
conditions = {'open','closed'};
for name_i = 1:length(wpms.names)
    fnl_wavelet_analysis_REST(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i); % need to edit
end


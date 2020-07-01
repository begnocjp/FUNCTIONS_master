%% Ultra-High Risk MMN Processing Pipeline
%  Adapted by Aaron Wong, Alexander Conley
%  October/November - 2015, Functional Neuroimaging Laboratory
%% Set-up working parameters
close all;
clear all;
clc;
warning off;

cd('E:\fieldtrip\');

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
%  wpms.names = {'AO1954'};      % testing dataset
% 
   wpms.names =     {'AH1958','AH1977','AO1954','AS1972','BH1975','BM1967', ...
                     'DD1985','DG1965','DJ1963','DS1963_MMN', ... %'IW1964' Removed for TF
                     'JI1972','JK1961','KB1967','KF1959','MY1969', ... % issue with MB1982 when trying to convert to EEGLAB format
                     'RT1986','SD1951','SS1963','ZN1977'}; 
%     wpms.names = {'MY1969', 'TS1970'};     % Large files
%     wpms.names = {'AH1958','AH1958_MMN3','DS1963_MMN','DS1963_MMN2'};     %Split Files, combined after trial definition and before ICA
%     
%     wpms.splitnamespairs = {{{'AH1958'},{'AH1958_MMN3'}};...
%                             {{'DS1963_MMN'},{'DS1963_MMN2'}}}; 
%   wpms.names = {'AH1958','DS1963_MMN'};                        
%     wpms.names = {'DD1985','BH1975','HS1953'}; % Possibly Unsuitable
    
    
%   DATASETS WITH ISSUES IN PREPROCESSING
%   'TS1970','HS1953'
%   VERY NOISY DATASET - SHOULD NOT USE
%   'MB1982'
%   VERY LARGE DATASETS
%   'MY1969', 'DS1963_MMN2'
%   DATASETS THAT NEED TO BE COMBINED
%   'AH1958','AH1958_MMN3','DS1963_MMN','DS1963_MMN2'

%   REARRANGED EXTERNAL FOR MRS STUDY
%   Ex1/2: Left/Right Mastoid, Ex3 Nose Ref, Ex4/5: Left Supra/Infra
%   Orbital, Ex6/7: Left/Right Lateral

%   EXCEPT for DD1985
%   Ex1/2: Mastoids, Ex3/4: Laterals, Ex5/6: Left Supra/Infra, Ex7 Nose

%EXPERIMENTAL CONDITTIONS:
wpms.conditions = {'standard','duration_deviant','frequency_deviant','intensity_deviant','duration_std',...
    'frequency_std','intensity_std','std_aftDev','preStd','init_Idev','init_Fdev','init_Ddev'...
     'MMN_Ddev','MMN_Fdev','MMN_Idev'};
wpms.cond = {'std','Ddev','Fdev','Idev','Dstd','Fstd','Istd','sad','pstd','Iint','Fint','Dint'...
     'MMN_Ddev','MMN_Fdev','MMN_Idev'};

wpms.condition_code_values.std = 1;      % Standard
wpms.condition_code_values.Ddev = 2;     % Duration Deviant
wpms.condition_code_values.Fdev = 3;     % Frequency Deviant
wpms.condition_code_values.Idev = 4;     % Intensity Deviant
wpms.condition_code_values.sad = 5;      % Standard After Deviant
wpms.condition_code_values.Istd = 6;     % Intensity Deviant as Standard
wpms.condition_code_values.Fstd = 7;     % Frequency Deviant as Standard
wpms.condition_code_values.Dstd = 8;     % Duration Deviant as Standard
wpms.condition_code_values.pstd = 9;     % Interval Standards before MMN
wpms.condition_code_values.Iint = 106;   % Initial Intensity Deviant as Standard
wpms.condition_code_values.Fint = 107;   % Initial Frequency Deviant as Standard
wpms.condition_code_values.Dint = 108;   % Initial Duration Deviant as Standard

wpms.sampling_frequency = 512; %hz


% add path
cd([wpms.dirs.CWD]);
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
% rmpath(genpath([wpms.dirs.CWD,wpms.dirs.packages 'eeglab13_4_4b']));



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
 for name_i = 1%1:length(wpms.names)
    sampling_frequency = 512; %hz
    [dat] = fnl_importeeg_and_downsample_v2(wpms,'bdf',name_i,sampling_frequency); %v2 used for large files 80+ channels
    [refdat] = fnl_rereference(dat,1:64); %EXG3 = Channel 67 = NOSE REFERENCING, %EXG1,EXG2 = 65,66 Mastoids
    
    clear dat
    
    [data] = fnl_preproc_filter(refdat,'yes',[48 52],'yes',0.1,'onepass',4,'but'); 
    % may need to cut the bandstop for larger window
%     data.label = {'FP1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3';'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3';'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz';'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8';'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6';'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2';'M1';'M2';'LO1';'LO2';'SO1';'SO2';'IO1';'IO2';'GSR1';'GSR2';'Erg1';'Erg2';'Resp';'Plet';'Temp';'Status';};

    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
    clear refdat data cfg %tidying
end

%% Visual Inspection of Data:
% Select the bad channels in data.
% After visual inspection, a prompt will appear, and you can enter a list
% of bad channels, e.g. C1,P3,Cz,CP2 etc.

for name_i = 6%:length(wpms.names)
    fnl_bad_channel_inspection(wpms,name_i,100);
end

%% Remove Bad Channels out from Data:
% Automatically remove bad channels for Trial Definition, and ICA
% calculation.

for name_i = 6%:length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
end

%% Trial Definition and ICA
% Get Trial Epochs, 
%       EVENTS_codes = 1,2,3,4,5,6,7,8,9,106,107,108 (event_values)
%       (pre-event) -0.1 to (post-event) 0.5 Seconds
% Run ICA

for name_i = 3:length(wpms.names)   
    if isempty(wpms.names{name_i})
        continue;
    end
    pre_trial = 0.5;
    post_trial = 0.9;
    trialfunction = 'UHRMMN'; 
    eventvalues   = [1,2,3,4,5,6,7,8,9,106,107,108];
    eventtypes    = 'trigger'; 
    trdat = fnl_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial);%(wpms,'bdf',name_i,trialfunction,pre_trial,post_trial,eventvalues,eventtypes)

    for pair_i = 1:length(wpms.splitnamespairs)
        if ismember(wpms.splitnamespairs{pair_i}{1},wpms.names(name_i))>0;

            fprintf('Found a split file: %s ',wpms.names{name_i});
            for split_i = 2:length(wpms.splitnamespairs{pair_i})
                current_name = wpms.splitnamespairs{pair_i}{split_i};
                fprintf('\t %s ',current_name{1});
                %Loading other half:
                trdat_i = fnl_trial_definition_split(wpms,pair_i,split_i,trialfunction,pre_trial,post_trial);%(wpms,'bdf',name_i,trialfunction,pre_trial,post_trial,eventvalues,eventtypes)
                %update the TRDAT: with by joining the Data:
                trdat.trial = [trdat.trial,trdat_i.trial];
                trdat.time = [trdat.time,trdat_i.time];
                trdat.sampleinfo = [trdat.sampleinfo;trdat_i.sampleinfo];
                trdat.trialinfo = [trdat.trialinfo;trdat_i.trialinfo];
                trdat.hdr.nSamples = trdat.hdr.nSamples + trdat_i.hdr.nSamples;
                Lia = ismember(wpms.names,current_name);
                for Lia_i = 1:length(Lia)
                    if Lia(Lia_i) == 1
                        wpms.names{Lia_i} = [];
                    end
                end
            end
            fprintf('\n');
        end
    end
    clear post_trial pre_trial trialfunction
    fnl_ICA(wpms,name_i,trdat);   
end
%Clean up removed combined subjects because of recombination:
try
    for i = 1:length(wpms.names)
        if isempty(wpms.names{i})
            wpms.names(i) = [];
        end
    end
catch e
    %do Nothing we expect Errors, if there are split files because the
    %array size changes.
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

% rmpath(genpath([wpms.dirs.CWD,wpms.dirs.packages 'eeglab13_4_4b']));
for name_i = 1:length(wpms.names)
    fnl_reinterpolate_v2(wpms,name_i);%,'yes');%,'biosemi');
end

%% Apply scalp current density montage
%%%% ONLY FOR TIME-FREQ ANALYSIS, for ERPs just move on to exporting section %%%%
%rmpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
% rmpath(genpath([wpms.dirs.CWD,wpms.dirs.packages 'eeglab13_4_4b']));

addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\CSDtoolbox']));
for name_i = 1:length(wpms.names)
    fnl_csd_transformation_v2(wpms,name_i)
%     fnl_csd_transformation(wpms,name_i,'biosemi');
end

%addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
rmpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\CSDtoolbox']));

%% Export to EEGDisplay:
% A file for each condition is generated in this section, and is then saved
% off to EEGDisplay format. The exported file can then be loaded into
% EEGDisplay.
% Each Condition per file: (Mat File), (EEGDisplay)\

for name_i =1:length(wpms.names)
    fnl_saveOffIndividualConditions_to_EEGDISPLAY_UHRMMN(wpms,wpms.conditions,wpms.cond,wpms.condition_code_values,name_i);
end

%% CONVERT FROM FIELDTRIP TO EEG STRUCT
% SaveOffIndividualConditions;
% SaveOffIndividualConditions_altbiosemicodes;
% This is for TimeFrequency analysis of data only

for name_i =1%:length(wpms.names)
%     fnl_saveOffIndividualConditions(wpms,wpms.conditions,wpms.cond,wpms.condition_code_values,name_i);
    fnl_setup_eegstructure(wpms,wpms.conditions,wpms.cond,name_i);
end

%% Begin FFT
% Using one wide FFT, to capture data around bandstop
% add eeglab to path
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\eeglab']));
times = -500:0.5:900; % May need to widen this significantly %AW Suggest widening the window in trial def
windowsize = 20;
bins = 160; % bins of 0.6125 Hz instead of 0.6 Hz
freqrange = [2 100]; 

channels = 1:64;
conditions = [{'standard','duration_deviant','frequency_deviant','intensity_deviant','duration_std',...
    'frequency_std','intensity_std','std_aftDev','preStd','init_Idev','init_Fdev','init_Ddev'}];
for name_i = 1:length(wpms.names)
    fnl_wavelet_analysis_UHRMMN(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i); % need to edit
end

   
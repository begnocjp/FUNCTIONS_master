%% MMN DISTRACTION Processing Pipeline
%  Adapted by Aaron Wong
%  April - 2015, Functional Neuroimaging Laboratory
%% Set-up working parameters
close all;
clear all;
clc;
warning off;

cd('P:\DISTRACTION\PROCESSING_PIPELINE');

% GENERAL DIRECTORY SETUP OF ANALYSIS:
wpms       = [];
wpms.dirs  = struct('CWD',                  [pwd,'\'],...
                    'packages',             'PACKAGES\', ...
                    'FUNCTIONS',            'FUNCTIONS\',...
                    'RAW',                  'RAW\',...
                    'preproc',              'PREPROC_OUTPUT\', ...
                    'DATA_DIR',             'EEGLAB_FORMAT\', ...
                    'WAVELET_OUTPUT_DIR',   'WAVELET_OUTPUT_DIR\',...
                    'EEGDispOutput',        'EEGDISPLAY_OUTPUT_DIR\');

%FILENAMES FOR EACH PARTICIPANT:
wpms.names = {'c12'};      ...%'testAlex_full', % Removed due to BAD DATA. <-- Failed ICA Stage, non convergence


%   wpms.names =     {'c04','c05','c06', ...
%                     'c08','c09','c10' , ...
%                      'c11','c12','c13', ...
%                      'c14','c15','c16', ...
%                      'c17','c18','c19', ...
%                      'c20','c21','c22', ...
%                      'c23','c24'};
% 
%EXPERIMENTAL CONDITTIONS:
wpms.conditions = {'standard','deviantSmall','deviantLarge','stdAfterDev'};
wpms.cond = {'stnd','devS','devL','sad'};
wpms.condition_code_values.stnd = 1;
wpms.condition_code_values.devS = 2;
wpms.condition_code_values.devL = 3;
wpms.condition_code_values.sad = 11;


% add path
cd([wpms.dirs.CWD]);
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));


% %% Preprocessing I
% %       Import, downsample and re-reference
% %       Downsample to 512 hz
% %       Set to AvMastoid Reference.
% %       Filter Bandstop 48-52Hz for Line Noise
% %       Filter High pass 0.1Hz, one pass, order 4 butterworth filter.
% % 
% %       Juanita said that it would be fine to use the mastoid rereference
% %       to do the processing from the start, which will mean that the
% %       rereferencing later will be obsolete, but this will mean the couple
% %       of participants which have not worked might be able to be
% %       processed. Taking a look at this the noise in the mastoids seems to
% %       be too large.
%  for name_i = 16:length(wpms.names)
%     sampling_frequency = 512; %hz
%     [dat] = fnl_importeeg_and_downsample(wpms,'bdf',name_i,sampling_frequency);
%     [refdat] = fnl_rereference(dat,1:64); %EXG3 = Channel 67 = NOSE REFERENCING, %EXG1,EXG2 = 65,66 Mastoids
%     
%     clear dat
%     
%     [data] = fnl_preproc_filter(refdat,'yes',[48 52],'yes',0.1,'onepass',4,'but');
%     
%     save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
%     clear refdat data cfg %tidying
% end

%% Visual Inspection of Data:
% Select the bad channels in data.
% After visual inspection, a prompt will appear, and you can enter a list
% of bad channels, e.g. C1,P3,Cz,CP2 etc.

for name_i = 1:length(wpms.names)
    fnl_bad_channel_inspection(wpms,name_i);
end

%% Remove Bad Channels out from Data:
% Automatically remove bad channels for Trial Definition, and ICA
% calculation.

for name_i = 1:length(wpms.names)   
    data = fnl_remove_bad_channels(wpms,name_i);
    
end


%% Trial Definition and ICA
% Get Trial Epochs, 
%       EVENTS_codes = 1,2,3,11 (event_values)
%       (pre-event) -0.5 to (post-event) 1.5 Seconds
% Run ICA
for name_i = 1:length(wpms.names)   
    pre_trial = 0.5;
    post_trial = 1.5;
    trialfunction = 'MMNDistraction'; 
    eventvalues   = [1,2,3,11];
    eventtypes    = 'trigger'; 
    trdat = fnl_trial_definition(wpms,'bdf',name_i,trialfunction,pre_trial,post_trial,eventvalues,eventtypes);
    clear post_trial pre_trial trialfunction
    fnl_ICA(wpms,name_i,trdat);        
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
% Load the EOG Corrected data, then perform a low pass filter of 30Hz, then
% perform automatic artifact correction -/+ 70uV.
% Save Data.
burnin = 0.3;
burnout = 0.5;
for name_i = 1:length(wpms.names)
    
    fnl_artifact_rejection_auto(wpms,name_i,true,30,-70,70,burnin,burnout);
end

%% Reinterpolate bad channels
% Bad channels are reinterpolated into the montage here.

for name_i = 1:length(wpms.names)
    fnl_reinterpolate(wpms,name_i,'biosemi');
end

%% Export to EEGDisplay:
% A file for each condition is generated in this section, and is then saved
% off to EEGDisplay format. The exported file can then be loaded into
% EEGDisplay.
% Each Condition per file: (Mat File), (EEGDisplay)
for name_i =1:length(wpms.names)
    fnl_saveOffIndividualConditions_MMN(wpms,wpms.conditions,wpms.cond,wpms.condition_code_values,name_i);
    
end

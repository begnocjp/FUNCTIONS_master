%% PreProc Batch - EGI Version - Center Cognitive Medicin
%tricked out for XNAT, by patrick, 2021 
%% Set-up working parameters
close all
clear all
%warning off;
wpms.dirs  = struct('CWD','./','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS/','RAW','RAW/','preproc','PREPROC_OUTPUT/', 'ERP','ERP/', ...
    'DATA_DIR','EEGLAB_FORMAT/','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR/', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT /','EEGDispOutput','EEGDISPLAY_OUTPUT/', ...
    'TIMELOCK','TIMELOCK/','GA_TIMELOCK','GA_TIMELOCK/','edat_txt','edat_txt/','QA','QA/');


wpms.names = dir('RAW/*.raw')
t = struct2table(wpms.names)
wpms.names = t.name
for name_i = 1:length(wpms.names)
wpms.names(name_i)= erase(wpms.names(name_i),'.raw')
end

% addpath /Users/patrick/Desktop/fieldtrip-20200423
% addpath([wpms.dirs.CWD,wpms.dirs.RAW]);
% addpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]);
% addpath([wpms.dirs.CWD,wpms.dirs.preproc]);
% addpath(genpath(['/Users/patrick/Desktop/Desktop/eeglab2019_1']))

savepath

ft_defaults

%% Preprocessing I
% Import, downsample and re-reference
for name_i = 1:length(wpms.names)
    sampling_frequency = 250; %hz
    [dat] = ccmegi_importeeg_and_downsample(wpms,'raw',name_i,sampling_frequency); % should not need to downsample, may write different function for this.
    [refdat] = fnl_rereference(dat,'all');
    
    clear dat
    
    [data] = ccm_preproc_filter(refdat,'no',[58 62],'yes',30,4,'but','yes',0.1,'onepass',1,'but'); 
% no high-pass needed EGI data sampled at 0.1-100 Hz
% Lowpassing at 30 for ERP, 30-50 for TF
% 
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
%     clear refdat data cfg %tidying
end
%% Automatic Bad Channel Rejection

%first convert data to EEGlab structurepathde

addpath(genpath(['/Users/patrick/Desktop/Desktop/eeglab2019_1']))
for name_i = 1:length(wpms.names)
    patrick_docker_ccm256_auto_chan_reject(wpms,name_i);
end

%% Visual Inspection of Data:
% for name_i = 7% length(wpms.names)   
%     ccm256_bad_channel_inspection(wpms,name_i,100);
% end

%% Remove Good Channels from Data to visualize rejected channels:
for name_i = 1:length(wpms.names)   
    patrick_docker_remove_good_channels(wpms,name_i);
end

%% Remove Bad Channels out from Data:
for name_i = 1:length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
end

%% Automatic ICA

for name_i = 1:length(wpms.names)
    patrick_docker_ccm256_auto_ica(wpms,name_i);
end


%% Trial Definition ONLY : gonogo
%%%changed pre and post trial times - 

for name_i = 1:length(wpms.names)   
    pre_trial = .2; %for target 1 sec on each side, for cue 
    post_trial = 1; %changed to 2 for inspection
    trialfunction = 'patrick_gonogo'; %will need to change per task, each task has trial function, will need to edit function for ANT task
    file_ext = 'raw';
    trdat = patrick_gonogo(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
    clear post_trial pre_trial trialfunction
    clear sample*
    clear value*
    %patrick_ccm_ICA(wpms,name_i,trdat);        
end
%% Trial Definition ONLY : stroop
%%%changed pre and post trial times - 
for name_i = 1:length(wpms.names)   
    pre_trial = .2; %for target 1 sec on each side, for cue 
    post_trial = 1;
    trialfunction = 'patrick_stroop'; %will need to change per task, each task has trial function, will need to edit function for ANT task
    file_ext = 'raw'
    trdat = patrick_stroop(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
    clear post_trial pre_trial trialfunction
    clear sample*
    clear value*
    %patrick_ccm_ICA(wpms,name_i,trdat);        
end
 

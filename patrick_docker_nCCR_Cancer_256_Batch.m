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

addpath /Users/patrick/Desktop/fieldtrip-20200423
addpath([wpms.dirs.CWD,wpms.dirs.RAW]);
addpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]);
addpath([wpms.dirs.CWD,wpms.dirs.preproc]);
addpath(genpath(['/Users/patrick/Desktop/Desktop/eeglab2019_1']))

savepath

ft_defaults

%% Preprocessing I
% Import, downsample and re-reference
for name_i = 1:length(wpms.names)
    sampling_frequency = 250; %hz
    [dat] = patrick_docker_ccmegi_importeeg_and_downsample(wpms,name_i,sampling_frequency); % should not need to downsample, may write different function for this.
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
 
%% Apply artifact rejection %toggle which condition to use
%patrick b changed "true" to "1"
for name_i = 1:length(wpms.names)
      condition = '_gonogo'
%   condition = '_stroop'
    patrick_ccm_artifact_rejection_auto(wpms,name_i,1,30,-150,150,condition)
end

%% Manual inspection/ artifact rejection of EEG data (manual rejection of artifacts
% for name_i = 1:length(wpms.names)
%      condition = '_gonogo'
% %     condition = '_Orienting'
% %    condition = '_Executive'
%     patrick_ccm_artifact_rejection_manual(wpms,name_i,condition)
% end


%% Reinterpolate bad channels %toggle which condition to use
for name_i = 1:length(wpms.names) 
      condition = '_gonogo'
 %     condition = '_stroop'
%     condition = '_Orienting'
%    condition = '_Executive'
    patrick_ccm256_reinterpolate(wpms,name_i,condition);
end

%% PRODUCE TIMELOCK ERP - Not for Coherency analysis %toggle which condition to use
% START AFTER REINTERPOLATION!

for name_i = 1:length(wpms.names)
     condition = '_gonogo'
%    condition = '_stroop'
%     condition = '_Orienting'
%     condition = '_Executive'
    conditions = {'1','2'};
    %cond = {'target','non-target'};

    %baseline is from -200 to 0 (stimuli)
    
%     baseline_start =  floor(sampling_frequency*0.8); % used for baseline correcetion of trials before ERP calculation 
%     baseline_end =     floor(sampling_frequency*1.0);
%     for i = 1:length(conditions)
        patrick_fnl_timelockanalysis(wpms,name_i,conditions,condition);
        %timelock = patrick_fnl_timelockanalysis_v2(wpms,name_i,conditions{cond_i},baseline_start,baseline_end);
%     end;
    %save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK.mat'],'timelock*','-v7.3');
    %clear timelock*
end

%% Draw ROI mean TIMELOCK ERP:   %toggle which condition to use
close all;
for name_i = 1:length(wpms.names)
    isreverse_ydir = 'true'; %true or false
% % 
    condition = '_gonogo'
    conditions = {'nogo','go','diff'};
%      
%      condition = '_stroop'
%       conditions = {'inc','c','diff'};

%     condition = '_Orienting'
%     conditions = {'center','updown','diff'};

%     condition = '_Executive'
%     conditions = {'incongruent','congruent','diff'};

     %Toggle channels used as ROIs for Butterfly
%  chan = [22,14,23,15,6,16,7];
%        ROI  = 'frontal'
chan  = [9,186,45,132,81,80,131];
        ROI  = 'central'
% chan  = [100,129,101,110,128,119];
%       ROI  = 'parietal'
% chan  = [137,115,123,158,159];
%      ROI  = 'occipital'

   
    patrick_ccm_plot_mean_ERP_ROIs_v2(wpms,name_i,isreverse_ydir,conditions,condition,chan,ROI)
    close all
end

%% Plot Grand Average N2/P3 ERP 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MANUAL SUB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LOADING!!!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%do pre vs post
% exclude n007_pre_gonogo_007, too much artifact
%%PRE
%  wpms.names = {
%     'n001_pre_gonogo_002';'n002_pre_gonogo_002'; ... %'n003_pre_gonogo_002'; ...
%     'n005_pre_gonogo_002';'n006_pre_gonogo_002'; ...
%     'n008_pre_gonogo_002'; ...
%     'n010_pre_gonogo_002';'n011_pre_gonogo_002'; ...
%     'n012_pre_gonogo_002';'n013_pre_gonogo_002'; ...
%     'n015_pre_gonogo_002';'n016_pre_gonogo_002'}
%%POST
 wpms.names = {
    'n001_post_gonogo_002';'n002_post_gonogo_002'; ... %'n003_post_gonogo_002'; ...
    'n005_post_gonogo_002';'n006_post_gonogo_002';
    'n008_post_gonogo_002'; ...
    'n010_post_gonogo_002';'n011_post_gonogo_002'; ...
    'n012_post_gonogo_002';'n013_post_gonogo_002'; ...
    'n015_post_gonogo_002';'n016_post_gonogo_002'}

%%PRE
% wpms.names = {
%     'n001_pre_stroop_002';'n002_pre_stroop_002';'n003_pre_stroop_002'; ...
%     'n005_pre_stroop_002';'n006_pre_stroop_002'}
%%POST
% wpms.names = {
%     'n001_post_stroop_002';'n002_post_stroop_002';'n003_post_stroop_002'; ...
%     'n005_post_stroop_002';'n006_post_stroop_002'}


name_i = 1:length(wpms.names)

condition = []

% condition.time = 'pre' 
  condition.time = 'post' 
% 
% condition.roi = [22,14,23,15,6,16,7]
% condition.chan = 'frontal'
% 
condition.roi = [9,186,45,132,81,80,131]
condition.chan = 'central'

condition.name = '_gonogo'
condition.erp = {'nogo','go','diff'};

% condition.name = '_stroop'
% condition.erp = {'inc','c','diff'}

patrick_plot_Grand_Average(wpms,name_i,condition)


%% Compute peak latency N2/P3/P1 ERP values
%ERP Latency (samples of trial portion used to compute average amplitude)
% P3_lat = 195:1:205
% N2_lat = 170:1:180
%wider range used for avg amplitude ERP calculation
%N2 150ms to 300ms (650ms to 800ms accounting for 500ms baseline)(650/4 to 800/4)
%P3 250 to 450 ms  (750ms to 950ms accounting for 500ms baseline)(750/4 to 950/4)
%P1 0 to 200 ms
do pre vs post
N2_lat = [162:1:200]
P3_lat = [187:1:238]
P1_lat = [125:1:175]

%Channels used as ROIs (must use multiple channels?)
front_chan = [22,14,23,15,6,16,7];
cent_chan  = [9,186,45,132,81,80,131];
pari_chan  = [100,129,101,110,128,119];
occip_chan  = [137,115,123,158,159];


patrick_compute_ERP_latency(wpms,name_i,N2_lat,P3_lat,P1_lat,front_chan,cent_chan,pari_chan,occip_chan)
%
%% Compute/plot Average N2/P3/P1 ERP values
do pre vs post
  condition.name = '_gonogo'
  condition.erp = {'nogo','go','diff'};

%condition.name = '_Orienting'
% condition.erp = {'center','updown','diff'}


% condition.name = '_Executive'
% conditions.erp = {'incongruent','congruent','diff'};

%ERP Latency (samples of trial portion used to compute average amplitude)
% P3_lat = 195:1:205
% N2_lat = 170:1:180
%wider range used for avg amplitude ERP calculation
%N2 150ms to 300ms (650ms to 800ms accounting for 500ms baseline)(650/4 to 800/4)
%P3 250 to 450 ms  (750ms to 950ms accounting for 500ms baseline)(750/4 to 950/4)
%P1 0 to 200 ms

N2_lat = [162:1:200]
P3_lat = [187:1:238]
% P1_lat = [125:1:175]


%Channels used as ROIs (must use multiple channels?)
front_chan = [22,14,23,15,6,16,7];
cent_chan  = [9,186,45,132,81,80,131];
pari_chan  = [100,129,101,110,128,119];
occip_chan  = [137,115,123,158,159];


patrick_compute_avg_ERP_peak(wpms,name_i,N2_lat,P3_lat,front_chan,cent_chan,pari_chan,occip_chan)
% % 



%% Incidental Memory Batch - 256 Channel Version
%  Adapted by Patrick Cooper and Aaron Wong
%  May - 2014, Functional Neuroimaging Laboratory
%  Modified by Alexander Conley - December 2016
%for using with catalina might need to run this command in terminal first:
%"sudo spctl --master-disable"
%% Set-up working parameters

close all
clear all
%warning off;
wpms.dirs  = struct('CWD','/Users/patrick/Desktop/CHAMP/substudy/','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS/','RAW','RAW/','preproc','PREPROC_OUTPUT/', 'ERP','ERP/', ...
    'DATA_DIR','EEGLAB_FORMAT/','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR/', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT /','EEGDispOutput','EEGDISPLAY_OUTPUT/', ...
    'TIMELOCK','TIMELOCK/','GA_TIMELOCK','GA_TIMELOCK/','edat_txt','edat_txt/');

wpms.names = {%'2001_ANT_002'}
 '2001_ANT_002';'2005_ANT_002';'2007_ANT_002';'2008_ANT_002';'2009_ANT_002'; ...
 '2012_ANT_002';'2013_ANT_002';'2021_ANT_002'}
%  '2023_ANT_002';'2029_ANT_002'}

cd([wpms.dirs.CWD]);
addpath /Users/patrick/Desktop/fieldtrip-20200423
addpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]);
addpath(genpath(['/Users/patrick/Desktop/Desktop/eeglab2019_1']))
ft_defaults

%% Preprocessing I
%  Import, downsample and re-reference
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
    clear refdat data cfg %tidying
end
%% Automatic Bad Channel Rejection

%first convert data to EEGlab structure

addpath(genpath(['/Users/patrick/Desktop/Desktop/eeglab2019_1']))
for name_i = 1:length(wpms.names)
    patrick_ccm256_auto_chan_reject(wpms,name_i);
end

%% Visual Inspection of Data:
% for name_i =  length(wpms.names)
%     ccm256_bad_channel_inspection(wpms,name_i,100);
% end

% %% Remove Good Channels from Data to visualize rejected channels:
% for name_i = 1:length(wpms.names)
%     patrick_fnl_remove_good_channels(wpms,name_i);
% end

%% Remove Bad Channels out from Data:
for name_i = 1:length(wpms.names)
    fnl_remove_bad_channels(wpms,name_i);
end

%% Automatic ICA

for name_i = 1:length(wpms.names)
    patrick_ccm256_auto_ica(wpms,name_i);
end


%% Trial Definition ONLY : Alerting
%%%changed pre and post trial times -
for name_i = 1:length(wpms.names)
    pre_trial = .2; %for target 1 sec on each side, for cue
    post_trial = 1; %changed to 2 for inspection
    trialfunction = 'patrick_Alerting_collapse'; %will need to change per task, each task has trial function, will need to edit function for ANT task
    file_ext = 'raw';
    trdat = patrick_Alerting_collapse(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
    clear post_trial pre_trial trialfunction
    clear sample*
    clear value*
    %patrick_ccm_ICA(wpms,name_i,trdat);
 end
%% Trial Definition ONLY : Orienting
%%changed pre and post trial times -
for name_i = 1:length(wpms.names)
    pre_trial = .2; %for target 1 sec on each side, for cue
    post_trial = 1;
    trialfunction = 'patrick_Orienting_collapse'; %will need to change per task, each task has trial function, will need to edit function for ANT task
    file_ext = 'raw'
    trdat = patrick_Orienting_collapse(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
    clear post_trial pre_trial trialfunction
    clear sample*
    clear value*
    %patrick_ccm_ICA(wpms,name_i,trdat);
end

%% Trial Definition ONLY : Executive 
%%%changed pre and post trial times -
for name_i = 1:length(wpms.names)
    pre_trial = .2; %for target 1 sec on each side, for cue
    post_trial = 1;
    trialfunction = 'patrick_Executive_collapse'; %will need to change per task, each task has trial function, will need to edit function for ANT task
    file_ext = 'raw'
    trdat = patrick_Executive_collapse(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
    clear post_trial pre_trial trialfunction
    clear sample*
    clear value*
    %patrick_ccm_ICA(wpms,name_i,trdat);
end

%% Apply artifact rejection %toggle which condition to use
%patrick b changed "true" to "1", will stop if finds sub with <1 good trial
for name_i = 1:length(wpms.names)
     %    condition = '_Alerting'
      % condition = '_Executive'
%          condition = '_Orienting'
     %   condition = '_incidental'
    patrick_ccm_artifact_rejection_auto(wpms,name_i,1,30,-150,150,condition)
end

%% Manual inspection/ artifact rejection of EEG data (manual rejection of artifacts
% for name_i = 1:length(wpms.names)
%      condition = '_gonogo'
% %     condition = '_Orienting'
%    condition = '_Executive'
%     patrick_ccm_artifact_rejection_manual(wpms,name_i,condition)
% end


%% Reinterpolate bad channels %toggle which condition to use
for name_i = 1:length(wpms.names)
     %    condition = '_Alerting'
     %   condition = '_Executive'
%          condition = '_Orienting'
%     condition = '_incidental'
    patrick_ccm256_reinterpolate(wpms,name_i,condition);
end

%% PRODUCE TIMELOCK ERP - Not for Coherency analysis %toggle which condition to use
% START AFTER REINTERPOLATION!

for name_i = 1:length(wpms.names)
     %   condition = '_Alerting'
     %   condition = '_Executive'
     %    condition = '_Orienting'
    %  condition = '_incidental'
    conditions = {'1','2'};
    baseline = [-0.2 0]
    %cond = {'target','non-target'};
    
    %baseline is from -200 to 0 (stimuli)
    
    %     baseline_start =  floor(sampling_frequency*0.8); % used for baseline correcetion of trials before ERP calculation
    %     baseline_end =     floor(sampling_frequency*1.0);
    %     for i = 1:length(conditions)
    patrick_fnl_timelockanalysis(wpms,name_i,conditions,condition,baseline);
    %timelock = patrick_fnl_timelockanalysis_v2(wpms,name_i,conditions{cond_i},baseline_start,baseline_end);
    %     end;
    %save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK.mat'],'timelock*','-v7.3');
    %clear timelock*
end

%% Draw ROI mean TIMELOCK ERP:   %toggle which condition to use
% close all;
% for name_i = 1:length(wpms.names)
%     isreverse_ydir = 'true'; %true or false
%     % %
%     %     condition = '_Alerting'
%     %     conditions = {'nocue','double','diff'};

%     %     condition = '_Orienting'
%     %     conditions = {'center','updown','diff'};
%     
%     %     condition = '_Executive'
%     %     conditions = {'incongruent','congruent','diff'};
%     
%     %Toggle channels used as ROIs for Butterfly
%     %  chan = [22,14,23,15,6,16,7];
%     %        ROI  = 'frontal'
%     % chan  = [9,186,45,132,81,80,131];
%     %         ROI  = 'central'
%     chan  = [100,129,101,110,128,119];
%     ROI  = 'parietal'
%     % chan  = [137,115,123,158,159];
%     %      ROI  = 'occipital'
%     
%     
%     patrick_ccm_plot_mean_ERP_ROIs_v2(wpms,name_i,isreverse_ydir,conditions,condition,chan,ROI)
%     close all
% end

%% Plot Grand Average N2/P3 ERP
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MANUAL SUB
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LOADING!!!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% % %% LEFT OUT bc <10 TRIALS in PRE grp: 'n003, n007'
% %%PRE
% wpms.names = {
%     'n001_pre_gonogo_002';
%     'n002_pre_gonogo_002'; ...
%     'n005_pre_gonogo_002';'n006_pre_gonogo_002'; ...
%     'n008_pre_gonogo_002'; ...
%     'n010_pre_gonogo_002';'n011_pre_gonogo_002'; ...
%     'n012_pre_gonogo_002';'n013_pre_gonogo_002'; ...
%     'n015_pre_gonogo_002';'n016_pre_gonogo_002';
%     'n019_pre_gonogo_002';'n022_pre_gonogo_002';
%     'n023_pre_gonogo_002';
%     'n024_pre_gonogo_002';'n025_pre_gonogo_002'}
% 
% % %%  'n025', trials = 7
% %%POST
%   wpms.names = {
%     'n001_post_gonogo_002';'n002_post_gonogo_002'; ...
%       'n003_post_gonogo_002';
%      'n005_post_gonogo_002';'n006_post_gonogo_002';
%       'n007_post_gonogo_002';
%     'n008_post_gonogo_002'; ...
%     'n010_post_gonogo_002';'n011_post_gonogo_002'; ...
%     'n012_post_gonogo_002';'n013_post_gonogo_002'; ...
%     'n015_post_gonogo_002';'n016_post_gonogo_002'; ...
%       'n017_post_gonogo_002';
%      'n019_post_gonogo_002';'n022_post_gonogo_002';  ...
%        'n020_post_gonogo_002';'n021_post_gonogo_002';
%      'n023_post_gonogo_002';
%       'N024_post_gonogo_002';'N025_post_gonogo_002'}
% 
% % %% LEFT OUT bc <10 TRIALS in POST grp: 'n005'
% %PRE
% wpms.names = {
%     'n001_pre_stroop_002';'n002_pre_stroop_002';'n003_pre_stroop_002'; ...
%     'n005_pre_stroop_002';'n006_pre_stroop_002';'n007_pre_stroop_002'; ...
%     'n008_pre_stroop_002'; ...
%     'n010_pre_stroop_002';'n011_pre_stroop_002'; ...
%     'n012_pre_stroop_002';'n013_pre_stroop_002'; ...
%     'n015_pre_stroop_002';'n016_pre_stroop_002';
%     'n019_pre_stroop_002';'n022_pre_stroop_002';
%     'n023_pre_stroop_002';
%     'n024_pre_stroop_002';'n025_pre_stroop_002'}
% 
% % %% LEFT OUT bc 2 congruent TRIALS in POST grp: 'n005'
% %%POST
%   wpms.names = {
%     'n001_post_stroop_002';'n002_post_stroop_002';'n003_post_stroop_002'; ...
%    'n006_post_stroop_002'; 'n007_post_stroop_002'; 
%     'n008_post_stroop_002'; ...
%      'n011_post_stroop_002';'n010_post_stroop_002'; ...
%     'n012_post_stroop_002';'n013_post_stroop_002'; ...
%     'n015_post_stroop_002';'n016_post_stroop_002';
%        'n017_post_stroop_002';
%       'n019_post_stroop_002';'n022_post_stroop_002';
%      'n020_post_stroop_002';'n012_post_stroop_002';
%       'n023_post_stroop_002';
%        'N024_post_stroop_002';'N025_post_stroop_002'}
% 
% % %% LEFT OUT bc <10 TRIALS in POST grp: 'n010'
% %%PRE
% wpms.names = {
%     'n001_pre_mem_002';'n002_pre_mem_002';'n003_pre_mem_002'; ...
%     'n005_pre_mem_002';'n006_pre_mem_002';'n007_pre_mem_002'; ...
%     'n008_pre_mem_002'; ...
%     'n010_pre_mem_002'; ...
%     'n011_pre_mem_002'; ...
%     'n012_pre_mem_002';'n013_pre_mem_002'; ...
%     'n015_pre_mem_002';'n016_pre_mem_002'; ...
%     'n019_pre_mem_002';'n022_pre_mem_002';
%     'n023_pre_mem_002';
%     'n024_pre_mem_002';'n025_pre_mem_002'}
% % %%POST LEFT OUT <10 TRIALS: 'n010_post_mem_002'
%   wpms.names = {
%     'n001_post_mem_002';'n002_post_mem_002';'n003_post_mem_002'; ...
%     'n005_post_mem_002';'n006_post_mem_002';'n007_post_mem_002'; ...
%     'n008_post_mem_002'; ...
%     'n011_post_mem_002'; ...
%     'n012_post_mem_002';'n013_post_mem_002'; ...
%     'n015_post_mem_002';'n016_post_mem_002';
%     'n017_post_mem_002';
%     'n019_post_mem_002';
%     'n020_post_mem_002';'n021_post_mem_002';
% 'n022_post_mem_002';'n023_post_mem_002';
% 'N024_post_mem_002';'N025_post_mem_002'}
% 
% 
% name_i = 1:length(wpms.names)
% 
% condition = []
% 
% %    condition.time = 'pre'
%     condition.time = 'post'
% %
% % condition.roi = [22,14,23,15,6,16,7]
% % condition.chan = 'frontal'
% 
% % condition.roi = [9,186,45,132,81,80,131]
% % condition.chan = 'central'
% %
% condition.roi = [100,129,101,110,128,119]
% condition.chan = 'parietal'
% 
% % condition.name = '_stroop'
% % condition.erp = {'inc','c','diff'}
% 
% condition.name = '_gonogo'
% condition.erp = {'nogo','go','diff'}
% 
% % condition.name = '_incidental'
% % condition.erp = {'sing','rept','diff'}
% 
% patrick_plot_Grand_Average(wpms,name_i,condition)
%% Compute peak latency/average amplitude/area under curve N2/P3/P1 ERP values using ERPLAB
% ERP Latency (samples of trial portion used to find peak latency)


N2_lat = [150 300]
P3_lat = [250 450]
%P3_lat = [200 400] - just gonogo
P1_lat = [0 200]


%Channels used as ROIs (must use multiple channels?)
front_chan = [22,14,23,15,6,16,7];
cent_chan  = [9,186,45,132,81,80,131];
pari_chan  = [100,129,101,110,128,119];
occip_chan  = [137,115,123,158,159];

%ROIs for forloop
%ROI = [

condition = []

   condition.name = '_Alerting'
   condition.erp = {'nocue','double','diff'};
% condition.time

%condition.name = '_Orienting'
% condition.erp = {'center','updown','diff'}
% condition.time

% condition.name = '_Executive'
% conditions.erp = {'incongruent','congruent','diff'};
% condition.time

%store group results information
store = []
store.ERPs = {'N2', 'P3', 'P1'};
store.calculation = {'Lat','avg_Amp'}
store.ROIs = {'mean_Frontal', 'mean_Central', 'mean_Parietal','mean_Occipital'};

for name_i = 1:length(wpms.names)
patrick_ERPLAB_amp_lat(wpms,name_i,N2_lat,P3_lat,P1_lat,front_chan,cent_chan,pari_chan,occip_chan, condition, store)
end

% 
% for name_i = 1:length(wpms.names)
%     
%     group_results.store{name_i} = load([wpms.dirs.CWD wpms.dirs.TIMELOCK wpms.names{name_i} '_TIMELOCK_amp_lat_.mat']);
%     group_results.names{name_i} = wpms.names{name_i}
%     
%     for n = 1:length(store.ERPs)
%         for i = 1:length(condition.erp)
%             for c = 1:length(store.calculation)
%                 for r = 1:length(store.ROIs)
%                     
%                     group_results.(store.ERPs{n}).(char(condition.erp(i))).(store.calculation(c)).(store.ROIs{r}){name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).(store.calculation(c)).Lat.(store.ROIs{r})
%                     %                             group_results.N2.(char(condition.erp(i))).Lat.mean_Frontal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).N2.Lat.mean_Frontal
%                     %                             group_results.N2.(char(condition.erp(i))).Lat.mean_Central{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).N2.Lat.mean_Central
%                     %                             group_results.N2.(char(condition.erp(i))).Lat.mean_Parietal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).N2.Lat.mean_Parietal
%                     %                             group_results.N2.(char(condition.erp(i))).Lat.mean_Occipital{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).N2.Lat.mean_Occipital
%                     %
%                     %                             group_results.P3.(char(condition.erp(i))).Lat.mean_Frontal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P3.Lat.mean_Frontal
%                     %                             group_results.P3.(char(condition.erp(i))).Lat.mean_Central{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P3.Lat.mean_Central
%                     %                             group_results.P3.(char(condition.erp(i))).Lat.mean_Parietal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P3.Lat.mean_Parietal
%                     %                             group_results.P3.(char(condition.erp(i))).Lat.mean_Occipital{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P3.Lat.mean_Occipital
%                     %
%                     %                             group_results.P1.(char(condition.erp(i))).Lat.mean_Frontal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P1.Lat.mean_Frontal
%                     %                             group_results.P1.(char(condition.erp(i))).Lat.mean_Central{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P1.Lat.mean_Central
%                     %                             group_results.P1.(char(condition.erp(i))).Lat.mean_Parietal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P1.Lat.mean_Parietal
%                     %                             group_results.P1.(char(condition.erp(i))).Lat.mean_Occipital{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P1.Lat.mean_Occipital
%                     %
%                     %                             group_results.N2.(char(condition.erp(i))).avg_Amp.mean_Frontal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.mean_Frontal
%                     %                             group_results.N2.(char(condition.erp(i))).avg_Amp.mean_Central{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.mean_Central
%                     %                             group_results.N2.(char(condition.erp(i))).avg_Amp.mean_Parietal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.mean_Parietal
%                     %                             group_results.N2.(char(condition.erp(i))).avg_Amp.mean_Occipital{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.mean_Occipital
%                     %
%                     %                             group_results.P3.(char(condition.erp(i))).avg_Amp.mean_Frontal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.mean_Frontal
%                     %                             group_results.P3.(char(condition.erp(i))).avg_Amp.mean_Central{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.mean_Central
%                     %                             group_results.P3.(char(condition.erp(i))).avg_Amp.mean_Parietal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.mean_Parietal
%                     %                             group_results.P3.(char(condition.erp(i))).avg_Amp.mean_Occipital{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.mean_Occipital
%                     %
%                     %                             group_results.P1.(char(condition.erp(i))).avg_Amp.mean_Frontal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.mean_Frontal
%                     %                             group_results.P1.(char(condition.erp(i))).avg_Amp.mean_Central{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.mean_Central
%                     %                             group_results.P1.(char(condition.erp(i))).avg_Amp.mean_Parietal{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.mean_Parietal
%                     %                             group_results.P1.(char(condition.erp(i))).avg_Amp.mean_Occipital{name_i} = group_results.store{name_i}.TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.mean_Occipital
%                 end
%             end
%         end
%     end
%     clear('TIMELOCK')
%     %get number of trials used in each condition
%     
%     load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' condition.name '.mat']);
%     if condition.name == '_Alerting'
%         group_results.num_trials.nocue{name_i} = length(load_subs{name_i}.timelock(1).cfg.previous.trials)
%         group_results.num_trials.double{name_i} = length(load_subs{name_i}.timelock(2).cfg.previous.trials)
%     elseif condition.name == '_Orienting'
%         group_results.num_trials.center{name_i} = length(load_subs{name_i}.timelock(1).cfg.previous.trials)
%         group_results.num_trials.updown{name_i} = length(load_subs{name_i}.timelock(2).cfg.previous.trials)
%     elseif condition.name == '_Executive'
%         group_results.num_trials.incongruent{name_i} = length(load_subs{name_i}.timelock(1).cfg.previous.trials)
%         group_results.num_trials.congruent{name_i} = length(load_subs{name_i}.timelock(2).cfg.previous.trials)
%     end
% end



%% Compute peak latency N2/P3/P1 ERP values using ERPLAB
% ERP Latency (samples of trial portion used to compute average amplitude)
% P3_lat = 195:1:205
% N2_lat = 170:1:180
%wider range used for avg amplitude ERP calculation
%N2 150ms to 300ms (350ms to 500ms accounting for 200ms baseline)(350/4 to 500/4)
%P3 250 to 450 ms  (450ms to 650ms accounting for 200ms baseline)(450/4 to 650/4)
%P3 200 to 400 ms  (400ms to 600ms accounting for 200ms baseline)(400/4 to
%600/4) - earlier latency just for Gonogo
%P1 0 to 200 ms    (200ms to 400ms accounting for 200ms baseline)(200/4 to 400/4)

%!!!!!!! Change according to
%baseline!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
N2_lat = [87:1:125]
P3_lat = [112:1:163]
%P3_lat = [100:1:150] - just gonogo
P1_lat = [50:1:100]


%Channels used as ROIs (must use multiple channels?)
front_chan = [22,14,23,15,6,16,7];
cent_chan  = [9,186,45,132,81,80,131];
pari_chan  = [100,129,101,110,128,119];
occip_chan  = [137,115,123,158,159];

%here when computing latency need to subtract baseline in calculation, so set
%baseline in sample points
% e.g. baselines is 200ms, convert to sample points 200/4 = 50
baseline = 50

     %   condition = '_Alerting'
     %   condition = '_Executive'
         condition = '_Orienting'
    %  condition = '_incidental'

patrick_compute_ERP_latency(wpms,name_i,N2_lat,P3_lat,P1_lat,front_chan,cent_chan,pari_chan,occip_chan,baseline)

%% Compute/plot Average N2/P3/P1 ERP values
%do pre vs post

%condition.name = '_Orienting'
% condition.erp = {'center','updown','diff'}


% condition.name = '_Executive'
% conditions.erp = {'incongruent','congruent','diff'};

% ERP Latency (samples of trial portion used to compute average amplitude)
% P3_lat = 195:1:205
% N2_lat = 170:1:180
%wider range used for avg amplitude ERP calculation
%N2 150ms to 300ms (350ms to 500ms accounting for 200ms baseline)(350/4 to 500/4)
%P3 250 to 450 ms  (450ms to 650ms accounting for 200ms baseline)(450/4 to 650/4)
%P3 200 to 400 ms  (400ms to 600ms accounting for 200ms baseline)(400/4 to
%600/4) - earlier latency just for Gonogo
%P1 0 to 200 ms    (200ms to 400ms accounting for 200ms baseline)(200/4 to 400/4)

%!!!!!!! Change according to
%baseline!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
N2_lat = [87:1:125]
P3_lat = [112:1:163]
%P3_lat = [100:1:150] - just gonogo
P1_lat = [50:1:100]


%Channels used as ROIs (must use multiple channels?)
front_chan = [22,14,23,15,6,16,7];
cent_chan  = [9,186,45,132,81,80,131];
pari_chan  = [100,129,101,110,128,119];
occip_chan  = [137,115,123,158,159];


patrick_compute_avg_ERP_peak(wpms,name_i,N2_lat,P3_lat,front_chan,cent_chan,pari_chan,occip_chan)
% %



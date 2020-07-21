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
wpms.dirs  = struct('CWD','/Users/patrick/Desktop/EEG/','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS/','RAW','RAW/','preproc','PREPROC_OUTPUT/', ...
    'DATA_DIR','EEGLAB_FORMAT/','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR/', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT/','EEGDispOutput','EEGDISPLAY_OUTPUT/', ...
    'TIMELOCK','TIMELOCK/','GA_TIMELOCK','GA_TIMELOCK/');

wpms.names = {'1101_ant_002';'1102_ant_002';'1103_ant_002';'1104_ant_002';'1105_ant_002';'1106_ant_002'}
% '1102_mem_002','1103_mem_002','1104_mem_002','1105_mem_002','1106_mem_002'};
% wpms.names = {'1101_ant_002','1102_ant_002','1103_ant_002','1104_ant_002','1105_ant_002','1106_ant_002'};

% add path
%                                                                                                                                                                                                                                                                                                                                                                                                                           
cd([wpms.dirs.CWD]);
addpath /Users/patrick/Desktop/fieldtrip-20200423
addpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]);
addpath(genpath(['/Users/patrick/Desktop/eeglab2019_1']))
%addpath(genpath(['/Users/patrick/Desktop/eeglab12_0_2_6b']))
ft_defaults
%addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
%% Preprocessing I
%  Import, downsample and re-reference
for name_i = 1:length(wpms.names)
    sampling_frequency = 250; %hz
    [dat] = ccmegi_importeeg_and_downsample(wpms,'raw',name_i,sampling_frequency); % should not need to downsample, may write different function for this.
    [refdat] = fnl_rereference(dat,'all');
    
    clear dat
    
    [data] = ccm_preproc_filter(refdat,'no',[58 62],'yes',50,4,'but','yes',0.5,'onepass',1,'but'); 
% no high-pass needed EGI data sampled at 0.1-100 Hz
% Lowpassing at 30 for ERP, 30-50 for TF
% 
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
    clear refdat data cfg %tidying
end
%% Automatic Bad Channel Rejection

%first convert data to EEGlab structure

addpath(genpath(['/Users/patrick/Desktop/eeglab2019_1']))
for name_i = 1:length(wpms.names)
    patrick_ccm256_auto_chan_reject(wpms,name_i);
end

%% Visual Inspection of Data:
%for name_i = length(wpms.names)   
%    ccm256_bad_channel_inspection(wpms,name_i,100);
%end

%% Remove Good Channels from Data to visualize rejected channels:
for name_i = 1:length(wpms.names)   
    patrick_fnl_remove_good_channels(wpms,name_i);
end

%% Remove Bad Channels out from Data:
for name_i = 1:length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
end

%% Automatic ICA

for name_i = 1:length(wpms.names)
    patrick_ccm256_auto_ica(wpms,name_i);
end

% %% Trial Definition ONLY : Alerting
% %%%changed pre and post trial times - 
% for name_i = length(wpms.names)   
%     pre_trial = .5; %for target 1 sec on each side, for cue 
%     post_trial = .5;
%     trialfunction = 'patrick_Alerting_'; %will need to change per task, each task has trial function, will need to edit function for ANT task
%     file_ext = 'raw';
%     trdat = patrick_Alerting_(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
%     clear post_trial pre_trial trialfunction
%     %patrick_ccm_ICA(wpms,name_i,trdat);        
% end
% %% Trial Definition ONLY : All_collapse
% %%%changed pre and post trial times - 
% for name_i = 1%:length(wpms.names)   
%     pre_trial = .5; %for target 1 sec on each side, for cue 
%     post_trial = .5;
%     trialfunction = 'patrick_All_collapse'; %will need to change per task, each task has trial function, will need to edit function for ANT task
%     file_ext = 'raw';
%     trdat = patrick_All_collapse(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
%     clear post_trial pre_trial trialfunction
%     clear sample*
%     clear value*
%     %patrick_ccm_ICA(wpms,name_i,trdat);        
% end
%% Trial Definition ONLY : Alerting_collapse
%%%changed pre and post trial times - 
for name_i = 1:length(wpms.names)   
    pre_trial = .5; %for target 1 sec on each side, for cue 
    post_trial = .5;
    trialfunction = 'patrick_Alerting_collapse'; %will need to change per task, each task has trial function, will need to edit function for ANT task
    file_ext = 'raw';
    trdat = patrick_Alerting_collapse(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
    clear post_trial pre_trial trialfunction
    clear sample*
    clear value*
    %patrick_ccm_ICA(wpms,name_i,trdat);        
end
%% Trial Definition ONLY : Orienting_collapse
%%%changed pre and post trial times - 
for name_i = 1:length(wpms.names)   
    pre_trial = .5; %for target 1 sec on each side, for cue 
    post_trial = .5;
    trialfunction = 'patrick_Orienting_collapse'; %will need to change per task, each task has trial function, will need to edit function for ANT task
    file_ext = 'raw';
    trdat = patrick_Orienting_collapse(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
    clear post_trial pre_trial trialfunction
    clear sample*
    clear value*
    %patrick_ccm_ICA(wpms,name_i,trdat);        
end
%% Trial Definition ONLY : Executive_collapse
%%%changed pre and post trial times - 
for name_i = 1:length(wpms.names)   
    pre_trial = .5; %for target 1 sec on each side, for target
    post_trial = .5;
    trialfunction = 'patrick_Executive_collapse'; %will need to change per task, each task has trial function, will need to edit function for ANT task
    file_ext = 'raw';
    trdat = patrick_Executive_collapse(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
    clear post_trial pre_trial trialfunction
    clear sample*
    clear value*
    %patrick_ccm_ICA(wpms,name_i,trdat);        
end
 %% Trial Definition ONLY
% %%%changed pre and post trial times - 
% for name_i = length(wpms.names)   
%     pre_trial = .5; %for target 1 sec on each side, for cue 
%     post_trial = .5;
%     trialfunction = 'Incident_M'; %will need to change per task, each task has trial function, will need to edit function for ANT task
%     file_ext = 'raw';
%     trdat = patrick_ccm_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
%     clear post_trial pre_trial trialfunction
%     %patrick_ccm_ICA(wpms,name_i,trdat);        
% end
% 
%% Trial Definition and ICA 
%%%changed pre and post trial times - patrick b.%%%%
%for name_i = length(wpms.names)   
%    pre_trial = .5;
%    post_trial = .5;
%    trialfunction = 'Incident_M'; 
%    file_ext = 'raw';
%    trdat = ccm_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
%    clear post_trial pre_trial trialfunction
%    ccm_ICA(wpms,name_i,trdat);        
%end
%% Remove EOG Components from ICA
%for name_i = length(wpms.names)
%    ccm256_ICA_inspection(wpms,name_i);
%end 
%% Apply artifact rejection %toggle which condition to use
%patrick b changed "true" to "1"
for name_i = 1:length(wpms.names)
     condition = '_Alerting'
%     condition = '_Orienting'
%     condition = '_Executive'
    patrick_ccm_artifact_rejection_auto(wpms,name_i,1,50,-100,100,condition)
end

%% Manual inspection/ artifact rejection of EEG data (manual rejection of artifacts
for name_i = 1:length(wpms.names)
%     condition = '_Alerting'
%     condition = '_Orienting'
     condition = '_Executive'
    patrick_ccm_artifact_rejection_manual(wpms,name_i,condition)
end


%% Reinterpolate bad channels %toggle which condition to use
for name_i = 1:length(wpms.names) 
     condition = '_Alerting'
%     condition = '_Orienting'
%     condition = '_Executive'
    patrick_ccm256_reinterpolate(wpms,name_i,condition);
end


%%%%%
%do 256 CSD transform here
%CSD expects coordinates from montage, montage, will get coordinates from alex,
%.spf EGI 256 net %%

% %% IMPORT EPOCHED DATA FROM NETSTATION
% % SKIP IF IMPORTING .RAW DATA 
% 
% for name_i = 1%:length(wpms.names)
%     sampling_frequency = 250; %hz
%     [dat] = ccmegi_importepoched(wpms,'raw',name_i,sampling_frequency); % should not need to downsample, may write different function for this.
%     [refdat] = fnl_rereference(dat,'all');
%     
%     clear data
%     
%     [data] = ccm_preproc_filter(refdat,'no',[58 62],'yes',50,4,'but','yes',0.1,'onepass',1,'but'); 
% % no high-pass needed EGI data sampled at 0.1-100 Hz
% % Lowpassing at 30 for ERP, 30-50 for TF
% % 
%     save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
%     clear refdat data cfg %tidying
% end



%% Apply scalp current density montage
% addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS '/CSDtoolbox']));
% type = 'egi';
% for name_i = length(wpms.names)
%     patrick_ccm256_csd_transformation_v2(wpms,name_i); %,type);
% end
% %% CONVERT FROM FIELDTRIP TO EEG STRUCT
% %SaveOffIndividualConditions;
% %SaveOffIndividualConditions_altbiosemicodes;
% 
% %These are all the conditions that are present in the code:
% conditions = {'single','repeat'}; %'attention',
% %shorthand for naming files and data structure:
% cond = {'sngl','rept'}; %'attn'
% 
% % condition_code_values.attn = 1;
% condition_code_values.sngl = 2;
% condition_code_values.rept = 3;
% wpms.sampling_frequency = 250;
% 
% for name_i =1%:length(wpms.names)
%     fnl_saveOffIndividualConditions(wpms,conditions,cond,condition_code_values,name_i);
%     patrick_fnl_setup_eegstructure(wpms,conditions,cond,name_i);
% end
% %% Begin FFT
% % add eeglab to path
% addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '/eeglab']));
% times = -1000:4:2000;
% windowsize = 20;
% bins = 80;
% freqrange = [2 50];
% channels = 1:256;
% conditions = [{'single'},{'repeat'}]; %{'attention'},
% for name_i = 1%:length(wpms.names)
%     fprintf('\n%s\t', wpms.names{name_i})
%     patrick_fnl_wavelet_analysis_v2(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i);
% end
% %% IMAGINARY COHERENCE ANALYSIS
% channels = 1:256;
% conditions = {'repeat','single'}; %'attention',
% for name_i = 1%:length(wpms.names)
%     patrick_fnl_imaginarycoherence_analysis(wpms,channels,conditions,name_i)
% end
% %% GENERATE CONNECTIVITY MATRICES
% channelcount = 256;
% freq_names = {'delta','theta','alpha','beta'};
% freq = [{1:18},{19:31},{35:49},{50:68}];
% conditions = {'repeat','single'}; %'attention',
% for name_i = 1%:length(wpms.names)
%     starttimes = 400:200:3600;
%     endtime = 600;
%     patrick_fnl_genconnmatrix(wpms,channelcount,conditions,starttimes,endtime,freq_names,freq,name_i);
% end
% %% PERFORM STATISTICAL ANALYSES
% addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '/massunivariate']));
% conditions = {'repeat','single'}; %'attention',
% frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
% times = {};
% starttime = -200:100:1400;
% endtime   = starttime+200;
% for time_i = 1:length(starttime)
%     times{time_i} = strcat(num2str(starttime(time_i)),'to',num2str(endtime(time_i)));
% end
% % generate list of files to be read in
% filelist{1,(length(names)*length(conditions)*length(times))} = [];
% count = 0;
% for name_i = 1:length(wpms.names)
%     for cond_i = 1:length(conditions)
%         for time_i = 1:length(times)
%             count = count+1;
%             filelist(count) = [wpms.dirs.CWD,wpms.dirs.COHERENCE_DIR,'/',wpms.names{name_i},'/',conditions{cond_i},'/',conditions{cond_i},times{time_i},'_CONECTIVITY_IMAG.mat'];
%         end%time_i loop
%     end%cond_i loop
% end%name_i loop
% clear count name_i cond_i time_i freqstruct condstruct
% 
% %% Export to EEGDisplay:
% % A file for each condition is generated in this section, and is then saved
% % off to EEGDisplay format. The exported file can then be loaded into
% % EEGDisplay.
% % Each Condition per file: (Mat File), (EEGDisplay)\
% 
% wpms.conditions = {'repeat','single'};%'attention',
% wpms.cond = {'rept','sngl'};%'attn',
% 
% wpms.condition_code_values.attn = 1;
% wpms.condition_code_values.sngl = 2;
% wpms.condition_code_values.rept = 3;
% %baseline is from -200 to 0 (stimuli)
% 
% baseline_start = floor(sampling_frequency*0.8);
% baseline_end = floor(sampling_frequency*1.0);
% 
% for name_i =1 %length(wpms.names)
%     patrick_ccm_saveOffIndividualConditions_to_ERP(wpms,wpms.conditions,wpms.cond,wpms.condition_code_values,name_i);
% end

%% PRODUCE TIMELOCK ERP - Not for Coherency analysis %toggle which condition to use
% START AFTER REINTERPOLATION!

for name_i = 1:length(wpms.names)
     condition = '_Alerting'
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

%% Draw TIMELOCK ERP:   %toggle which condition to use
close all;
for name_i = 1:length(wpms.names)
    isreverse_ydir = true; %true or false
     condition = '_Alerting'
     conditions = {'nocue','double','diff'};

%     condition = '_Orienting'
%     conditions = {'center','updown','diff'};

%     condition = '_Executive'
%     conditions = {'incongruent','congruent','diff'};

    channel = 30;
    patrick_ccm_plotERP(wpms,name_i,channel,isreverse_ydir,conditions,condition)
    close all
end
%% TIMELOCK statistics
% define the parameters for the statistical comparison
%     condition = '_Alerting'
%     condition = '_Orienting'
     condition = '_Executive'
    conditions = {'1','2'};
    %cond = {'target','non-target'};





cfg = [];
cfg.channel     = 'MLT12';
cfg.latency     = [0.3 0.7];
cfg.avgovertime = 'yes';
cfg.parameter   = 'avg';
cfg.method      = 'analytic';
cfg.statistic   = 'ft_statfun_depsamplesT';
cfg.alpha       = 0.05;
cfg.correctm    = 'no';

Nsub = 10;
cfg.design(1,1:2*Nsub)  = [ones(1,Nsub) 2*ones(1,Nsub)];
cfg.design(2,1:2*Nsub)  = [1:Nsub 1:Nsub];
cfg.ivar                = 1; % the 1st row in cfg.design contains the independent variable
cfg.uvar                = 2; % the 2nd row in cfg.design contains the subject number

stat = ft_timelockstatistics(cfg, allsubjFIC{:}, allsubjFC{:});   % don't forget the {:}!








%% Compute/plot Grand Average ERP!

 condition.name = '_Executive'
 conditions.erp = {'incongruent','congruent','diff'};

% condition.name = '_Alerting'
% condition.erp = {'nocue','double','diff'};

% condition.name = '_Orienting'
% condition.erp = {'center','updown','diff'}

channel = 'all';

patrick_plot_Grand_Average(wpms,name_i,condition,channel)





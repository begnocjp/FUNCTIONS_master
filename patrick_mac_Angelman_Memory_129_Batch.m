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
wpms.dirs  = struct('CWD','./','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS/','RAW','/INPUTS/RAW/','MAT','/INPUTS/MAT/','preproc','PREPROC_OUTPUT/', 'ERP','ERP/', ...
    'DATA_DIR','EEGLAB_FORMAT/','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR/', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT/','EEGDispOutput','EEGDISPLAY_OUTPUT/', ...
    'TIMELOCK','TIMELOCK/','GA_TIMELOCK','GA_TIMELOCK/');

%wpms.names = {'as_003_memory_ABOM_20170713_124013002'};
wpms.names = dir('./INPUTS/RAW/*');
t = struct2table(wpms.names)
t = t.name
disp(1:length(wpms.names))
wpms.names = {t}
wpms.names{1, 1}(1:3) = []

for i = 1:length(wpms.names{1, 1})
 wpms.names{1, 1}{i, 1} = erase(wpms.names{1, 1}{i, 1},'.raw') 
  wpms.names(1)
end

store = wpms.names
for i = 1:length(wpms.names{1, 1})
 store{1, 1}{i, 1} = erase(store{1, 1}{i, 1},'.raw') 
 store{1, 1}{i, 1} = cellstr(store{1, 1}{i, 1}) 
 wpms.names(i) = store{1, 1}{i, 1} 
end

%                                                                                                                                                                                                                                                                                                                                                                                                                           
cd([wpms.dirs.CWD]);
addpath /Users/patrick/Desktop/fieldtrip-20200423
addpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]);
addpath(genpath(['/Users/patrick/Desktop/eeglab2019_1']))
%addpath(genpath(['/Users/patrick/Desktop/eeglab12_0_2_6b']))
ft_defaults
%addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
% cfg = [];
% cfg.layout = 'GSN129.sfp'
% [cfg] = ft_layoutplot(cfg)
% ft_layout('GSN128.sfp')
% 
% 
  cfg = [];
  cfg.layout = 'GSN129.sfp';
  figure; ft_multiplotER(cfg, trdat);
  
  cfg = [];
  cfg.viewmode = 'vertical';
  artfct       = ft_databrowser(cfg, trdat)
  
  plot(data.time{1}, data.trial{1});
% axis on % this shows the actual MATLAB axes
% 
% cfg = [];
% cfg.channel = 'E128';
% figure; ft_singleplotER(cfg,data);

%chan 129 is reference channel
%% Preprocessing I
%  Import, downsample and re-reference
for name_i = 1:length(wpms.names)
    sampling_frequency = 250; %hz
    [dat] = ccmegi_importeeg_and_downsample(wpms,'raw',name_i,sampling_frequency); % should not need to downsample, may write different function for this.
    
    s = size(dat.trial{1,1}(:,1))
    num_chan = s(1,1)
    if num_chan==129;
       cfg = [];
        cfg.channel= ft_channelselection({'all' '-E129'}, dat.label);
        dat = ft_selectdata(cfg,dat) 
        num_chan=128
    end
    
    [refdat] = fnl_rereference(dat,'all');
    clear dat
    data = ccm_preproc_filter(refdat,'no',[58 62],'yes',50,4,'but','yes',0.5,'onepass',1,'but');
    % no high-pass needed EGI data sampled at 0.1-100 Hz
    % Lowpassing at 30 for ERP, 30-50 for TF
    %
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
    clear refdat data cfg %tidying
end
%% Automatic Bad Channel Rejection

%first convert data to EEGlab structure

addpath(genpath(['/Users/patrick/Desktop/Desktop/eeglab2019_1']))

num_electro = num_chan
if num_chan==256;
    nlabel = 'egi_label_256.mat';
    nlout = 'GSN256.sfp';
    art_thresh_chan=1:256;
elseif num_chan==128;
    nlabel = 'egi_label_128.mat';
    nlout = 'GSN128.sfp';
    art_thresh_chan=1:128;
    
end
for name_i = 1:length(wpms.names)
    patrick_docker_ccm256_auto_chan_reject(wpms,name_i,nlout,num_electro);
end

%% Visual Inspection of Data:
%for name_i = length(wpms.names)   
%    ccm256_bad_channel_inspection(wpms,name_i,100);
%end

%% Remove Good Channels from Data to visualize rejected channels:
for name_i = 1:length(wpms.names)   
    patrick_docker_remove_good_channels(wpms,name_i,nlout);
end

%% Remove Bad Channels out from Data:
for name_i = 1:length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
end

%% Automatic ICA

for name_i = 1:length(wpms.names)
    patrick_docker_ccm256_auto_ica(wpms,name_i,nlout,num_chan) 
end

%% Trial Definition ONLY : Incidental
reject_min = -5000000000000
reject_max = 5000000000000
art_thresh_chan=1:128;

pre_trial = .2; %for target 1 sec on each side, for cue
post_trial = 1; %changed to 2 for inspection
trialfunction = 'TF_Incidental'; %will need to change per task, each task has trial function, will need to edit function for ANT task
file_ext = 'raw';

for name_i = 1:length(wpms.names)
trdat = patrick_docker_incidental(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
end

condition = '_Incidental'
for name_i = 1:length(wpms.names)
    patrick_docker_ccm_artifact_rejection_auto(wpms,name_i,1,30,reject_min,reject_max,condition,art_thresh_chan);
end

for name_i = 1:length(wpms.names)
patrick_docker_ccm256_reinterpolate(wpms,name_i,condition,nlout,nlabel);
end


%low: with this 210 had 132 trials,  122 had wierd trial data
%reject_min = -50000000000
%reject_max = 50000000000
%at this threshold must reject 006,014,108,111,120,126,127,137,203,209,223

%medium
%reject_min = -500000000000
%reject_max = 500000000000
%at this threshold must reject 014,108,127,111,203,209,223


%high
%reject_min = -5000000000000
%reject_max = 5000000000000
%at this threshold must reject 111





%     clear post_trial pre_trial trialfunction
%     clear sample*
%     clear value*
 

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



% Apply scalp current density montage
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS '/CSDtoolbox']));
type = 'egi';
for name_i = 1:length(wpms.names)
    patrick_ccm256_csd_transformation_v2(wpms,name_i,condition,art_thresh_chan,nlabel,num_chan); %,type);
end
%% CONVERT FROM FIELDTRIP TO EEG STRUCT
%SaveOffIndividualConditions;
%SaveOffIndividualConditions_altbiosemicodes;

%These are all the conditions that are present in the code:
conditions = {'sing','rept'}; %'attention',
%shorthand for naming files and data structure:
cond = {'sing','rept'}; %'attn'

% condition_code_values.attn = 1;
condition_code_values.sing = 1;
condition_code_values.rept = 2;
wpms.sampling_frequency = 250;

for name_i =1:length(wpms.names)
    fnl_saveOffIndividualConditions(wpms,conditions,cond,condition_code_values,name_i);
    patrick_fnl_setup_eegstructure(wpms,conditions,cond,name_i);
end
%% Begin FFT
% add eeglab to path
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '/eeglab']));
%times = -1000:4:2000;
times = -700:4:1500; %some padding to help prevent edge artifacts
windowsize = 20;
bins = 80;
freqrange = [2 30];
channels = 1:128;
conditions = [{'sing'},{'rept'}]; %{'attention'},
for name_i = 1:length(wpms.names)
    fprintf('\n%s\t', wpms.names{name_i})
    patrick_fnl_wavelet_analysis_v2(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i);
end


%% IMAGINARY COHERENCE ANALYSIS
channels = 1:256;
conditions = {'repeat','single'}; %'attention',
for name_i = 1%:length(wpms.names)
    patrick_fnl_imaginarycoherence_analysis(wpms,channels,conditions,name_i)
end
%% GENERATE CONNECTIVITY MATRICES
channelcount = 256;
freq_names = {'delta','theta','alpha','beta'};
freq = [{1:18},{19:31},{35:49},{50:68}];
conditions = {'repeat','single'}; %'attention',
for name_i = 1%:length(wpms.names)
    starttimes = 400:200:3600;
    endtime = 600;
    patrick_fnl_genconnmatrix(wpms,channelcount,conditions,starttimes,endtime,freq_names,freq,name_i);
end
%% PERFORM STATISTICAL ANALYSES
addpath(genpath([wpms.dirs.CWD, '/mass_uni_toolbox']));
conditions = {'repeat','single'}; %'attention',
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
times = {};
starttime = -200:100:1400;
endtime   = starttime+200;
for time_i = 1:length(starttime)
    times{time_i} = strcat(num2str(starttime(time_i)),'to',num2str(endtime(time_i)));
end
% generate list of files to be read in
filelist{1,(length(wpms.names)*length(conditions)*length(times))} = [];
count = 0;
for name_i = 1:length(wpms.names)
    for cond_i = 1:length(conditions)
        for time_i = 1:length(times)
            count = count+1;
            filelist(count) = [wpms.dirs.CWD,wpms.dirs.COHERENCE_DIR,'/',wpms.names{name_i},'/',conditions{cond_i},'/',conditions{cond_i},times{time_i},'_CONECTIVITY_IMAG.mat'];
        end%time_i loop
    end%cond_i loop
end%name_i loop
clear count name_i cond_i time_i freqstruct condstruct

%% Export to EEGDisplay:
% A file for each condition is generated in this section, and is then saved
% off to EEGDisplay format. The exported file can then be loaded into
% EEGDisplay.
% Each Condition per file: (Mat File), (EEGDisplay)\

wpms.conditions = {'repeat','single'};%'attention',
wpms.cond = {'rept','sngl'};%'attn',

wpms.condition_code_values.attn = 1;
wpms.condition_code_values.sngl = 2;
wpms.condition_code_values.rept = 3;
%baseline is from -200 to 0 (stimuli)

baseline_start = floor(sampling_frequency*0.8);
baseline_end = floor(sampling_frequency*1.0);

for name_i =1 %length(wpms.names)
    patrick_ccm_saveOffIndividualConditions_to_ERP(wpms,wpms.conditions,wpms.cond,wpms.condition_code_values,name_i);
end

%% PRODUCE TIMELOCK ERP - Not for Coherency analysis %toggle which condition to use
% START AFTER REINTERPOLATION!

for name_i = 1:length(wpms.names)
  %     condition = '_Alerting'
  %     condition = '_Executive'
        condition = '_Orienting'
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

%% Draw TIMELOCK butterfly ERP:   %toggle which condition to use
close all;
for name_i = 1:length(wpms.names)
    isreverse_ydir = true; %true or false
% 
%     condition = '_Alerting'
%      conditions = {'nocue','double','diff'};
% 
%     condition = '_Orienting'
%     conditions = {'center','updown','diff'};

     condition = '_Executive'
     conditions = {'incongruent','congruent','diff'};

     %Toggle channels used as ROIs for Butterfly
% chan = [22,14,23,15,6,16,7];
%       ROI  = 'frontal'
% chan  = [9,186,45,132,81,80,131];
%         ROI  = 'central'
chan  = [100,129,101,110,128,119];
      ROI  = 'parietal'
%  chan  = [137,115,123,158,159];
%       ROI  = 'occipital'

%creating struct for chan 'for loop'
  
% chan = struct('roi',{[22,14,23,15,6,16,7]},'location',{'frontal'}) %frontal
% chan(2).roi = [9,186,45,132,81,80,131]          %central
% chan(2).location = 'central'
% chan(3).roi = [100,129,101,110,128,119]         %pari
% chan(3).location = 'parietal'
% chan(4).roi = [137,115,123,158,159]             %occip
% chan(4).location = 'occipital'

    patrick_ccm_plotERP_ROIs_v2(wpms,name_i,isreverse_ydir,conditions,condition,ROI,chan)
    close all
end
%% Draw ROI mean TIMELOCK ERP:   %toggle which condition to use
close all;
for name_i = 1:length(wpms.names)
    isreverse_ydir = 'true'; %true or false
% 
%     condition = '_Alerting'
%     conditions = {'nocue','double','diff'};

%     condition = '_Orienting'
%     conditions = {'center','updown','diff'};

     condition = '_Executive'
     conditions = {'incongruent','congruent','diff'};

     %Toggle channels used as ROIs for Butterfly
% chan = [22,14,23,15,6,16,7];
%       ROI  = 'frontal'
% chan  = [9,186,45,132,81,80,131];
%         ROI  = 'central'
% chan  = [100,129,101,110,128,119];
%       ROI  = 'parietal'
chan  = [137,115,123,158,159];
      ROI  = 'occipital'

   
    patrick_ccm_plot_mean_ERP_ROIs_v2(wpms,name_i,isreverse_ydir,conditions,condition,chan,ROI)
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








%% Plot Grand Average N2/P3 ERP 

condition = []
condition.roi = [22,14,23,15,6,16,7]
condition.chan = 'frontal'

% condition.roi = [9,186,45,132,81,80,131]
% condition.chan = 'central'
% % 
% condition.roi = [100,129,101,110,128,119]
% condition.chan =  'parietal'

% condition.roi = [137,115,123,158,159]
% condition.chan = 'occipital'


% condition.name = '_Alerting'
% condition.erp = {'nocue','double','diff'};


% condition.name = '_Orienting'
% condition.erp = {'center','updown','diff'}

 condition.name = '_Executive'
 condition.erp = {'incongruent','congruent','diff'};


 

patrick_plot_Grand_Average(wpms,name_i,condition)


%% Compute peak latency N2/P3/P1 ERP values
%ERP Latency (samples of trial portion used to compute average amplitude)
% P3_lat = 195:1:205
% N2_lat = 170:1:180
%wider range used for avg amplitude ERP calculation
%N2 150ms to 300ms (650ms to 800ms accounting for 500ms baseline)(650/4 to 800/4)
%P3 250 to 450 ms  (750ms to 950ms accounting for 500ms baseline)(750/4 to 950/4)
%P1 0 to 200 
N2_lat = [162:1:200] % 0ms - 200ms
P3_lat = [187:1:238]
P1_lat = [125:1:175]

%Channels used as ROIs (must use multiple channels?) GSN - 128
front_chan = [19,10,20,11,4,12,5];
cent_chan  = [7,107,32,81,54,55,80];
pari_chan  = [67,73,78,72,76,77];

% %Channels used as ROIs (must use multiple channels?) GSN - 256
% front_chan = [22,14,23,15,6,16,7];
% cent_chan  = [9,187,44,133,79,80,132];
% pari_chan  = [99,111,130,110,120,129];
% 
% %hydrocel rois - 256
% front_chan = [22,14,23,15,6,16,7];
% cent_chan  = [9,186,45,132,81,80,131];
% pari_chan  = [100,129,101,110,128,119];
% occip_chan  = [137,115,123,158,159];


patrick_compute_ERP_latency(wpms,name_i,N2_lat,P3_lat,P1_lat,front_chan,cent_chan,pari_chan,occip_chan)
%
%% Compute/plot Average N2/P3/P1 ERP values
% 
%  condition.name = '_Alerting'
%  condition.erp = {'nocue','double','diff'};

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
%P1 0 to 200 ms    (500ms to 700ms accounting for 500ms baseline)

% N2_lat = [162:1:200]
% P3_lat = [187:1:238]
% P1_lat = [125:1:175]
% N1_lat = [125:1:175]
% N1_lat = [137:1:163] % 50ms - 150ms 


%Channels used as ROIs (must use multiple channels?)
front_chan = [22,14,23,15,6,16,7];
cent_chan  = [9,186,45,132,81,80,131];
pari_chan  = [100,129,101,110,128,119];
occip_chan  = [137,115,123,158,159];


patrick_compute_avg_ERP_peak_v3(wpms,name_i)
%(wpms,name_i,N2_lat,P3_lat,P1_lat,front_chan,cent_chan,pari_chan,occip_chan)
% 



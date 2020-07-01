%% Incidental Memory Batch
%  Adapted by Patrick Cooper and Aaron Wong
%  May - 2014, Functional Neuroimaging Laboratory
%  Modified by Alexander Conley - December 2016
%% Set-up working parameters
close all
clear all
warning off;
wpms       = [];%working parameters
wpms.dirs  = struct('CWD','E:\fieldtrip\','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS\','RAW','RAW\','preproc','PREPROC_OUTPUT\', ...
    'DATA_DIR','EEGLAB_FORMAT\','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR\', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT\','EEGDispOutput','EEGDISPLAY_OUTPUT\');

% wpms.names = {'wc01_scenes_002','wc115_scenes_002','wc1102_scenes_002','wc1103_scenes_002','wc1104_scenes_002',...
%     'wc1105_scenes_002','wc1107_scenes_002','wc1108_scenes_002','wc1109_scenes_002',...
%     'wc1110_scenes_002','wc1111_scenes_002','wc1112_scenes_002','wc1113_scenes_002','wc1114_scenes_002','wc1115_scenes_002',...
%     'wc1116_scenes_002','wc1117_scenes_002','wc1118_scenes_002','wc1119_scenes_002','wc1120_scenes_002','wc1121_scenes_002',...
%     'wc1122_scenes_002','wc1123_scenes_002','wc1124_scenes_002','wc1125_scenes_002','wc1126_scenes_002','wc1128_scenes_002',...
%     'wc1129_scenes_002','wc1130_scenes_002','wc1131_scenes_002'}; %	'wc1106_scenes_002',

wpms.names = {'CD_07_nonword002','rett06_nonword002'};

% wpms.names = {'wc01_scenes_epoched'};

% wpms.names = {'wlb101_memory t1002','wlb101_memory_t2002','jal_102_memory_t1002','JAL_102_mem_t2002','SMM-103_mem_t1002',...
%     'SMM_103_mem_t2002','MBC104_mem_t1002','MBC104_mem_t2002','JCS_105_memory_t1_002','JCS105_mem_t2_002',...
%     'GES106_mem_t1_002','GES106_mem_t2_002','RTU107_mem_t1_002','RTU107_mem_t2_002','GLS108_mem_t1_002','GLS108_mem_t2_002',...
%     'TJB201_mem_t1_002','TJB201_mem_t2_002','J-K203_mem_t1_002','J-K203_mem_t2_002','BRM204_mem_t1_002',...
%     'BRM204_mem_t2_002','RKT205_mem_t1_002','RKT205_mem_t2_002','MDL206_mem_t1_002','MDL206_mem_t2_002',...
%     'SNE207_mem_t1_002','207SNE_mem_t2_002','CE208_mem_t1_002','CE208_mem_t2_002',...
%     'CMB301_mem_t1_002','CMB301_mem_t2_002','DSK302_mem_t1_002','DSK302_mem_t2_002','KAL303_mem_t1_002',...
%     'KAL303_mem_t2_002','DMG304_mem_t1_002','DMG304_mem_t2_002','WMS305_mem_t1_002','WMS305_mem_t2_002',...
%     'DJK306_mem_t1_002','DJK306_mem_t2_002','TAG307_mem_t1_002','TAG307_mem_t2_002',...
%     'GGL308_mem_t1_002','GGL308_mem_t2_002','JWL401_mem_t1_002','JWL401_mem_t2_002','PHD402_mem_t1_002','PHD402_mem_t2_002',...
%     'JCC403_mem_t1_002','JCC403_mem_t2_002','DFM404_mem_t1_002','DFM404_mem_t2_002','MLM405_mem_t1_002','MLM405_mem_t2_002',...
%     'MBC406_mem_t1_002','MBC406_mem_t2_002','BMT407_mem_t1_002','BMT407_mem_t2_002','RWD408_mem_t1_002',...
%     'RWD408_mem_t2_002','DAB501_mem_t1_002','DAB501_mem_t2_002','DJR502_mem_t1_002','DJR502_mem_t2_002',...
%     'DLN503_mem_t1_002','DLN503_mem_t2_002','SKM504_mem_t1_002','SKM504_mem_t2_002','DMS505_mem_t1_002',...
%     'DMS505_mem_t2_002','AMJ506_mem_t1_002','AMJ506_mem_t2_002','CMW507_mem_t1_002','CMW507_mem_t2_002',...
%     'JNH508_mem_t1_002','JNH508_mem_t2_002'};

% add path
cd([wpms.dirs.CWD]);
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
%% Preprocessing I
%  Import, downsample and re-reference
for name_i = 1:2 %length(wpms.names)
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

%% Visual Inspection of Data:
for name_i = 1 %length(wpms.names)   
    ccm_bad_channel_inspection(wpms,name_i,100);
end

%% Remove Bad Channels out from Data:
for name_i = 1 %length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
end

%% Trial Definition and ICA
for name_i = 2%:length(wpms.names)   
    pre_trial = 1.0;
    post_trial = 2.0;
    trialfunction = 'Incident_M'; 
    file_ext = 'raw';
    trdat = ccm_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);
    clear post_trial pre_trial trialfunction
    ccm_ICA(wpms,name_i,trdat);        
end
%% Remove EOG Components from ICA
for name_i = 1%:length(wpms.names)
    ccm_ICA_inspection(wpms,name_i);
end
%% Apply artifact rejection
for name_i = 1%:length(wpms.names)
    ccm_artifact_rejection_auto(wpms,name_i,true,50,-150,150)
end

%% Reinterpolate bad channels
for name_i = 1:length(wpms.names)
    ccm_reinterpolate(wpms,name_i);
end

%% IMPORT EPOCHED DATA FROM NETSTATION

for name_i = 1%:length(wpms.names)
    sampling_frequency = 250; %hz
    [dat] = ccmegi_importepoched(wpms,'raw',name_i,sampling_frequency); % should not need to downsample, may write different function for this.
    [refdat] = fnl_rereference(dat,'all');
    
    clear dat
    
    [data] = ccm_preproc_filter(refdat,'no',[58 62],'yes',50,4,'but','yes',0.1,'onepass',1,'but'); 
% no high-pass needed EGI data sampled at 0.1-100 Hz
% Lowpassing at 30 for ERP, 30-50 for TF
% 
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
    clear refdat data cfg %tidying
end



%% Apply scalp current density montage
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\CSDtoolbox']));
type = 'egi';
for name_i = 1:length(wpms.names)
    ccm_csd_transformation_v2(wpms,name_i); %,type);
end
%% CONVERT FROM FIELDTRIP TO EEG STRUCT
%SaveOffIndividualConditions;
%SaveOffIndividualConditions_altbiosemicodes;

%These are all the conditions that are present in the code:
conditions = {'single','repeat'}; %'attention',
%shorthand for naming files and data structure:
cond = {'sngl','rept'}; %'attn'

% condition_code_values.attn = 1;
condition_code_values.sngl = 2;
condition_code_values.rept = 3;
wpms.sampling_frequency = 250;

for name_i =1:length(wpms.names)
    fnl_saveOffIndividualConditions(wpms,conditions,cond,condition_code_values,name_i);
    fnl_setup_eegstructure(wpms,conditions,cond,name_i);
end
%% Begin FFT
% add eeglab to path
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\eeglab']));
times = -1000:4:2000;
windowsize = 20;
bins = 80;
freqrange = [2 50];
channels = 1:128;
conditions = [{'single'},{'repeat'}]; %{'attention'},
for name_i = 1:length(wpms.names)
    fprintf('\n%s\t', wpms.names{name_i})
    fnl_wavelet_analysis_v2(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i);
end
%% IMAGINARY COHERENCE ANALYSIS
channels = 1:128;
conditions = {'repeat','single'}; %'attention',
for name_i = 1%:length(wpms.names)
    fnl_imaginarycoherence_analysis(wpms,channels,conditions,name_i)
end
%% GENERATE CONNECTIVITY MATRICES
channelcount = 128;
freq_names = {'delta','theta','alpha','beta'};
freq = [{1:18},{19:31},{35:49},{50:68}];
conditions = {'repeat','single'}; %'attention',
for name_i = 1%:length(wpms.names)
    starttimes = 400:200:3600;
    endtime = 600;
    fnl_genconnmatrix(wpms,channelcount,conditions,starttimes,endtime,freq_names,freq,name_i);
end
%% PERFORM STATISTICAL ANALYSES
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\massunivariate']));
conditions = {'repeat','single'}; %'attention',
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
times = {};
starttime = -200:100:1400;
endtime   = starttime+200;
for time_i = 1:length(starttime)
    times{time_i} = strcat(num2str(starttime(time_i)),'to',num2str(endtime(time_i)));
end
% generate list of files to be read in
filelist{1,(length(names)*length(conditions)*length(times))} = [];
count = 0;
for name_i = 1:length(wpms.names)
    for cond_i = 1:length(conditions)
        for time_i = 1:length(times)
            count = count+1;
            filelist(count) = [wpms.dirs.CWD,wpms.dirs.COHERENCE_DIR,'\',wpms.names{name_i},'\',conditions{cond_i},'\',conditions{cond_i},times{time_i},'_CONECTIVITY_IMAG.mat'];
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

% wpms.condition_code_values.attn = 1;
wpms.condition_code_values.sngl = 2;
wpms.condition_code_values.rept = 3;
%baseline is from -200 to 0 (stimuli)

baseline_start = floor(sampling_frequency*0.8);
baseline_end = floor(sampling_frequency*1.0);

for name_i =26:30%length(wpms.names)
    ccm_saveOffIndividualConditions_to_ERP(wpms,wpms.conditions,wpms.cond,wpms.condition_code_values,name_i);
end

%% PRODUCE TIMELOCK ERP - Not for Coherency analysis
% START AFTER REINTERPOLATION!

for name_i = 1:3 %length(wpms.names)
    conditions = {'attention','repeat','single'};
    cond = {'attn','rept','sgnl'};
    
    condition_code_values.attn = 1;
    condition_code_values.sngl = 2;
    condition_code_values.rept = 3;
    %baseline is from -200 to 0 (stimuli)
    
    baseline_start = floor(sampling_frequency*0.8);
    baseline_end = floor(sampling_frequency*1.0);
    for cond_i = 1:length(conditions)
        timelock.(conditions{cond_i}) = fnl_timelockanalysis(wpms,name_i,conditions{cond_i},baseline_start,baseline_end);
    end;
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK.mat'],'timelock*','-v7.3');
    clear timelock*
end

%% Draw TIMELOCK ERP:
close all;
for name_i = 1%:length(wpms.names)
    isreverse_ydir = true; %true or false
    channel = 30;
    ccm_plotERP(wpms,name_i,channel,isreverse_ydir)
end
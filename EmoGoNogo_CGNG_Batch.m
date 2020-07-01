%% CCM Emotional Go-Nogo Batch
%  Adapted by Patrick Cooper and Aaron Wong
%  May - 2014, Functional Neuroimaging Laboratory
%  Modified by Alexander Conley - June 2017
%% Set-up working parameters
close all
clear all
warning off;
wpms       = [];%working parameters
wpms.dirs  = struct('CWD','E:\fieldtrip\','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS\','RAW','RAW\','preproc','PREPROC_OUTPUT\', ...
    'DATA_DIR','EEGLAB_FORMAT\','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR\', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT\','EEGDispOutput','EEGDISPLAY_OUTPUT\');


wpms.names = {'S01_A_002','S01_B_002','S02_A_G002','S02_B_002','S03_A_002','S03_B_002','S04_A_002','S04_B_002','S05_A_002',...,
    'S05_B_002','S06_A_002','S06_B_002','S07_A_002','S07_B_002','S08_A_002','S08_B_002','S09_A_002','S09_B_002'};
    

% add path
cd([wpms.dirs.CWD]);
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
%% Preprocessing I
%  Import, downsample and re-reference
for name_i = 1%:length(wpms.names)
    sampling_frequency = 250; %hz
    [dat] = ccmegi_importeeg_and_downsample(wpms,'raw',name_i,sampling_frequency); % should not need to downsample, may write different function for this.
    [refdat] = fnl_rereference(dat,'all');
    
    clear dat
    
%     [data] = ccm_bandstop_filter(refdat,'no',[58 62]); % no high-pass needed EGI data sampled at 0.1-100 Hz
    [data] = ccm_preproc_filter(refdat,'no',[58 62],'yes',50,4,'but','yes',0.1,'onepass',1,'but');
    
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
    clear refdat data cfg %tidying
end

%% Visual Inspection of Data:
for name_i = 1%:length(wpms.names)   
    ccm_bad_channel_inspection(wpms,name_i,100);
    %LIST ALL CHANNELS AS E# OR THEY WILL NOT BE REMOVED
end

%% Remove Bad Channels out from Data:
for name_i = 1%:length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
end

%% Trial Definition and ICA
for name_i = 1%:length(wpms.names)   
    pre_trial = 2.5;
    post_trial = 2.5;
    trialfunction = 'emoGNG'; 
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
    ccm_artifact_rejection_auto(wpms,name_i,true,30,-150,150)
end

%% Reinterpolate bad channels
for name_i = 1%:length(wpms.names)
    ccm_reinterpolate(wpms,name_i);
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
conditions = {'leftgo','rightgo','nogo'};
%shorthand for naming files and data structure:
cond = {'ltar','rtar','nogo'};

condition_code_values.ltar = 1;
condition_code_values.rtar = 2;
condition_code_values.nogo = 3;
wpms.sampling_frequency = 250;

for name_i =1:length(wpms.names)
    ccm_saveOffIndividualConditions_to_ERP(wpms,conditions,cond,condition_code_values,name_i);
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
conditions = [{'leftgo'},{'rightgo'},{'nogo'}];
for name_i = 1:length(wpms.names)
    fprintf('\n%s\t', wpms.names{name_i})
    fnl_wavelet_analysis_v2(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i);
end
%% IMAGINARY COHERENCE ANALYSIS
channels = 1:128;
conditions = {'leftgo','rightgo','nogo'};
for name_i = 1%:length(wpms.names)
    fnl_imaginarycoherence_analysis(wpms,channels,conditions,name_i)
end
%% GENERATE CONNECTIVITY MATRICES
channelcount = 128;
freq_names = {'delta','theta','loweralpha','upperalpha','beta'};
freq = [{1:18},{19:31},{35:40},{41:47},{48:68}];
conditions = {'leftgo','rightgo','nogo'};
for name_i = 1%:length(wpms.names)
    starttimes = 400:200:3600;
    endtime = 600;
    fnl_genconnmatrix(wpms,channelcount,conditions,starttimes,endtime,freq_names,freq,name_i);
end
%% PERFORM STATISTICAL ANALYSES
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\massunivariate']));
conditions = {'leftgo','rightgo','nogo'};
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
% off to .ERP format. The exported file can then be loaded into EEGDisplay.
% Each Condition per file: (Mat File), (EEGDisplay)\

wpms.conditions = {'leftgo','rightgo','nogo'};
wpms.cond = {'ltar','rtar','nogo'};

wpms.condition_code_values.ltar = 1;
wpms.condition_code_values.rtar = 2;
wpms.condition_code_values.nogo = 3;
%baseline is from -200 to 0 (stimuli)
sampling_frequency = 250;

baseline_start = floor(sampling_frequency*0.8);
baseline_end = floor(sampling_frequency*1.0);

for name_i =1%:length(wpms.names)
    ccm_saveOffIndividualConditions_to_ERP(wpms,wpms.conditions,wpms.cond,wpms.condition_code_values,name_i);
end

%% PRODUCE TIMELOCK ERP - Not for Coherency analysis

for name_i = 1:length(wpms.names)
    conditions = {'leftgo','rightgo','nogo'};
    cond = {'ltar','rtar','nogo'};
    
    condition_code_values.attn = 1;
    condition_code_values.sngl = 2;
    condition_code_values.rept = 3;
    %baseline is from -200 to 0 (cue)
    % We know that Data starts is 1 second before Cue. (512)
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
    fnl_plotERP(wpms,name_i,channel,isreverse_ydir)
end
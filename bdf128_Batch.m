%% BioSemi 128-channel batch script
%  Adapted by Patrick Cooper and Aaron Wong
%  May - 2014, Functional Neuroimaging Laboratory
%  Modified by Alexander Conley - August 2019
%% Set-up working parameters
close all
clear all
warning off;
wpms       = [];%working parameters
wpms.dirs  = struct('CWD','E:\fieldtrip\','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS\','RAW','RAW\','preproc','PREPROC_OUTPUT\', ...
    'DATA_DIR','EEGLAB_FORMAT\','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR\', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT\','EEGDispOutput','EEGDISPLAY_OUTPUT\');

wpms.names = {'Subject1_AERP_SERP','Subject2_AERP'}; %	'Subject3_AERP';'PilotSubjectSERP'
    

% add path
cd([wpms.dirs.CWD]);
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
%% Preprocessing I
%  Import, downsample and re-reference
for name_i = 1%:length(wpms.names)
    sampling_frequency = 512; %hz SAMPLE in 1024!
    [dat] = bdf128_importeeg_and_downsample(wpms,'bdf',name_i,sampling_frequency);
    [refdat] = fnl_rereference(dat,'all');
    
    clear dat
    
    [data] = fnl_preproc_filter(refdat,'yes',[58 62],'yes',0.1,'onepass',1,'but'); % Older batch used 0.02 Hz hi-pass, will chech whether we need to change back.
    
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
    clear refdat data cfg %tidying
end

%% Visual Inspection of Data:
for name_i = 2%:length(wpms.names)   
    bdf128_bad_channel_inspection(wpms,name_i,50);
end

%% Remove Bad Channels out from Data:
for name_i = 2%:length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
end

%% Trial Definition and ICA
for name_i = 2%:length(wpms.names)   
    pre_trial = 1.0;
    post_trial = 4.0;
    trialfunction = 'tourette_aud'; % ' tourette_tact
    trdat = fnl_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial);
    clear post_trial pre_trial trialfunction
    bdf_tourette_ICA(wpms,name_i,trdat);        
end
%% Remove EOG Components from ICA
for name_i = 2%:length(wpms.names)
    bdf128_ICA_inspection(wpms,name_i);
end
%% Apply artifact rejection
for name_i = 2%:length(wpms.names)
    bdf128_artifact_rejection_auto(wpms,name_i,true,50,-200,200)% Start at -100/100
end

%% Reinterpolate bad channels
for name_i = 2%:length(wpms.names)
    bdf128_reinterpolate(wpms,name_i);
end
%% Apply scalp current density montage
% Issues with running this on the bdf128 files
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\CSDtoolbox']));
for name_i = 2%:length(wpms.names)
    bdf128_csd_transformation_v2(wpms,name_i);
end
%% CONVERT FROM FIELDTRIP TO EEG STRUCT
%SaveOffIndividualConditions;
%SaveOffIndividualConditions_altbiosemicodes;
sampling_frequency = 512;
%These are all the conditions that are present in the AUD task:
conditions = {'long','short','vis'};
%shorthand for naming files and data structure:
cond = {'ln','sh','vz'};
% 
condition_code_values.ln = 71;
condition_code_values.sh = 81;
condition_code_values.vz = 50;

%These are all the conditions that are present in the TACT task:
% conditions = {'long','long_sham','short','short_sham','vis'};
%shorthand for naming files and data structure:
% cond = {'ln','lns','sh','shs','vz'};

% condition_code_values.ln = 11;
% condition_code_values.lns = 15;
% condition_code_values.sh = 21;
% condition_code_values.shs = 25;
% condition_code_values.vz = 50;

%condition_code_values.ni = [167 168 169 170 177 178 179 180 187 188 189 190 ...
%                            65447 65448 65449 65450 65457 65458 65459 65460 65467 65468 65469 65470];
for name_i =2%:length(wpms.names)
    bdf128_saveOffIndividualConditions(wpms,conditions,condition_code_values,cond,name_i,sampling_frequency);
    fnl_setup_eegstructure(wpms,conditions,cond,name_i);
end
%% Begin FFT
% add eeglab to path
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\eeglab']));
times = -900:0.5:4000;
windowsize = 20;
bins = 53;
freqrange = [2 55];
channels = 1:128;
conditions = [{'long'},{'short'},{'vis'}]; % AUD
% conditions = [{'long'},{'long_sham'},{'short'},{'short_sham'},{'vis'}]; %TACT

for name_i = 1%:length(wpms.names)
    fprintf('\n%s\t', wpms.names{name_i})
    bdf128_wavelet_analysis(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i);
end
%% IMAGINARY COHERENCE ANALYSIS
channels = 1:128;
conditions = {'long','short','vis'};
for name_i = 1%:length(wpms.names)
    bdf128_imaginarycoherence_analysis(wpms,channels,conditions,name_i)
end
%% GENERATE CONNECTIVITY MATRICES
channelcount = 128;
freq_names = {'delta','theta','loweralpha','upperalpha','beta'};
freq = [{1:18},{19:31},{35:40},{41:47},{48:68}];
conditions = {'long','short','vis'};
for name_i = 1:length(wpms.names)
    starttimes = 400:200:3600;
    endtime = 600;
    fnl_genconnmatrix(wpms,channelcount,conditions,starttimes,endtime,freq_names,freq,name_i);
end
%% PERFORM STATISTICAL ANALYSES
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\massunivariate']));
conditions = {'long','short','vis'};
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

%% Export to ERPformat:
% A file for each condition is generated in this section, and is then saved
% off to EEGDisplay format. The exported file is a .erp can then be loaded
% into EEGDisplay.
% Each Condition per file: (Mat File), (EEGDisplay)\

wpms.conditions = {'long','short','vis'};
%shorthand for naming files and data structure:
wpms.cond = {'ln','sh','vz'};
% 
wpms.condition_code_values.ln = 71;
wpms.condition_code_values.sh = 81;
wpms.condition_code_values.vz = 50;

%These are all the conditions that are present in the TACT task:
% wpms.conditions = {'long','long_sham','short','short_sham','vis'};
%shorthand for naming files and data structure:
% wpms.cond = {'ln','lns','sh','shs','vz'};

% wpms.condition_code_values.ln = 11;
% wpms.condition_code_values.lns = 15;
% wpms.condition_code_values.sh = 21;
% wpms.condition_code_values.shs = 25;
% wpms.condition_code_values.vz = 50;

wpms.sampling_frequency = 512;

for name_i =1:length(wpms.names)
    ccm_saveOffIndividualConditions_to_ERP(wpms,wpms.conditions,wpms.cond,wpms.condition_code_values,name_i);
end

%% PRODUCE TIMELOCK ERP - Not for Coherency analysis

for name_i = 1:length(wpms.names)
    conditions = {'dirleft','dirright','nondirleft','nondirright'};
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
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
    'COHERENCE_DIR','IMAGCOH_OUTPUT\');
wpms.names = {'DCR101']; %	'wc1116_scenes','wc1121_scenes','wc1125_scenes','wc1131_scenes';
    

% add path
cd([wpms.dirs.CWD]);
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
%% Preprocessing I
%  Import, downsample and re-reference
for name_i = 1:length(wpms.names)
    sampling_frequency = 512; %hz
    [dat] = fnl_importeeg_and_downsample(wpms,'bdf',name_i,sampling_frequency);
    [refdat] = fnl_rereference(dat,48);
    
    clear dat
    
    [data] = fnl_preproc_filter(refdat,'yes',[48 52],'yes',0.1,'onepass',1,'but'); % Older batch used 0.02 Hz hi-pass, will chech whether we need to change back.
    
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
    clear refdat data cfg %tidying
end

%% Visual Inspection of Data:
for name_i = [41]%1:length(wpms.names)   
    fnl_bad_channel_inspection(wpms,name_i);
end

%% Remove Bad Channels out from Data:
for name_i = 1:length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
end

%% Trial Definition and ICA
for name_i = 1:length(wpms.names)   
    pre_trial = 1.0;
    post_trial = 4.0;
    trialfunction = 'Conflict_v2'; 
    trdat = fnl_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial);
    clear post_trial pre_trial trialfunction
    fnl_ICA(wpms,name_i,trdat);        
end
%% Remove EOG Components from ICA
for name_i = 1:length(wpms.names)
    fnl_ICA_inspection(wpms,name_i);
end
%% Apply artifact rejection
for name_i = 1:length(wpms.names)
    fnl_artifact_rejection_auto(wpms,name_i,true,30,-150,150)%Changed to -150/150 as in downsampled batch
end

%% Reinterpolate bad channels
for name_i = 1:length(wpms.names)
    fnl_reinterpolate_v2(wpms,name_i);
end
%% Apply scalp current density montage
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\CSDtoolbox']));
for name_i = 1:length(wpms.names)
    fnl_csd_transformation(wpms,name_i);
end
%% CONVERT FROM FIELDTRIP TO EEG STRUCT
%SaveOffIndividualConditions;
%SaveOffIndividualConditions_altbiosemicodes;

%These are all the conditions that are present in the code:
conditions = {'dirleft','dirright','nondirleft','nondirright','nogo'};
%shorthand for naming files and data structure:
cond = {'dl','dr','nl','nr', 'ng'};

condition_code_values.dl = [21];
condition_code_values.dr = [32];
condition_code_values.nl = [11];
condition_code_values.nr = [12];
condition_code_values.ng = [20 30];

%These are all possible codes for a condition that we would like to group
%together:
%condition_code_values.mr = [161 162 171 172 181 182 65441 65442 65451 65452 65461 65462];
%condition_code_values.st = [163 164 173 174 183 184 65443 65444 65453 65454 65463 65464];
%condition_code_values.sa = [165 166 175 176 185 186 65445 65446 65455 65456 65465 65466];
%condition_code_values.ni = [167 168 169 170 177 178 179 180 187 188 189 190 ...
%                            65447 65448 65449 65450 65457 65458 65459 65460 65467 65468 65469 65470];
for name_i =1:length(wpms.names)
    fnl_saveOffIndividualConditions(wpms,conditions,cond,condition_code_values,name_i);
    fnl_setup_eegstructure(wpms,conditions,cond,name_i);
end
%% Begin FFT
% add eeglab to path
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\eeglab']));
times = -900:0.5:4000;
windowsize = 20;
bins = 80;
freqrange = [2 50];
channels = 1:64;
conditions = [{'dirleft'},{'dirright'},{'nondirleft'},{'nondirright'},{'nogo'}];
for name_i = 1:length(wpms.names)
    fprintf('\n%s\t', wpms.names{name_i})
    fnl_wavelet_analysis_v2(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i);
end
%% IMAGINARY COHERENCE ANALYSIS
channels = 1:64;
conditions = {'dirleft','dirright','nondirleft','nondirright'};
for name_i = 150:length(wpms.names)
    fnl_imaginarycoherence_analysis(wpms,channels,conditions,name_i)
end
%% GENERATE CONNECTIVITY MATRICES
channelcount = 64;
freq_names = {'delta','theta','loweralpha','upperalpha','beta'};
freq = [{1:18},{19:31},{35:40},{41:47},{48:68}];
conditions = {'dirleft','dirright','nondirleft','nondirright'};
for name_i = 1:length(wpms.names)
    starttimes = 400:200:3600;
    endtime = 600;
    fnl_genconnmatrix(wpms,channelcount,conditions,starttimes,endtime,freq_names,freq,name_i);
end
%% PERFORM STATISTICAL ANALYSES
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\massunivariate']));
conditions = {'dirleft','dirright','nondirleft','nondirright'};
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
%% Age-ility Processing Pipeline
%  Adapted by Patrick Cooper and Aaron Wong
%  May - 2014, Functional Neuroimaging Laboratory
%% Set-up working parameters
close all
clear all
warning off;
wpms       = [];%working parameters
wpms.dirs  = struct('CWD','F:\FNL_EEG_TOOLBOX\','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS\','RAW','RAW\','preproc','PREPROC_OUTPUT\', ...
    'DATA_DIR','EEGLAB_FORMAT\','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR\', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT\');
wpms.names = {'AGE121' 'AGE122' 'AGE123'  ... %'AGE043' 'AGE048'...
'AGE124' 'AGE128' 'AGE129' 'AGE130' 'AGE131'...
'AGE133' 'AGE134' 'AGE136' 'AGE138' 'AGE146'...
'AGE147' 'AGE148' 'AGE149' 'AGE150' 'AGE151' 'AGE152'...
'AGE153' 'AGE155' 'AGE156' 'AGE158' 'AGE159' 'AGE161'... 
'AGE162' 'AGE164' 'AGE165' 'AGE166' 'AGE167' 'AGE168'...
'AGE169' 'AGE170' 'AGE172' 'AGE175' 'AGE176' 'AGE177'... 
'AGE178' 'AGE180' 'AGE181' 'AGE182' 'AGE184' 'AGE185'...
'AGE186' 'AGE187' 'AGE195'};%AGE079 still has problems with empty files
% add path
cd([wpms.dirs.CWD]);
addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
%% Preprocessing I
%  Import, downsample and re-reference
for name_i = 14:length(wpms.names)
    sampling_frequency = 512; %hz
    [dat] = fnl_importeeg_and_downsample(wpms,'bdf',name_i,sampling_frequency);
    [refdat] = fnl_rereference(dat,48);
    
    clear dat
    
    [data] = fnl_preproc_filter(refdat,'yes',[48 52],'yes',0.1,'onepass',1,'but');
    
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT'],'data','-v7.3');
    clear refdat data cfg %tidying
end

%% Visual Inspection of Data:
for name_i = [7 22]%1:length(wpms.names)   
    fnl_bad_channel_inspection(wpms,name_i);
end

%% Remove Bad Channels out from Data:
for name_i = [7 22]%1:length(wpms.names)   
    fnl_remove_bad_channels(wpms,name_i);
end

%% Trial Definition and ICA
for name_i = [7 22]%1:length(wpms.names)   
    pre_trial = 1.0;
    post_trial = 3.5;
    trialfunction = 'Agility'; 
    trdat = fnl_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial);
    clear post_trial pre_trial trialfunction
    fnl_ICA(wpms,name_i,trdat);        
end
%% Remove EOG Components from ICA
for name_i = [7 22]%1:length(wpms.names)
    fnl_ICA_inspection(wpms,name_i);
end
%% Apply artifact rejection
for name_i = [7 22]%21:length(wpms.names)
    fnl_artifact_rejection_auto(wpms,name_i,true,30,-120,120)%Olivia try this with -120 and 120 as the last values instead -Patrick
end
%% Apply scalp current density montage
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\CSDtoolbox']));
for name_i = 1:length(wpms.names)
    fnl_csd_transformation(wpms,name_i);
end
%% Reinterpolate bad channels
for name_i = 1:length(wpms.names)
    fnl_reinterpolate(wpms,name_i);
end
%% CONVERT FROM FIELDTRIP TO EEG STRUCT
%SaveOffIndividualConditions;
%SaveOffIndividualConditions_altbiosemicodes;

%These are all the conditions that are present in the code:
conditions = {'mixrepeat','switchto','switchaway','noninf'};
%shorthand for naming files and data structure:
cond = {'mr','st','sa','ni'};
%These are all possible codes for a condition that we would like to group
%together:
condition_code_values.mr = [161 162 171 172 181 182 65441 65442 65451 65452 65461 65462];
condition_code_values.st = [163 164 173 174 183 184 65443 65444 65453 65454 65463 65464];
condition_code_values.sa = [165 166 175 176 185 186 65445 65446 65455 65456 65465 65466];
condition_code_values.ni = [167 168 169 170 177 178 179 180 187 188 189 190 ...
                            65447 65448 65449 65450 65457 65458 65459 65460 65467 65468 65469 65470];
for name_i =1:length(wpms.names)
    fnl_saveOffIndividualConditions(wpms,conditions,cond,condition_code_values,name_i);
    fnl_setup_eegstructure(wpms,conditions,cond,name_i);
end
%% Begin FFT
% add eeglab to path
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\eeglab']));
times = -400:0.5:2200;
windowsize = 20;
bins = 80;
freqrange = [2 50];
channels = 1:64;
conditions = [{'switchto'},{'switchaway'},{'noninf'},{'mixrepeat'}];
for name_i = 1:length(wpms.names)
    fnl_wavelet_analysis(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i);
end
%% IMAGINARY COHERENCE ANALYSIS
channels = 1:64;
conditions = {'switchto','switchaway','noninf','mixrepeat'};
for name_i = 1:length(wpms.names)
    fnl_imaginarycoherence_analysis(wpms,channels,conditions,name_i)
end
%% GENERATE CONNECTIVITY MATRICES
channelcount = 64;
freq_names = {'delta','theta','loweralpha','upperalpha','beta'};
freq = [{1:18},{19:31},{35:40},{41:47},{48:68}];
conditions = {'switchto','switchaway','noninf','mixrepeat'};
for name_i = 1:length(wpms.names)
    starttimes = 400:200:3600;
    endtime = 600;
    fnl_genconnmatrix(wpms,channelcount,conditions,starttimes,endtime,freq_names,freq,name_i);
end
%% PERFORM STATISTICAL ANALYSES
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\massunivariate']));
conditions = {'switchto','switchaway','noninf','mixrepeat'};
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
    conditions = {'mixrepeat','switchto','switchaway','noninf'};
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
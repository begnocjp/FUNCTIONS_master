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
    'COHERENCE_DIR','COHERENCE_DIR/','IMAGCOH_OUTPUT','IMAGCOH_OUTPUT/','EEGDispOutput','EEGDISPLAY_OUTPUT/', ...
    'TIMELOCK','TIMELOCK/','GA_TIMELOCK','GA_TIMELOCK/','edat_txt','edat_txt/');

 wpms.names = { % '2023_rest'}
 '2001_rest';'2005_rest';'2007_rest';'2008_rest';'2009_rest'; ...
 '2012_rest';'2013_rest';'2021_rest';'2023_rest';'2029_rest'}

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
%% Trial Definition ONLY : resting
%%%changed pre and post trial times -
for name_i = 1:length(wpms.names)
    trial_length = 2; %length trials seconds
    overlap = 0; %overlap for trials in seconds
    trialfunction = 'patrick_resting'; %will need to change per task, each task has trial function, will need to edit function for ANT task
    file_ext = 'raw'
    trdat = patrick_resting(wpms,name_i,trialfunction,trial_length,overlap,file_ext);
    clear trial_length overlap trialfunction
    clear sample*
    clear value*
    %patrick_ccm_ICA(wpms,name_i,trdat);
end
%% Apply artifact rejection %toggle which condition to use
%patrick b changed "true" to "1", will stop if finds sub with <1 good trial
for name_i = 1:length(wpms.names)
     %     condition = '_gonogo'
    %    condition = '_stroop'
     %   condition = '_incidental'
            condition = '_resting'
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
%        condition = '_gonogo'
%       condition = '_stroop'
%     condition = '_incidental'
    patrick_ccm256_reinterpolate(wpms,name_i,condition);
end

%% Reinterpolate bad channels for resting state %toggle which condition to use
for name_i = 1:length(wpms.names)
     condition = '_resting'
    patrick_ccm256_reinterpolate_resting(wpms,name_i,condition);
end

%% Apply scalp current density montage
%addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS '/CSDtoolbox']));
type = 'egi';
for name_i = 1:length(wpms.names)
     condition = '_resting'
    patrick_ccm256_csd_transformation_v2(wpms,name_i,condition); %,type);
end

%% CONVERT FROM FIELDTRIP TO EEG STRUCT
%SaveOffIndividualConditions;
%SaveOffIndividualConditions_altbiosemicodes;

%These are all the conditions that are present in the code:
%conditions = {'single','repeat'}; %'attention',
conditions = {'CSDDATA'}; %'attention',
%shorthand for naming files and data structure:
cond = {'rest'}; %'attn'

% condition_code_values.attn = 1;
% condition_code_values.sngl = 2;
% condition_code_values.rept = 3;
wpms.sampling_frequency = 250;

for name_i =1:length(wpms.names)
    %fnl_saveOffIndividualConditions(wpms,conditions,cond,condition_code_values,name_i);
    %patrick_fnl_setup_eegstructure_resting(wpms,conditions,cond,name_i);
    patrick_fnl_setup_eegstructure(wpms,conditions,cond,name_i);

end
%% Begin FFT
% add eeglab to path
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '/eeglab']));
%times = -1000:4:2000;
times = 0:4:2000;  %resting state trials, must match trial size unless wavelt function code is changed
windowsize = 20;
bins = 80;
freqrange = [2 30]; %changed from 50 to 30 for upper limit - patrick
channels = 1:256;
conditions = [{'CSDDATA'}];
%conditions = [{'single'},{'repeat'}]; %{'attention'},
% for name_i = 1:length(wpms.names)
%     fprintf('\n%s\t', wpms.names{name_i})
%     patrick_fnl_wavelet_analysis_v2(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i);
% end
%%use below for resting state analysis 
for name_i = 1:length(wpms.names)
    fprintf('\n%s\t', wpms.names{name_i})
    patrick_fnl_wavelet_analysis_v2_resting(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i);
end
%% IMAGINARY COHERENCE ANALYSIS
channels = 1:256;
%conditions = {'repeat','single'}; %'attention',
conditions = {'resting'}; %'attention',
for name_i = 1%:length(wpms.names)
    patrick_fnl_imaginarycoherence_analysis(wpms,channels,conditions,name_i)
end
%% GENERATE CONNECTIVITY MATRICES
channelcount = 256;
freq_names = {'delta','theta','alpha','beta'};
freq = [{1:18},{19:31},{35:49},{50:68}];
%conditions = {'repeat','single'}; %'attention',
conditions = {'resting'}; %'attention',
for name_i = 1%:length(wpms.names)
    starttimes = 400:200:3600;
    endtime = 600;
    patrick_fnl_genconnmatrix(wpms,channelcount,conditions,starttimes,endtime,freq_names,freq,name_i);
end
%% PERFORM STATISTICAL ANALYSES
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '/massunivariate']));
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


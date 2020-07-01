%% Comparison Pipeline:
%
%   The following file is to test the CSD Transform and allow data
%   visualisation. Using the FT_MultiplotER.
%
%   Verification of Different Spline settings in CSD Montage
%
%   RESULT: % CSD Montage is now calculated using a modified tutorial code for BIOSEMI DATA Found in: 
%           .CWD\PACKAGES\CSDtoolbox\exam\EEGlab_Make_G_H_AGEILITYBDF.m
%           The output of that file is then saved to CSDmontage_64.mat, and is loaded
%           below.

%% Setup :

clear all;close all;clc;
wpms.dirs  = struct('CWD','E:\fieldtrip\',...
                    'packages','PACKAGES',...
                    'DATA_DIR','EEGLAB_FORMAT\', ...
                    'FUNCTIONS','FUNCTIONS\',...
                    'REPAIRED_DATA','REPAIRED_DATA\',...
                    'REF_OUT','ReferenceOutput\',...
                    'RAW','RAW\',...
                    'preproc','PREPROC_OUTPUT\',...
                    'timelock','TIMELOCK_ERPS\',...
                    'WAVELET_OUTPUT_DIR','wavelet_2\');
cd([wpms.dirs.CWD wpms.dirs.preproc]);
%listing = dir('AGE*_ARTFREEDATA*');
names = {1:length(wpms.names)};
wpms.names{1,length(names)}=[]; %cell(1,length(names));
for name_i =1:length(names)
    wpms.names{1,name_i} = names{name_i}(1:6);
end


wpms.conditions = {'dirleft','dirright','nondirleft','nondirright'};%conditions of interest
wpms.RefComparisons = {'Vertex','CommonAverage','AverageMastoids','SurfaceLapacian'};
addpath(genpath([wpms.dirs.CWD wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD wpms.dirs.packages filesep 'fieldtrip-20150902' filesep]));

%% Compute CSD:

addpath(genpath([wpms.dirs.CWD wpms.dirs.packages filesep 'CSDtoolbox' filesep]));%add csdtoolbox to path
%E = load([wpms.dirs.FUNCTIONS 'original_labels.mat']); %CHECK FORMAT OF LABELS might need a transpose.
%E = {EEG.chanlocs(1:nchans).labels}';
%M = ExtractMontage('10-5-System_Mastoids_EGI129.csd',E.labels(1:64)); % 1:64 because must be on scalp.
%MapMontage(M)
filename = [wpms.dirs.CWD wpms.dirs.REPAIRED_AND_REFERENCED wpms.names{name_i} '_REPAIRED_AND_REFERENCED_' wpms.conditions{cond_i} '.mat'];
A = load(filename);
datnames = fieldnames(A);
refdat = A.(datnames{1});
clear A;
load('CSDmontage_64.mat');
%for m=2:6

%[G,H] = GetGH(Montage,m);%get montage


for name_i = 1%:length(wpms.names)
%
    fprintf('Currently Referencing: %s \n',wpms.names{name_i});
    for cond_i = 1%:length(wpms.conditions)
        fprintf('Currently Referencing: %s \n',wpms.names{name_i});

        X = refdat.trial;
        for trial_i = 1:length(refdat.trial);
            fprintf('.');
            dat = squeeze(refdat.trial{trial_i}(1:64,:));
            X{1,trial_i}(1:64,:) = CSD(dat,G,H);
         
        end
        fprintf('\nSurface Laplacian Rereferencing complete..\n');
        refdat.trial = X;
        save_filename = [wpms.dirs.CWD wpms.dirs.REF_OUT wpms.RefComparisons{4} filesep wpms.names{name_i} '' wpms.conditions{cond_i} '_SPLINETEST_' num2str(m) '.mat'];
        fprintf('\nSaving as: %s\n',save_filename);
        save(save_filename,'refdat');
        
    end
%   end
%
end
%end

%% Verify Spline Test
close all;
listings = dir([wpms.dirs.CWD wpms.dirs.REF_OUT wpms.RefComparisons{4} filesep '*_SPLINETEST_*.mat']);
filenames = {listings(:).name};

% Filter Settings:
cfg_filter = [];
cfg_filter.lpfilter = 'yes';
cfg_filter.lpfreq =  8;
cfg_filter.lpfilttype = 'but';
cfg_filter.lpfiltorder = 4;
cfg_filter.lpfiltdir = 'twopass-reverse';

cfg_timelock = [];
cfg_timelock.channel = 'all';
cfg_timelock.trials = 'all';
cfg_timelock.keeptrials = 'no';    
cfg_timelock.vartrllength = 0;

cfg_plot = [];
cfg_plot.parameter = 'avg';
cfg_plot.channel = [1:64];
cfg_plot.layout = 'FNL_biosemi64.lay';
cfg_plot.showlabels = 'yes';

for file_i = 4
    fprintf(filenames{file_i});
    load([wpms.dirs.CWD wpms.dirs.REF_OUT wpms.RefComparisons{4} filesep filenames{file_i}]);
    refdat = ft_preprocessing(cfg_filter,refdat);
    timelock_data{file_i} = ft_timelockanalysis(cfg_timelock, refdat);
    timelock_data{file_i}.avg = timelock_data{file_i}.avg./max(max(abs(timelock_data{file_i}.avg)));

end

load([wpms.dirs.CWD,wpms.dirs.REF_OUT,wpms.RefComparisons{2},filesep,check_subject,'mixrepeat.mat']);
CommonAverageData = refdat;
CommonAverageData = ft_preprocessing(cfg_filter,CommonAverageData);
timelock_CommonAverageData = ft_timelockanalysis(cfg_timelock, CommonAverageData);
timelock_CommonAverageData.avg= timelock_CommonAverageData.avg./max(max(abs(timelock_CommonAverageData.avg)));
%Produce Comparison Plot:
close all;
figure();
    ft_multiplotER(cfg_plot, timelock_data{2},...
                        timelock_data{3},...
                        timelock_data{4},...
                        timelock_data{5},...
                        timelock_CommonAverageData);
figure();
    ft_multiplotER(cfg_plot, timelock_data{4},timelock_CommonAverageData);                
%                     
%     figure()
%     ft_multiplotER(cfg_plot, timelock_data{6},...
%                         timelock_data{7},...
%                         timelock_data{8},...
%                         timelock_data{9},...
%                         timelock_data{1},...
%                         timelock_CommonAverageData);
%     saveas(gcf,'timelock_TestSPLINE_AGE002.jpg');



%% FNL_CSD_TRANSFORMATION_v2
%   Applies scalp current density (aka current source density) to artifact
%   free data
%   Each subject's montage is created on a per person basis to account for
%   any channels that have been removed prior
% 
%  USEAGE:
%         fnl_artifact_rejection_auto(wpms,name_i)
%  INPUTS:
%         wpms: working parameters stucture (contains names,dirs)
%         name_i: current participant index
%
%  Patrick Cooper & Aaron Wong, 2014
%  Functional Neuroimaging Laboratory, University of Newcastle
function ccm256_csd_transformation_v2(wpms,name_i,condition)
%wpms.conditions = {'attn','sngl','rept'};%conditions of interest
wpms.RefComparisons = {'Vertex','CommonAverage','AverageMastoids','SurfaceLapacian'};
addpath(genpath([wpms.dirs.CWD wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD wpms.dirs.FUNCTIONS filesep 'fieldtrip' filesep]));
%channels = 128;
channels = 256;

fprintf('Currently Referencing: %s \n',wpms.names{name_i});
%changing file name for testing
filename = [wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REPAIRED_AND_REFERENCED' condition '.mat'];
%filename = [wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT.mat'];
load(filename);


cfg_timelock = [];
cfg_timelock.channel = 'all';
cfg_timelock.trials = 'all';
cfg_timelock.keeptrials = 'no';    
cfg_timelock.vartrllength = 0;

%timelock_data_before = ft_timelockanalysis(cfg_timelock, refdat);

addpath(genpath([wpms.dirs.CWD wpms.dirs.packages filesep 'CSDtoolbox' filesep]));%add csdtoolbox to path
E = load([wpms.dirs.FUNCTIONS 'egi_label_256.mat']); %CHECK FORMAT OF LABELS might need a transpose.
%E = {EEG.chanlocs(1:nchans).labels}';
M = ExtractMontage('EGI_256.csd',E.labels(1:256)); 
MapMontage(M)
[G,H] = GetGH(M);%get montage

X = refdat.trial;
for trial_i = 1:length(refdat.trial);
    fprintf('.');
    data = squeeze(refdat.trial{trial_i}(1:256,:));
    X{1,trial_i}(1:256,:) = CSD(data,G,H);
end
fprintf('\nSurface Laplacian Rereferencing complete..\n');
refdat.trial = X;
save_filename = [wpms.dirs.CWD wpms.dirs.preproc filesep wpms.names{name_i} '_CSDDATA.mat'];
fprintf('\nSaving as: %s\n',save_filename);
save(save_filename,'refdat','-v7.3');


% cfg_timelock = [];
% cfg_timelock.channel = 'all';
% cfg_timelock.trials = 'all';
% cfg_timelock.keeptrials = 'no';    
% cfg_timelock.vartrllength = 0;
% 
% timelock_data_after = ft_timelockanalysis(cfg_timelock, refdat);
% 
% cfg_plot = [];
% cfg_plot.parameter = 'avg';
% cfg_plot.channel = [1:256];
% cfg_plot.layout = 'GSN-HydroCel-256.sfp';
% cfg_plot.showlabels = 'yes';
% 
% ft_multiplotER(cfg_plot, timelock_data_before, timelock_data_after);
pause(5);

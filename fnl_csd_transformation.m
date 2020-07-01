%% FNL_CSD_TRANSFORMATION
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
function fnl_csd_transformation(wpms,name_i,type)
if strcmp(type,'neuroscan')
    [M] = fnl_genMontage_neuroscan(wpms.dirs.CWD,wpms.dirs.preproc,wpms.names,name_i);
else
    [M] = fnl_genMontage_biosemi(wpms.dirs.CWD,wpms.dirs.preproc,wpms.names,name_i);
end
[G,H] = GetGH(M);
load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_ARTFREEDATA']);
tic;
%Extract artrej.trial
for j = 1:size(data.trial,2)
    D = data.trial{1,j}(1:(length(M.lab)),:);
    X = CSD(D,G,H);
    X = single(X);
    data.trial{1,j}(1:(length(M.lab)),:) = X(:,:);
end
toc
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSDDATA'], 'data','-v7.3');
clear D X data j
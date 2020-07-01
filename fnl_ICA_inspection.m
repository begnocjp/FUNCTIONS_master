%% FNL_ICA_INSPECTION
% Displays components from ICA fnl_ica for inspection
% Currently we are using ICA to exclude EOG related components
%  USEAGE:
%         fnl_ICA_inspection(wpms,name_i)
%  INPUTS:
%         wpms: working parameters stucture (contains names,dirs)
%         name_i: current participant index
%
%  Patrick Cooper & Aaron Wong, 2014
%  Functional Neuroimaging Laboratory, University of Newcastle
function fnl_ICA_inspection(wpms,name_i)
PartID = wpms.names{name_i}; % change this to load each new participant in.
fprintf('Working on: %s \n',PartID);
load([wpms.dirs.CWD wpms.dirs.preproc PartID,'_ICADATA']);
cfg = [];
cfg.layout = 'biosemi64.lay';
cfg.viewmode = 'component';
x = ft_databrowser(cfg, ic_data);%try x?
eog=inputdlg('Which component(s) was/were (a) blink(s)?, e.g. 2 or 9,10');
% inputdlg won't produce multiple cells if we have multiple components,
% will do this here:
if length(eog{1,1}) > 2;%2 for length of largest component number (e.g. 71), if greater than this, likely has multiple entries
    eog = tokenize(eog{1,1},',');
end
cfg.component = str2double(eog);
eogcorr = ft_rejectcomponent(cfg, ic_data);
clear ic_data %tidying
fprintf('Saving: %s%s \n',PartID,'''s blink corrected data. . .');
save([wpms.dirs.CWD wpms.dirs.preproc PartID,'_EOGCORRECTED'],'eogcorr');
end

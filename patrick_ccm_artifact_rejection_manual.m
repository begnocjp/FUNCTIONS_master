function patrick_ccm_artifact_rejection_manual(wpms,name_i,condition)
fprintf('%s\t%s\n','Working on:',wpms.names{name_i});
load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_ARTFREEDATA' condition])


cfg = [];
 cfg.method      = 'summary'
%                     'summary'  show a single number for each channel and trial (default)
%                     'channel'  show the data per channel, all trials at once
%                     'trial'    show the data per trial, all channels at once
cfg.layout        = '/Users/patrick/Desktop/EEG/FUNCTIONS/GSN-HydroCel-256.sfp';
data = ft_rejectvisual(cfg,data);

close all
% save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_ARTFREEDATA_MAN_REJ' condition] 'data','-v7.3');
clear cfg data %tidying
end
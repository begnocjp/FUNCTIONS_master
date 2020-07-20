%% ARTIFACT_REJECTION_MANUAL

function patrick_ccm_artifact_rejection_manual(wpms,name_i,condition)
fprintf('%s\t%s\n','Working on:',wpms.names{name_i});
load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_ARTFREEDATA' condtion])


cfg = [];
  cfg.method      = 'trial'  
data = ft_rejectvisual(cfg,eogcorr);

close all
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_ARTFREEDATA_MAN_REJ'] condition,'data','-v7.3');
clear artrej eogcorr artifact cfg data %tidying
end
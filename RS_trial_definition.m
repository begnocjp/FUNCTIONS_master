function [trdat] = RS_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial)

    fprintf('%s %s %s \n','----- Begin Trial Definition -----','Participant:',wpms.names{name_i});
    %cd([CWD,PREPROC_OUTPUT]);
    load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_BadChannRemoved']);
    %cd([CWD,RAW]);
    cfg=[];
    cfg.hdr                   = ft_read_header([wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.bdf']);
    cfg.event                 = ft_read_event ([wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.bdf']);
    cfg.trialfun              = trialfunction;
    cfg.trialdef.pre          = pre_trial; % latency in seconds
    cfg.trialdef.post         = post_trial;   % latency in seconds
    cfg.filename_original     = [wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '.bdf'];
    cfg.wpms                  = wpms;
    
    eval(['[trl] = ft_trialfun_',cfg.trialfun,'(cfg,name_i);']); % for data recorded on new biosemi - else use normal function

    if isempty(trl)
        fprintf('%s\n','Using biosemi2 function')%debugging PC
        eval(['[trl] = ft_trialfun_',cfg.trialfun,'_biosemi2(cfg,name_i);'])
    end
    cfg.trl = trl;
    fprintf('Size of TRL: %i',size(trl,2));
    for trl_i = 1:size(cfg.trl)
        if cfg.hdr.Fs ~= data.fsample
            cfg.trl(trl_i,1) = round(cfg.trl(trl_i,1)/(cfg.hdr.Fs/data.fsample));
            cfg.trl(trl_i,2) = round(cfg.trl(trl_i,2)/(cfg.hdr.Fs/data.fsample));
            cfg.trl(trl_i,3) = round(cfg.trl(trl_i,3)/(cfg.hdr.Fs/data.fsample));
        end
    end
    trdat = ft_redefinetrial(cfg,data);
    trdat.trialinfo  = trdat.trialinfo(:,1);
    clear data tdat%tidying

    
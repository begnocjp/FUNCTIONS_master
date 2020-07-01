function [trdat] = fnl_trial_definition_split(wpms,pair_i,split_i,trialfunction,pre_trial,post_trial)
    current_name = wpms.splitnamespairs{pair_i}{split_i};
    fprintf('%s %s %s \n','----- Begin Trial Definition -----','Participant:',current_name{1});
    %cd([CWD,PREPROC_OUTPUT]);
    load([wpms.dirs.CWD wpms.dirs.preproc current_name{1} '_BadChannRemoved']);
    %cd([CWD,RAW]);
    cfg=[];
    cfg.hdr                   = ft_read_header([wpms.dirs.CWD wpms.dirs.RAW current_name{1} '.bdf']);
    cfg.event                 = ft_read_event ([wpms.dirs.CWD wpms.dirs.RAW current_name{1} '.bdf']);
    cfg.trialfun              = trialfunction;
    cfg.trialdef.pre          = pre_trial; % latency in seconds
    cfg.trialdef.post         = post_trial;   % latency in seconds
    cfg.filename_original     = [wpms.dirs.CWD wpms.dirs.preproc current_name{1} '.bdf'];
    cfg.wpms                  = wpms;
    cfg.current_name          = current_name;

    eval(['[trl] = ft_trialfun_',cfg.trialfun,'(cfg,-1);']); % for data recorded on new biosemi - else use normal function

    if isempty(trl)
        fprintf('%s\n','Using biosemi2 function')%debugging PC
        eval(['[trl] = ft_trialfun_',cfg.trialfun,'_biosemi2(cfg,-1);'])
    end
    cfg.trl = trl;
    fprintf('Size of TRL: %i',size(trl,2));
    for trl_i = 1:length(cfg.trl)
        if cfg.hdr.Fs ~= data.fsample
            cfg.trl(trl_i,1) = round(cfg.trl(trl_i,1)/(cfg.hdr.Fs/data.fsample));
            cfg.trl(trl_i,2) = floor(cfg.trl(trl_i,2)/(cfg.hdr.Fs/data.fsample));
            cfg.trl(trl_i,3) = round(cfg.trl(trl_i,3)/(cfg.hdr.Fs/data.fsample));
        end
    end
    trdat = ft_redefinetrial(cfg,data);
    trdat.trialinfo  = trdat.trialinfo(:,1);
    clear data tdat%tidying

    
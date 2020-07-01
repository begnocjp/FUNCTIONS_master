function [trdat] = ccm_trial_definition(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext)

    fprintf('%s %s %s \n','----- Begin Trial Definition -----','Participant:',wpms.names{name_i});
    %cd([CWD,PREPROC_OUTPUT]);
    load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_BadChannRemoved']);
    %cd([CWD,RAW]);
    cfg=[];
    cfg.hdr                   = ft_read_header([wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' file_ext]);
    cfg.event                 = ft_read_event ([wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' file_ext]);
    cfg.trialfun              = trialfunction;
    cfg.trialdef.pre          = pre_trial; % latency in seconds
    cfg.trialdef.post         = post_trial;   % latency in seconds
    cfg.filename_original     = [wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' file_ext];
    cfg.wpms                  = wpms;
    
    eval(['[trl] = ft_trialfun_',cfg.trialfun,'(cfg,name_i);']); % for data recorded on new biosemi - else use normal function

    if isempty(trl)
        fprintf('%s\n','Using biosemi2 function')%debugging PC
        eval(['[trl] = ft_trialfun_',cfg.trialfun,'_biosemi2(cfg,name_i);'])
    end
    cfg.trl = trl;
    fprintf('Size of TRL: %i',size(trl,2));
    for trl_i = 1:length(cfg.trl)
        if cfg.hdr.Fs ~= data.fsample
            cfg.trl(trl_i,1) = round(cfg.trl(trl_i,1)/(cfg.hdr.Fs/data.fsample));
            cfg.trl(trl_i,2) = floor(cfg.trl(trl_i,2)/(cfg.hdr.Fs/data.fsample));
            cfg.trl(trl_i,3) = round(cfg.trl(trl_i,3)/(cfg.hdr.Fs/data.fsample));
            if cfg.trl(trl_i,1) > data.sampleinfo(2) 
                cfg.trl(trl_i,1) = -1;
            end    
            if cfg.trl(trl_i,2) > data.sampleinfo(2)
                cfg.trl(trl_i,2) = -1;
            end  
        end
    end
    trl_i =1;
    while trl_i  <= length(cfg.trl)
        if any((cfg.trl(trl_i,:)==-1))
            cfg.trl(trl_i,:) = [];
            trl_i = 1;
        end
        trl_i = trl_i+1;
    end

    trdat = ft_redefinetrial(cfg,data);
    trdat.trialinfo  = trdat.trialinfo(:,1);
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat'],'trdat','-v7.3'); % added this into to save trial data for auto artifact rejeciton 
    clear data tdat%tidying

    
    
    
   %%%%%%%%%%%% testing define trial %%%%%%%%%%%%%%%% 
    
    
    
    
cfg = [];
cfg.dataset   = data;
cfg.trialfun  = 'ft_trialfun_general';
cfg.trialdef.eventtype  = 'STI101';
cfg.trialdef.eventvalue = 1;
cfg.trialdef.prestim    = 0.050; % in seconds
cfg.trialdef.poststim   = 0.250; % in seconds
cfg = ft_definetrial(cfg); 
    
    
    
    
cfg = [];
cfg.dataset   = [wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' file_ext];
cfg.trialfun  = 'ft_trialfun_general';
cfg.trialdef.eventtype  = 'trigger';
cfg.trialdef.eventvalue = 'bgin';
cfg.trialdef.prestim    = 0.050; % in seconds
cfg.trialdef.poststim   = 0.250; % in seconds
cfg = ft_definetrial(cfg);    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
function [timelock_erp] = patrick_fnl_timelockanalysis(wpms,name_i,conditions, condition,baseline)


    fprintf('---- Time Lock Analysis on: %s ----\n', wpms.names{name_i});
    
    %DATA = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} %'_CSD_' condition '.mat']); %for CSD data
    %DATA = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat' '.mat']); % use repaired and rereferenced? 
    DATA = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REPAIRED_AND_REFERENCED' condition])
    a = fieldnames(DATA);
    a = a{1,1};

    
%     t = toc;
%     fprintf('\t---- BaseLine Correction Finnished: %s %3.3f seconds----\n',  wpms.names{name_i},t);
%     
    %Time Lock for Each Class:
    %data_clean = refdat;
    %clear data;
    for i =  1:length(conditions)
    cfg  = [];
    cfg.channel            = 1:256;
    cfg.covariance         = 'yes';
    cfg.covariancewindow   = 'all';
    cfg.keeptrials         = 'no';
    cfg.removemean         = 'yes';
    cfg.vartrllength       = 0;
    cfg.trials             = find(ismember(DATA.(a).trialinfo,i));
    [timelock_erp.conditions(i)] = ft_timelockanalysis(cfg, DATA.(a));
    
  
    end
    
    %baseline correct (applying baseline correction on avg)
    
      for i = 1:length(conditions)
    cfg=[];
    cfg.baseline = baseline;
    timelock_erp.conditions_blcor(i) = ft_timelockbaseline(cfg, timelock_erp.conditions(i));
    
      end
    
    timelock = timelock_erp.conditions_blcor  
      
     %make difference waves
        
        cfg = [];
        cfg.operation = 'subtract'
        cfg.parameter = 'avg'
        AlertDiff = ft_math(cfg, timelock(1), timelock(2));
        timelock(3).avg = AlertDiff.avg
        timelock(3).time = AlertDiff.time
        timelock(3).label = AlertDiff.label
        timelock(3).elec = AlertDiff.elec
        timelock(3).dimord = AlertDiff.dimord
        timelock(3).cfg = AlertDiff.cfg
      
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' condition '.mat'],'timelock','-v7.3');
   %find(ismember(DATA.refdat.trialinfo,1))

end



% Old baseline correction 


%     %Baseline Correction for each Trial within a sample:
%     fprintf('\t---- BaseLine Correction on: %s ----\n',  wpms.names{name_i});
%     tic;
%     
%     begsample = baseline_start; %410 = -200ms, or  460 = -100ms 
%     endsample = baseline_end; %50ms
    
%     %do beg.end sample need to be negative??
%     
%     for i = 1:length(DATA.(a).trial)
%         DATA.(a).trial{1,i}= ft_preproc_baselinecorrect(DATA.(a).trial{1,i}, begsample, endsample); % look into ft_timelockbaseline
%     end
%     






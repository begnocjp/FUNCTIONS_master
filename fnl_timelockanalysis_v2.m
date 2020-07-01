function [timelock_erp] = fnl_timelockanalysis(wpms,name_i,condition,baseline_start,baseline_end)


    fprintf('---- Time Lock Analysis on: %s ----\n', wpms.names{name_i});
    
    DATA = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSD_' condition '.mat']);
    a = fieldnames(DATA);
    a = a{1,1};

    %Baseline Correction for each Trial within a sample:
    fprintf('\t---- BaseLine Correction on: %s ----\n',  wpms.names{name_i});
    tic;
    
    begsample = baseline_start; %410 = -200ms, or  460 = -100ms 
    endsample = baseline_end; %50ms
    
    for i = 1:length(DATA.(a).trial)
        DATA.(a).trial{1,i}= ft_preproc_baselinecorrect(DATA.(a).trial{1,i}, begsample, endsample);
    end
    
    t = toc;
    fprintf('\t---- BaseLine Correction Finnished: %s %3.3f seconds----\n',  wpms.names{name_i},t);
    
    %Time Lock for Each Class:
    %data_clean = refdat;
    %clear data;
    
    cfg  = [];
    cfg.channel            = 1:64;
    cfg.covariance         = 'yes';
    cfg.covariancewindow   = 'all';
    cfg.keeptrials         = 'no';
    cfg.removemean         = 'yes';
    cfg.vartrllength       = 0;
    %cfg.trials             = find(ismember(DATA.(a).trialinfo,codes));
    [timelock_erp] = ft_timelockanalysis(cfg, DATA.(a));
    
end
function patrick_timelock_stats(wpms,name_i,condition,channel)


%load all subjects
for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' condition '.mat']);
end


% define the parameters for the statistical comparison
cfg = [];
cfg.channel     = 240;
cfg.latency     = [0.1 5];
cfg.avgovertime = 'yes';
cfg.parameter   = 'avg';
cfg.method      = 'analytic';
cfg.statistic   = 'ft_statfun_depsamplesT';
cfg.alpha       = 0.05;
cfg.correctm    = 'no';

Nsub = 6;
cfg.design(1,1:2*Nsub)  = [ones(1,Nsub) 2*ones(1,Nsub)];
cfg.design(2,1:2*Nsub)  = [1:Nsub 1:Nsub];
cfg.ivar                = 1; % the 1st row in cfg.design contains the independent variable
cfg.uvar                = 2; % the 2nd row in cfg.design contains the subject number

stat = ft_timelockstatistics(cfg, load_subs{1:1}.timelock(1), load_subs{1,2}.timelock(1),...
load_subs{1,3}.timelock(1),load_subs{1,4}.timelock(1),load_subs{1,5}.timelock(1), ...
load_subs{1,6}.timelock(1), ...  
load_subs{1:1}.timelock(2), load_subs{1,2}.timelock(2), ...
load_subs{1,3}.timelock(2), load_subs{1,4}.timelock(2),load_subs{1,5}.timelock(2), ...
load_subs{1,6}.timelock(2))
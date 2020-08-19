function patrick_plot_Grand_Average(wpms,name_i,condition,channel)


%load all subjects
for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' condition.name '.mat']);
end

%make Grand Average
cfg = [];
cfg.channel        = condition.roi   %can toggle to select single/ groups of channels
%cfg.latency        = [begin end] in seconds or 'all' (default = 'all')
%cfg.normalizevar   = 'N' or 'N-1' (default = 'N-1')
cfg.method         = 'across' %(default) or 'within', see below.
%cfg.parameter      = string or cell-array indicating which
% parameter to average. default is set to
% 'avg', if it is present in the data


%compute GA for trial type 1
grandavg{1} = ft_timelockgrandaverage(cfg, ...
    load_subs{1,1}.timelock(1), ...
    load_subs{1,2}.timelock(1), ...
    load_subs{1,3}.timelock(1), ...
    load_subs{1,4}.timelock(1), ...
    load_subs{1,5}.timelock(1), ...
    load_subs{1,6}.timelock(1))

%compute GA for trial type 2
grandavg{2} = ft_timelockgrandaverage(cfg, ...
    load_subs{1,1}.timelock(2), ...
    load_subs{1,2}.timelock(2), ...
    load_subs{1,3}.timelock(2), ...
    load_subs{1,4}.timelock(2), ...
    load_subs{1,5}.timelock(2), ...
    load_subs{1,6}.timelock(2))

%compute GA for DIFF
grandavg{3} = ft_timelockgrandaverage(cfg, ...
    load_subs{1,1}.timelock(3), ...
    load_subs{1,2}.timelock(3), ...
    load_subs{1,3}.timelock(3), ...
    load_subs{1,4}.timelock(3), ...
    load_subs{1,5}.timelock(3), ...
    load_subs{1,6}.timelock(3))

%set GA variables to corresponding conditions so that ft_multiplot will
%label ERPs

if  1 == strcmp(condition.name,'_Executive')
    incongruent =  grandavg{1}
    congruent   =  grandavg{2}
    diff        =  grandavg{3}
elseif 1 == strcmp(condition.name,'_Alerting')
    nocue      = grandavg{1}
    double     = grandavg{2}
    diff       = grandavg{3}
elseif 1 == strcmp(condition.name,'_Orienting')
    center    = grandavg{1}
    updown    = grandavg{2}
    diff      = grandavg{3}
end

save([wpms.dirs.CWD wpms.dirs.TIMELOCK 'GRANDAVERAGE' condition.name condition.chan '.mat'],'grandavg','-v7.3');

%make GA ERP plots according to condition 

cfg = [];
cfg.showlabels    = 'yes';
cfg.fontsize      = 6;
cfg.linecolor     = 'bgr'
cfg.layout        = '/Users/patrick/Desktop/EEG/FUNCTIONS/GSN-HydroCel-256.sfp';
%cfg.ylim = [-3e-13 3e-13];

if 1 == strcmp(condition.name,'_Executive')
   ft_multiplotER(cfg, incongruent,congruent,diff);
    
elseif 1 == strcmp(condition.name,'_Alerting')
    ft_multiplotER(cfg, nocue,double,diff);
    
elseif 1 == strcmp(condition.name,'_Orienting')
    ft_multiplotER(cfg, center,updown,diff);
    
end
end


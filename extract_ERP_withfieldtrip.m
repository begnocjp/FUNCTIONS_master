function [ERP] = extract_ERP_withfieldtrip(wpms,filename, baseline,lpfreq,hpfreq)
addpath(genpath([wpms.dirs.PACKAGES 'eeglab12_0_1_0b' filesep]));
EEG = pop_loadset(filename);
rmpath(genpath([wpms.dirs.PACKAGES 'eeglab12_0_1_0b' filesep]));
addpath(genpath([wpms.dirs.PACKAGES 'fieldtrip' filesep]));
data = eeglab2fieldtrip( EEG, 'preprocessing', 'none' );
cfg = [];
cfg.lpfilter ='yes';
cfg.hpfilter ='yes';
cfg.lpfreq        = lpfreq;%lowpass  frequency in Hz
cfg.hpfreq        = hpfreq;%highpass frequency in Hz
cfg.lpfilttype    = 'but';
cfg.hpfilttype    = 'but';
cfg.lpfiltord     = 4;
cfg.hpfiltord     = 4;
cfg.lpfiltdir =   'twopass';
cfg.hpfiltdir =   'twopass';
cfg12 = cfg;
filterdata = ft_preprocessing(cfg12,data);
cfg = [];
[timelock] = ft_timelockanalysis(cfg, filterdata);
cfg = [];
cfg.baseline = baseline;
[timelock] = ft_timelockbaseline(cfg, timelock);
ERP = timelock.avg;
rmpath(genpath([wpms.dirs.PACKAGES 'fieldtrip' filesep]));

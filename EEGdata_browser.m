
load(['E:\fieldtrip\PREPROC_OUTPUT\7102_2Aud002_ARTFREEDATA']);
cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfreq = 100;
cfg.lpfilttype = 'but';
cfg.lpfiltord = 4;
data = ft_preprocessing(cfg,data);
cfg = [];
cfg.layout = 'GSN128.sfp';
cfg.continuous = 'yes';
cfg.channel = 1:128;
cfg.viewmode = 'vertical';
cfg.ylim = [-25 25];
cfg.blocksize = 10; % 1 second per screen
cfg = ft_databrowser(cfg,data); % look for bad channels
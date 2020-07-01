cfg = [];
cfg.lpfilter    = 'yes';
cfg.lpfreq      = 30;
cfg.lpfilttype  = 'but';
cfg.lpfiltord   = 4;
fprintf(1,'---- Performing LP Filtering: CuttOff = %1.1fHz\n',cfg.lpfreq);
eogcorr = ft_preprocessing(cfg,eogcorr);
cfg = []; 
% cfg.polyremoval = 'yes';
% eogcorr = ft_preprocessing(cfg,eogcorr);
cfg.viewmode = 'butterfly';
cfg.layout = 'biosemi64.lay';
% cfg.channel = eogcorr.label(1:63);
% ft_databrowser(cfg, eogcorr_2)
% [data] = ft_rejectvisual(cfg, eogcorr)
[data] = ft_databrowser(cfg,eogcorr)
% 
% cfg = [];
% cfg.viewmode = 'component';
% cfg.layout = 'biosemi64.lay';
% ft_databrowser(cfg,ic_data)
% cfg.component = [30 43];
% eogcorr_2 = ft_rejectcomponent(cfg, ic_data);
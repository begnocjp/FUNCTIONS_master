%FNL_VISUALISE:
function fnl_bad_channel_inspection(wpms,name_i,lpfreq)

    PartID = wpms.names{name_i}; % change this to load each new participant in.
    fprintf('Working on: %s \n',PartID);
    load([wpms.dirs.CWD wpms.dirs.preproc PartID,'_REFnFILT']);
    cfg = [];
    cfg.lpfilter = 'yes';
    cfg.lpfreq = lpfreq;   
    cfg.lpfilttype = 'but';
    cfg.lpfiltord = 4;

    fprintf(1,'---- Performing LP Filtering: CuttOff = %1.1fHz\n',cfg.lpfreq);
    data = ft_preprocessing(cfg,data);
    cfg = [];
    cfg.layout = 'biosemi64.lay';
    cfg.continuous = 'yes';
    cfg.channel = 1:72;
    cfg.viewmode = 'vertical';
    cfg.ylim = [-25 25];
    cfg.blocksize = 10; % 1 second per screen
    cfg = ft_databrowser(cfg,data); % look for bad channels

    badchann=inputdlg('Bad channels: e.g AF2,PO8,... Or Click Cancel for no bad channels');
    if isempty(badchann);
        fprintf('%s/n','No bad channels detected');
    else
        badchann = tokenize(badchann{1,1},',');
    end

    fprintf('%s %s %s','For participant ',PartID,'the following channels were deemed BAD: ');
    for bc_i = 1:length(badchann)
        fprintf('%s  ',badchann{1,bc_i});
    end
    fprintf('\n');
    clear bc_i data cfg %tidying
    save([wpms.dirs.CWD wpms.dirs.preproc PartID,'_badchannellist'],'badchann');
end


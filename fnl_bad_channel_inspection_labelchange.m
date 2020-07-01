%FNL_VISUALISE:
function fnl_bad_channel_inspection_labelchange(wpms,name_i,lpfreq)

    PartID = wpms.names{name_i}; % change this to load each new participant in.
    fprintf('Working on: %s \n',PartID);
    load([wpms.dirs.CWD wpms.dirs.preproc PartID,'_REFnFILT']);
    data.label = {'FP1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3';'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3';'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz';'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8';'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6';'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2';'M1';'M2';'LO1';'LO2';'SO1';'SO2';'IO1';'IO2';'GSR1';'GSR2';'Erg1';'Erg2';'Resp';'Plet';'Temp';'Status';};

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


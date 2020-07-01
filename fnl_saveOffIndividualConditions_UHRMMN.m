%% SAVES DATA into INDIVIDUAL CONDITIONS in EEGDISPLAY FORMAT (FULHAM)
%
%

function fnl_saveOffIndividualConditions_UHRMMN(wpms,conditions,cond,condition_code_values,name_i)
fprintf('%s\t%s\n', 'Working on:', wpms.names{name_i});

load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSDDATA.mat']);

    for conditions_i = 1:length(conditions)
    
    fprintf('\t\t\tSearching for %s\n',conditions{conditions_i});
    codes = condition_code_values.(cond{conditions_i});
    indices = zeros(length(refdat.trial),1);
    cnt = 0;
    for k = 1:length(refdat.trialinfo(:,1));
%         for j = 1:length(fieldnames(condition_code_values));%size(codes,2);
            if codes == refdat.trialinfo(k,1);
                indices(k,1) = 1;
                cnt = cnt+1;
            end
%         end
    end
    tempdat = [];
%     tlen = length(refdat.time{1,1});
    j = 1;
    for k = 1:length(indices)
        if indices(k,1) == 1;
            if size(refdat.trial{1,k},1) == 72
                tlen = length(refdat.time{1,k});
                x = refdat.trial{1,k}(1:64,1:tlen);
            elseif size(refdat.trial{1,k},1) == 36
                tlen = length(refdat.time{1,k});
                x = refdat.trial{1,k}(1:32,1:tlen);  
            else
                tlen = length(refdat.time{1,k});
                x = refdat.trial{1,k}(:,1:tlen);
            end;
                    
            tempdat{1,j} = x;
            clear x
            x = refdat.trialinfo(k,1);
            temptrinf(j,1) = x;
            clear x
            x = refdat.sampleinfo(k,1:2);
            tempsmpinf(j,1:2) = x;
            clear x
            j = j +1;
        end
    end
    tempdata = [];
    tempdata = refdat;
    tempdata.trial = tempdat;
    tempdata.trialinfo = temptrinf;
    tempdata.sampleinfo = tempsmpinf;
    tempdata.fsample = wpms.sampling_frequency;
    y = length(tempdata.trial);
    tempdata.time = refdat.time(1:y);
    varname = [cond{conditions_i},'data'];
    eval([varname,' = tempdata;']);
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',conditions{conditions_i},'.mat'],varname);
    clear y tempdata tempdat temptrinf tempsmpinf varname
end;

%%  Calculate MMN: dev - standard:
    
    % Frequency Deviant
    fprintf('Calculating: MMN_Fdev  = %s - %s \n', cond{3}, cond{1});
    MMN_Fdev = mean_data.(cond{3})-mean_data.(cond{1});
    tempdata = [];
    tempdata = refdat;
    tempdata.trial = {MMN_Fdev};
    tempdata.trialinfo = mean_temptrinf;
    tempdata.sampleinfo = mean_tempsmpinf;
    y = length(tempdata.trial);
    tempdata.time = refdat.time(1:y);
    varname = ['MMN_Fdev_data'];
    eval([varname,' = tempdata;']);
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',varname,'.mat'],varname);
    cfg = [];
    cfg.ReferenceSites = {};
    for i = 1:length(tempdata.label)
        cfg.ReferenceSites{i,1} = refchan_names{refchan_i};
    end;
    eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',varname,'_',refchan_names{refchan_i},'.erp'');']);

    % Duration Deviant
    fprintf('Calculating: MMN_Ddev  = %s - %s \n', cond{2}, cond{1});
    MMN_Ddev = mean_data.(cond{2})-mean_data.(cond{1});
    tempdata = [];
    tempdata = refdat;
    tempdata.trial = {MMN_Ddev};
    tempdata.trialinfo = mean_temptrinf;
    tempdata.sampleinfo = mean_tempsmpinf;
    y = length(tempdata.trial);
    tempdata.time = refdat.time(1:y);
    varname = ['MMN_Ddev_data'];
    eval([varname,' = tempdata;']);
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',varname,'.mat'],varname);
    cfg = [];
    cfg.ReferenceSites = {};
    for i = 1:length(tempdata.label)
        cfg.ReferenceSites{i,1} = refchan_names{refchan_i};
    end;
    
    eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',varname,'_',refchan_names{refchan_i},'.erp'');']);
    
    % Intensity Deviant
    fprintf('Calculating: MMN_Idev  = %s - %s \n', cond{4}, cond{1});
    MMN_Idev = mean_data.(cond{4})-mean_data.(cond{1});
    tempdata = [];
    tempdata = refdat;
    tempdata.trial = {MMN_Idev};
    tempdata.trialinfo = mean_temptrinf;
    tempdata.sampleinfo = mean_tempsmpinf;
    y = length(tempdata.trial);
    tempdata.time = refdat.time(1:y);
    varname = ['MMN_Idev_data'];
    eval([varname,' = tempdata;']);
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',varname,'.mat'],varname);
    cfg = [];
    cfg.ReferenceSites = {};
    for i = 1:length(tempdata.label)
        cfg.ReferenceSites{i,1} = refchan_names{refchan_i};
    end;
    
    eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',varname,'_',refchan_names{refchan_i},'.erp'');']);
    
end
disp('Function Completed');

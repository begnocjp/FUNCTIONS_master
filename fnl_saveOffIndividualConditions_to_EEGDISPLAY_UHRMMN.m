%% SAVES DATA into INDIVIDUAL CONDITIONS in EEGDISPLAY FORMAT (FULHAM)
%
%

function fnl_saveOffIndividualConditions_to_EEGDISPLAY_UHRMMN(wpms,conditions,cond,condition_code_values,name_i)
fprintf('%s\t%s\n', 'Working on:', wpms.names{name_i});

load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REPAIRED_AND_REFERENCED.mat']);
refdat_orig = refdat;
% We are rereferencing here how
refchans = [{65:66}];%{67}]; Unaware of nose channel for MRS montage, and the SCB project does not use them.
refchan_names = [{'AvMastoids'}];%,{'Nose'}];

for refchan_i = 1:size(refchans)
    
    cfg.reref = 'yes';
    cfg.refchannel = refchans{refchan_i};
    refdat_mastoids = ft_preprocessing(cfg,refdat_orig);

    refdat = refdat_mastoids;

    %conditions = wpms.conditions;
    %cond = wpms.cond;
    %condition_code_values = wpms.condition_code_values;

    mean_data = condition_code_values;

    for conditions_i = 1:length(conditions)

        tempdat = [];
        temptrinf = [];
        tempsmpinf = [];

        fprintf('\t\t\tSearching for %s\n',conditions{conditions_i});

        
        
        codes = condition_code_values.(cond{conditions_i});

        cnt = sum(refdat.trialinfo==codes);
        indices = refdat.trialinfo==codes;
        
        fprintf('\t\t\tFound trial numbers =  %i\n',cnt);
        
        tlen = length(refdat.time{1,1});
        sum_tempdat = zeros(size(refdat.trial{1,1}));
        j = 1;
        for k = 1:length(indices)
            if indices(k,1) == 1;
                if size(refdat.trial{1,k},1) == 72
                    x = refdat.trial{1,k}(1:72,1:tlen);
                elseif size(refdat.trial{1,k},1) == 30
                    x = refdat.trial{1,k}(1:30,1:tlen);  
                elseif size(refdat.trial{1,k},1) == 64
                    x = refdat.trial{1,k}(1:64,1:tlen);
                end;

                tempdat{1,j} = x;
                clear x;    
                temptrinf(j,1) = refdat.trialinfo(k,1);
                tempsmpinf(j,1:2) =  refdat.sampleinfo(k,1:2);

                sum_tempdat = sum_tempdat + tempdat{1,j};
                j = j +1;
            end



        end

        tempdata = [];
        tempdata = refdat;
        tempdata.trial = tempdat;
        tempdata.trialinfo = temptrinf;
        tempdata.sampleinfo = tempsmpinf;
        y = length(tempdata.trial);
        tempdata.time = refdat.time(1:y);
        varname = [cond{conditions_i},'data'];
        eval([varname,' = tempdata;']);
        save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',conditions{conditions_i},'_',refchan_names{refchan_i},'.mat'],varname);
        cfg = [];
        cfg.ReferenceSites = {};
        for i = 1:length(tempdata.label)
            cfg.ReferenceSites{i,1} = refchan_names{refchan_i};
        end;
        eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',conditions{conditions_i},'_',refchan_names{refchan_i},'.erp'');'])
        %clear y tempdata tempdat temptrinf tempsmpinf varname

        %% For Mean or Average of each condition:

        mean_refdat = sum_tempdat./length(tempdat);
        mean_tempsmpinf(1,1:2) = [1 tlen];
        mean_temptrinf = temptrinf(1,1); %all should be the same;

        tempdata = [];
        tempdata = refdat;
        tempdata.trial = {mean_refdat};
        tempdata.trialinfo = mean_temptrinf;
        tempdata.sampleinfo = mean_tempsmpinf;
        y = length(tempdata.trial);
        tempdata.time = refdat.time(1:y);
        varname = [cond{conditions_i},'data'];
        eval([varname,' = tempdata;']);
        save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',conditions{conditions_i},'.mat'],varname);
        cfg = [];
        cfg.ReferenceSites = {};
        for i = 1:length(tempdata.label)
            cfg.ReferenceSites{i,1} = refchan_names{refchan_i};
        end;
        eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',conditions{conditions_i},'_',refchan_names{refchan_i},'_MEAN.erp'');'])

        mean_data.(cond{conditions_i}) = mean_refdat;

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
    varname = ['MMN_Fdev'];
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
    varname = ['MMN_Ddev'];
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
    varname = ['MMN_Idev'];
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

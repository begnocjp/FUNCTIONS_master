%% SAVES DATA into INDIVIDUAL CONDITIONS in EEGDISPLAY FORMAT (FULHAM)
%
%

function ccm_saveOffIndividualConditions_to_ERP(wpms,conditions,cond,condition_code_values,name_i)
fprintf('%s\t%s\n', 'Working on:', wpms.names{name_i});

load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REPAIRED_AND_REFERENCED.mat']);
refdat_orig = refdat;
% We are rereferencing here how
% refchans = [1:128];%{67}]; Unaware of nose channel for MRS montage, and the SCB project does not use them.
% refchan_names = [{'CommonAvg'}];%,{'Nose'}];

% for refchan_i = 1:size(refchans)
    
%     cfg.reref = 'no';
%     cfg.refchannel = refchans{refchan_i};
%     refdat_commonavg = ft_preprocessing(cfg,refdat_orig);

%     refdat = refdat_commonavg;

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
                if size(refdat.trial{1,k},1) == 128
                    x = refdat.trial{1,k}(1:128,1:tlen);
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
        save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',conditions{conditions_i},'.mat'],varname);
        cfg = [];
%         cfg.ReferenceSites = {};
%         for i = 1:length(tempdata.label)
%             cfg.ReferenceSites{i,1} = refchan_names{refchan_i};
%         end;
        eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',conditions{conditions_i},'.erp'');'])
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
%         cfg.ReferenceSites = {};
%         for i = 1:length(tempdata.label)
%             cfg.ReferenceSites{i,1} = refchan_names{refchan_i};
%         end;
        eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',conditions{conditions_i},'_MEAN.erp'');'])

        mean_data.(cond{conditions_i}) = mean_refdat;

        clear y tempdata tempdat temptrinf tempsmpinf varname


    end;

    
% end
disp('Function Completed');

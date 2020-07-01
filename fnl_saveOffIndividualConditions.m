function fnl_saveOffIndividualConditions(wpms,conditions,cond,condition_code_values,name_i)

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

clear all
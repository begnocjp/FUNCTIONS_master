function DIFFDATA = diffConnMats_AW(ACTIVE_DATA,SHAM_DATA,DIFFDATA)

    conds = fieldnames(ACTIVE_DATA.conditions);
    freqs = fieldnames(ACTIVE_DATA.conditions.(conds{1}));
    participant_size = size(ACTIVE_DATA.conditions.(conds{1}).(freqs{1}),1);
    
    for par_i = 1:participant_size
        fprintf('Processing Participant %i \n',par_i);    
        for cond_i = 1:length(conds)
            fprintf('\t%s \n',conds{cond_i});
            for freq_i = 1:length(freqs)
                fprintf('\t\t%s \n',freqs{freq_i});
                DIFFDATA.conditions.(conds{cond_i}).(freqs{freq_i})(par_i,:,:,:) = ...
                        ACTIVE_DATA.conditions.(conds{cond_i}).(freqs{freq_i})(par_i,:,:,:)- ...
                        SHAM_DATA.conditions.(conds{cond_i}).(freqs{freq_i})(par_i,:,:,:);
            end
        end
    end
end


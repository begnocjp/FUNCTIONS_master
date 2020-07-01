function [TVALS_DIFFDATA,PVALS_DIFFDATA] = ttestConnMats_young_AW(DIFFDATA,TVALS_DIFFDATA,PVALS_DIFFDATA)

    conds = fieldnames(DIFFDATA.conditions);
    freqs = fieldnames(DIFFDATA.conditions.(conds{1}));
    %participant_size = size(ACTIVE_DATA.conditions.(conds{1}).(freqs{1}),1);
    MAX_part_size = 22; % youngs stop at index 22.
    %for par_i = 1:MAX_part_size
        %fprintf('Processing Participant %i \n',par_i);    
        for cond_i = 1:length(conds)
            fprintf('\t%s \n',conds{cond_i});
            for freq_i = 1:length(freqs)
                fprintf('\t\t%s \n',freqs{freq_i});
                [~,PVALS_DIFFDATA.conditions.(conds{cond_i}).(freqs{freq_i})(:,:,:),~,t]= ttest(DIFFDATA.conditions.(conds{cond_i}).(freqs{freq_i})(1:MAX_part_size,:,:,:),0);
                TVALS_DIFFDATA.conditions.(conds{cond_i}).(freqs{freq_i})(:,:,:) = t.tstat;    
            end
        end
    %end
end


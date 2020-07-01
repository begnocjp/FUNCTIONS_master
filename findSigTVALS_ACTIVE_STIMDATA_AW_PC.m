function [SIGTVALS_ACTIVE_DATA] = findSigTVALS_ACTIVE_STIMDATA_AW_PC(TVALS_ACTIVE_DATA,PVALS_ACTIVE_DATA,SIGTVALS_ACTIVE_DATA,SIGNIFICANCE)

    conds = fieldnames(TVALS_ACTIVE_DATA.conditions);
    freqs = fieldnames(TVALS_ACTIVE_DATA.conditions.(conds{1}));

    fprintf('Finding Significant TVALS: \n')
    for cond_i = 1:length(conds)
        fprintf('\t%s \n',conds{cond_i});
        for freq_i = 1:length(freqs)
            fprintf('\t\t%s ',freqs{freq_i});
            tic;
            for time_i = 1:size(PVALS_ACTIVE_DATA.conditions.(conds{cond_i}).(freqs{freq_i}),1)
                fprintf('.');
                for row_i = 1:size(PVALS_ACTIVE_DATA.conditions.(conds{cond_i}).(freqs{freq_i}),2)
                    for col_i = 1:size(PVALS_ACTIVE_DATA.conditions.(conds{cond_i}).(freqs{freq_i}),3)
                        [h,~,~] = fdr_bh(PVALS_ACTIVE_DATA.conditions.(conds{cond_i}).(freqs{freq_i})(time_i,row_i,col_i),SIGNIFICANCE,'pdep','no');
                        if h == 1;
                            SIGTVALS_ACTIVE_DATA.conditions.(conds{cond_i}).(freqs{freq_i})(time_i,row_i,col_i) = TVALS_ACTIVE_DATA.conditions.(conds{1}).(freqs{1})(time_i,row_i,col_i);
                        end
                        clear h
                    end
                end
               
            end
            time_counter = toc;
            fprintf('\t\t%2.2f seconds\n',time_counter);
        end
    end
end

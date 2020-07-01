function [SIGTVALS_SHAM_DATA] = findSigTVALS_SHAM_STIMDATA_AW_PC(TVALS_SHAM_DATA,PVALS_SHAM_DATA,SIGTVALS_SHAM_DATA,SIGNIFICANCE)

    conds = fieldnames(TVALS_SHAM_DATA.conditions);
    freqs = fieldnames(TVALS_SHAM_DATA.conditions.(conds{1}));

    fprintf('Finding Significant TVALS: \n')
    for cond_i = 1:length(conds)
        fprintf('\t%s \n',conds{cond_i});
        for freq_i = 1:length(freqs)
            fprintf('\t\t%s ',freqs{freq_i});
            tic;
            for time_i = 1:size(PVALS_SHAM_DATA.conditions.(conds{cond_i}).(freqs{freq_i}),1)
                fprintf('.');
                for row_i = 1:size(PVALS_SHAM_DATA.conditions.(conds{cond_i}).(freqs{freq_i}),2)
                    for col_i = 1:size(PVALS_SHAM_DATA.conditions.(conds{cond_i}).(freqs{freq_i}),3)
                        [h,~,~] = fdr_bh(PVALS_SHAM_DATA.conditions.(conds{cond_i}).(freqs{freq_i})(time_i,row_i,col_i),SIGNIFICANCE,'pdep','no');
                        if h == 1;
                            SIGTVALS_SHAM_DATA.conditions.(conds{cond_i}).(freqs{freq_i})(time_i,row_i,col_i) = TVALS_SHAM_DATA.conditions.(conds{1}).(freqs{1})(time_i,row_i,col_i);
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

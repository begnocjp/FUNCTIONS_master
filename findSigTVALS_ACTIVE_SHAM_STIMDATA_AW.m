function [SIGTVALS_DIFFDATA] = findSigTVALS_ACTIVE_SHAM_STIMDATA_AW(TVALS_DIFFDATA,PVALS_DIFFDATA,SIGTVALS_DIFFDATA,SIGNIFICANCE)

    conds = fieldnames(TVALS_DIFFDATA.conditions);
    freqs = fieldnames(TVALS_DIFFDATA.conditions.(conds{1}));

    fprintf('Finding Significant TVALS: \n')
    for cond_i = 1:length(conds)
        fprintf('\t%s \n',conds{cond_i});
        for freq_i = 1:length(freqs)
            fprintf('\t\t%s ',freqs{freq_i});
            tic;
            for time_i = 1:size(PVALS_DIFFDATA.conditions.(conds{1}).(freqs{1}),1)
                fprintf('.');
                for row_i = 1:size(PVALS_DIFFDATA.conditions.(conds{1}).(freqs{1}),2)
                    for col_i = 1:size(PVALS_DIFFDATA.conditions.(conds{1}).(freqs{1}),3)
                        [h,~,~] = fdr_bh(PVALS_DIFFDATA.conditions.(conds{1}).(freqs{1})(time_i,row_i,col_i),SIGNIFICANCE,'pdep','no');
                        if h == 1;
                            SIGTVALS_DIFFDATA.conditions.(conds{1}).(freqs{1})(time_i,row_i,col_i) = TVALS_DIFFDATA.conditions.(conds{1}).(freqs{1})(time_i,row_i,col_i);
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

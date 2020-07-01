function [SIGTVALS_ACTIVE_SHAM_STIMDATA] = findSigTVALS_ACTIVE_SHAM_STIMDATA_ORDER(TVALS_ACTIVE_SHAM_STIMDATA,PVALS_ACTIVE_SHAM_STIMDATA,stim_i,time_i,SIGTVALS_ACTIVE_SHAM_STIMDATA,SIGNIFICANCE)
switch stim_i
    case 1
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.delta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.delta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.theta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.theta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.loweralpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.loweralpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.upperalpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.upperalpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.beta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.beta(time_i,row,col);
                end
                clear h
            end
        end
    case 2
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.delta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.delta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.theta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.theta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.loweralpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.loweralpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.upperalpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.upperalpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.beta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.beta(time_i,row,col);
                end
                clear h
            end
        end

    case 3
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.delta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.delta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.theta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.theta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.loweralpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.loweralpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.upperalpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.upperalpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.beta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.beta(time_i,row,col);
                end
                clear h
            end
        end
    case 4
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.delta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.delta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.theta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.theta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.loweralpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.loweralpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.upperalpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.upperalpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.beta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.beta(time_i,row,col);
                end
                clear h
            end
        end

end
end
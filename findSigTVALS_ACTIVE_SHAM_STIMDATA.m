function [SIGTVALS_ACTIVE_SHAM_STIMDATA] = findSigTVALS_ACTIVE_SHAM_STIMDATA(TVALS_ACTIVE_SHAM_STIMDATA,PVALS_ACTIVE_SHAM_STIMDATA,stim_i,time_i,SIGTVALS_ACTIVE_SHAM_STIMDATA,SIGNIFICANCE)
switch stim_i
    case 1
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.active.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.active.delta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.active.delta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.active.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.active.theta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.active.theta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.active.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.active.loweralpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.active.loweralpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.active.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.active.upperalpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.active.upperalpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.active.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.active.beta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.active.beta(time_i,row,col);
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
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.delta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.delta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.theta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.theta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.loweralpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.loweralpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.upperalpha(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.upperalpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.beta(time_i,row,col) = TVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.beta(time_i,row,col);
                end
                clear h
            end
        end
        
end
end
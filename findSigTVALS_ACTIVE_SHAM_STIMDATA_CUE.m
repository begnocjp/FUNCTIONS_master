function [SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE] = findSigTVALS_ACTIVE_SHAM_STIMDATA_CUE(TVALS_ACTIVE_STIMDATA_DIR,TVALS_ACTIVE_STIMDATA_NONDIR,TVALS_SHAM_STIMDATA_DIR,TVALS_SHAM_STIMDATA_NONDIR,PVALS_ACTIVE_STIMDATA_DIR,PVALS_ACTIVE_STIMDATA_NONDIR,PVALS_SHAM_STIMDATA_DIR,PVALS_SHAM_STIMDATA_NONDIR,cond_i,time_i,SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE,SIGNIFICANCE)
switch cond_i
    case 1 %dir active
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                [h,~,~] = fdr_bh(PVALS_ACTIVE_STIMDATA_DIR.conditions.dir.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.dir.delta(time_i,row,col) = TVALS_ACTIVE_STIMDATA_DIR.conditions.dir.delta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_STIMDATA_DIR.conditions.dir.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.dir.theta(time_i,row,col) = TVALS_ACTIVE_STIMDATA_DIR.conditions.dir.theta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_STIMDATA_DIR.conditions.dir.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.dir.loweralpha(time_i,row,col) = TVALS_ACTIVE_STIMDATA_DIR.conditions.dir.loweralpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_STIMDATA_DIR.conditions.dir.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.dir.upperalpha(time_i,row,col) = TVALS_ACTIVE_STIMDATA_DIR.conditions.dir.upperalpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_STIMDATA_DIR.conditions.dir.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.dir.beta(time_i,row,col) = TVALS_ACTIVE_STIMDATA_DIR.conditions.dir.beta(time_i,row,col);
                end
                clear h
            end
        end
    case 2 %nondir active
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                [h,~,~] = fdr_bh(PVALS_ACTIVE_STIMDATA_NONDIR.conditions.nondir.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.nondir.delta(time_i,row,col) = TVALS_ACTIVE_STIMDATA_NONDIR.conditions.nondir.delta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_STIMDATA_NONDIR.conditions.nondir.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.nondir.theta(time_i,row,col) = TVALS_ACTIVE_STIMDATA_NONDIR.conditions.nondir.theta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_STIMDATA_NONDIR.conditions.nondir.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.nondir.loweralpha(time_i,row,col) = TVALS_ACTIVE_STIMDATA_NONDIR.conditions.nondir.loweralpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_STIMDATA_NONDIR.conditions.nondir.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.nondir.upperalpha(time_i,row,col) = TVALS_ACTIVE_STIMDATA_NONDIR.conditions.nondir.upperalpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_ACTIVE_STIMDATA_NONDIR.conditions.nondir.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.nondir.beta(time_i,row,col) = TVALS_ACTIVE_STIMDATA_NONDIR.conditions.nondir.beta(time_i,row,col);
                end
                clear h
            end
        end
    case 3 %dir sham
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                [h,~,~] = fdr_bh(PVALS_SHAM_STIMDATA_DIR.conditions.dir.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.dir.delta(time_i,row,col) = TVALS_SHAM_STIMDATA_DIR.conditions.dir.delta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_SHAM_STIMDATA_DIR.conditions.dir.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.dir.theta(time_i,row,col) = TVALS_SHAM_STIMDATA_DIR.conditions.dir.theta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_SHAM_STIMDATA_DIR.conditions.dir.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.dir.loweralpha(time_i,row,col) = TVALS_SHAM_STIMDATA_DIR.conditions.dir.loweralpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_SHAM_STIMDATA_DIR.conditions.dir.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.dir.upperalpha(time_i,row,col) = TVALS_SHAM_STIMDATA_DIR.conditions.dir.upperalpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_SHAM_STIMDATA_DIR.conditions.dir.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.dir.beta(time_i,row,col) = TVALS_SHAM_STIMDATA_DIR.conditions.dir.beta(time_i,row,col);
                end
                clear h
            end
        end
    case 4 %nondir sham
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                [h,~,~] = fdr_bh(PVALS_SHAM_STIMDATA_NONDIR.conditions.nondir.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.nondir.delta(time_i,row,col) = TVALS_SHAM_STIMDATA_NONDIR.conditions.nondir.delta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_SHAM_STIMDATA_NONDIR.conditions.nondir.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.nondir.theta(time_i,row,col) = TVALS_SHAM_STIMDATA_NONDIR.conditions.nondir.theta(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_SHAM_STIMDATA_NONDIR.conditions.nondir.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.nondir.loweralpha(time_i,row,col) = TVALS_SHAM_STIMDATA_NONDIR.conditions.nondir.loweralpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_SHAM_STIMDATA_NONDIR.conditions.nondir.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.nondir.upperalpha(time_i,row,col) = TVALS_SHAM_STIMDATA_NONDIR.conditions.nondir.upperalpha(time_i,row,col);
                end
                clear h
                [h,~,~] = fdr_bh(PVALS_SHAM_STIMDATA_NONDIR.conditions.nondir.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
                if h == 1;
                    SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE.conditions.nondir.beta(time_i,row,col) = TVALS_SHAM_STIMDATA_NONDIR.conditions.nondir.beta(time_i,row,col);
                end
                clear h
            end
        end
        
end
end
function [SIGTVALS] = findSigTVals(TVALS,PVALS,cond_i,time_i,SIGTVALS,SIGNIFICANCE)
switch cond_i
    case 1
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                   27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                   50 51 54 55 56 57 58 59 60 62 63 64];
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                   27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                   50 51 54 55 56 57 58 59 60 62 63 64];
               [h,~,~] = fdr_bh(PVALS.conditions.dirleft.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.dirleft.delta(time_i,row,col) = TVALS.conditions.dirleft.delta(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.dirleft.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.dirleft.theta(time_i,row,col) = TVALS.conditions.dirleft.theta(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.dirleft.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.dirleft.loweralpha(time_i,row,col) = TVALS.conditions.dirleft.loweralpha(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.dirleft.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.dirleft.upperalpha(time_i,row,col) = TVALS.conditions.dirleft.upperalpha(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.dirleft.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.dirleft.beta(time_i,row,col) = TVALS.conditions.dirleft.beta(time_i,row,col);
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
               [h,~,~] = fdr_bh(PVALS.conditions.dirright.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.dirright.delta(time_i,row,col) = TVALS.conditions.dirright.delta(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.dirright.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.dirright.theta(time_i,row,col) = TVALS.conditions.dirright.theta(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.dirright.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.dirright.loweralpha(time_i,row,col) = TVALS.conditions.dirright.loweralpha(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.dirright.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.dirright.upperalpha(time_i,row,col) = TVALS.conditions.dirright.upperalpha(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.dirright.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.dirright.beta(time_i,row,col) = TVALS.conditions.dirright.beta(time_i,row,col);
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
               [h,~,~] = fdr_bh(PVALS.conditions.nondirleft.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.nondirleft.delta(time_i,row,col) = TVALS.conditions.nondirleft.delta(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.nondirleft.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.nondirleft.theta(time_i,row,col) = TVALS.conditions.nondirleft.theta(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.nondirleft.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.nondirleft.loweralpha(time_i,row,col) = TVALS.conditions.nondirleft.loweralpha(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.nondirleft.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.nondirleft.upperalpha(time_i,row,col) = TVALS.conditions.nondirleft.upperalpha(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.nondirleft.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.nondirleft.beta(time_i,row,col) = TVALS.conditions.nondirleft.beta(time_i,row,col);
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
               [h,~,~] = fdr_bh(PVALS.conditions.nondirright.delta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.nondirright.delta(time_i,row,col) = TVALS.conditions.nondirright.delta(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.nondirright.theta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.nondirright.theta(time_i,row,col) = TVALS.conditions.nondirright.theta(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.nondirright.loweralpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.nondirright.loweralpha(time_i,row,col) = TVALS.conditions.nondirright.loweralpha(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.nondirright.upperalpha(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.nondirright.upperalpha(time_i,row,col) = TVALS.conditions.nondirright.upperalpha(time_i,row,col);
               end
               clear h
               [h,~,~] = fdr_bh(PVALS.conditions.nondirright.beta(time_i,row,col),SIGNIFICANCE,'pdep','no');
               if h == 1;
                   SIGTVALS.conditions.nondirright.beta(time_i,row,col) = TVALS.conditions.nondirright.beta(time_i,row,col);
               end
               clear h
            end
        end
end
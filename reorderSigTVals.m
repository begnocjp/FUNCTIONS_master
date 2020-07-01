function [REORDSIGTVALS] = reorderSigTVals(SIGTVALS,cond_i,time_i,REORDSIGTVALS)
switch cond_i
    case 1
        rowcount = 0;
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            rowcount = rowcount +1;
            colcount = 0;
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                if isinf(SIGTVALS.conditions.dirleft.delta(time_i,row,col));
                    SIGTVALS.conditions.dirleft.delta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.dirleft.theta(time_i,row,col));
                    SIGTVALS.conditions.dirleft.theta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.dirleft.loweralpha(time_i,row,col));
                    SIGTVALS.conditions.dirleft.loweralpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.dirleft.upperalpha(time_i,row,col));
                    SIGTVALS.conditions.dirleft.upperalpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.dirleft.beta(time_i,row,col));
                    SIGTVALS.conditions.dirleft.beta(time_i,row,col) = 0;
                end
                colcount = colcount+1;
                REORDSIGTVALS.conditions.dirleft.delta(time_i,rowcount,colcount) = SIGTVALS.conditions.dirleft.delta(time_i,row,col);
                REORDSIGTVALS.conditions.dirleft.theta(time_i,rowcount,colcount) = SIGTVALS.conditions.dirleft.theta(time_i,row,col);
                REORDSIGTVALS.conditions.dirleft.loweralpha(time_i,rowcount,colcount) = SIGTVALS.conditions.dirleft.loweralpha(time_i,row,col);
                REORDSIGTVALS.conditions.dirleft.upperalpha(time_i,rowcount,colcount) = SIGTVALS.conditions.dirleft.upperalpha(time_i,row,col);
                REORDSIGTVALS.conditions.dirleft.beta(time_i,rowcount,colcount) = SIGTVALS.conditions.dirleft.beta(time_i,row,col);
            end
        end
    case 2
        rowcount = 0;
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            rowcount = rowcount +1;
            colcount = 0;
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                if isinf(SIGTVALS.conditions.dirright.delta(time_i,row,col));
                    SIGTVALS.conditions.dirright.delta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.dirright.theta(time_i,row,col));
                    SIGTVALS.conditions.dirright.theta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.dirright.loweralpha(time_i,row,col));
                    SIGTVALS.conditions.dirright.loweralpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.dirright.upperalpha(time_i,row,col));
                    SIGTVALS.conditions.dirright.upperalpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.dirright.beta(time_i,row,col));
                    SIGTVALS.conditions.dirright.beta(time_i,row,col) = 0;
                end
                colcount = colcount+1;
                REORDSIGTVALS.conditions.dirright.delta(time_i,rowcount,colcount) = SIGTVALS.conditions.dirright.delta(time_i,row,col);
                REORDSIGTVALS.conditions.dirright.theta(time_i,rowcount,colcount) = SIGTVALS.conditions.dirright.theta(time_i,row,col);
                REORDSIGTVALS.conditions.dirright.loweralpha(time_i,rowcount,colcount) = SIGTVALS.conditions.dirright.loweralpha(time_i,row,col);
                REORDSIGTVALS.conditions.dirright.upperalpha(time_i,rowcount,colcount) = SIGTVALS.conditions.dirright.upperalpha(time_i,row,col);
                REORDSIGTVALS.conditions.dirright.beta(time_i,rowcount,colcount) = SIGTVALS.conditions.dirright.beta(time_i,row,col);
            end
        end
    case 3
        rowcount = 0;
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            rowcount = rowcount +1;
            colcount = 0;
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                if isinf(SIGTVALS.conditions.nondirleft.delta(time_i,row,col));
                    SIGTVALS.conditions.nondirleft.delta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.nondirleft.theta(time_i,row,col));
                    SIGTVALS.conditions.nondirleft.theta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.nondirleft.loweralpha(time_i,row,col));
                    SIGTVALS.conditions.nondirleft.loweralpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.nondirleft.upperalpha(time_i,row,col));
                    SIGTVALS.conditions.nondirleft.upperalpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.nondirleft.beta(time_i,row,col));
                    SIGTVALS.conditions.nondirleft.beta(time_i,row,col) = 0;
                end
                colcount = colcount+1;
                REORDSIGTVALS.conditions.nondirleft.delta(time_i,rowcount,colcount) = SIGTVALS.conditions.nondirleft.delta(time_i,row,col);
                REORDSIGTVALS.conditions.nondirleft.theta(time_i,rowcount,colcount) = SIGTVALS.conditions.nondirleft.theta(time_i,row,col);
                REORDSIGTVALS.conditions.nondirleft.loweralpha(time_i,rowcount,colcount) = SIGTVALS.conditions.nondirleft.loweralpha(time_i,row,col);
                REORDSIGTVALS.conditions.nondirleft.upperalpha(time_i,rowcount,colcount) = SIGTVALS.conditions.nondirleft.upperalpha(time_i,row,col);
                REORDSIGTVALS.conditions.nondirleft.beta(time_i,rowcount,colcount) = SIGTVALS.conditions.nondirleft.beta(time_i,row,col);
            end
        end
    case 4
        rowcount = 0;
        for row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                50 51 54 55 56 57 58 59 60 62 63 64];
            rowcount = rowcount +1;
            colcount = 0;
            for col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 25 26 ...
                    27 29 30 31 32 36 37 38 39 40 41 44 45 46 47 48 49 ...
                    50 51 54 55 56 57 58 59 60 62 63 64];
                if isinf(SIGTVALS.conditions.nondirright.delta(time_i,row,col));
                    SIGTVALS.conditions.nondirright.delta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.nondirright.theta(time_i,row,col));
                    SIGTVALS.conditions.nondirright.theta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.nondirright.loweralpha(time_i,row,col));
                    SIGTVALS.conditions.nondirright.loweralpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.nondirright.upperalpha(time_i,row,col));
                    SIGTVALS.conditions.nondirright.upperalpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS.conditions.nondirright.beta(time_i,row,col));
                    SIGTVALS.conditions.nondirright.beta(time_i,row,col) = 0;
                end
                colcount = colcount+1;
                REORDSIGTVALS.conditions.nondirright.delta(time_i,rowcount,colcount) = SIGTVALS.conditions.nondirright.delta(time_i,row,col);
                REORDSIGTVALS.conditions.nondirright.theta(time_i,rowcount,colcount) = SIGTVALS.conditions.nondirright.theta(time_i,row,col);
                REORDSIGTVALS.conditions.nondirright.loweralpha(time_i,rowcount,colcount) = SIGTVALS.conditions.nondirright.loweralpha(time_i,row,col);
                REORDSIGTVALS.conditions.nondirright.upperalpha(time_i,rowcount,colcount) = SIGTVALS.conditions.nondirright.upperalpha(time_i,row,col);
                REORDSIGTVALS.conditions.nondirright.beta(time_i,rowcount,colcount) = SIGTVALS.conditions.nondirright.beta(time_i,row,col);
            end
        end
end
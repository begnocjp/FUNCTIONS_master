function [REORDSIGTVALS_ACTIVE_SHAM_STIMDATA] = reorderSigTVals_ACTIVE_SHAM_STIMDATA_ORDER(SIGTVALS_ACTIVE_SHAM_STIMDATA,stim_i,time_i,REORDSIGTVALS_ACTIVE_SHAM_STIMDATA)
switch stim_i
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
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.delta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.delta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.theta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.theta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.loweralpha(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.loweralpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.upperalpha(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.upperalpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.beta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.beta(time_i,row,col) = 0;
                end
                colcount = colcount+1;
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.delta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.delta(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.theta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.theta(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.loweralpha(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.loweralpha(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.upperalpha(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.upperalpha(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.beta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activeone.beta(time_i,row,col);
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
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.delta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.delta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.theta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.theta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.loweralpha(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.loweralpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.upperalpha(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.upperalpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.beta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.beta(time_i,row,col) = 0;
                end
                colcount = colcount+1;
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.delta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.delta(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.theta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.theta(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.loweralpha(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.loweralpha(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.upperalpha(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.upperalpha(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.beta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamone.beta(time_i,row,col);
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
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.delta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.delta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.theta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.theta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.loweralpha(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.loweralpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.upperalpha(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.upperalpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.beta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.beta(time_i,row,col) = 0;
                end
                colcount = colcount+1;
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.delta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.delta(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.theta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.theta(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.loweralpha(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.loweralpha(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.upperalpha(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.upperalpha(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.beta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.activetwo.beta(time_i,row,col);
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
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.delta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.delta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.theta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.theta(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.loweralpha(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.loweralpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.upperalpha(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.upperalpha(time_i,row,col) = 0;
                end
                if isinf(SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.beta(time_i,row,col));
                    SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.beta(time_i,row,col) = 0;
                end
                colcount = colcount+1;
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.delta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.delta(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.theta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.theta(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.loweralpha(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.loweralpha(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.upperalpha(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.upperalpha(time_i,row,col);
                REORDSIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.beta(time_i,rowcount,colcount) = SIGTVALS_ACTIVE_SHAM_STIMDATA.conditions.shamtwo.beta(time_i,row,col);
            end
        end        
end
end
function [TVALS_DIFFDATA,PVALS_DIFFDATA] = ttestConnMats_young(DIFFDATA,cond_i,time_i,TVALS_DIFFDATA,PVALS_DIFFDATA)
partgroup = 22;%index for participants per age group
switch cond_i
    case 1
        for row = 1:size(DIFFDATA.conditions.dirleft.delta,3)
            for col = 1:size(DIFFDATA.conditions.dirleft.delta,4)
                [~,PVALS_DIFFDATA.conditions.dirleft.delta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.dirleft.delta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.dirleft.delta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.dirleft.theta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.dirleft.theta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.dirleft.theta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.dirleft.loweralpha(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.dirleft.loweralpha(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.dirleft.loweralpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.dirleft.upperalpha(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.dirleft.upperalpha(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.dirleft.upperalpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.dirleft.beta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.dirleft.beta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.dirleft.beta(time_i,row,col) = t.tstat;
                clear t
            end
        end
    case 2
        for row = 1:size(DIFFDATA.conditions.dirleft.delta,3)
            for col = 1:size(DIFFDATA.conditions.dirleft.delta,4)
                [~,PVALS_DIFFDATA.conditions.dirright.delta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.dirright.delta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.dirright.delta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.dirright.theta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.dirright.theta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.dirright.theta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.dirright.loweralpha(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.dirright.loweralpha(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.dirright.loweralpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.dirright.upperalpha(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.dirright.upperalpha(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.dirright.upperalpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.dirright.beta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.dirright.beta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.dirright.beta(time_i,row,col) = t.tstat;
                clear t
            end
        end
    case 3
        for row = 1:size(DIFFDATA.conditions.dirleft.delta,3)
            for col = 1:size(DIFFDATA.conditions.dirleft.delta,4)
                [~,PVALS_DIFFDATA.conditions.nondirleft.delta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.nondirleft.delta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.nondirleft.delta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.nondirleft.theta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.nondirleft.theta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.nondirleft.theta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.nondirleft.loweralpha(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.nondirleft.loweralpha(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.nondirleft.loweralpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.nondirleft.upperalpha(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.nondirleft.upperalpha(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.nondirleft.upperalpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.nondirleft.beta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.nondirleft.beta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.nondirleft.beta(time_i,row,col) = t.tstat;
                clear t
            end
        end
    case 4
        for row = 1:size(DIFFDATA.conditions.dirleft.delta,3)
            for col = 1:size(DIFFDATA.conditions.dirleft.delta,4)
                [~,PVALS_DIFFDATA.conditions.nondirright.delta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.nondirright.delta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.nondirright.delta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.nondirright.theta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.nondirright.theta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.nondirright.theta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.nondirright.loweralpha(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.nondirright.loweralpha(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.nondirright.loweralpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.nondirright.upperalpha(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.nondirright.upperalpha(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.nondirright.upperalpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_DIFFDATA.conditions.nondirright.beta(time_i,row,col),~,t]= ttest(DIFFDATA.conditions.nondirright.beta(1:partgroup,time_i,row,col),0);
                TVALS_DIFFDATA.conditions.nondirright.beta(time_i,row,col) = t.tstat;
                clear t
            end
        end
end
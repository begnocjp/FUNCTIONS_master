function [TVALS_CUEDATA,PVALS_CUEDATA] = ttestCueConnMats_young(ACTIVE_AVCUEDATA,SHAM_AVCUEDATA,cond_i,time_i,TVALS_CUEDATA,PVALS_CUEDATA)
partgroup = 22;%index for participants per age group
switch cond_i
    case 1 %dir active
        for row = 1:size(ACTIVE_AVCUEDATA.conditions.dir.delta,3)
            for col = 1:size(ACTIVE_AVCUEDATA.conditions.dir.delta,4)
                [~,PVALS_CUEDATA.conditions.dir.delta(time_i,row,col),~,t]= ttest(ACTIVE_AVCUEDATA.conditions.dir.delta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.dir.delta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.dir.theta(time_i,row,col),~,t]= ttest(ACTIVE_AVCUEDATA.conditions.dir.theta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.dir.theta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.dir.loweralpha(time_i,row,col),~,t]= ttest(ACTIVE_AVCUEDATA.conditions.dir.loweralpha(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.dir.loweralpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.dir.upperalpha(time_i,row,col),~,t]= ttest(ACTIVE_AVCUEDATA.conditions.dir.upperalpha(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.dir.upperalpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.dir.beta(time_i,row,col),~,t]= ttest(ACTIVE_AVCUEDATA.conditions.dir.beta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.dir.beta(time_i,row,col) = t.tstat;
                clear t
            end
        end
    case 2 %nondir active
        for row = 1:size(ACTIVE_AVCUEDATA.conditions.nondir.delta,3)
            for col = 1:size(ACTIVE_AVCUEDATA.conditions.nondir.delta,4)
                [~,PVALS_CUEDATA.conditions.nondir.delta(time_i,row,col),~,t]= ttest(ACTIVE_AVCUEDATA.conditions.nondir.delta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.nondir.delta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.nondir.theta(time_i,row,col),~,t]= ttest(ACTIVE_AVCUEDATA.conditions.nondir.theta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.nondir.theta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.nondir.loweralpha(time_i,row,col),~,t]= ttest(ACTIVE_AVCUEDATA.conditions.nondir.loweralpha(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.nondir.loweralpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.nondir.upperalpha(time_i,row,col),~,t]= ttest(ACTIVE_AVCUEDATA.conditions.nondir.upperalpha(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.nondir.upperalpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.nondir.beta(time_i,row,col),~,t]= ttest(ACTIVE_AVCUEDATA.conditions.nondir.beta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.nondir.beta(time_i,row,col) = t.tstat;
                clear t
            end
        end
    case 3 %dir sham
        for row = 1:size(SHAM_AVCUEDATA.conditions.dir.delta,3)
            for col = 1:size(SHAM_AVCUEDATA.conditions.dir.delta,4)
                [~,PVALS_CUEDATA.conditions.dir.delta(time_i,row,col),~,t]= ttest(SHAM_AVCUEDATA.conditions.dir.delta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.dir.delta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.dir.theta(time_i,row,col),~,t]= ttest(SHAM_AVCUEDATA.conditions.dir.theta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.dir.theta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.dir.loweralpha(time_i,row,col),~,t]= ttest(SHAM_AVCUEDATA.conditions.dir.loweralpha(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.dir.loweralpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.dir.upperalpha(time_i,row,col),~,t]= ttest(SHAM_AVCUEDATA.conditions.dir.upperalpha(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.dir.upperalpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.dir.beta(time_i,row,col),~,t]= ttest(SHAM_AVCUEDATA.conditions.dir.beta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.dir.beta(time_i,row,col) = t.tstat;
                clear t
            end
        end
    case 4 %nondir active
        for row = 1:size(SHAM_AVCUEDATA.conditions.nondir.delta,3)
            for col = 1:size(SHAM_AVCUEDATA.conditions.nondir.delta,4)
                [~,PVALS_CUEDATA.conditions.nondir.delta(time_i,row,col),~,t]= ttest(SHAM_AVCUEDATA.conditions.nondir.delta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.nondir.delta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.nondir.theta(time_i,row,col),~,t]= ttest(SHAM_AVCUEDATA.conditions.nondir.theta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.nondir.theta(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.nondir.loweralpha(time_i,row,col),~,t]= ttest(SHAM_AVCUEDATA.conditions.nondir.loweralpha(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.nondir.loweralpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.nondir.upperalpha(time_i,row,col),~,t]= ttest(SHAM_AVCUEDATA.conditions.nondir.upperalpha(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.nondir.upperalpha(time_i,row,col) = t.tstat;
                clear t
                [~,PVALS_CUEDATA.conditions.nondir.beta(time_i,row,col),~,t]= ttest(SHAM_AVCUEDATA.conditions.nondir.beta(1:partgroup,time_i,row,col),0);
                TVALS_CUEDATA.conditions.nondir.beta(time_i,row,col) = t.tstat;
                clear t
            end
        end        
end
function [TVALS_ACTIVE_SHAM_STIMDATA_ORDER,PVALS_ACTIVE_SHAM_STIMDATA_ORDER] = ttestConnMats_ACTIVE_SHAM_STIMDATA_ORDER_young(ACTIVE_SHAM_STIMDATA,time_i,TVALS_ACTIVE_SHAM_STIMDATA_ORDER,PVALS_ACTIVE_SHAM_STIMDATA_ORDER)
%order indices
actone = [3 5 8 9 10 13 15 16 19 21 22];
acttwo = [1 2 4 6 7 11 12 14 17 18 20];
shamone = acttwo;
shamtwo = actone;

for row = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,3)
    for col = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,4)
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.delta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.delta(actone,time_i,row,col),0);%magic number - 22 = young participants
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.delta(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.theta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.theta(actone,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.theta(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.loweralpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.loweralpha(actone,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.loweralpha(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.upperalpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.upperalpha(actone,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.upperalpha(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.beta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.beta(actone,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.beta(time_i,row,col) = t.tstat;
        clear t
    end
end
for row = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,3)
    for col = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,4)
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.delta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.delta(shamone,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.delta(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.theta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.theta(shamone,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.theta(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.loweralpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.loweralpha(shamone,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.loweralpha(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.upperalpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.upperalpha(shamone,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.upperalpha(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.beta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.beta(shamone,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.beta(time_i,row,col) = t.tstat;
        clear t
    end
end

for row = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,3)
    for col = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,4)
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.delta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.delta(acttwo,time_i,row,col),0);%magic number - 22 = young participants
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.delta(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.theta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.theta(acttwo,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.theta(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.loweralpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.loweralpha(acttwo,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.loweralpha(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.upperalpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.upperalpha(acttwo,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.upperalpha(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.beta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.beta(acttwo,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.beta(time_i,row,col) = t.tstat;
        clear t
    end
end
for row = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,3)
    for col = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,4)
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.delta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.delta(shamtwo,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.delta(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.theta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.theta(shamtwo,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.theta(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.loweralpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.loweralpha(shamtwo,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.loweralpha(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.upperalpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.upperalpha(shamtwo,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.upperalpha(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.beta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.beta(shamtwo,time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.beta(time_i,row,col) = t.tstat;
        clear t
    end
end

end
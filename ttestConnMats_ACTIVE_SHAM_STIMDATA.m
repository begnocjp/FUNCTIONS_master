function [TVALS_ACTIVE_SHAM_STIMDATA,PVALS_ACTIVE_SHAM_STIMDATA] = ttestConnMats_ACTIVE_SHAM_STIMDATA(ACTIVE_SHAM_STIMDATA,time_i,TVALS_ACTIVE_SHAM_STIMDATA,PVALS_ACTIVE_SHAM_STIMDATA)
for row = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,3)
    for col = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,4)
        [~,PVALS_ACTIVE_SHAM_STIMDATA.conditions.active.delta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.delta(1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,1),time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA.conditions.active.delta(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA.conditions.active.theta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.theta(1:size(ACTIVE_SHAM_STIMDATA.conditions.active.theta,1),time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA.conditions.active.theta(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA.conditions.active.loweralpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.loweralpha(1:size(ACTIVE_SHAM_STIMDATA.conditions.active.loweralpha,1),time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA.conditions.active.loweralpha(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA.conditions.active.upperalpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.upperalpha(1:size(ACTIVE_SHAM_STIMDATA.conditions.active.upperalpha,1),time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA.conditions.active.upperalpha(time_i,row,col) = t.tstat;
        clear t
        [~,PVALS_ACTIVE_SHAM_STIMDATA.conditions.active.beta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.active.beta(1:size(ACTIVE_SHAM_STIMDATA.conditions.active.beta,1),time_i,row,col),0);
        TVALS_ACTIVE_SHAM_STIMDATA.conditions.active.beta(time_i,row,col) = t.tstat;
        clear t
    end
end
    for row = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,3)
        for col = 1:size(ACTIVE_SHAM_STIMDATA.conditions.active.delta,4)
            [~,PVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.delta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.delta(1:size(ACTIVE_SHAM_STIMDATA.conditions.sham.delta,1),time_i,row,col),0);
            TVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.delta(time_i,row,col) = t.tstat;
            clear t
            [~,PVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.theta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.theta(1:size(ACTIVE_SHAM_STIMDATA.conditions.sham.theta,1),time_i,row,col),0);
            TVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.theta(time_i,row,col) = t.tstat;
            clear t
            [~,PVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.loweralpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.loweralpha(1:size(ACTIVE_SHAM_STIMDATA.conditions.sham.loweralpha,1),time_i,row,col),0);
            TVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.loweralpha(time_i,row,col) = t.tstat;
            clear t
            [~,PVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.upperalpha(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.upperalpha(1:size(ACTIVE_SHAM_STIMDATA.conditions.sham.upperalpha,1),time_i,row,col),0);
            TVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.upperalpha(time_i,row,col) = t.tstat;
            clear t
            [~,PVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.beta(time_i,row,col),~,t]= ttest(ACTIVE_SHAM_STIMDATA.conditions.sham.beta(1:size(ACTIVE_SHAM_STIMDATA.conditions.sham.beta,1),time_i,row,col),0);
            TVALS_ACTIVE_SHAM_STIMDATA.conditions.sham.beta(time_i,row,col) = t.tstat;
            clear t
        end
    end

end
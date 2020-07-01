% GRandAverage Topoplots:
conditions = {'ar','mr','st','sa','nr','ns'};
OUTPUTDIR = 'F:\FNL_EEG_TOOLBOX\TIMELOCK_ERPS\HEADPLOTS\';
close all;
cfg = [];
cfg.parameter   = 'avg';
cfg.zlim  = [-5 5];
cfg.comment = 'no';
for i = -0.2:0.01:0;
    cfg.xlim = [ i i+0.025]; %150-200ms %[513 513+256];
    %   cfg.highlight = 'labels';
    cfg.layout      = 'biosemi64.lay';
    
    figure('Position',[50 50 1600 900]);
    %    title(names(1,name_i).pnum);
    subplot(2,3,1)
    ft_topoplotER(cfg,Class_ar) ;
    title('All Repeat');
    
    subplot(2,3,2)
    ft_topoplotER(cfg, Class_mr);
    title('Mix Repeat');
    
    subplot(2,3,3)
    ft_topoplotER(cfg, Class_st);
    title('Switch To');
    
    subplot(2,3,4)
    ft_topoplotER(cfg, Class_sa);
    title('Switch Away');
    
    subplot(2,3,5)
    ft_topoplotER(cfg, Class_nr);
    title('NonInf Repeat');
    
    subplot(2,3,6)
    ft_topoplotER(cfg, Class_ns);
    title('NonInf Switch');
    
    text(-3.25,1.20,['GRANDAVERAGE TOPOLOGY [',num2str(cfg.xlim(1)*1000),'-',num2str(cfg.xlim(2)*1000), ']ms'],'FontSize',18);
    
    saveas(gcf,[OUTPUTDIR,'GRANDAVERAGE_TOPOPLOT_ER_',num2str(cfg.xlim(1)*1000)],'png');
    saveas(gcf,[OUTPUTDIR,'GRANDAVERAGE_TOPOPLOT_ER',num2str(cfg.xlim(1)*1000),'.eps',],'psc2');
    close all;
end
function fnl_ICA_RS(wpms,name_i,cond_i)

    fprintf('%s %s %s \n','----- Begin ICA -----','Participant:',wpms.names{name_i});
    cfg = [];
    cfg.channel = 1:(length(cond_i.label)-1);%remove status
    cfg.method = 'fastica';
    ic_data = ft_componentanalysis(cfg,cond_i);
    clear dat %tidying
    fprintf('Saving: %s%s \n',wpms.names{name_i},'''s ICA data. . .');
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i},wpms.conditions{cond_i},'_ICADATA'],'ic_data','-v7.3');
    fprintf('Save successful!\n');
    
end
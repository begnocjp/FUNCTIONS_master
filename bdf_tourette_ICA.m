function bdf_tourette_ICA(wpms,name_i,trdat)

    fprintf('%s %s %s \n','----- Begin ICA -----','Participant:',wpms.names{name_i});
    cfg = [];
    cfg.channel = 1:(length(trdat.label)-5);%remove status and EMG channels
    cfg.method = 'fastica';
    ic_data = ft_componentanalysis(cfg,trdat);
    clear dat %tidying
    fprintf('Saving: %s%s \n',wpms.names{name_i},'''s ICA data. . .');
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i},'_ICADATA'],'ic_data','-v7.3');
    fprintf('Save successful!\n');
    
end
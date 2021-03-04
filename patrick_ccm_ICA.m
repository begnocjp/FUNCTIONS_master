function patrick_ccm_ICA(wpms,name_i,trdat)

    fprintf('%s %s %s \n','----- Begin ICA -----','Participant:',wpms.names{name_i});
    cfg = [];
    cfg.channel = 1:length(trdat.label);%remove status
    cfg.method = 'fastica';
    ic_data = ft_componentanalysis(cfg,trdat);
    clear dat %tidying
    fprintf('Saving: %s%s \n',wpms.names{name_i},'''s ICA data. . .');
    eogcorr = trdat  %not doing anything with IC data (was already removed ith EEGlab) just saving structure for next steps
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i},'_EOGCORRECTED'],'eogcorr','-v7.3'); %not doing anything with IC data (was already removed ith EEGlab) just saving structure for next steps
    fprintf('Save successful!\n');
    
end


%save([wpms.dirs.CWD wpms.dirs.preproc PartID,'_EOGCORRECTED'],'eogcorr');

function patrick_ccm_ICA(wpms,name_i,trdat)

    fprintf('%s %s %s \n','----- Begin ICA -----','Participant:',wpms.names{name_i});
    %cfg = [];
    %cfg.channel = 1:length(trdat.label);%remove status
    %cfg.method = 'fastica';
    %ic_data = ft_componentanalysis(cfg,trdat);
    clear dat %tidying
    fprintf('Saving: %s%s \n',wpms.names{name_i},'''s ICA data. . .');
    eogcorr = trdat  %not doing anything with IC data (was already removed ith EEGlab) just saving structure for next steps
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i},'_EOGCORRECTED'],'eogcorr','-v7.3'); %not doing anything with IC data (was already removed ith EEGlab) just saving structure for next steps
    fprintf('Save successful!\n');
    
end

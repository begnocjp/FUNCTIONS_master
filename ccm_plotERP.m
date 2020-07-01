function ccm_plotERP(wpms,name_i,channel,reverse)
    
    DATA = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK.mat']);
    condition_names = fieldnames(DATA);
    DATA = DATA.timelock;
    figure();
    hold on; 
    %channel = 62; %po8 *right hemisphere
    %channel = 25; %po7 *left hemisphere
    colours = [{'-b'}; {'-g'}; {'-r'}; {'-c'};{'-m'};{'-k'};{'-y'}];
    legend_details = [];
    for plot_i = 1:length(condition_names)
        condition_name = condition_names{plot_i,1};
        plot(DATA.(condition_name).time,DATA.(condition_name).avg(channel,:),colours{plot_i});
        
        %tokenise and rejoin data for legend:
        str_cells_no_underscore = tokenize(condition_name, '_');
        removed_underscore = [];
        for i = 1:length(str_cells_no_underscore)
            removed_underscore = [removed_underscore, str_cells_no_underscore{i},' '];
        end

        
        legend_details = [ legend_details,  '''',removed_underscore,'''',', '];
    end
    
    xlabel('Time (ms)');
    ylabel('uV')
    
    %tokenise and rejoin data for names:
    str_cells_no_underscore = tokenize(wpms.names{name_i}, '_');
    removed_underscore = [];
    for i = 1:length(str_cells_no_underscore)
        removed_underscore = [str_cells_no_underscore{i},' '];
    end

    if reverse == true
        set(gca,'YDir','reverse');
    else
        set(gca,'YDir','normal');
    end
    eval(['legend(',legend_details,'''Location'',''NorthWest'');']);
    title([removed_underscore,'Channel: ',num2str(channel),' TIMELOCK ERP']);
    mkdir([wpms.dirs.CWD wpms.dirs.timelock wpms.names{name_i}])
    saveas(gcf,[wpms.dirs.CWD wpms.dirs.timelock wpms.names{name_i} '\' wpms.names{name_i} '_' num2str(channel) '_TIMELOCK_ERP'],'bmp');
    saveas(gcf,[wpms.dirs.CWD wpms.dirs.timelock wpms.names{name_i} '\' wpms.names{name_i} '_' num2str(channel) '_TIMELOCK_ERP','.eps'],'psc2');
    
    %clear time;
    %save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK'],'timelock*','-v7.3');
    
end

function patrick_ccm_plotERP_ROIs(wpms,name_i,reverse, conditions,condition,ROI,chan)
    
    DATA = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' condition '.mat']);
    condition_names = conditions;
   % DATA = DATA.timelock;
   % DATA = DATA.timelock_erp;

%     cfg = [];
%     cfg.layout = '/Users/patrick/Desktop/EEG/FUNCTIONS/GSN-HydroCel-256.sfp'
%     cfg.interactive = 'yes';
%     cfg.showoutline = 'yes';
%     ft_multiplotER(cfg, AlertDiff);
%         
%   mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat))      
    
        
    figure();
    hold on; 
    colours = [{'-b'}; {'-g'}; {'-r'}; {'-c'};{'-m'};{'-k'};{'-y'}];
    
    for plot_i = 1:length(condition_names)
         label = ' / number of trial used-'
%         title = {strcat(condition_names{1,plot_i}, label, Num_trials)}
        %condition_name = strcat(condition_names{1,plot_i}, label, Num_trials)
%         condition_name = condition_names{1,plot_i};
        plot(DATA.timelock(plot_i).time,mean(DATA.timelock(plot_i).avg(chan.frontal),colours{plot_i});
        
        %tokenise and rejoin data for legend:
        str_cells_no_underscore = condition_names;
        legend_details = [];
        removed_underscore = [];
        for i = 1:length(str_cells_no_underscore)
            removed_underscore = [removed_underscore, str_cells_no_underscore{i},' '];  
        end

      
    end
    
    %get number of trials
         Num_trial_A = num2str(size((DATA.timelock(1).cfg.previous.trials),1))
         Num_trial_B = num2str(size((DATA.timelock(2).cfg.previous.trials),1))
    
     %arrange data for legend
      
        removed_underscore1 = [str_cells_no_underscore{1},' ',label,Num_trial_A]; 
        removed_underscore2 = [str_cells_no_underscore{2},' ',label,Num_trial_B];
        removed_underscore3 = [str_cells_no_underscore{3}];
        
        
        legend_details = [ legend_details,  '''',removed_underscore1,'''',', '];
        legend_details = [ legend_details,  '''',removed_underscore2,'''',', '];
        legend_details = [ legend_details,  '''',removed_underscore3,'''',', '];
   
    xlabel('Time (ms)');
    ylabel('uV')
    
    %tokenise and rejoin data for name
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
    eval(['legend(',legend_details,'''Location'',''SouthWest'');']);
    title([removed_underscore,'Chan: ',ROI,' TIMELOCK ERP' condition]);
    mkdir([wpms.dirs.CWD wpms.dirs.TIMELOCK wpms.names{name_i}])
    saveas(gcf,[wpms.dirs.CWD wpms.dirs.TIMELOCK wpms.names{name_i} '\' wpms.names{name_i} '_' ROI '_TIMELOCK_ERP' condition]);
    saveas(gcf,[wpms.dirs.CWD wpms.dirs.TIMELOCK wpms.names{name_i} '\' wpms.names{name_i} '_' ROI '_TIMELOCK_ERP' condition],'bmp');
    saveas(gcf,[wpms.dirs.CWD wpms.dirs.TIMELOCK wpms.names{name_i} '\' wpms.names{name_i} '_' ROI '_TIMELOCK_ERP' condition,'.eps'],'psc2');
    
    %clear time;
    %save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK'],'timelock*','-v7.3');
    
end

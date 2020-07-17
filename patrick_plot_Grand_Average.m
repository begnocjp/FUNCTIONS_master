function patrick_plot_Grand_Average(wpms,name_i,isreverse_ydir,conditions,caption,condition)


%load all subjects

for name_i = 1:length(wpms.names)
load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' condition '.mat']);
end
 
%make Grand Average a

cfg = [];
   %cfg.channel        = channel      %can toggle to select single/ groups of channels
   %cfg.latency        = [begin end] in seconds or 'all' (default = 'all')
   %cfg.normalizevar   = 'N' or 'N-1' (default = 'N-1')
   cfg.method         = 'across' %(default) or 'within', see below.
   %cfg.parameter      = string or cell-array indicating which
                       % parameter to average. default is set to
                       % 'avg', if it is present in the data
                    
                       
 %compute GA for trial type 1
 
      grandavg{1} = ft_timelockgrandaverage(cfg, ...
       load_subs{1,1}.timelock(1), ...
       load_subs{1,2}.timelock(1), ...
       load_subs{1,3}.timelock(1), ...
       load_subs{1,4}.timelock(1), ...
       load_subs{1,5}.timelock(1), ...
       load_subs{1,6}.timelock(1))

 %compute GA for trial type 2
 
      grandavg{2} = ft_timelockgrandaverage(cfg, ...
       load_subs{1,1}.timelock(2), ...
       load_subs{1,2}.timelock(2), ...
       load_subs{1,3}.timelock(2), ...
       load_subs{1,4}.timelock(2), ...
       load_subs{1,5}.timelock(2), ...
       load_subs{1,6}.timelock(2))

 %compute GA for DIFF

      grandavg{3} = ft_timelockgrandaverage(cfg, ...
       load_subs{1,1}.timelock(3), ...
       load_subs{1,2}.timelock(3), ...
       load_subs{1,3}.timelock(3), ...
       load_subs{1,4}.timelock(3), ...
       load_subs{1,5}.timelock(3), ...
       load_subs{1,6}.timelock(3))

for cond_i = 1:length(conditions)
VAR = conditions{cond_i}
VAR = genvarname(VAR)
VAR = grandavg{1,cond_i};     
end
   



 save([wpms.dirs.CWD wpms.dirs.TIMELOCK 'GRANDAVERAGE' condition '.mat'],'grandavg','-v7.3');
   

cfg = [];
cfg.showlabels    = 'yes';
cfg.fontsize      = 6;
cfg.layout        = '/Users/patrick/Desktop/EEG/FUNCTIONS/GSN-HydroCel-256.sfp';
%cfg.ylim = [-3e-13 3e-13];

ft_multiplotER(cfg, incongruent,grandavg{1,2},grandavg{1,3});
 
incongruent = grandavg{1,1}
 
 
 
 
 

    condition_names = conditions;  
    figure();
    hold on; 
    colours = [{'-b'}; {'-r'}; {'-g'}; {'-c'};{'-m'};{'-k'};{'-y'}];
    
    for plot_i = 1:length(condition_names)
        condition_name = condition_names{1,plot_i};
        plot(grandavg{1,plot_i}.time,grandavg{1,plot_i}.avg,colours{plot_i});
        
        %tokenise and rejoin data for legend:
        str_cells_no_underscore = condition_names;
        legend_details = [];
        removed_underscore = [];
        for i = 1:length(str_cells_no_underscore)
            removed_underscore = [removed_underscore, str_cells_no_underscore{i},' '];  
        end

      
    end
    

    
     %arrange data for legend
        
        removed_underscore1 = [str_cells_no_underscore{1},' ']; 
        removed_underscore2 = [str_cells_no_underscore{2},' '];
        removed_underscore3 = [str_cells_no_underscore{3},' '];
        
        legend_details = [ legend_details,  '''',removed_underscore1,'''',', '];
        legend_details = [ legend_details,  '''',removed_underscore2,'''',', '];
        legend_details = [ legend_details,  '''',removed_underscore3,'''',', '];
   
    xlabel('Time (ms)');
    ylabel('uV')
    
    %tokenise and rejoin data for name
%     str_cells_no_underscore = tokenize(wpms.names{name_i}, '_');
%     removed_underscore = [];
%     for i = 1:length(str_cells_no_underscore)
%         removed_underscore = [str_cells_no_underscore{i},' '];
%     end
% 
%     if reverse == true
%         set(gca,'YDir','reverse');
%     else
%         set(gca,'YDir','normal');
%     end
    eval(['legend(',legend_details,'''Location'',''SouthWest'');']);
    title([caption,'Chan',num2str(channel)]);
    mkdir([wpms.dirs.CWD wpms.dirs.GA_TIMELOCK])
    saveas(gcf,[wpms.dirs.CWD wpms.dirs.GA_TIMELOCK caption '_Chan_' num2str(channel)]);
    saveas(gcf,[wpms.dirs.CWD wpms.dirs.GA_TIMELOCK '\' caption '_Chan_' num2str(channel)],'bmp');
    saveas(gcf,[wpms.dirs.CWD wpms.dirs.GA_TIMELOCK '\' caption '_Chan_' num2str(channel),'.eps'],'psc2');
    
    %clear time;
    %save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK'],'timelock*','-v7.3');
   
   
   
  

end


function patrick_plot_Grand_Average(wpms,name_i,channel,isreverse_ydir,conditions,caption)


%load all subjects

for name_i = 1:length(wpms.names)
load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK.mat']);
end
 
%make Grand Average a

cfg = [];
   cfg.channel        = channel
   %cfg.latency        = [begin end] in seconds or 'all' (default = 'all')
   %cfg.normalizevar   = 'N' or 'N-1' (default = 'N-1')
   cfg.method         = 'across' %(default) or 'within', see below.
   %cfg.parameter      = string or cell-array indicating which
                       % parameter to average. default is set to
                       % 'avg', if it is present in the data
                    
                       
 %compute GA for No Cue
 
      Alert_grandavg{1} = ft_timelockgrandaverage(cfg, ...
       load_subs{1,1}.timelock(1), ...
       load_subs{1,2}.timelock(1), ...
       load_subs{1,3}.timelock(1), ...
       load_subs{1,4}.timelock(1), ...
       load_subs{1,5}.timelock(1), ...
       load_subs{1,6}.timelock(1))

 %compute GA for Double
 
      Alert_grandavg{2} = ft_timelockgrandaverage(cfg, ...
       load_subs{1,1}.timelock(2), ...
       load_subs{1,2}.timelock(2), ...
       load_subs{1,3}.timelock(2), ...
       load_subs{1,4}.timelock(2), ...
       load_subs{1,5}.timelock(2), ...
       load_subs{1,6}.timelock(2))

 %compute GA for DIFF

      Alert_grandavg{3} = ft_timelockgrandaverage(cfg, ...
       load_subs{1,1}.timelock(3), ...
       load_subs{1,2}.timelock(3), ...
       load_subs{1,3}.timelock(3), ...
       load_subs{1,4}.timelock(3), ...
       load_subs{1,5}.timelock(3), ...
       load_subs{1,6}.timelock(3))

   
   %plot Grand Average



    condition_names = conditions;  
    figure();
    hold on; 
    colours = [{'-b'}; {'-g'}; {'-r'}; {'-c'};{'-m'};{'-k'};{'-y'}];
    
    for plot_i = 1:length(condition_names)
        condition_name = condition_names{1,plot_i};
        plot(Alert_grandavg{1,plot_i}.time,Alert_grandavg{1,plot_i}.avg,colours{plot_i});
        
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


function patrick_docker_remove_good_channels(wpms,name_i)
    fprintf('Loading: %s%s \n',wpms.names{name_i},'''s common average referenced data. . .');
    load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT']); %referenced data
    fprintf('Loading: %s%s \n',wpms.names{name_i},'''s good channel list. . .');
    load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i},'_goodchannellist']);%badchannel list

    
    
    %Generate a new strucute with only the bad channels:

    
    time = data.time;
    label = cell((length(data.label)-length(goodchann)),1);
    trial = cell(1,1);
    trial{1,1} = zeros((length(data.label)-length(goodchann)),size(data.trial{1,1},2));
    mon_bad = 1;
    count = 1;
    
    % What we want to do is to check ALL channels in the bad list, against
    % the labels, to see if the current label (index_i) is in the list, if
    % it is in the list, we want to skip the channel, then 
    for index_i = 1:(length(data.label))
    %Condition: Do not check for bad channels in list,as all have been
    %found
        if mon_bad > length(goodchann)
            if index_i <= length(data.label)
                label(count,1)   = data.label(index_i,1);
                trial{1,1}(count,:) = data.trial{1,1}(index_i,:);
                count = count+1;
            end
            continue;
        end
        %fprintf('Comparing %s with %s \n', M.lab{mon_i,1}, badchann{1,mon_bad});
        %look for bad channels and append to new structure.
        found_monbad = false;
        for check_monbad_i  = 1:length(goodchann)
            if strcmpi(data.label{index_i,1},goodchann{1,check_monbad_i})
                fprintf('Found Good_Channel: %s\n',goodchann{1,check_monbad_i})
                found_monbad = true;
                mon_bad = mon_bad+1;
            end
        end      
        if found_monbad == false
                
            label(count,1)   = data.label(index_i,1);
            trial{1,1}(count,:) = data.trial{1,1}(index_i,:);
            count = count+1;
            
        end
        if index_i == 64 && mon_bad <= length(goodchann)
            fprintf('WARNING: One or More ELECTRODES were NOT FOUND\n');
            for check_monbad_i  = 1:length(goodchann)
                fprintf('\tGood_Channel List: %s\n',goodchann{1,check_monbad_i});
            end
            beep;
        end
    end

  
    
    
    cfg = data.cfg;
    data_2 = struct('hdr',data.hdr,'fsample',data.fsample,'sampleinfo',data.sampleinfo,'trial',{trial},'time',{time},'cfg',cfg,'label',{label});
    clear data;
    data = data_2;
    clear data_2
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_GoodChannRemoved'],'data','-v7.3');
      cfg = []
    cfg.layout = './GSN-HydroCel-256.sfp'
    cfg.visibile = 'off'
    plot_only_badchan = ft_layoutplot(cfg, data)
    saveas(gcf,'/Users/patrick/Desktop/nCCR_Cancer_EEG/images/test.png')
    
  %save figure%
  savefig('./QA/goodchan.fig')
  %fig = openfig('/Users/patrick/Desktop/EEG/goodchan.fig')
  filename = [wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_AutoRejectedChannels.pdf']
  saveas(fig, filename)
  
    
    
    %%%

    

    
    
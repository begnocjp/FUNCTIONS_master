function fnl_remove_bad_channels(wpms,name_i)
    fprintf('Loading: %s%s \n',wpms.names{name_i},'''s common average referenced data. . .');
    load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REFnFILT']); %referenced data
    fprintf('Loading: %s%s \n',wpms.names{name_i},'''s bad channel list. . .');
    load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i},'_badchannellist']);%badchannel list

    
    
    
    %plot channels that are not being removed, need data.elec
    
cfg = [];
cfg.layout = ans
ft_layoutplot(cfg, data)
    
    
    %Generate a new strucute with only the bad channels:

    
    time = data.time;
    label = cell((length(data.label)-length(badchann)),1);
    trial = cell(1,1);
    trial{1,1} = zeros((length(data.label)-length(badchann)),size(data.trial{1,1},2));
    mon_bad = 1;
    count = 1;
    
    % What we want to do is to check ALL channels in the bad list, against
    % the labels, to see if the current label (index_i) is in the list, if
    % it is in the list, we want to skip the channel, then 
    for index_i = 1:(length(data.label))
    %Condition: Do not check for bad channels in list,as all have been
    %found
        if mon_bad > length(badchann)
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
        for check_monbad_i  = 1:length(badchann)
            if strcmpi(data.label{index_i,1},badchann{1,check_monbad_i})
                fprintf('Found Bad_Channel: %s\n',badchann{1,check_monbad_i})
                found_monbad = true;
                mon_bad = mon_bad+1;
            end
        end      
        if found_monbad == false
                
            label(count,1)   = data.label(index_i,1);
            trial{1,1}(count,:) = data.trial{1,1}(index_i,:);
            count = count+1;
            
        end
        if index_i == 64 && mon_bad <= length(badchann)
            fprintf('WARNING: One or More ELECTRODES were NOT FOUND\n');
            for check_monbad_i  = 1:length(badchann)
                fprintf('\tBad_Channel List: %s\n',badchann{1,check_monbad_i});
            end
            beep;
        end
    end

    cfg = data.cfg;
    data_2 = struct('hdr',data.hdr,'fsample',data.fsample,'sampleinfo',data.sampleinfo,'trial',{trial},'time',{time},'cfg',cfg,'label',{label});
    clear data;
    data = data_2;
    clear data_2
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_BadChannRemoved'],'data','-v7.3');
    
    
    
    %%%

    
cfg = []
cfg.layout = '/Users/patrick/Desktop/EEG/FUNCTIONS/GSN-HydroCel-256.sfp'
plot1 = ft_layoutplot(cfg, data)
    
    
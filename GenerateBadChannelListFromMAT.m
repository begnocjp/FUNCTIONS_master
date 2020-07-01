% Read Bad Channel List


for name_i = 1:length (wpms.names);
    %compare names to see if they are in the list.
    badchann={''};
    index = -1;
    for list_i = 1:size(BadChannelListv2,1)
        %find index of names
        if strcmp(wpms.names{name_i},BadChannelListv2{list_i,1});
            index = list_i;
            break;
        end
    end

    if index ~= -1
        %find last val that is not ''
        for empt_i = 2:size(BadChannelListv2,2);
            if strcmp(BadChannelListv2{index,empt_i},'');
                break;
            end
        end
        badchann = BadChannelListv2(index,2:empt_i-1);
    end

    % load channels into the the baddchannel array.


    %otherwise save the blank channel list.


    save ([wpms.names{name_i},'_badchannellist.mat'],'badchann');
end
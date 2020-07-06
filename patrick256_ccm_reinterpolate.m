%% CCM_REINTERPOLATE
%   Reinterpolate bad channels back into data after applying scalp current
%   density montage
%   Requires a bad channel list made previously (this can be empty)
%  USEAGE:
%         fnl_reinterpolate(wpms,name_i)
%  INPUTS:
%         wpms: working parameters stucture (contains names,dirs)
%         name_i: current participant index
%
%  Patrick Cooper & Aaron Wong, 2014
%  Functional Neuroimaging Laboratory, University of Newcastle
function ccm_reinterpolate(wpms,name_i)
fprintf('Loading: %s%s \n',wpms.names{name_i},'''s data');
load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_ARTFREEDATA']);%csd data
load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_badchannellist']);%badchannel list
%Generating Full Array:
%load original montage - Labels
load([wpms.dirs.CWD wpms.dirs.FUNCTIONS 'egi_labels.mat']);
label = labels(1:length(labels),1);
%get new structure:
time = data.time;
trial = cell(1,size(data.trial,2));
for i = 1:size(data.trial,2)
    %Changing Trail samples found:
    %use min samples in trial to set the matrix.
    min_size_array = [];
    for ind_i = 1:size(data.trial,2)
        min_size_array = [min_size_array;size(data.trial{1,ind_i},2)]; %#ok<AGROW>
    end
    min_size=min(min_size_array);
    trial{1,i} = zeros((length(label)),min_size);
    for ind_i = 1:length(time)
        time{1,ind_i} = time{1,ind_i}(1,1:min_size);
    end
    %copy if labels match
    for index_i = 1:length(data.label)
        for j = 1:length(label)
            if strcmpi(data.label{index_i,1},label{j,1})
                trial{1,i}(j,:) = data.trial{1,i}(index_i,1:min_size);
                
                break;
            end
        end
    end
end
cfg = data.cfg;
data_2 = struct('hdr',data.hdr,'fsample',data.fsample,'sampleinfo',data.sampleinfo,'trialinfo',data.trialinfo,'trial',{trial},'time',{time},'cfg',cfg,'label',{label});
clear data;
data = data_2;
clear data_2 trial time j i
fprintf('Preparing electrode neighbourhood. . . ');
cfg = [];
fprintf('. ');
cfg.method = 'triangulation';
fprintf('. ');
cfg.layout = 'GSN-HydroCel-256.sfp';
fprintf('. \n');
neighbours = ft_prepare_neighbours(cfg, data);
fprintf('Selecting bad channels from prepared list. . . \n');
channel = ft_channelselection(badchann,data.label);
fprintf('Channel selection complete! \n');
% repair bad channels
fprintf('Repairing bad channels. . .');
cfg.method = 'nearest';
fprintf('. ');
cfg.badchannel = badchann; % cell-array of channels from channel
fprintf('. ');
cfg.missingchannel = []; % can be the same
fprintf('. ');
cfg.neighbours = neighbours;
fprintf('. ');
cfg.trials = 'all';
fprintf('. ');
temp = data;
fprintf('. \n');
interp = ccm_channelrepair(cfg, temp);
interp.sampleinfo = temp.sampleinfo;
refdat = interp;
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REPAIRED_AND_REFERENCED'],'refdat','-v7.3')
clear data channel badchann data interp lay neighbours w temp% tidying
end
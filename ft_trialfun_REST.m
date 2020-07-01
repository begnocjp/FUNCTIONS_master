function [trl] = ft_trialfun_REST(cfg,name_i)
index = name_i;
%edited by Aaron/Alex - 2016.01.13




%% Calculate Reation Times:

% load all trial functions:
% See how many we are working with? ...
% obtain an array of times to perform calculations with
% calculate the mean
% calculate the standard deviation.

%convert all events to proper code:  (subtract 65280) ***DON'T THINK I NEED THIS FOR THE RESTING STATE PARADIGM 
% magic_number = 65280;
% for event_i = 1:length(cfg.event)
%     cfg.event(1,event_i).value = cfg.event(1,event_i).value - magic_number;
% end

% search for "trigger" events
trigger = [cfg.event(strcmp('STATUS', {cfg.event.type})).value]';
%disp(trigger);
sample  = [cfg.event(strcmp('STATUS', {cfg.event.type})).sample]';
%disp(sample)

% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.pre  * cfg.hdr.Fs);
posttrig =  round(cfg.trialdef.post * cfg.hdr.Fs);


% look for the combination of a trigger "31" followed by a trigger "1"
% for each trigger except the last one
trl = [];

%Grab Reaction time: HighCutOffs
%load('HighCutOffs.mat');
% Filename_RT = names; % for trial definition
% indices = names(1,name_i);
%Finds the string, and returns an array of 0 (False),1 (true)
% indices = strcmp(Filename_RT(:,1),cfg.filename_original(1:6)); %added 1:6 index -PC
% index = name_i;
% index = find(indices,1);
% if size(index,1) == 0
%     fprintf('ERROR: Filename not Found for Slow ReactionTime\n')
% end
% fprintf('Comparing String: %s with %s: Found at Index %i\n',cfg.filename_original,Filename_RT{index,1},index);
%HighCutOff = ReactionTimes(index);
okCount = 0;

for j = 1:(length(trigger)-1)
    trg1 = trigger(j);
    %     trg2 = trigger(j+1);
    
    if      trg1 == 254
%         fprintf('.',j);
        trlbegin = sample(j) + pretrig;
        trlend   = sample(j) + posttrig;
        offset   = pretrig;
        newtrl   = [trlbegin trlend offset trg1]; 
        trl      = [trl; newtrl];
        okCount = okCount +1;
    end
    
end

fprintf('Total Number Processed: %i \n', okCount);

end
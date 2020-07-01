function [trl] = ft_trialfun_Conflict(cfg,name_i)
index = name_i;
%edited by Aaron/Alex/Patrick - 2014.01.10




%% Calculate Reation Times:

% load all trial functions:
% See how many we are working with? ...
% obtain an array of times to perform calculations with
% calculate the mean
% calculate the standard deviation.

%convert all events to proper code:  (subtract 65280)
magic_number = 65280;
for event_i = 1:length(cfg.event)
    cfg.event(1,event_i).value = cfg.event(1,event_i).value - magic_number;
end

% search for "trigger" events
trigger = [cfg.event(strcmp('STATUS', {cfg.event.type})).value]';
sample  = [cfg.event(strcmp('STATUS', {cfg.event.type})).sample]';

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

fastCount = 0;
slowCount = 0;
okCount = 0;
RT_ARRAY = [];
for j = 1:(length(trigger)-1)
    trg1 = trigger(j);
    trg2 = trigger(j+1);

    if      trg1 == 11 && trg2 == 40 || ...
            trg1 == 12 && trg2 == 50 ||...
            trg1 == 21 && trg2 == 40 ||...
            trg1 == 32 && trg2 == 50
        
        RT_ARRAY = [RT_ARRAY; (sample(j+1)-sample(j))/cfg.hdr.Fs*1000];
        
    end
end

average_RT = mean(RT_ARRAY);
stdDev = std(RT_ARRAY);
HighCutOff = average_RT + 3*stdDev;
LowCutOff =200;
%%NOTE! CHANGE TO TIME!
for j = 1:(length(trigger)-1)
    trg1 = trigger(j);
    trg2 = trigger(j+1);

    if      trg1 == 11 && trg2 == 40 || ...
            trg1 == 12 && trg2 == 50 ||...
            trg1 == 21 && trg2 == 40 ||...
            trg1 == 32 && trg2 == 50
        
        rt = (sample(j+1)-sample(j))/cfg.hdr.Fs*1000;
        if rt < LowCutOff
            fprintf('Reaction Too Fast: %i: %3.2f \n',j,rt);
            fastCount = fastCount+1;
        elseif rt > HighCutOff
            fprintf('Reaction Too Slow: %i: %3.2f is larger then %3.2f\n',j,rt,HighCutOff);
            slowCount = slowCount+1;
        elseif sample(j) + posttrig >= cfg.hdr.nSamples
            fprintf('Not adding trial as Ending sample is out of Range');
            
        elseif sample(j) + pretrig <0
            fprintf('Not adding trial as Ending sample is out of Range');
        else
            fprintf('RT: %i: %3.2f\n',j,rt);
            trlbegin = sample(j) + pretrig;
            trlend   = sample(j) + posttrig;
            offset   = pretrig;
            newtrl   = [trlbegin trlend offset trg1];
            trl      = [trl; newtrl];
            okCount = okCount +1;
        end
                
    end
end


 
fprintf('Total Number Processed: %i \n', fastCount+slowCount+okCount);
fprintf('Rejected - Too Fast: %i (%3.2f percent) \n', fastCount, 100*fastCount/(fastCount+slowCount+okCount));
fprintf('Rejected - Too Slow: %i (%3.2f percent) \n', slowCount, 100*slowCount/(fastCount+slowCount+okCount));
fprintf('Accepted: %i (%3.2f percent) \n', okCount, 100*okCount/(fastCount+slowCount+okCount));


%c = clock;
%currenttime = (datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));
fileID = fopen('ProcessingLog.txt','a');
%fprintf(fileID,'\n\n%s: %s - Trial Function \n', currenttime,cfg.filename_original);
fprintf(fileID,'Total Number Processed: %i \n', fastCount+slowCount+okCount);
fprintf(fileID,'Rejected - Too Fast: %i (%3.2f percent) \n', fastCount, 100*fastCount/(fastCount+slowCount+okCount));
fprintf(fileID,'Rejected - Too Slow: %i (%3.2f percent) \n', slowCount, 100*slowCount/(fastCount+slowCount+okCount));
fprintf(fileID,'Accepted: %i (%3.2f percent) \n', okCount, 100*okCount/(fastCount+slowCount+okCount));
fclose(fileID);

end
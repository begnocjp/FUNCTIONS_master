function [trl] = ft_trialfun_Incident_M(cfg,name_i)
index = name_i;
%edited by Aaron/Alex/Patrick - 2017.01.09

% For incidental memory task we have a number of trigger codes, all in
% strings
% 'SESS' = beginning of session
% 'CELL' = not needed
% 'bgin' = beginning of a trial
% 'sngl' = non-repeating picture
% 'TRSP'  = end of trial
% 'rept' = repeating picture
% 'resp' = motor response to 'attn'
% 'attn' = probe
% 

%% Calculate Reation Times:

% load all trial functions:
% See how many we are working with? ...
% obtain an array of times to perform calculations with
% calculate the mean
% calculate the standard deviation.

%convert all events to proper code:  (subtract 65280)
magic_number = 0;
for event_i = 1:length(cfg.event)
    cfg.event(1,event_i).sample = cfg.event(1,event_i).sample - magic_number;
end

% search for "trigger" events
trigger = {cfg.event.value}';
sample  = [cfg.event(strcmp('trigger', {cfg.event.type})).sample]';

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
errorCount = 0;
rtCount = 0;
okCount = 0;
RT_ARRAY = [];

for j = 1:(length(trigger)-1)
    trg1 = trigger{j};
    trg2 = trigger{j+1};

    if      trg1 == 'attn' & trg2 == 'resp'
        
        RT_ARRAY = [RT_ARRAY; (sample(j+1)-sample(j))/cfg.hdr.Fs*1000];
        
    end
end

average_RT = mean(RT_ARRAY);
stdDev = std(RT_ARRAY);
HighCutOff = average_RT + 3*stdDev;
LowCutOff =200;
%%NOTE! CHANGE TO TIME!
for j = 1:(length(trigger)-1)
    trg1 = trigger{j};
    trg2 = trigger{j+1};

    if      trg1 == 'attn' & trg2 == 'resp'
            
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
            trg1 = 1;
            newtrl   = [trlbegin trlend offset trg1];
            trl      = [trl; newtrl];
            rtCount = rtCount +1;
            okCount = okCount+1;
        end
                
    end
end

for j = 1:(length(trigger)-1)
    trg1 = trigger{j};
    trg2 = trigger{j+1};
    if trg1 == 'sngl' | trg1 == 'rept'
%        fprintf('%s\t%i\t%s\t%i\n','Trigger 1:',trg1,'Trigger 2:',trg2);
        if trg2 == 'resp'
            errorCount = errorCount+1;
        else
            trlbegin = sample(j) + pretrig;
            trlend   = sample(j) + posttrig;
            offset   = pretrig;
            if trg1 == 'sngl'
                trg1 = 2;
                newtrl = [trlbegin trlend offset trg1];
                trl = [trl; newtrl];
                okCount = okCount +1;
            else trg1 = 3;
                newtrl   = [trlbegin trlend offset trg1];
                trl      = [trl; newtrl];
                okCount = okCount +1;
            end
%            disp(NGokCount);
        end
    end
end

% TRIAL ID INFO: Attention Trials = 1; Single Trials = 2; Repeat Trials = 3 

fprintf('Total Number Processed: %i \n', fastCount+slowCount+okCount);
fprintf('Rejected - Too Fast: %i (%3.2f percent) \n', fastCount, 100*fastCount/(fastCount+slowCount+rtCount));
fprintf('Rejected - Too Slow: %i (%3.2f percent) \n', slowCount, 100*slowCount/(fastCount+slowCount+rtCount));
fprintf('Rejected - Nogo Error: %i (3.2f percent) \n', errorCount, 100*errorCount/(errorCount+okCount));
fprintf('Accepted: %i (%3.2f percent) \n', okCount, 100*okCount/(errorCount+okCount));
fprintf('Accepted: %i (%3.2f percent) \n', rtCount, 100*rtCount/(fastCount+slowCount+rtCount));

%c = clock;
%currenttime = (datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));
fileID = fopen('ProcessingLog.txt','a');
%fprintf(fileID,'\n\n%s: %s - Trial Function \n', currenttime,cfg.filename_original);
fprintf(fileID,'Total Number Processed: %i \n', fastCount+slowCount+okCount);
fprintf(fileID,'Rejected - Too Fast: %i (%3.2f percent) \n', fastCount, 100*fastCount/(fastCount+slowCount+rtCount));
fprintf(fileID,'Rejected - Too Slow: %i (%3.2f percent) \n', slowCount, 100*slowCount/(fastCount+slowCount+rtCount));
fprintf(fileID,'Rejected - Nogo Error: %i (3.2f percent) \n', errorCount, 100*errorCount/(errorCount+okCount));
fprintf(fileID,'Accepted: %i (%3.2f percent) \n', okCount, 100*okCount/(errorCount+okCount));
fprintf(fileID,'Accepted: %i (%3.2f percent) \n', rtCount, 100*rtCount/(fastCount+slowCount+rtCount));
fclose(fileID);

end
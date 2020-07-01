function [trl] = ft_trialfun_Agility(cfg,name_i)
%% FT_TRIALFUN_AGILITY
%  Extracts appropriate trigger codes from STATUS channel for Age-ility
%  Project
%  "Appropriate" trigger codes are ones that are not dummy trials,
%  errors, or trials followed by an error
%
%  This is a custom built function to be used in fieldtrip
%
% USEAGE:
%        [trl] = ft_trialfun_Agility(cfg,name_i)
%
% INPUTS:        
%                cfg: data structure containing cfg.event
%                name_i: current index of participant list
% OUTPUT:
%                trl: trial structure containing at least three columns for
%                     trial onset, trial offset and trigger code
%                     (used by fieldtrip)
%
% Patrick Cooper and Aaron Wong, 2013
% Functional Neuroimaging Laboratory, University of Newcastle
%
% Updated: 2014/06/05
%          Included logic test for post-error trials
%          Patrick Cooper

index = name_i;
%edited by Patrick - 2013.10.28
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
load('HighCutOffs.mat');
highCutOff = tooslow(index);

fastCount = 0;
slowCount = 0;
okCount = 0;
for j = 1:(length(trigger)-2)
    correct_trial = false;
    trg1 = trigger(j);
    trg3 = trigger(j+2);
    
    %Conversion Formula: SmallCode(0~255) = 2^8-(2^16-OldCode[0~65536])
    
    %All Repeats:
    if      trg1== 65411 && trg3==65281 || trg1== 65412 && trg3==65282 || ...    % THIS LINE: START All Repeats:
            trg1== 65421 && trg3==65281 || trg1== 65422 && trg3==65282 || ...
            trg1== 65431 && trg3==65281 || trg1== 65432 && trg3==65282 || ...
            trg1== 65441 && trg3==65281 || trg1== 65442 && trg3==65282 || ...    % THIS LINE: START Mixed Block:
            trg1== 65443 && trg3==65281 || trg1== 65444 && trg3==65282 || ...
            trg1== 65445 && trg3==65281 || trg1== 65446 && trg3==65282 || ...
            trg1== 65447 && trg3==65281 || trg1== 65448 && trg3==65282 || ...
            trg1== 65449 && trg3==65281 || trg1== 65450 && trg3==65282 || ...
            trg1== 65451 && trg3==65281 || trg1== 65452 && trg3==65282 || ...
            trg1== 65453 && trg3==65281 || trg1== 65454 && trg3==65282 || ...
            trg1== 65455 && trg3==65281 || trg1== 65456 && trg3==65282 || ...
            trg1== 65457 && trg3==65281 || trg1== 65458 && trg3==65282 || ...
            trg1== 65459 && trg3==65281 || trg1== 65460 && trg3==65282 || ...
            trg1== 65461 && trg3==65281 || trg1== 65462 && trg3==65282 || ...
            trg1== 65463 && trg3==65281 || trg1== 65464 && trg3==65282 || ...
            trg1== 65465 && trg3==65281 || trg1== 65466 && trg3==65282 || ...
            trg1== 65467 && trg3==65281 || trg1== 65468 && trg3==65282 || ...
            trg1== 65469 && trg3==65281 || trg1== 65470 && trg3==65282 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% L O O K      H E R E %%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Make sure not a post-error trial
        %Odd codes require response code 1, even codes require response code 2
        correct_trial = true;
        if correct_trial == 1 && (mod(trigger(j-3),2) == 1 && trigger(j-1) == 65281) || ...
                correct_trial ==1 && (mod(trigger(j-3),2) == 0 && trigger(j-1) == 65282) == 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% E N D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            %Calculate the reaction time: time(trig3) - time(trig2)
            rt = (sample(j+2) / cfg.hdr.Fs *1000) - (sample(j+1) / cfg.hdr.Fs *1000);
            if rt < 200
                fprintf('Reaction Too Fast: %i: %3.2f \n',j,rt);
                fastCount = fastCount+1;
            elseif rt > highCutOff
                fprintf('Reaction Too Slow: %i: %3.2f is larger then %3.2f\n',j,rt,highCutOff);
                slowCount = slowCount+1;
            else
                fprintf('RT: %i: %3.2f\n',j,rt);
                trlbegin = sample(j) + pretrig;
                trlend   = sample(j) + posttrig;
                offset   = pretrig;
                newtrl   = [trlbegin trlend offset trg1 rt];
                trl      = [trl; newtrl];
                okCount = okCount +1;
            end
        end
    end  
end
fprintf('Total Number Processed: %i \n', fastCount+slowCount+okCount);
fprintf('Rejected - Too Fast: %i (%3.2f percent) \n', fastCount, 100*fastCount/(fastCount+slowCount+okCount));
fprintf('Rejected - Too Slow: %i (%3.2f percent) \n', slowCount, 100*slowCount/(fastCount+slowCount+okCount));
fprintf('Accepted: %i (%3.2f percent) \n', okCount, 100*okCount/(fastCount+slowCount+okCount));
c = clock;
currenttime = (datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));
fileID = fopen('ProcessingLog.txt','a');
fprintf(fileID,'\n\n%s: %s - Trial Function \n', currenttime,cfg.filename_original);
fprintf(fileID,'Total Number Processed: %i \n', fastCount+slowCount+okCount);
fprintf(fileID,'Rejected - Too Fast: %i (%3.2f percent) \n', fastCount, 100*fastCount/(fastCount+slowCount+okCount));
fprintf(fileID,'Rejected - Too Slow: %i (%3.2f percent) \n', slowCount, 100*slowCount/(fastCount+slowCount+okCount));
fprintf(fileID,'Accepted: %i (%3.2f percent) \n', okCount, 100*okCount/(fastCount+slowCount+okCount));
fclose(fileID);
end


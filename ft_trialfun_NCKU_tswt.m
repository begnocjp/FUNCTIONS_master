function [trl] = ft_trialfun_NCKU_tswt(cfg,name_i)
%% FT_TRIALFUN_NCKU_tswt
%  Extracts appropriate trigger codes from STATUS channel for coloured
%  cross tswt task from neuroscan config files that convert 16 bit to decimal
%  correctly
%
%  "Appropriate" trigger codes are ones that are not dummy trials,
%  errors, or trials followed by an error
%
%  This is a custom built function to be used in fieldtrip
%
% USEAGE:
%        [trl] = ft_trialfun_Agility_biosemi2(cfg,name_i)
%
% INPUTS:
%                cfg: data structure containing cfg.event
%                name_i: current index of participant list
% OUTPUT:
%                trl: trial structure containing at least three columns for
%                     trial onset, trial offset and trigger code
%                     (used by fieldtrip)
%
% Origibal written by Patrick Cooper and Aaron Wong, 2013
% Functional Neuroimaging Laboratory, University of Newcastle
%
% Updated: January 2016 for use in coloured cross tswt paradigm
%          Aaron Wong and Alexander Conley
%          
index = name_i;
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
    
    if      trg1== 131 && trg3==1 || trg1== 132 && trg3==2 || ... % THIS LINE: All Repeats:
            trg1== 141 && trg3==1 || trg1== 142 && trg3==2 || ...
            trg1== 151 && trg3==1 || trg1== 152 && trg3==2 || ...        
            trg1== 161 && trg3==1 || trg1== 162 && trg3==2 || ... % THIS LINE: Mixed Block:
            trg1== 163 && trg3==1 || trg1== 164 && trg3==2 || ...
            trg1== 165 && trg3==1 || trg1== 166 && trg3==2 || ...
            trg1== 167 && trg3==1 || trg1== 168 && trg3==2 || ...
            trg1== 169 && trg3==1 || trg1== 170 && trg3==2 || ...
            trg1== 171 && trg3==1 || trg1== 172 && trg3==2 || ...
            trg1== 173 && trg3==1 || trg1== 174 && trg3==2 || ...
            trg1== 175 && trg3==1 || trg1== 176 && trg3==2 || ...
            trg1== 177 && trg3==1 || trg1== 178 && trg3==2 || ...
            trg1== 179 && trg3==1 || trg1== 180 && trg3==2 || ...
            trg1== 181 && trg3==1 || trg1== 182 && trg3==2 || ...
            trg1== 183 && trg3==1 || trg1== 184 && trg3==2 || ...
            trg1== 185 && trg3==1 || trg1== 186 && trg3==2 || ...
            trg1== 187 && trg3==1 || trg1== 188 && trg3==2 || ...
            trg1== 189 && trg3==1 || trg1== 190 && trg3==2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%% L O O K      H E R E %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Make sure not a post-error trial
        %Odd codes require response code 1, even codes require response code 2
        correct_trial = true;
        if correct_trial == 1 && (mod(trigger(j-3),2) == 1 && trigger(j-1) == 1) || ...
                correct_trial ==1 && (mod(trigger(j-3),2) == 0 && trigger(j-1) == 2) == 1;
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
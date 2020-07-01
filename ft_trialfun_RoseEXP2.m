function [trl] = ft_trialfun_RoseEXP2(cfg,name_i)
%% FT_TRIALFUN_RoseEXP2
%  Extracts appropriate trigger codes from STATUS channel for Elena's
%  Project from Neuroscan config files that convert 24 bit to decimal
%  correctly
%
% The basic scheme for the event codes is to multiply the stimulus number
% by five, then add a number for the trial type.
% 
% The stimulus number is simply numbering the stimuli in order, so the GA
% stimuli are numbers 1-10, GN 11-20, RA 21-30, and RN 31-40.
% 
% The trial type numbers are:
% 
% 1: Congruent
% 2: Congruent semantic, incongruent threat
% 3: Incongruent semantic, congruent threat
% 4: Incongruent semantic, incongruent threat
% 
% Thus, the event code '6' means the first GA stimulus, with congruent
% flankers. The event code '118' means the third RA stimulus (23 * 5 =
% 115), with incongruent semantic, congruent threat flankers.
%
%  This is a custom built function to be used in fieldtrip
%
% USEAGE:
%        [trl] = ft_trialfun_RoseEXP2(cfg,name_i)
%
% INPUTS:
%                cfg: data structure containing cfg.event
%                name_i: current index of participant list
% OUTPUT:
%                trl: trial structure containing at least three columns for
%                     trial onset, trial offset and trigger code
%                     (used by fieldtrip)
%
% Aaron Wong, 2014
% Functional Neuroimaging Laboratory, University of Newcastle
%
% Updated: 2014/12/03
%          Included logic test for post-error trials
%          Aaron Wong
index = name_i;
%edited by Patrick - 2013.10.28
% search for "trigger" events

%% CALCULATE CODES:

GA = 1:10;
GN = 11:20;
RA = 21:30;
RN = 31:40;

STIM_TYPE = [GA;GN;RA;RN];

CON = 1;
CON_SEM_INCON_THREAT = 2;
INCON_SEM_CON_THREAT = 3;
INCON_SEM_INCON_THREAT = 4;
COND_TYPES = [CON;CON_SEM_INCON_THREAT;INCON_SEM_CON_THREAT;INCON_SEM_INCON_THREAT];

COND_NAMES = [{'GA_CONG'},{'GA_CON_SEM_INCON_THREAT'},{'GA_INCON_SEM_CON_THREAT'},{'GA_INCON_SEM_INCON_THREAT'}...
              {'GN_CONG'},{'GN_CON_SEM_INCON_THREAT'},{'GN_INCON_SEM_CON_THREAT'},{'GN_INCON_SEM_INCON_THREAT'}...  
              {'RA_CONG'},{'RA_CON_SEM_INCON_THREAT'},{'RA_INCON_SEM_CON_THREAT'},{'RA_INCON_SEM_INCON_THREAT'}...  
              {'RN_CONG'},{'RN_CON_SEM_INCON_THREAT'},{'RN_INCON_SEM_CON_THREAT'},{'RN_INCON_SEM_INCON_THREAT'}  ];

count = 1;
ACCEPT_TRIGGEER_CODES = [];
for i = 1:size(STIM_TYPE,1);
    for j = 1:size(COND_TYPES,1);
        fprintf('%s :',COND_NAMES{count});
        a = STIM_TYPE(i,:)*5+COND_TYPES(j);
        ACCEPT_TRIGGEER_CODES = [ACCEPT_TRIGGEER_CODES,a];
        fprintf('------\n');
        count = count+1;
    end
end

%% START TRIGGER CODE EXTRACTION:

trigger = [cfg.event(strcmp('trigger', {cfg.event.type})).value]';
sample  = [cfg.event(strcmp('trigger', {cfg.event.type})).sample]';

% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.pre  * cfg.hdr.Fs);
posttrig =  round(cfg.trialdef.post * cfg.hdr.Fs);

% look for the combination of a trigger "31" followed by a trigger "1"
% for each trigger except the last one
trl = [];

%Grab Reaction time: HighCutOffs
%load('HighCutOffs.mat');
%highCutOff = tooslow(index);

fastCount = 0;
slowCount = 0;
okCount = 0;
for j = 1:(length(trigger)-2)
    %correct_trial = false;
    trg1 = trigger(j);      % Fixation point
    trg2 = trigger(j+1);    % CODE
    trg3 = trigger(j+2);    % CORRECT CODE
    fprintf('%i: Testing: %i with %i with %i \n',j,trg1,trg2,trg3);
%     if      trg1== 11 && trg2==1 || trg1== 12 && trg2==1 || ...
%             trg1== 13 && trg2==1 || trg1== 14 && trg2==1 || ...
%             trg1== 15 && trg2==1 || trg1== 31 && trg2==1 || ...
%             trg1== 32 && trg2==1 || trg1== 33 && trg2==1 || ...
%             trg1== 34 && trg2==1 || trg1== 35 && trg2==1 
%         

    %% FLANKER LOCKED CODES:
    if (trg1 == 255||trg1 == 99) && ismember(trg2,ACCEPT_TRIGGEER_CODES) && (trg3 ==1 || trg3 ==2) ;
                fprintf('Found: %i: %i \t RESP: %i \tRT: %1.3f Seconds\n',j+1,trg2,trg3,(sample(j+2) - sample(j+1))/cfg.hdr.Fs);
                trlbegin = sample(j+1) + pretrig;
                trlend   = sample(j+1) + posttrig;
                offset   = pretrig;
                rt       = (sample(j+2) - sample(j+1))/cfg.hdr.Fs;
                newtrl   = [trlbegin trlend offset trg2 rt];
                trl      = [trl; newtrl];
                okCount = okCount +1;
            
    end
    %% RESPONSE LOCKED CODES:
%     if trg1 == 99 && ismember(trg2,ACCEPT_TRIGGEER_CODES) && (trg3 ==1 || trg3 ==2) ;
%                 fprintf('Found: %i: %i\n',j+2,trg3);
%                 trlbegin = sample(j+2) + pretrig + (-2*cfg.hdr.Fs);
%                 trlend   = sample(j+2) + posttrig + (-2*cfg.hdr.Fs);
%                 offset   = pretrig + (-2*cfg.hdr.Fs);
%                 rt       = (sample(j+2) - sample(j+1))/cfg.hdr.Fs;
%                 newtrl   = [trlbegin trlend offset trg1 rt];
%                 trl      = [trl; newtrl];
%                 okCount = okCount +1;
%             
%     end
    
end

TOTAL = 960; %FROM WORD DOC:
%fprintf('Total Number Processed: %i \n', fastCount+slowCount+okCount);
%fprintf('Rejected - Too Fast: %i (%3.2f percent) \n', fastCount, 100*fastCount/(fastCount+slowCount+okCount));
%fprintf('Rejected - Too Slow: %i (%3.2f percent) \n', slowCount, 100*slowCount/(fastCount+slowCount+okCount));
fprintf('Accepted: %i (%3.2f percent) \n', okCount, 100*okCount/TOTAL);


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
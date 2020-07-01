function [trl] = ft_trialfun_UHRMMN(cfg,name_i)
%% Based on FT_TRIALFUN_AGILITY
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
%edited by Alexander Conley - 2015.10
% search for "trigger" events
trigger = [cfg.event(strcmp('STATUS', {cfg.event.type})).value]'-65280;
sample  = [cfg.event(strcmp('STATUS', {cfg.event.type})).sample]';

unique(trigger);


% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.pre  * cfg.hdr.Fs);
posttrig =  round(cfg.trialdef.post * cfg.hdr.Fs);

% look for the combination of a trigger "31" followed by a trigger "1"
% for each trigger except the last one
trl = [];
allTrl = [];
%crctTrl = [];

Count = 0;

%%%%%% Modded loop, as we are not taking response time
for j = 1:length(trigger)
    trg = trigger(j);
    if trg == 1 || trg == 2 || trg == 3 || trg == 4 || trg == 5 || trg == 6 || ...
            trg == 7 || trg == 8 || trg == 9 || trg == 106 || trg == 107 || trg == 108
        
        trlbegin = sample(j) + pretrig;
        trlend   = sample(j) + posttrig;
        offset   = pretrig;
%        rt = round((sample(j+2) - sample(j+1))/2);
        % here I do the trimming of the data, so that its a hit with RT
        % between 200 and 1600.
%         if ((trigger(j + 2) > 200) && (trigger(j + 2) < 203) && ...
%                 (rt > 199) && (rt < 1601))
%             hit = 1;
%             crtTrl   = [trlbegin trlend offset trg hit rt];
%             crctTrl = [crctTrl; crtTrl]; 
%         else
%             hit = 0;
%             trg = trg + 50;
%         end
        newtrl   = [trlbegin trlend offset trg]; % hit rt];
        allTrl      = [allTrl; newtrl];
        Count = Count +1;
    end
end

trl = allTrl;
if name_i ~= -1
    wpms = cfg.wpms;
    PartID = wpms.names{name_i};

else
    wpms = cfg.wpms;
    PartID = cfg.current_name{1};
end

    save([wpms.dirs.CWD wpms.dirs.preproc PartID,'_allTrl.txt' ],'allTrl', '-ascii', '-double', '-tabs');
    fprintf('TOTAL FOUND: %i\n',Count);


end


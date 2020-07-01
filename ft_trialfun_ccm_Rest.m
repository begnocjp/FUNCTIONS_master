function [trl] = ft_trialfun_ccm_Rest(cfg,name_i)
index = name_i;
%edited by Aaron/Alex/Patrick - 2017.06.30

% For Resting task we do not need triggers
% 

%% Calculate Trial Epoch for Resting State Task

% Just need to setup the resting state session length
% then remove the artefact manually
% 

trl = [];

trlbegin = pre_trial;
trlend   = pre_trial + post_trial;
% offset   = pretrig;
newtrl   = [trlbegin trlend];
trl      = [trl; newtrl];

% TRIAL ID INFO: Attention Trials = 1; Single Trials = 2; Repeat Trials = 3 

fprintf('Resting state completed for %s \n', name_i);

%c = clock;
%currenttime = (datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));

end
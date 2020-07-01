
function [trdat] = patrick_Alerting_nocue(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);

fprintf('%s %s %s \n','----- Begin Trial Definition -----','Participant:',wpms.names{name_i});
    %cd([CWD,PREPROC_OUTPUT]);
    load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_BadChannRemoved']);
    %cd([CWD,RAW]);
    cfg=[];
    cfg.hdr                   = ft_read_header([wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' file_ext]);
    cfg.event                 = ft_read_event ([wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' file_ext]);
    cfg.trialfun              = trialfunction;
    cfg.trialdef.pre          = pre_trial; % latency in seconds
    cfg.trialdef.post         = post_trial;   % latency in seconds
    cfg.filename_original     = [wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' file_ext];
    cfg.wpms                  = wpms;



value1      = [find(strcmp('wnou', {cfg.event.value}))]'%compare for both 'wnou' and 'wnod' by comparing only first two letter
value2      = [find(strcmp('wnod', {cfg.event.value}))]'
value       = vertcat(value1, value2) %combine the two


sample1     = [cfg.event(find(strcmp('wnou', {cfg.event.value}))).sample]'; %get samples for both conditions
sample2     = [cfg.event(find(strcmp('wnod', {cfg.event.value}))).sample]';
sample =       vertcat(sample1, sample2)  %combine the two


% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.pre  * cfg.hdr.Fs);
posttrig =  round(cfg.trialdef.post * cfg.hdr.Fs);

%make trl matrix
cfg.trl = []
trlbegin = sample + pretrig;      %  begin trial
trlend   = sample + posttrig;     %  end of trial
offset = pretrig*ones(size(trlend));              %  a negative offset indicates that the trial begins before the trigger      

cfg.trl = [trlbegin trlend offset]; % concatenate the columns into the trl matrix
  
  
 trdat = ft_redefinetrial(cfg,data);
    trdat.trialinfo  = trdat.trialinfo(:,1);
    %save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat'],'trdat','-v7.3'); % added this into to save trial data for auto artifact rejeciton 
    %clear data tdat%tidying

    



% % look for the combination of a trigger "7" followed by a trigger "64"
% % for each trigger except the last one
% trl = [];
% for j = 1:(length(value)-1)
% trg1 = value(j);
% trg2 = value(j+1);
% if trg1==7 && trg2==64
%   trlbegin = sample(j) + pretrig;
%   trlend   = sample(j) + posttrig;
%   offset   = pretrig;
%   newtrl   = [trlbegin trlend offset];
%   trl      = [trl; newtrl];
% end


% WARNING STIM CODES
% 'wnou' = No Cue, Target Up
% 'wnod' = No Cue, Target Down
% 'wceu' = Center Cue, Target Up
% 'wced' = Center Cue, Target Down
% 'wdou' = Double Cue, Target Up
% 'wdud' = Double Cue, Target Down
% 'wupu' = Up Cue, Target Up
% 'wdwd' = Down Cue, Target Down


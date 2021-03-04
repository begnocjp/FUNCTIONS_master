
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



value1      = [find(strcmp('wnou', {cfg.event.value}))]'% find trials with trigger value for "no cue"
value2      = [find(strcmp('wnod', {cfg.event.value}))]'
value3      = [find(strcmp('wdou', {cfg.event.value}))]'% find trials with trigger value for "double"
value4      = [find(strcmp('wdud', {cfg.event.value}))]'
value_n      = vertcat(value1, value2) %combine the two
value_d      = vertcat(value3, value4) %combine the two

sample1     = [cfg.event(find(strcmp('wnou', {cfg.event.value}))).sample]'; %get samples for both conditions
sample2     = [cfg.event(find(strcmp('wnod', {cfg.event.value}))).sample]';
sample3     = [cfg.event(find(strcmp('wdou', {cfg.event.value}))).sample]'; %get samples for both conditions
sample4     = [cfg.event(find(strcmp('wdud', {cfg.event.value}))).sample]';
sample_n =       vertcat(sample1, sample2)  %combine the two
sample_d =       vertcat(sample3, sample4)  %combine the two


info.no_cue = cfg.event(value_n) %get trial info for both conditions
% make trial.info - 1 = first marker "wnou" 2 = second marker "wnod"

 value_marker1 = value1
 value_marker1(:,1) = 1 
 
  value_marker2 = value2
  value_marker2(:,1) = 2
 
 value_marker_no_cue      = vertcat(value_marker1, value_marker2) 
  
info.double_cue = cfg.event(value_d) %get trial info for both conditions

% make trial.info - 1 = first marker "wnou" 2 = second marker "wnod"

 value_marker3 = value3
 value_marker3(:,1) = 3 
 
  value_marker4 = value4
  value_marker4(:,1) = 4
 
 value_marker_double      = vertcat(value_marker3, value_marker4) 
   

% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.pre  * cfg.hdr.Fs);
posttrig =  round(cfg.trialdef.post * cfg.hdr.Fs);

%make trl matrix no cue
cfg.trl = []
trlbegin = sample_n + pretrig;      %  begin trial
trlend   = sample_n + posttrig;     %  end of trial
offset = pretrig*ones(size(trlend));              %  a negative offset indicates that the trial begins before the trigger      

cfg.trl = [trlbegin trlend offset]; % concatenate the columns into the trl matrix
  
  
 trdat.alerting_no_cue = ft_redefinetrial(cfg,data);
 
 %make trl matrix double cue
cfg.trl = []
trlbegin = sample_d + pretrig;      %  begin trial
trlend   = sample_d + posttrig;     %  end of trial
offset = pretrig*ones(size(trlend));              %  a negative offset indicates that the trial begins before the trigger      

cfg.trl = [trlbegin trlend offset]; % concatenate the columns into the trl matrix
  
  
 trdat.alerting_double_cue = ft_redefinetrial(cfg,data);
 
 info = cfg.event(value) %get trial info for both conditions

   % trdat.trialinfo  =  {info(:).value}';
     trdat.alerting_no_cue.trialinfo  =  value_marker_no_cue
     trdat.alerting_double_cue.trialinfo  =  value_marker_double
   % trdat.trialinfo_markers  =  trdat.trialinfo
   % trdat.trialinfo  =  str2double(trdat.trialinfo) %convert trial info to NaN double for auto 
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat'],'trdat','-v7.3'); % added this into to save trial data for auto artifact rejeciton 
    %clear data tdat%tidying

%load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat'])

% WARNING STIM CODES
% 'wnou' = No Cue, Target Up
% 'wnod' = No Cue, Target Down
% 'wceu' = Center Cue, Target Up
% 'wced' = Center Cue, Target Down
% 'wdou' = Double Cue, Target Up
% 'wdud' = Double Cue, Target Down
% 'wupu' = Up Cue, Target Up
% 'wdwd' = Down Cue, Target Down


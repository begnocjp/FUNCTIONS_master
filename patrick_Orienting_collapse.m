
function [trdat] = patrick_Orienting_collapse(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);

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



value1      = [find(strcmp('wceu', {cfg.event.value}))]'% find trials with trigger value for "center"
value2      = [find(strcmp('wced', {cfg.event.value}))]'
value3      = [find(strcmp('wupu', {cfg.event.value}))]'% find trials with trigger value for "up & down"
value4      = [find(strcmp('wdwd', {cfg.event.value}))]'
value      = vertcat(value1, value2, value3, value4) %combine 

sample1     = [cfg.event(find(strcmp('wceu', {cfg.event.value}))).sample]'; %get samples for both conditions
sample2     = [cfg.event(find(strcmp('wced', {cfg.event.value}))).sample]';
sample3     = [cfg.event(find(strcmp('wupu', {cfg.event.value}))).sample]'; %get samples for both conditions
sample4     = [cfg.event(find(strcmp('wdwd', {cfg.event.value}))).sample]';
sample      =  vertcat(sample1, sample2, sample3, sample4)  %combine 



info = cfg.event(value) %get trial info for both conditions
% make trial.info - 1 = first marker "wnou" 2 = second marker "wnod"

 value_marker1 = value1
 value_marker1(:,1) = 3 
 
  value_marker2 = value2
  value_marker2(:,1) = 3
  
 value_marker3 = value3
 value_marker3(:,1) = 4 
 
  value_marker4 = value4
  value_marker4(:,1) = 4
 
 value_marker     = vertcat(value_marker1, value_marker2, value_marker3, value_marker4) 
   

% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.pre  * cfg.hdr.Fs);
posttrig =  round(cfg.trialdef.post * cfg.hdr.Fs);

%make trl matrix no cue
cfg.trl = []
trlbegin = sample + pretrig;      %  begin trial
trlend   = sample + posttrig;     %  end of trial
offset = pretrig*ones(size(trlend));              %  a negative offset indicates that the trial begins before the trigger      

cfg.trl = [trlbegin trlend offset]; % concatenate the columns into the trl matrix
  
  
 trdat = ft_redefinetrial(cfg,data);
 
 %make trl matrix double cue


   % trdat.trialinfo  =  {info(:).value}';
     trdat.trialinfo  =  value_marker

   % trdat.trialinfo_markers  =  trdat.trialinfo
   % trdat.trialinfo  =  str2double(trdat.trialinfo) %convert trial info to NaN double for auto 
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat'],'trdat','-v7.3'); % added this into to save trial data for auto artifact rejeciton 
    %clear data tdat%tidying
end
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


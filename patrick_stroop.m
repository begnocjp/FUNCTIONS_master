
function [trdat] = patrick_stroop(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);

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
    
    edat                  = readtable([wpms.dirs.edat_txt wpms.names{name_i} '.txt'])
    accuracy              = edat{:,33}


value1      = [find(strcmp('ibng', {cfg.event.value}))]'% find trials with trigger value for "ibng"
value2      = [find(strcmp('ignb', {cfg.event.value}))]'% 
value3      = [find(strcmp('iynr', {cfg.event.value}))]'% 
value4     = [find(strcmp('ibny', {cfg.event.value}))]'% 
value5      = [find(strcmp('irny', {cfg.event.value}))]'% inc greenNyellow  and redNyellow ?  
value6      = [find(strcmp('ignr', {cfg.event.value}))]'% 
value7      = [find(strcmp('iyng', {cfg.event.value}))]'%
value8      = [find(strcmp('iynb', {cfg.event.value}))]'% 
value9      = [find(strcmp('irng', {cfg.event.value}))]'% 
value10     = [find(strcmp('irnb', {cfg.event.value}))]'% 
value11      = [find(strcmp('ibnr', {cfg.event.value}))]'% 

value12      = [find(strcmp('cblu', {cfg.event.value}))]'% 
value13      = [find(strcmp('cred', {cfg.event.value}))]'%
value14      = [find(strcmp('cgre', {cfg.event.value}))]'% 
value15      = [find(strcmp('cyel', {cfg.event.value}))]'%

value16      = [find(strcmp('nbng', {cfg.event.value}))]'% 
value17      = [find(strcmp('ngng', {cfg.event.value}))]'%
value18      = [find(strcmp('nrng', {cfg.event.value}))]'% 
value19      = [find(strcmp('nyng', {cfg.event.value}))]'%

value20      = [find(strcmp('nxnr', {cfg.event.value}))]'% 
value21      = [find(strcmp('nxnb', {cfg.event.value}))]'%
value22      = [find(strcmp('nxng', {cfg.event.value}))]'% 
value23      = [find(strcmp('nxny', {cfg.event.value}))]'%

value      = vertcat(value1, value2, value3, value4, value5, value6, ...
value7, value8, value9, value10, value11, value12, value13, value14, value15, ...
value16, value17, value18, value19, value20, value21, value22, value23) %combine 

    indices = find(accuracy(:,1)==0); %remove inaccurate trials - % find all row indices in the second column of your matrix X that are equal to % zero
    value(indices,:) = []; % get rid of all the rows in value that correspond to the row indices you found
    
  
sample1     = [cfg.event(find(strcmp('ibng', {cfg.event.value}))).sample]'% get samples for both conditions
sample2     = [cfg.event(find(strcmp('ignb', {cfg.event.value}))).sample]'% 
sample3     = [cfg.event(find(strcmp('iynr', {cfg.event.value}))).sample]'% 
sample4     = [cfg.event(find(strcmp('ibny', {cfg.event.value}))).sample]'% 
sample5     = [cfg.event(find(strcmp('irny', {cfg.event.value}))).sample]'% 
sample6     = [cfg.event(find(strcmp('ignr', {cfg.event.value}))).sample]'% 
sample7     = [cfg.event(find(strcmp('iyng', {cfg.event.value}))).sample]'%
sample8     = [cfg.event(find(strcmp('iynb', {cfg.event.value}))).sample]'% 
sample9     = [cfg.event(find(strcmp('irng', {cfg.event.value}))).sample]'% 
sample10    = [cfg.event(find(strcmp('irnb', {cfg.event.value}))).sample]'% 
sample11     = [cfg.event(find(strcmp('ibnr', {cfg.event.value}))).sample]'% 

sample12      = [cfg.event(find(strcmp('cblu', {cfg.event.value}))).sample]'% 
sample13      = [cfg.event(find(strcmp('cred', {cfg.event.value}))).sample]'%
sample14      = [cfg.event(find(strcmp('cgre', {cfg.event.value}))).sample]'% 
sample15      = [cfg.event(find(strcmp('cyel', {cfg.event.value}))).sample]'%

sample16      = [cfg.event(find(strcmp('nbng', {cfg.event.value}))).sample]'% 
sample17      = [cfg.event(find(strcmp('ngng', {cfg.event.value}))).sample]'%
sample18      = [cfg.event(find(strcmp('nrng', {cfg.event.value}))).sample]'% 
sample19      = [cfg.event(find(strcmp('nyng', {cfg.event.value}))).sample]'%

sample20      = [cfg.event(find(strcmp('nxnr', {cfg.event.value}))).sample]'% 
sample21      = [cfg.event(find(strcmp('nxnb', {cfg.event.value}))).sample]'%
sample22      = [cfg.event(find(strcmp('nxng', {cfg.event.value}))).sample]'% 
sample23      = [cfg.event(find(strcmp('nxny', {cfg.event.value}))).sample]'%

sample      = vertcat(sample1, sample2, sample3, sample4, sample5, sample6, ...
sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15, ...
sample16, sample17, sample18, sample19, sample20, sample21, sample22, sample23) %combine 
   
    sample(indices,:) = []; % get rid of all the rows in sample that correspond to the inaccurate indices you found
    
info = cfg.event(value) %get trial info for both conditions
% make trial.info - 1 = first marker "nogo" 2 = second marker "rtar/ltar"

 value_marker1 = value1
 value_marker1(:,1) = 1 
 value_marker2 = value2
 value_marker2(:,1) = 1
 value_marker3 = value3
 value_marker3(:,1) = 1 
 value_marker4 = value4
 value_marker4(:,1) = 1 
 value_marker5 = value5
 value_marker5(:,1) = 1
 value_marker6 = value6
 value_marker6(:,1) = 1
 value_marker7 = value7
 value_marker7(:,1) = 1 
 value_marker8 = value8
 value_marker8(:,1) = 1
 value_marker9 = value9
 value_marker9(:,1) = 1
 value_marker10 = value10
 value_marker10(:,1) = 1 
 value_marker11 = value11
 value_marker11(:,1) = 1
 
 value_marker12 = value12
 value_marker12(:,1) = 2
 value_marker13 = value13
 value_marker13(:,1) = 2
 value_marker14 = value14
 value_marker14(:,1) = 2
 value_marker15 = value15
 value_marker15(:,1) = 2
 
 value_marker16 = value16
 value_marker16(:,1) = 3
 value_marker17 = value17
 value_marker17(:,1) = 3
 value_marker18 = value18
 value_marker18(:,1) = 3
 value_marker19 = value19
 value_marker19(:,1) = 3
 
 value_marker20 = value20
 value_marker20(:,1) = 4
 value_marker21 = value21
 value_marker21(:,1) = 4
 value_marker22 = value22
 value_marker22(:,1) = 4
 value_marker23 = value23
 value_marker23(:,1) = 4
 
 
 
value_marker      = vertcat(value_marker1, value_marker2, value_marker3, value_marker4, value_marker5, value_marker6, ...
value_marker7, value_marker8, value_marker9, value_marker10, value_marker11, value_marker12, value_marker13, value_marker14, value_marker15, ...
value_marker16, value_marker17, value_marker18, value_marker19, value_marker20, value_marker21, value_marker22, value_marker23) %combine 
   
      value_marker(indices,:) = []; % get rid of all the rows in sample that correspond to the inaccurate indices you found

 
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
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat_stroop'],'trdat','-v7.3'); % added this into to save trial data for auto artifact rejeciton 
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


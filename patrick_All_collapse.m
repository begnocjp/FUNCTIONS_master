
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

value1      = [find(strcmp('tnui', {cfg.event.value}))]'% find trials with trigger value for "incongruent"
value2      = [find(strcmp('tndi', {cfg.event.value}))]'
value3      = [find(strcmp('tcui', {cfg.event.value}))]'
value4      = [find(strcmp('tcdi', {cfg.event.value}))]'
value5      = [find(strcmp('tbui', {cfg.event.value}))]'
value6      = [find(strcmp('tbdi', {cfg.event.value}))]'
value7      = [find(strcmp('tuui', {cfg.event.value}))]'
value8      = [find(strcmp('tddi', {cfg.event.value}))]'  

value9      = [find(strcmp('tnuc', {cfg.event.value}))]'% find trials with trigger value for "congruent" 
value10      = [find(strcmp('tndc', {cfg.event.value}))]'
value11      = [find(strcmp('tcuc', {cfg.event.value}))]'
value12      = [find(strcmp('tcdc', {cfg.event.value}))]'
value13      = [find(strcmp('tbuc', {cfg.event.value}))]'
value14      = [find(strcmp('tbdc', {cfg.event.value}))]'
value15      = [find(strcmp('tuuc', {cfg.event.value}))]'
value16      = [find(strcmp('tddc', {cfg.event.value}))]'


value17      = [find(strcmp('wnou', {cfg.event.value}))]'% find trials with trigger value for "no cue"
value18      = [find(strcmp('wnod', {cfg.event.value}))]'
value19      = [find(strcmp('wdou', {cfg.event.value}))]'% find trials with trigger value for "double"
value20      = [find(strcmp('wdud', {cfg.event.value}))]'

value21      = [find(strcmp('wceu', {cfg.event.value}))]'% find trials with trigger value for "center"
value22      = [find(strcmp('wced', {cfg.event.value}))]'
value23      = [find(strcmp('wupu', {cfg.event.value}))]'% find trials with trigger value for "up & down"
value24      = [find(strcmp('wdwd', {cfg.event.value}))]'


value      = vertcat(value1, value2, value3, value4, value5, value6, value7, value8, ...
             value9, value10, value11, value12, value13, value14, value15, value16, ...
             value17, value18, value19, value20, value21, value22, value23, value24) %combine 
         
sample1      = [cfg.event(find(strcmp('tnui', {cfg.event.value}))).sample]'%get samples for both conditions
sample2      = [cfg.event(find(strcmp('tndi', {cfg.event.value}))).sample]'
sample3      = [cfg.event(find(strcmp('tcui', {cfg.event.value}))).sample]'
sample4      = [cfg.event(find(strcmp('tcdi', {cfg.event.value}))).sample]'
sample5      = [cfg.event(find(strcmp('tbui', {cfg.event.value}))).sample]'
sample6      = [cfg.event(find(strcmp('tbdi', {cfg.event.value}))).sample]'
sample7      = [cfg.event(find(strcmp('tuui', {cfg.event.value}))).sample]'
sample8      = [cfg.event(find(strcmp('tddi', {cfg.event.value}))).sample]'  

sample9      = [cfg.event(find(strcmp('tnuc', {cfg.event.value}))).sample]'
sample10     = [cfg.event(find(strcmp('tndc', {cfg.event.value}))).sample]'
sample11     = [cfg.event(find(strcmp('tcuc', {cfg.event.value}))).sample]'
sample12     = [cfg.event(find(strcmp('tcdc', {cfg.event.value}))).sample]'
sample13     = [cfg.event(find(strcmp('tbuc', {cfg.event.value}))).sample]'
sample14     = [cfg.event(find(strcmp('tbdc', {cfg.event.value}))).sample]'
sample15     = [cfg.event(find(strcmp('tuuc', {cfg.event.value}))).sample]'
sample16     = [cfg.event(find(strcmp('tddc', {cfg.event.value}))).sample]'

sample17     = [cfg.event(find(strcmp('wnou', {cfg.event.value}))).sample]'; %get samples for both conditions
sample18     = [cfg.event(find(strcmp('wnod', {cfg.event.value}))).sample]';
sample19     = [cfg.event(find(strcmp('wdou', {cfg.event.value}))).sample]'; %get samples for both conditions
sample20     = [cfg.event(find(strcmp('wdud', {cfg.event.value}))).sample]';

sample21     = [cfg.event(find(strcmp('wceu', {cfg.event.value}))).sample]'; %get samples for both conditions
sample22     = [cfg.event(find(strcmp('wced', {cfg.event.value}))).sample]';
sample23     = [cfg.event(find(strcmp('wupu', {cfg.event.value}))).sample]'; %get samples for both conditions
sample24     = [cfg.event(find(strcmp('wdwd', {cfg.event.value}))).sample]';

sample      = vertcat(sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, ...
             sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16, ...
             sample17, sample18, sample19, sample20, sample21, sample22, sample23, sample24) %combine 


info = cfg.event(value) %get trial info for both conditions
% make trial.info - 1 = first marker "wnou" 2 = second marker "wnod"

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
value_marker9(:,1) = 2
value_marker10 = value10
value_marker10(:,1) = 2
value_marker11 = value11
value_marker11(:,1) = 2
value_marker12 = value12
value_marker12(:,1) = 2
value_marker13 = value13
value_marker13(:,1) = 2
value_marker14 = value14
value_marker14(:,1) = 2
value_marker15 = value15
value_marker15(:,1) = 2
value_marker16 = value16
value_marker16(:,1) = 2

value_marker17 = value17
value_marker17(:,1) = 3
value_marker18 = value18
value_marker18(:,1) = 3

value_marker19 = value19
value_marker19(:,1) = 4
value_marker20 = value20
value_marker20(:,1) = 4

value_marker21 = value21
value_marker21(:,1) = 5
value_marker22 = value22
value_marker22(:,1) = 5

value_marker23 = value23
value_marker23(:,1) = 6
value_marker24 = value24
value_marker24(:,1) = 6

 
 value_marker      = vertcat(value_marker1, value_marker2, value_marker3, value_marker4, value_marker5, value_marker6, value_marker7, value_marker8, ...
             value_marker9, value_marker10, value_marker11, value_marker12, value_marker13, value_marker14, value_marker15, value_marker16, ...
             value_marker17, value_marker18, value_marker19, value_marker20, value_marker21, value_marker22, value_marker23, value_marker24) %combine 
   

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


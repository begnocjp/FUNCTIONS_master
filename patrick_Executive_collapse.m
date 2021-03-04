
function [trdat] = patrick_Executive_collapse(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);

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
value      = vertcat(value1, value2, value3, value4, value5, value6, value7, value8, ...
             value9, value10, value11, value12, value13, value14, value15, value16) %combine 


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
sample       = vertcat(sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, ...
             sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16)


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
 
value_marker      = vertcat(value_marker1, value_marker2, value_marker3, value_marker4, value_marker5, value_marker6, value_marker7, value_marker8, ...
             value_marker9, value_marker10, value_marker11, value_marker12, value_marker13, value_marker14, value_marker15, value_marker16) %combine 
   

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
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat_Executive'],'trdat','-v7.3'); % added this into to save trial data for auto artifact rejeciton 
    %clear data tdat%tidying
end
%load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat'])

% TARGET STIM CODES

% 'tnui' = No Cue, Target Up, Incongruent

% 'tndi' = No Cue, Target Down, Incongruent

% 'tcui' = Center Cue, Target Up, Incongruent

% 'tcdi' = Center Cue, Target Down, Incongruent

% 'tbui' = Double Cue, Target Up, Incongruent

% 'tbdi' = Double Cue, Target Down, Incongruent

% 'tuui' = Up Cue, Target Up, Incongruent

% 'tddi' = Down Cue, Target Down, Incongruent

% 'tnuc' = No Cue, Target Up, Congruent

% 'tndc' = No Cue, Target Down, Congruent

% 'tcuc' = Center Cue, Target Up, Congruent

% 'tcdc' = Center Cue, Target Down, Congruent

% 'tbuc' = Double Cue, Target Up, Congruent

% 'tbdc' = Double Cue, Target Down, Congruent

% 'tuuc' = Up Cue, Target Up, Congruent

% 'tddc' = Doown Cue, Target Down, Congruent


function [trdat] = patrick_gonogo(wpms,name_i,trialfunction,pre_trial,post_trial,file_ext);

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
    accuracy              = edat{:,48}


value1      = [find(strcmp('nogo', {cfg.event.value}))]'% find trials with trigger value for "nogo"
value2      = [find(strcmp('rtar', {cfg.event.value}))]'% find trials with trigger value for "rtar"
value3      = [find(strcmp('ltar', {cfg.event.value}))]'% find trials with trigger value for "ltar"
value      = vertcat(value1, value2, value3) %combine 

    indices = find(accuracy(:,1)==0); %remove inaccurate trials - % find all row indices in the second column of your matrix X that are equal to % zero
    value(indices,:) = []; % get rid of all the rows in value that correspond to the row indices you found
    
    
sample1     = [cfg.event(find(strcmp('nogo', {cfg.event.value}))).sample]'; %get samples for both conditions
sample2     = [cfg.event(find(strcmp('rtar', {cfg.event.value}))).sample]';
sample3     = [cfg.event(find(strcmp('ltar', {cfg.event.value}))).sample]'; %get samples for both conditions
sample      =  vertcat(sample1, sample2, sample3)  %combine 
   
    sample(indices,:) = []; % get rid of all the rows in sample that correspond to the inaccurate indices you found
    
info = cfg.event(value) %get trial info for both conditions
% make trial.info - 1 = first marker "nogo" 2 = second marker "rtar/ltar"

 value_marker1 = value1
 value_marker1(:,1) = 1 
 
  value_marker2 = value2
  value_marker2(:,1) = 2
  
 value_marker3 = value3
 value_marker3(:,1) = 2 
 
 value_marker     = vertcat(value_marker1, value_marker2, value_marker3) 
   
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
    save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat_gonogo'],'trdat','-v7.3'); % added this into to save trial data for auto artifact rejeciton 
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


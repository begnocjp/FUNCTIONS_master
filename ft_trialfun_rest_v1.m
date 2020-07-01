function [trl] = ft_trialfun_rest_v1(cfg,name_i)
index = name_i;
%edited by Aaron/Alex/Patrick - 2017.01.09

% For resting state recordings from .mff files
% 
% 
% 
% 

%% Calculate Times:

% load all trial samples:
% See how many we are working with? ...
% obtain an array of times to perform calculations of trial beginnings with

% for event_i = 1:length(cfg.event)
%     cfg.event(1,event_i).sample = cfg.event(1,event_i).sample - magic_number;
% end

% Determine trial length/num trials
% For 250 Hz, 500 samples = 2 sec
beg_trials = 1:500:cfg.hdr.nSamples;

% determine the number of samples before and after the trial beginning
pretrig  = -round(cfg.trialdef.pre  * cfg.hdr.Fs);
posttrig =  round(cfg.trialdef.post * cfg.hdr.Fs);

% find trigger items
trigger = {cfg.event.value}';
sample  = [cfg.event(strcmp('trigger', {cfg.event.type})).sample]';

% Build Trial Epochs
trl = [];

for j = (1:length(beg_trials)-1)
%     if 
%     
%     end
    trlbegin = beg_trials(j) + pretrig;
    trlend   = beg_trials(j) + posttrig -1;
    offset   = pretrig;
    newtrl   = [trlbegin trlend offset 3];
    trl      = [trl; newtrl];
    
end

trialCount = length(beg_trials);
% TRIAL ID INFO: Attention Trials = 1; Single Trials = 2; Repeat Trials = 3 

%c = clock;
%currenttime = (datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));
fileID = fopen('ProcessingLog.txt','a');
%fprintf(fileID,'\n\n%s: %s - Trial Function \n', currenttime,cfg.filename_original);
fprintf(fileID,'Total Number Processed: %i \n', trialCount);
fclose(fileID);

end
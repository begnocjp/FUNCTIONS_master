%% FNL_ARTIFACT_REJECTION_AUTO
%   Undertakes artifact rejection on the data after blink correction has been
%   applied
%   Data can be filtered to remove muscle artifact using a low pass filter in
%   this stage
%   Trials that do not have signals that exceed the min and max values are
%   deemed to be valid trials
%
%   Min and Max threshold values may differ for each dataset - it is
%   recommended to explore these with your dataset first to reach a sensible
%   level
%
% 
%  USEAGE:
%         fnl_artifact_rejection_auto(wpms,name_i,lpfilter,lpfreq,min,max)
%  INPUTS:
%         wpms: working parameters stucture (contains names,dirs)
%         name_i: current participant index
%         lpfilter: low pass filter should be applied? true or false
%         lpfreq: low pass frequency cut off e.g. 30
%         min: minimum threshold value
%         max: maximum threshold value
%
%  Patrick Cooper & Aaron Wong, 2014
%  Functional Neuroimaging Laboratory, University of Newcastle
function patrick_ccm_artifact_rejection_auto(wpms,name_i,lpfilter,lpfreq,min,max,condition)
load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORR_trdat' condition]);
cfg = [];
if lpfilter == 1;
    cfg.lpfilter    = 'yes';
    cfg.lpfreq      = lpfreq;
    cfg.lpfilttype  = 'but';
    cfg.lpfiltord   = 4;
elseif lpfilter == 0;
    cfg.lpfilter = 'no';
end
fprintf(1,'---- Performing LP Filtering: CuttOff = %1.1fHz\n',cfg.lpfreq);
eogcorr = ft_preprocessing(cfg,trdat); %feeding trdat directly in here, used to be 'eogcorr' from old manual ICA correction, now just takes 'trdat; from trial definition 
cfg = [];
% for i = 1:length(eogcorr.label)
%     if strcmp(eogcorr.label{i},'O2');
%         index = i;
%     end
% end
% exist_index = exist('index','var');
% if exist_index == 0;
%     for i = 1:length(eogcorr.label)
%         if strcmp(eogcorr.label{i},'M1');
%             index = i-1;
%         end
%     end
% end
cfg.artfctdef.threshold.channel   = 1:210; %don't include frontal-externals ; oat question - after channel reject does this still make sense?
cfg.artfctdef.threshold.min       = min; % put 'min' variable back in
cfg.artfctdef.threshold.max       = max; % put 'max' variable back in
cfg.trl                           = eogcorr.cfg.previous.trl; % changing from  orig - patrick b. eogcorr.cfg.previous.previous{1,1}.previous.trl;
cfg.bpfilter                      = 'no';
cfg.artfctdef.bpfilter            = 'no';
cfg.artfctdef.threshold.bpfilter  = 'no';
cfg.artfctdef.feedback            = 'yes';
[cfg, artifact]                   = ft_artifact_threshold(cfg, eogcorr); %changed from eogcorr to trdat 
nt                                = (length(cfg.trl) - length(artifact));
npt                               = (nt/length(cfg.trl)*100);
%dbstop if error % debug?
fileid                            = fopen('TrialProcessingLog_reranforneuroimage.txt','a');
fprintf(fileid,'%s\t%i\t%3.1f',wpms.names{name_i},nt,npt);
fprintf(fileid,'\r\n');
fclose(fileid); 
[data] = ft_rejectartifact(cfg, eogcorr); %changed from eogcorr to trdat 
%clear eogcorr artifact nt npt ans
close all
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_ARTFREEDATA' condition],'data','-v7.3');
%clear artrej eogcorr artifact cfg data %tidying
end
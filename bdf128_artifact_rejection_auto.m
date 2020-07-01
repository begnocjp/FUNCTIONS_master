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
function bdf128_artifact_rejection_auto(wpms,name_i,lpfilter,lpfreq,min,max)
fprintf('%s\t%s\n','Working on:',wpms.names{name_i});
load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_EOGCORRECTED']);
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
eogcorr = ft_preprocessing(cfg,eogcorr);
cfg = [];
for i = 1:length(eogcorr.label)
    if strcmp(eogcorr.label{i},'D32');
        index = i;
    end
end
exist_index = exist('index','var');
if exist_index == 0;
    for i = 1:length(eogcorr.label)
        if strcmp(eogcorr.label{i},'EXG1');
            index = i-1;
        end
    end
end
cfg.artfctdef.threshold.channel   = 1:index;%don't include externals
cfg.artfctdef.threshold.min       = min;
cfg.artfctdef.threshold.max       = max;
cfg.trl                           = eogcorr.cfg.previous.previous{1,1}.previous.trl;
cfg.bpfilter                      = 'no';
cfg.artfctdef.bpfilter            = 'no';
cfg.artfctdef.threshold.bpfilter  = 'no';
cfg.artfctdef.feedback            = 'yes';
[cfg, artifact]                   = ft_artifact_threshold(cfg, eogcorr);
nt                                = (length(cfg.trl) - length(artifact));
npt                               = (nt/length(cfg.trl)*100);

fileid                            = fopen('TrialProcessingLog_reranforneuroimage.txt','a');
fprintf(fileid,'%s\t%i\t%3.1f',wpms.names{name_i},nt,npt);
fprintf(fileid,'\r\n');
fclose(fileid);
[data] = ft_rejectartifact(cfg,eogcorr);
clear eogcorr artifact nt npt ans
close all
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_ARTFREEDATA'],'data','-v7.3');
clear artrej eogcorr artifact cfg data %tidying
end
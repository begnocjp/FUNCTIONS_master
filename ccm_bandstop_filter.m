%% CCM_PREPROC_FILTER
% Run a bandstop filter to remove line noise
%  USEAGE:
%           [data] = ccm_preproc_filter(refdat,'bsfilterchoice',bsfilter)
%  INPUTS:
%         refdat              = dat structure from fnl_reference
%        'bsfilterchoice'     = string to select need for band stop filter 
%                              'yes' or 'no'
%                               used to remove line noise
%         bsfilter            = band stop filter values
%                               recommended [48 52] in USA use [58 62]

% OUTPUT:
%         data  = filtered data
%
%
% Patrick Cooper, May 2014
% Functional Neuroimaging Laboratory, University of Newcastle

function [data] = ccm_bandstop_filter(refdat,bsfilterchoice,bsfilter)

cfg = [];
cfg.bsfilter = bsfilterchoice;
cfg.bsfreq = bsfilter;
% 
% cfg.lpfilter = lpfilterchoice;
% cfg.lpfreq = lpfilter;
% 
% cfg.hpfilter = hpfilterchoice;
% cfg.hpfreq = hpfilter;
% 
% cfg.hpfiltdir = hpfiltdir;
% cfg.hpfiltord = hpfiltord;
% cfg.hpfilttype = hpfilttype;
fprintf('%s\t%2.0f\t%s\n','Performing',mean(cfg.bsfreq),'filter');
% fprintf('%s\t%1.2f\t%s %s\n','Performing',cfg.hpfreq,cfg.hpfilttype,'filter');
data = ft_preprocessing(cfg,refdat);
clear refdat %tidying
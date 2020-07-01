%% FNL_PREPROC_FILTER
% Apply a new reference montage to data
%  USEAGE:
%           [data] = fnl_preproc_filter(refdat,'bsfilterchoice',bsfilter,'hpfilterchoice',hpfilter,'hpfiltdir',hpfiltord,'hpfilttype')
%  INPUTS:
%         refdat              = dat structure from fnl_reference
%        'bsfilterchoice'     = string to select need for bandstop filter 
%                              'yes' or 'no'
%                               used to remove line noise
%         bsfilter            = band stop filter values
%                               recommended [48 52] in USA use [58 62]
%        'hpfilterchoice'     = string to select need for high pass filter
%                              'yes' or 'no'
%                               used to remove low frequency drift
%         hpfilter            = high pass filter value, e.g. 0.1
%        'hpfiltdir'          = string; direction of highpass filter
%                               'twopass', 'onepass' or 'onepass-reverse'
%        'hpfiltord'          = string; filter order
%                               default 4, try lower values if failing
%        'hpfilttype'         = string; filter type
%                               'but' or 'fir' or 'firls'
%
%
% OUTPUT:
%         data  = filtered data
%
%
% Patrick Cooper, May 2014
% Functional Neuroimaging Laboratory, University of Newcastle

function [data] = fnl_preproc_filter(refdat,bsfilterchoice,bsfilter,hpfilterchoice,hpfilter,hpfiltdir,hpfiltord,hpfilttype)

cfg = [];
cfg.bsfilter = bsfilterchoice;
cfg.bsfreq = bsfilter;
cfg.hpfilter = hpfilterchoice;
cfg.hpfreq = hpfilter;

cfg.hpfiltdir = hpfiltdir;
cfg.hpfiltord = hpfiltord;
cfg.hpfilttype = hpfilttype;
fprintf('%s\t%2.0f\t%s\n','Performing',mean(cfg.bsfreq),'filter');
fprintf('%s\t%1.2f\t%s %s\n','Performing',cfg.hpfreq,cfg.hpfilttype,'filter');
data = ft_preprocessing(cfg,refdat);
clear refdat %tidying
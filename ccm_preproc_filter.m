%% CCM_PREPROC_FILTER
% Run a bandstop filter to remove line noise
%  USEAGE:
%           [data] = ccm_preproc_filter(refdat,'bsfilterchoice',bsfilter,'lpfilterchoice',lpfilter,'lpfiltdir',lpfiltord,'lpfilttype','hpfilterchoice',hpfilter,'hpfiltdir',hpfiltord,'hpfilttype')
%  INPUTS:
%         refdat              = dat structure from fnl_reference
%        'bsfilterchoice'     = string to select need for band stop filter 
%                              'yes' or 'no'
%                               used to remove line noise
%         bsfilter            = band stop filter values
%                               recommended [48 52] in USA use [58 62]
%        'lpfilterchoice'     = string to select need for lowpass filter 
%                              'yes' or 'no'
%                               used to remove high freq noise
%         lpfilter            = low pass filter value
%                               recommended 30 for ERP, 30-50 for TF
%        'lpfiltord'          = string; filter order
%                               default 4, try lower values if failing
%        'lpfilttype'         = string; filter type
%                               recommend 'but', also 'fir' or 'firls'
%        'hpfilterchoice'     = string to select need for highpass filter 
%                              'yes' or 'no'
%                               used to remove low freq noise
%         hpfilter            = band stop filter value
%                               recommended 0.1
%        'hpfiltdir'          = string; direction of highpass filter
%                               'twopass', 'onepass' or 'onepass-reverse'
%        'hpfiltord'          = string; filter order
%                               default 4, try lower values if failing
%        'hpfilttype'         = string; filter type
%                               recommend 'but', also 'fir' or 'firls'
%
%
% OUTPUT:
%         data  = filtered data
%
%
% Patrick Cooper, May 2014
% Modded by Alexander Conley, July 2017
% Functional Neuroimaging Laboratory, University of Newcastle

function [data] = ccm_preproc_filter(refdat,bsfilterchoice,bsfilter,lpfilterchoice,lpfilter,lpfiltord,lpfilttype,hpfilterchoice,hpfilter,hpfiltdir,hpfiltord,hpfilttype)

cfg = [];
cfg.bsfilter = bsfilterchoice;
cfg.bsfreq = bsfilter;

cfg.lpfilter = lpfilterchoice;
cfg.lpfreq = lpfilter;

% cfg.lpfiltdir = lpfiltdir;
cfg.lpfiltord = lpfiltord;
cfg.lpfilttype = lpfilttype;

cfg.hpfilter = hpfilterchoice;
cfg.hpfreq = hpfilter;

cfg.hpfiltdir = hpfiltdir;
cfg.hpfiltord = hpfiltord;
cfg.hpfilttype = hpfilttype;


fprintf('%s\t%2.0f\t%s\n','Performing',mean(cfg.bsfreq),'filter');
fprintf('%s\t%1.2f\t%s %s\n','Performing',cfg.lpfreq,cfg.lpfilttype,'filter');
fprintf('%s\t%1.2f\t%s %s\n','Performing',cfg.hpfreq,cfg.hpfilttype,'filter');
data = ft_preprocessing(cfg,refdat);
clear refdat %tidying
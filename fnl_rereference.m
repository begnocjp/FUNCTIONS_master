%% FNL_REREFERENCE
% Apply a new reference montage to data
%  USEAGE:
%           [refdat] = fnl_rereference(dat,refchannel)
%  INPUTS:
%         dat           = dat structure from fnl_importeeg/fnl_downsample
%         refchannel    = reference channel(s)
%                         can be a single channel (e.g. 48) or
%                         average of multiple channels (e.g. [65 66])
%                         use 'all' for common average reference
%
% OUTPUT:
%         refdat  = data with new reference montage applied
%
%
% NOTE: This is a required step when working with BioSemi Data
%
%       Biosemi EEG systems record from active electrodes, and as such 
%       rely upon Common Mode Sense (CMS) and Driven Right Leg (DRL) 
%       electrodes, rather than the Earth and Reference electrodes used 
%       in passive electrode EEG systems. Given this configuration, EEG 
%       signals must be re-referenced to (an arbitrarily chosen) scalp 
%       electrode in order to obtain satisfactory levels of common mode 
%       rejection of electrical artifact, and before the signals can be 
%       treated as being physiologically meaningful. 
%       See http://www.biosemi.com/faq/cms&drl.htm
%
% Patrick Cooper, May 2014
% Functional Neuroimaging Laboratory, University of Newcastle

function [refdat] = fnl_rereference(dat,varargin)
cfg = [];
%check reference channel and assign to variable for cfg.refchannel to use
% varargin
% refchanncheck = class(varargin);
% refchanncheck
% if ischar(refchanncheck); %check for string input
refchann = varargin{1,1};
if strcmp(refchann,'all') == 1;
    refchann = [1:length(dat.label)];
    fprintf('%s\t%s\n','Applying new reference montage:','common average reference');
    cfg.reref = 'yes';
    cfg.refchannel = refchann;
    refdat = ft_preprocessing(cfg,dat);
    fprintf('Rereferencing done!\n');
elseif strcmp(refchann,'all') ~= 1;
    fprintf('%s\t','Applying new reference montage:');
    cfg.reref = 'yes';
    cfg.refchannel = refchann;
    refdat = ft_preprocessing(cfg,dat);
    fprintf('Rereferencing done!\n');
else warning('fnl_rereference:noref','no reference channel selected\n This is NOT recommended for Biosemi data');
    cfg.reref = 'no';
    refdat = ft_preprocessing(cfg,dat);
    fprintf('No referencing performed, moving on\n')
    error('reference channel not recognised, try ''all'' instead');
end%check if input was 'all'

% end%check for string
clear dat % tidying up as we go
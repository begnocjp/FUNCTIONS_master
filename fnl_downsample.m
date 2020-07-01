%% FNL_DOWNSAMPLE
%
% Downsamples imported EEG data to reduce processing time and storage
% Can be ignored if downsampling not required
%
%
%  USEAGE:
%           [dat] = fnl_importeeg(dat,fsample)
%  INPUTS:
%         dat     = dat structure from fnl_importeeg
%         fsample = required new sampling frequency e.g. 512
% OUTPUT:
%         dat     = data structure
%
% Patrick Cooper, May 2014
% Functional Neuroimaging Laboratory, University of Newcastle
function [dat] = fnl_downsample(dat,fsample)
narginchk(2,2)
fprintf('%s\t%4.0f\t%s\t%4.0f\n','Resampling from:',dat.fsample,'to',fsample);
dat.trial{1,1} = ft_preproc_resample(cell2mat(dat.trial(1,1)), dat.fsample, 512, 'resample');
dat.time{1,1} = ft_preproc_resample(cell2mat(dat.time(1,1)), dat.fsample, 512, 'resample');
dat.fsample = fsample;
dat.sampleinfo = [1 length(dat.trial{1,1})];
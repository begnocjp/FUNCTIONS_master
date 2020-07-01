%% FNL_IMPORTEEG
%
%  Imports a participant's EEG datafile into pipeline
%
%
%  USEAGE:
%           [dat] = fnl_importeeg(wpms,filext,name_i)
%  INPUTS:
%         wpms   = working parameters structure
%                  (must include names and CWD fields)
%         filext = string denoting eeg file format (e.g. 'bdf')
%         name_i = current participant in a processing loop
% OUTPUT:
%         dat    = data structure
%
% Patrick Cooper, May 2014
% Functional Neuroimaging Laboratory, University of Newcastle
function [dat] = fnl_importeeg(wpms,filext,name_i)
% check function inputs
narginchk(3,3)
fprintf('----- Importing EEG for : %s ------\n', ...
    wpms.names{name_i});
cfg = [];
cfg.datafile = [wpms.dirs.CWD wpms.dirs.RAW  wpms.names{name_i} '_TSWT.' filext];
cfg.continuous = 'yes';
dat = ft_preprocessing(cfg);
%% FNL_IMPORTEEG_and_downsample
%
%  Imports a participant's EEG datafile into pipeline
%
%
%  USEAGE:
%           [dat] = fnl_importeeg(wpms,filext,name_i,fsample)
%  INPUTS:
%         wpms   = working parameters structure
%                  (must include names and CWD fields)
%         filext = string denoting eeg file format (e.g. 'bdf')
%         name_i = current participant in a processing loop
%         fsample = required new sampling frequency e.g. 512
% OUTPUT:
%         dat    = data structure
%
% Patrick Cooper and Aaron Wong, May 2014
% Functional Neuroimaging Laboratory, University of Newcastle
function [dat_final] = fnl_importeeg_and_downsample_v2(wpms,filext,name_i,fsample)
% check function inputs
    narginchk(4,4)
    fprintf('----- Importing EEG for : %s ------\n', ...
            wpms.names{name_i});

    header = ft_read_header([wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' filext]);
    channel_size = header.nChans;

    %Generate New Structure:
    dat_final.hdr = header;
    dat_final.label = cell(80,1); %header.nChans
    dat_final.trial{1,1} = zeros(header.nChans,ceil(header.nSamples/4));
    dat_final.time{1,1} = zeros(1,ceil(header.nSamples/4));
    dat_final.fsample = fsample;
    dat_final.sampleinfo = ones(1,2);
    
    if header.nChans == 73
        channel_array = 72;
    else
        channel_array = [1:64,(header.nChans-15):header.nChans]; % 8 if just the externals, 16 if both the externals and the senso
    end
    
    count = 1;

    for i = channel_array
        
        cfg= [];
        cfg.datafile = [wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' filext]; 
        cfg.channel = i;
        cfg.continuous = 'yes';
        dat = ft_preprocessing(cfg);
        dat_final.trial{1,1}(count,:) = ft_preproc_resample(cell2mat(dat.trial(1,1)), dat.fsample, fsample, 'downsample');%changed 512 to fsample -PC
        dat_final.time{1,1} = ft_preproc_resample(cell2mat(dat.time(1,1)), dat.fsample, fsample, 'downsample');%changed 512 to fsample -PC
        dat_final.fsample = fsample;
        dat_final.label(count) = dat.label;
        dat_final.sampleinfo(2) = dat.sampleinfo(2)/(dat.hdr.Fs/fsample);
        count = count+1;
    end

end
%% CCM_EGI_IMPORTEEG_and_downsample
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
% Modded: Alexander Conley, December 2016
% Center for Cognitive Medicine, Vanderbilt University Medical Center

function [dat_final] = ccmegi_importeeg_and_downsample(wpms,filext,name_i,fsample)
% check function inputs
    narginchk(4,4)
    fprintf('----- Importing EEG for : %s ------\n', ...
            wpms.names{name_i});

    header = ft_read_header([wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' filext]);
    channel_size = header.nChans;

    %Generate New Structure:
    dat_final.hdr = header;
    dat_final.label = cell(header.nChans,1);
    dat_final.trial{1,1} = zeros(header.nChans,ceil(header.nSamples)); % /4 % No downsample needed as sampled at 250 Hz
    dat_final.time{1,1} = zeros(1,ceil(header.nSamples)); % /4 % No downsample needed as sampled at 250 Hz
    dat_final.fsample = fsample;
    dat_final.sampleinfo = ones(1,2);

    for i = 1:channel_size

        cfg= [];
        cfg.datafile = [wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' filext]; 
        cfg.channel = i;
        cfg.continuous = 'yes';
        dat = ft_preprocessing(cfg);
        dat_final.trial{1,1}(i,:) = cell2mat(dat.trial(1,1)); %ft_preproc_resample(cell2mat(dat.trial(1,1)), dat.fsample, fsample, 'resample');%changed 512 to fsample -PC
        dat_final.time{1,1} = cell2mat(dat.time(1,1)); %ft_preproc_resample(cell2mat(dat.time(1,1)), dat.fsample, fsample, 'resample');%changed 512 to fsample -PC
        dat_final.fsample = fsample;
        dat_final.label(i) = dat.label;
        dat_final.sampleinfo(2) = dat.sampleinfo(2)/(dat.hdr.Fs/fsample);
    end

end
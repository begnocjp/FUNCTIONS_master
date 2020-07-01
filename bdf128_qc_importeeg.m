%% BDF128_IMPORTEEG_and_downsample
%
%  Imports a participant's EEG datafile into pipeline from BioSemi 128
%  channel cap
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
% Alex Conley, December 2019
% Center for Cognitive Medicine, Vanderbilt University Medical Center
function [dat_final] = bdf128_qc_importeeg(wpms,filext,name_i)
% check function inputs
    narginchk(3,3)
    fprintf('----- Importing EEG for : %s ------\n', ...
            wpms.names{name_i});

    header = ft_read_header([wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' filext]);
    channel_size = header.nChans;

    %Generate New Structure: Import data into MATLAB format, no downsample
    dat_final.hdr = header;
    dat_final.label = cell(header.nChans,1);
    dat_final.trial{1,1} = zeros(header.nChans,ceil(header.nSamples));
    dat_final.time{1,1} = zeros(1,ceil(header.nSamples));
%     dat_final.fsample = fsample;
    dat_final.sampleinfo = ones(1,2);

    for i = 1:channel_size

        cfg= [];
        cfg.datafile = [wpms.dirs.CWD wpms.dirs.RAW wpms.names{name_i} '.' filext]; 
        cfg.channel = i;
        cfg.continuous = 'yes';
        dat = ft_preprocessing(cfg);
%         dat_final.trial{1,1}(i,:) = ft_preproc_resample(cell2mat(dat.trial(1,1)), dat.fsample, fsample, 'downsample');%changed 512 to fsample -PC
%         dat_final.time{1,1} = ft_preproc_resample(cell2mat(dat.time(1,1)), dat.fsample, fsample, 'downsample');%changed 512 to fsample -PC
%         dat_final.fsample = fsample;
%         dat_final.label(i) = dat.label;
%         dat_final.sampleinfo(2) = dat.sampleinfo(2)/(dat.hdr.Fs/fsample);
    end

end
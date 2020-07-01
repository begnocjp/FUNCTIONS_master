%% EEGLAB Spectral Data


wpms       = [];%working parameters
wpms.dirs  = struct('CWD','E:\fieldtrip\','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS\','RAW','RAW\','preproc','PREPROC_OUTPUT\', ...
    'DATA_DIR','EEGLAB_FORMAT\','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR\', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT\','EEGDispOutput','EEGDISPLAY_OUTPUT\');
addpath('E:\fieldtrip\PACKAGES\eeglab_current\eeglab14_1_2b');
eeglab


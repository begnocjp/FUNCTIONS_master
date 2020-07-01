function [ERP] = extract_ERP_withfilt(filename, baseline,lowfilt,hifilt,filterorder)
EEG = pop_loadset(filename);


% Inputs:
%   EEG       - input dataset
%   locutoff  - lower edge of the frequency pass band (Hz)  {0 -> lowpass}
%   hicutoff  - higher edge of the frequency pass band (Hz) {0 -> highpass}
%   filtorder - length of the filter in points {default 3*fix(srate/locutoff)}
%   revfilt   - [0|1] Reverse filter polarity (from bandpass to notch filter). 
%                     Default is 0 (bandpass).
%   usefft    - [0|1] 1 uses FFT filtering instead of FIR. Default is 0.
%   firtype   - ['firls'|'fir1'] filter design method, default is 'firls'
%   causal    - [0|1] 1 uses causal filtering. Default is 0.
srate = 500;
filterorder = 500;
revfilt = 0;
usefft = 0;
firtype = 'firls';
plotfreqz = 0;
causal = 1;


EEGOUT = pop_eegfilt( EEG, lowfilt, hifilt, filterorder);
EEG_temp = EEGOUT;
EEG_temp.data = reshape(EEGOUT.data,size(EEG.data));
BASE = pop_rmbase(EEG_temp, baseline);
EEGOUT_temp =EEGOUT;
EEGOUT_temp.data = reshape(BASE.data,size(EEG_temp.data));
ERP = pop_comperp(EEGOUT_temp,1,1);
close;

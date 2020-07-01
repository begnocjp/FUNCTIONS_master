function [ERP] = extract_ERP(filename, baseline)
EEG = pop_loadset(filename);
BASE = pop_rmbase(EEG, baseline);
EEGOUT = pop_eegfilt( BASE, 0, 8);
ERP = pop_comperp(EEGOUT,1,1);


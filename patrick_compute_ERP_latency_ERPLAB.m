function patrick_compute_ERP_latency_ERPLAB(wpms,name_i,N2_lat,P3_lat,P1_lat,front_chan,cent_chan,pari_chan,occip_chan,baseline)

PartID = wpms.names{name_i}; % change this to load each new participant in.
fprintf('Working on: %s \n',PartID);
load([wpms.dirs.CWD wpms.dirs.preproc PartID,'_REFnFILT']);


load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' condition '.mat']);
%convert to EEGlab structure
data=timelock(1,1)
data.events      = [];
data.channels = data.label
EEG = pop_fileio(data.hdr, data.trial{1, 1});
Chan.chanlocs=readlocs('/Users/patrick/Desktop/nCCR_Cancer_EEG/FUNCTIONS/GSN-HydroCel-256.sfp')
EEG.chanlocs = Chan.chanlocs
EEG.chanlocs(1:3) = []


 save([wpms.dirs.CWD wpms.dirs.ERP [condition '_ERP_lat_ERPLAB']], 'ERP');

%ccm256_auto_bad_channel_reject

function patrick_ccm256_auto_chan_reject(wpms,name_i)

PartID = wpms.names{name_i}; % change this to load each new participant in.
fprintf('Working on: %s \n',PartID);
load([wpms.dirs.CWD wpms.dirs.preproc PartID,'_REFnFILT']);


%convert to EEGlab structure
% data = refdat_CSD_2029
data.events      = [];
data.channels = data.label
EEG = pop_fileio(data.hdr, data.trial{1, 1});
Chan.chanlocs=readlocs('/Users/patrick/Desktop/nCCR_Cancer_EEG/FUNCTIONS/GSN-HydroCel-256.sfp')
EEG.chanlocs = Chan.chanlocs
EEG.chanlocs(1:3) = []


%perform channel rejection, if you adjust the threshold here also make same
%adjustment to the chanrej function in auto ICA removal 

%rehecting based on spec freq
[EEG,EEG.reject.indelec] = pop_rejchan(EEG,'elec',[1:256], ...
    'threshold',2,'norm','on','measure','spec','freqrange',[0.3 40]);

%rejecting based on kurtosis
%  [EEG,EEG.reject.indelec] = pop_rejchan(EEG,'elec',[1:256], ...
%     'threshold',4,'norm','on','measure','kurt');





data = eeglab2fieldtrip( EEG, 'raw', 'none' )


goodchann = data.elec.label


save([wpms.dirs.CWD wpms.dirs.preproc PartID,'_goodchannellist'],'goodchann');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



badchann = num2cell(EEG.reject.indelec);
badchann = string(badchann);
badchann = strcat('E',badchann);
badchann = cellstr(badchann);

%save output
save([wpms.dirs.CWD wpms.dirs.preproc PartID,'_badchannellist'],'badchann');

%tidy remove EEGLab
% show bad electrodes on scalp montage for into PDF, pssobly for end of
% preprocessing PDF


%plot = ft_layoutplot(cfg, data)


end


function [ERPLAB_amp_lat] = patrick_ERPLAB_amp_lat(wpms,name_i,N2_lat,P3_lat,P1_lat,front_chan,cent_chan,pari_chan,occip_chan,condition,time)

%calculate mean amplitude and peak latency using ERPLAB 

%for each condition load avg timelock, also loack preprocessed trials help to create EEG structure for ERPLAB



DATA_timelock = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' condition.name '.mat']) 

DATA = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REPAIRED_AND_REFERENCED' condition.name])
data = DATA.refdat    
hdr = data.hdr
trial = data.trial

  data.events      = [];
  data.hdr        = hdr
  data.trial      = trial
  data.channels = data.label
  EEG = pop_fileio(data.hdr, data.trial);    
  Chan.chanlocs=readlocs('/Users/patrick/Desktop/nCCR_Cancer_EEG/FUNCTIONS/GSN-HydroCel-256.sfp')
  EEG.chanlocs = Chan.chanlocs
  EEG.chanlocs(1:3) = []
  EEG.nbchan = 256
 
    a = fieldnames(DATA);
    a = a{1,1};
 
    EEG = pop_fileio(data.hdr, data.trial);
    EEG.data = DATA_timelock.timelock(1).avg
    
  Chan.chanlocs=readlocs('/Users/patrick/Desktop/nCCR_Cancer_EEG/FUNCTIONS/GSN-HydroCel-256.sfp')
  EEG.chanlocs = Chan.chanlocs
  EEG.chanlocs(1:3) = []
  EEG.nbchan = 256

for i = 1:length(condition.erp)
    
    ALLERP = []
        ALLERP.erpname= [wpms.names{name_i} '_TIMELOCK' condition.name]
       ALLERP.filename= [wpms.names{name_i} '_TIMELOCK' condition.name '.erp']
       ALLERP.filepath= '.'
      ALLERP.workfiles= {'test'}
        ALLERP.subject= ''
          ALLERP.nchan= 256
           ALLERP.nbin= 1
           ALLERP.pnts= size(DATA_timelock.timelock(i).avg,[2])
          ALLERP.srate= 250
           ALLERP.xmin= EEG.xmin
           ALLERP.xmax= EEG.xmax
          ALLERP.times= (DATA_timelock.timelock(i).time*1000)
        ALLERP.bindata= DATA_timelock.timelock(i).avg
       ALLERP.binerror= []
       ALLERP.datatype= 'ERP'
        ALLERP.ntrials= []
      ALLERP.pexcluded= []
         ALLERP.isfilt= 0
       ALLERP.chanlocs=  EEG.chanlocs
            ALLERP.ref= 'common'
       ALLERP.bindescr= []
          ALLERP.saved= 'yes'
        ALLERP.history= '2019.1'; % this tracks which version of EEGLAB is being used, you may ignore itEEG= pop_creabasiceventlist( EEG , 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', 'elist.txt' );% Script: 23-Sep-2021 21:01:19EEG= pop_binlister( EEG , 'BDF', './binlister_demo_2.txt', 'ExportEL', './test.txt', 'IndexEL',1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' );% Script: 23-Sep-2021 21:07:04EEG = eeg_checkset( EEG );EEG = pop_epochbin( EEG , [-200.0800.0],'pre');% Script: 23-Sep-2021 21:22:19EEG.etc.eeglabvers = '2021.1'; % this tracks which version of EEGLAB is being used, you may ignore itEEG = eeg_checkset( EEG );EEG = eeg_checkset( EEG );EEG  = pop_artmwppth( EEG , 'Channel',  1:16, 'Flag', [ 1 2], 'Threshold',  100, 'Twindow', [ -200 798], 'Windowsize',  200, 'Windowstep',  100 ); % GUI: 24-Sep-2021 09:33:07EEG = eeg_checkset( EEG );; % this tracks which version of EEGLAB is being used, you may ignore it↵EEG= pop_creabasiceventlist( EEG , 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', 'elist.txt' );% Script: 23-Sep-2021 21:01:19↵EEG= pop_binlister( EEG , 'BDF', './binlister_demo_2.txt', 'ExportEL', './test.txt', 'IndexEL',1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' );% Script: 23-Sep-2021 21:07:04↵EEG = eeg_checkset( EEG );↵EEG = pop_epochbin( EEG , [-200.0800.0],'pre');% Script: 23-Sep-2021 21:22:19↵EEG.etc.eeglabvers = '2021.1'; % this tracks which version of EEGLAB is being used, you may ignore it↵EEG = eeg_checkset( EEG );↵EEG = eeg_checkset( EEG );↵EEG  = pop_artmwppth( EEG , 'Channel',  1:16, 'Flag', [ 1 2], 'Threshold',  100, 'Twindow', [ -200 798], 'Windowsize',  200, 'Windowstep',  100 ); % GUI: 24-Sep-2021 09:33:07↵EEG = eeg_checkset( EEG );'
        ALLERP.version= '8.20'
     ALLERP.splinefile= ''
      ALLERP.EVENTLIST= []
    ALLERP.dataquality= []
    
    
  % COMPUTE LATENCIES
   %N2 
     [TIMELOCK.(char(condition.erp(i))).N2.info.Frontal TIMELOCK.(char(condition.erp(i))).N2.Lat.Frontal] = pop_geterpvalues( ALLERP, N2_lat,[1],front_chan,'Measure','peaklatbl', ...
     'Peakpolarity','negative','Neighborhood',10,'Resolution',1)
 
     [TIMELOCK.(char(condition.erp(i))).N2.info.Central TIMELOCK.(char(condition.erp(i))).N2.Lat.Central] = pop_geterpvalues( ALLERP, N2_lat,[1],cent_chan,'Measure','peaklatbl', ...
     'Peakpolarity','negative','Neighborhood',10,'Resolution',1)
 
     [TIMELOCK.(char(condition.erp(i))).N2.info.Parietal TIMELOCK.(char(condition.erp(i))).N2.Lat.Parietal] = pop_geterpvalues( ALLERP, N2_lat,[1],pari_chan,'Measure','peaklatbl', ...
     'Peakpolarity','negative','Neighborhood',10,'Resolution',1)
 
     [TIMELOCK.(char(condition.erp(i))).N2.info.Occipital TIMELOCK.(char(condition.erp(i))).N2.Lat.Occipital] = pop_geterpvalues( ALLERP, N2_lat,[1],occip_chan,'Measure','peaklatbl', ...
     'Peakpolarity','negative','Neighborhood',10,'Resolution',1)
 
   %P3
     [TIMELOCK.(char(condition.erp(i))).P3.info.Frontal TIMELOCK.(char(condition.erp(i))).P3.Lat.Frontal] = pop_geterpvalues( ALLERP, P3_lat,[1],front_chan,'Measure','peaklatbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',1)
 
 
%      [test testlat]= pop_geterpvalues( ALLERP, P3_lat,[1],front_chan,'Measure','peaklatbl', ...
%      'Peakpolarity','positive','Neighborhood',10,'Resolution',1)
%  
 
     [TIMELOCK.(char(condition.erp(i))).P3.info.Central TIMELOCK.(char(condition.erp(i))).P3.Lat.Central] = pop_geterpvalues( ALLERP, P3_lat,[1],cent_chan,'Measure','peaklatbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',1)
 
     [TIMELOCK.(char(condition.erp(i))).P3.info.Parietal TIMELOCK.(char(condition.erp(i))).P3.Lat.Parietal] = pop_geterpvalues( ALLERP, P3_lat,[1],pari_chan,'Measure','peaklatbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',1)
 
     [TIMELOCK.(char(condition.erp(i))).P3.info.Occipital TIMELOCK.(char(condition.erp(i))).P3.Lat.Occipital] = pop_geterpvalues( ALLERP, P3_lat,[1],occip_chan,'Measure','peaklatbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',1)
 
   %P1
     [TIMELOCK.(char(condition.erp(i))).P1.info.Frontal TIMELOCK.(char(condition.erp(i))).P1.Lat.Frontal] = pop_geterpvalues( ALLERP, P1_lat,[1],front_chan,'Measure','peaklatbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',1)
 
     [TIMELOCK.(char(condition.erp(i))).P1.info.Central TIMELOCK.(char(condition.erp(i))).P1.Lat.Central] = pop_geterpvalues( ALLERP, P1_lat,[1],cent_chan,'Measure','peaklatbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',1)
 
     [TIMELOCK.(char(condition.erp(i))).P1.info.Parietal TIMELOCK.(char(condition.erp(i))).P1.Lat.Parietal] = pop_geterpvalues( ALLERP, P1_lat,[1],pari_chan,'Measure','peaklatbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',1)
 
     [TIMELOCK.(char(condition.erp(i))).P1.info.Occipital TIMELOCK.(char(condition.erp(i))).P1.Lat.Occipital] = pop_geterpvalues( ALLERP, P1_lat,[1],occip_chan,'Measure','peaklatbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',1)
 
 % COMPUTE AVERAGE AMPLITUDES
   %N2 
     [TIMELOCK.(char(condition.erp(i))).N2.info.Frontal TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.Frontal] = pop_geterpvalues( ALLERP, N2_lat,[1],front_chan,'Measure','meanbl', ...
     'Peakpolarity','negative','Neighborhood',10,'Resolution',4)
 
     [TIMELOCK.(char(condition.erp(i))).N2.info.Central TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.Central] = pop_geterpvalues( ALLERP, N2_lat,[1],cent_chan,'Measure','meanbl', ...
     'Peakpolarity','negative','Neighborhood',10,'Resolution',4)
 
     [TIMELOCK.(char(condition.erp(i))).N2.info.Parietal TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.Parietal] = pop_geterpvalues( ALLERP, N2_lat,[1],pari_chan,'Measure','meanbl', ...
     'Peakpolarity','negative','Neighborhood',10,'Resolution',4)
 
     [TIMELOCK.(char(condition.erp(i))).N2.info.Occipital TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.Occipital] = pop_geterpvalues( ALLERP, N2_lat,[1],occip_chan,'Measure','meanbl', ...
     'Peakpolarity','negative','Neighborhood',10,'Resolution',4)
 
   %P3
     [TIMELOCK.(char(condition.erp(i))).P3.info.Frontal TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.Frontal] = pop_geterpvalues( ALLERP, P3_lat,[1],front_chan,'Measure','meanbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
 
     [TIMELOCK.(char(condition.erp(i))).P3.info.Central TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.Central] = pop_geterpvalues( ALLERP, P3_lat,[1],cent_chan,'Measure','meanbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
 
     [TIMELOCK.(char(condition.erp(i))).P3.info.Parietal TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.Parietal] = pop_geterpvalues( ALLERP, P3_lat,[1],pari_chan,'Measure','meanbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
 
     [TIMELOCK.(char(condition.erp(i))).P3.info.Occipital TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.Occipital] = pop_geterpvalues( ALLERP, P3_lat,[1],occip_chan,'Measure','meanbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
 
   %P1
     [TIMELOCK.(char(condition.erp(i))).P1.info.Frontal TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.Frontal] = pop_geterpvalues( ALLERP, P1_lat,[1],front_chan,'Measure','meanbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
 
     [TIMELOCK.(char(condition.erp(i))).P1.info.Central TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.Central] = pop_geterpvalues( ALLERP, P1_lat,[1],cent_chan,'Measure','meanbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
 
     [TIMELOCK.(char(condition.erp(i))).P1.info.Parietal TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.Parietal] = pop_geterpvalues( ALLERP, P1_lat,[1],pari_chan,'Measure','meanbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
 
     [TIMELOCK.(char(condition.erp(i))).P1.info.Occipital TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.Occipital] = pop_geterpvalues( ALLERP, P1_lat,[1],occip_chan,'Measure','meanbl', ...
     'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
 
 
 % COMPUTE AREA UNDER CURVE
%    %N2 
%      [TIMELOCK.(char(condition.erp(i))).N2.info.Frontal TIMELOCK.(char(condition.erp(i))).N2.area.Frontal] = pop_geterpvalues( ALLERP, N2_lat,[1],front_chan,'Measure','area', ...
%      'Peakpolarity','negative','Neighborhood',10,'Resolution',4)
%  
%      [TIMELOCK.(char(condition.erp(i))).N2.info.Central TIMELOCK.(char(condition.erp(i))).N2.area.Centra] = pop_geterpvalues( ALLERP, N2_lat,[1],cent_chan,'Measure','area', ...
%      'Peakpolarity','negative','Neighborhood',10,'Resolution',4)
%  
%      [TIMELOCK.(char(condition.erp(i))).N2.info.Parietal TIMELOCK.(char(condition.erp(i))).N2.area.Parietal] = pop_geterpvalues( ALLERP, N2_lat,[1],pari_chan,'Measure','area', ...
%      'Peakpolarity','negative','Neighborhood',10,'Resolution',4)
%  
%      [TIMELOCK.(char(condition.erp(i))).N2.info.Occipital TIMELOCK.(char(condition.erp(i))).N2.area.Occipital] = pop_geterpvalues( ALLERP, N2_lat,[1],occip_chan,'Measure','area', ...
%      'Peakpolarity','negative','Neighborhood',10,'Resolution',4)
%  
%    %P3
%      [TIMELOCK.(char(condition.erp(i))).P3.info.Frontal TIMELOCK.(char(condition.erp(i))).P3.area.Frontal] = pop_geterpvalues( ALLERP, P3_lat,[1],front_chan,'Measure','area', ...
%      'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
%  
%      [TIMELOCK.(char(condition.erp(i))).P3.info.Central TIMELOCK.(char(condition.erp(i))).P3.area.Central] = pop_geterpvalues( ALLERP, P3_lat,[1],cent_chan,'Measure','area', ...
%      'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
%  
%      [TIMELOCK.(char(condition.erp(i))).P3.info.Parietal TIMELOCK.(char(condition.erp(i))).P3.area.Parietal] = pop_geterpvalues( ALLERP, P3_lat,[1],pari_chan,'Measure','area', ...
%      'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
%  
%      [TIMELOCK.(char(condition.erp(i))).P3.info.Occipital TIMELOCK.(char(condition.erp(i))).P3.area.Occipital] = pop_geterpvalues( ALLERP, P3_lat,[1],occip_chan,'Measure','area', ...
%      'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
%  
%    %P1
%      [TIMELOCK.(char(condition.erp(i))).P1.info.Frontal TIMELOCK.(char(condition.erp(i))).P1.area.Frontal] = pop_geterpvalues( ALLERP, P1_lat,[1],front_chan,'Measure','area', ...
%      'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
%  
%      [TIMELOCK.(char(condition.erp(i))).P1.info.Central TIMELOCK.(char(condition.erp(i))).P1.area.Central] = pop_geterpvalues( ALLERP, P1_lat,[1],cent_chan,'Measure','area', ...
%      'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
%  
%      [TIMELOCK.(char(condition.erp(i))).P1.info.Parietal TIMELOCK.(char(condition.erp(i))).P1.area.Parietal] = pop_geterpvalues( ALLERP, P1_lat,[1],pari_chan,'Measure','area', ...
%      'Peakpolarity','positive','Neighborhood',10,'Resolution',4)
%  
%      [TIMELOCK.(char(condition.erp(i))).P1.info.Occipital TIMELOCK.(char(condition.erp(i))).P1.area.Occipital] = pop_geterpvalues( ALLERP, P1_lat,[1],occip_chan,'Measure','area', ...
%      'Peakpolarity','positive','Neighborhood',10,'Resolution',4) 
 
%creat ROI means for lat/amp

%latency
TIMELOCK.(char(condition.erp(i))).P1.Lat.mean_Frontal = mean(TIMELOCK.(char(condition.erp(i))).P1.Lat.Frontal)
TIMELOCK.(char(condition.erp(i))).P1.Lat.mean_Central = mean(TIMELOCK.(char(condition.erp(i))).P1.Lat.Central)
TIMELOCK.(char(condition.erp(i))).P1.Lat.mean_Parietal = mean(TIMELOCK.(char(condition.erp(i))).P1.Lat.Parietal)
TIMELOCK.(char(condition.erp(i))).P1.Lat.mean_Occipital = mean(TIMELOCK.(char(condition.erp(i))).P1.Lat.Occipital)

TIMELOCK.(char(condition.erp(i))).P3.Lat.mean_Frontal = mean(TIMELOCK.(char(condition.erp(i))).P3.Lat.Frontal)
TIMELOCK.(char(condition.erp(i))).P3.Lat.mean_Central = mean(TIMELOCK.(char(condition.erp(i))).P3.Lat.Central)
TIMELOCK.(char(condition.erp(i))).P3.Lat.mean_Parietal = mean(TIMELOCK.(char(condition.erp(i))).P3.Lat.Parietal)
TIMELOCK.(char(condition.erp(i))).P3.Lat.mean_Occipital = mean(TIMELOCK.(char(condition.erp(i))).P3.Lat.Occipital)

TIMELOCK.(char(condition.erp(i))).N2.Lat.mean_Frontal = mean(TIMELOCK.(char(condition.erp(i))).N2.Lat.Frontal)
TIMELOCK.(char(condition.erp(i))).N2.Lat.mean_Central = mean(TIMELOCK.(char(condition.erp(i))).N2.Lat.Central)
TIMELOCK.(char(condition.erp(i))).N2.Lat.mean_Parietal = mean(TIMELOCK.(char(condition.erp(i))).N2.Lat.Parietal)
TIMELOCK.(char(condition.erp(i))).N2.Lat.mean_Occipital = mean(TIMELOCK.(char(condition.erp(i))).N2.Lat.Occipital)


%amplitude
TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.mean_Frontal = mean(TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.Frontal)
TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.mean_Central = mean(TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.Central)
TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.mean_Parietal = mean(TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.Parietal)
TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.mean_Occipital = mean(TIMELOCK.(char(condition.erp(i))).P1.avg_Amp.Occipital)

TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.mean_Frontal = mean(TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.Frontal)
TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.mean_Central = mean(TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.Central)
TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.mean_Parietal = mean(TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.Parietal)
TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.mean_Occipital = mean(TIMELOCK.(char(condition.erp(i))).P3.avg_Amp.Occipital)

TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.mean_Frontal = mean(TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.Frontal)
TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.mean_Central = mean(TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.Central)
TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.mean_Parietal = mean(TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.Parietal)
TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.mean_Occipital = mean(TIMELOCK.(char(condition.erp(i))).N2.avg_Amp.Occipital)


end

%store group results
store = []
store.ERPs = {'N2', 'P3', 'P1'};
store.calculation = {'Lat','avg_Amp'}
store.ROIs = {'mean_Frontal', 'mean_Central', 'mean_Parietal','mean_Occipital'};

group_results.names{name_i} = wpms.names{name_i}
%TIMELOCK.group_results.store{name_i}
    
for n = 1:length(store.ERPs)
    for i = 1:length(condition.erp)
        for c = 1:length(store.calculation)
            for r = 1:length(store.ROIs)
                
                group_results.(char(store.ERPs{n})).(char(condition.erp(i))).(char(store.calculation(c))).*char(store.ROIs{r}) = TIMELOCK.(char(condition.erp(i))).(store.ERPs{n}).(char(store.calculation(c))).(store.ROIs{r})
                
            end
        end
    end
end
    
    
     load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' condition.name '.mat']);
    if condition.name == '_Alerting'
        group_results.num_trials.nocue{name_i} = length(load_subs{name_i}.timelock(1).cfg.previous.trials)
        group_results.num_trials.double{name_i} = length(load_subs{name_i}.timelock(2).cfg.previous.trials)
    elseif condition.name == '_Orienting'
        group_results.num_trials.center{name_i} = length(load_subs{name_i}.timelock(1).cfg.previous.trials)
        group_results.num_trials.updown{name_i} = length(load_subs{name_i}.timelock(2).cfg.previous.trials)
    elseif condition.name == '_Executive'
        group_results.num_trials.incongruent{name_i} = length(load_subs{name_i}.timelock(1).cfg.previous.trials)
        group_results.num_trials.congruent{name_i} = length(load_subs{name_i}.timelock(2).cfg.previous.trials)
    end

save([wpms.dirs.CWD wpms.dirs.TIMELOCK wpms.names{name_i} '_TIMELOCK_amp_lat_.mat'],'TIMELOCK','-v7.3');

   

   
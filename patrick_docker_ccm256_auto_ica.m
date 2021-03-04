%ccm256_auto_I

function patrick_docker_ccm256_auto_ica(wpms,name_i) 

PartID = wpms.names{name_i}; % change this to load each new participant in.
fprintf('Working on: %s \n',PartID);
load([wpms.dirs.CWD wpms.dirs.preproc PartID,'_REFnFILT']);
%convert to EEGlab structure

data.events      = [];
data.channels = data.label
EEG = pop_fileio(data.hdr, data.trial{1, 1});
Chan.chanlocs=readlocs('./GSN-HydroCel-256.sfp')
EEG.chanlocs = Chan.chanlocs
EEG.chanlocs(1:3) = []
%perform ICA rejection

 % if you change autochan rej settings make sure to match below
[EEG,EEG.reject.indelec] = pop_rejchan(EEG,'elec',[1:256], ...
    'threshold',2,'norm','on','measure','spec','freqrange',[0.3 40]);



% %rejecting based on kurtosis
%  [EEG,EEG.reject.indelec] = pop_rejchan(EEG,'elec',[1:256], ...
%     'threshold',4,'norm','on','measure','kurt');
% 

 
%   EEG1 = EEG
 %   EEG.icaweights = EEG1.icaweights
 %    EEG.icawinv = EEG1.icawinv
%run ICA "fastica"
   EEG = pop_runica( EEG,'fastica') 

%not using : ADJUST auto ICA (not fully auto, final selection still needed) ADJUST command: EEG = interface_ADJ (EEG, 'report');
%continute with FASTER ICA process
 
  icaProperties = component_properties(EEG)
  EEG.FASTER.icaProperties= icaProperties;
   
  exceeded_threshold = min_z(icaProperties)
  bad_component = find(exceeded_threshold)
  components = transpose(bad_component(:,1))
  EEG = pop_selectcomps( EEG, components) %for visual inspection of components

  % now actually reject components 
  % components = EEG.reject.gcompreject
  keepcomp = 0
  % plotag = 0
  EEG = pop_subcomp( EEG, components);   %removes specific components
  savefig('./QA/pop_selectcomps.fig')
  fig = openfig('./QA/pop_selectcomps.fig')
  filename = [wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_AutoRejectedICAcomps.pdf']
  saveas(fig, filename)
  saveas(fig, './QA/pop_selectcomps.pdf')
  
  
   %save output (either entire EEG structure of ideally PDF of rejected
   %componenets)
   % save([wpms.dirs.CWD wpms.dirs.preproc PartID,'_badICAlist'],'EEG');

 %now take ICA cleaned data (EEG.data) and assign to (bad chan removed) fieldtrip structure
 %for data with both bad chans and ICA components removed 

 
 load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_BadChannRemoved'])
 
 data.trial{1,1} = EEG.data 

 % eogcorr = data
  
save([wpms.dirs.CWD wpms.dirs.preproc PartID,'_BadChannRemoved'],'data');
  
  
   %%%save output somewhere%%%%%
  
  
 
    
    %tidy remove EEGLab 
    % show bad electrodes on scalp montage for into PDF, pssobly for end of
    % preprocessing PDF
    
    
end

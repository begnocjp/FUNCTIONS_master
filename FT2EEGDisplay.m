function FT2EEGDisplay ( Cfg, Data , FileName )
% FT2EEGDisplay:  Save Fieldtrip data structure to an EEGDisplay Data File.
%
%   FT2EEGDisplay ( Cfg, Data, FileName )
%
%   Data       FieldTrip data structure
%   FileName   Name of EEGDisplay File to create
%   Cfg        Optional information:
%
%   Cfg.BadChannels
%       Optional.
%       Cell array of Electrode site names that are to be marked as bad channels
%       eg Cfg.BadChannels = {'Fz','Cz'};
%
%   Cfg.ReferenceSites
%       Optional
%       A cell array of Reference site names. One for each Channel.
%       This provides the most flexible way to specify reference site names
%       e.g. Cfg.ReferenceSites = {'AvMastoids','AvMastoids','VEOG_Ref','GND'};
%
%   Cfg.CommonReference
%       Optional. Only used if ReferenceSites is not specified.
%       String defining a common reference for the scalp EEG data.
%       e.g. Cfg.CommonReference = 'Nose';
%
%   Cfg.BipolarSites
%       Optional. Only used if ReferenceSites is not specified.
%       Cell array of Channel Names that are NOT referenced to Cfg.CommonReference.
%       For these channels, a unique reference will be generated, eg VEOG_Ref
%       Defaults to list of common EOG,EMG and Status channel names.
%       e.g. Cfg.BipolarSites = {'none'}
%       e.g. Cfg.BipolarSites = {'VEOG1','VEOG2','Left_EMG','Status'};
%
% Version 1. 19/6/2014: Written by Ross Fulham

% Handle default values for Bad Channels

if ~isfield(Cfg,'BadChannels')
  Cfg.BadChannels = {};
end

% Handle Default values for Reference Sites

if ~isfield(Cfg,'ReferenceSites') || isempty(Cfg.ReferenceSites)

    if ~isfield(Cfg,'CommonReference') || isempty(Cfg.CommonReference)
        Cfg.CommonReference = 'Ref';
    end
    
    if ~isfield(Cfg,'BipolarSites') || isempty(Cfg.BipolarSites)
        Cfg.BipolarSites = {'EMG','EOG','HEOG','VEOG','VEOG1','VEOG2','Status'};
    end
    
    Cfg.ReferenceSites = {};
    for i=1:length(Data.label)
        Site = Data.label{i};
        if any(strncmp(Site,Cfg.BipolarSites,length(Site)))
            Cfg.ReferenceSites{i} = [Site '_Ref'];
        else
            Cfg.ReferenceSites{i} = Cfg.CommonReference;
        end
    end
end

% Open Output Data File

fprintf('Saving in EEGDisplay format: %s\n',FileName);

[fID,errmsg] = fopen (FileName,'w');

if fID<0
    error([errmsg ': ' FileName])
end

global EEGDisp_FileParams;

EEGDisp_FileParams = {};       %  FileParams.SetDefaultValues();
EEGDisp_FileParams.fID = fID;
EEGDisp_FileParams.CheckSum = 0;
EEGDisp_FileParams.FileSize = 0;

StoreToken('EEG ',0);
StoreToken('IBM ',0); 
StoreTokenULong('FVER',100);
StoreTokenString('PVER','FieldTrip');

Trials = size(Data.trial,2);

msPerSample = 1000.0/Data.fsample;  % milliseconds per sample

for Trial = 1:Trials

  StoreToken('DSET',0);
  
  if Trial==1
      if isfield(Cfg,'event') && ~isempty(Cfg.event)
          
         StoreTokenString('ELST','');
  
         for Ev = 1:length(Cfg.event)
             
             Event = Cfg.event(Ev);
             
             StoreTokenString('PLST','');
             
             StoreTokenString('PNAM','#Time');
             StoreTokenString('PVAL',num2str((Event.sample-1)*msPerSample));

             StoreTokenString('PNAM','#Type');
             StoreTokenString('PVAL','1');
             
             v = Event.value;
             if ~ischar(v)
                 v = num2str(v);
             end
             StoreTokenString('PNAM','$Code');
             StoreTokenString('PVAL',v);
             
             StoreTokenString('PNAM','$RawCode');
             StoreTokenString('PVAL',v);
             
             t = Event.type;
             if ~ischar(t)
                 t = num2str(t);
             end            
             StoreTokenString('PNAM','$FT_TYPE');
             StoreTokenString('PVAL',Event.type);
             
             StoreTokenString('PLND','');
         end
         
         StoreTokenString('EEND','');
         
      elseif isfield(Cfg,'trl') && ~isempty(Cfg.trl)
          
         StoreTokenString('ELST','');
  
         for trial = 1:length(Cfg.trl)
             
             trl = Cfg.trl(trial,:);
             
             StoreTokenString('PLST','');
             
             StoreTokenString('PNAM','#Time');
             StoreTokenString('PVAL',num2str((trl(1)-1-trl(3))*msPerSample));

             StoreTokenString('PNAM','#Type');
             StoreTokenString('PVAL','1');
             
             StoreTokenString('PNAM','$Code');
             StoreTokenString('PVAL',num2str(trl(4)));
             
             StoreTokenString('PNAM','$RawCode');
             StoreTokenString('PVAL',num2str(trl(4)));
             
             StoreTokenString('PLND','');
         end
         
         StoreTokenString('EEND','');
      end
  end

  Trl = Data.trial{Trial};
  
  [nChans,nSamples] = size(Trl);
  StartTime = Data.time{Trial}(1) * 1000.0;

  if ~isfield(Data,'trialinfo')
      CondName = 'EEG';
  else
      CondName = Data.trialinfo(Trial);
      if ~ischar(CondName)
           CondName = num2str(CondName);
      end
  end
  
  for Channel=1:nChans
      Site = Data.label{Channel};
      RefSite = Cfg.ReferenceSites{Channel}; 

      BadChannel = 0;
      if any(strncmp(Site,Cfg.BadChannels,length(Site)))
          BadChannel = 1;
      end
      
      % Store General Header properties
      
      StoreTokenString('PLST','');

      StoreTokenString('PNAM','$Subject');
      StoreTokenString('PVAL','Test Subject');

      StoreTokenString('PNAM','$Condition');
      StoreTokenString('PVAL',CondName);

      StoreTokenString('PLND','');

      % Store Channel Data
      
      StoreTokenULong('ASMP',nSamples);
      NumbersPerSample = 1;         % Curve.A_D.NumbersPerSample. 1 for EEG, 2 for Complex, 6 for Dipole
      StoreTokenLong('PRMS',NumbersPerSample);     
      StoreTokenULong('DOMN',0);    % TimeFreqDomain:  Time=0, Frequency=1
      StoreTokenULong('DATA',0);    % DataMode:  Potential=0, Scalar=1, Current=2, Marker=3, Probability=5, Fixed_Dipole=6, Moving_Dipole=7
      StoreTokenULong('FFTM',0);    % FFTMode: NOT_FFT=0, FFT_REAL_IM=1, FFT_AMP_PHASE=2, FFT_POWER=3
      StoreTokenULong('BADC',BadChannel);
  %if( StoreTokenFloat_Binary(ID_TNT ,Curve.A_D.TotalNumberOfTrials ,FileParams.AD.TotalNumberOfTrials) ) return true;
  %if( StoreTokenFloat_Binary(ID_CASE,Curve.A_D.Number_Cases        ,FileParams.AD.Number_Cases)  )  return true;
      StoreTokenDouble('RATE',msPerSample);  % milliseconds per sample

      StoreTokenFloat('STRT',StartTime);

      StoreTokenString('SITE',Site);
      
      StoreTokenString('REF ',RefSite);

      SizeOfFloat = 4;           % EEG Data is stored as single precision float (not double)
      Size = nSamples * NumbersPerSample * SizeOfFloat;

      StoreToken('DDAT',Size);
      fwrite(EEGDisp_FileParams.fID,Trl(Channel,:),'float32');
      
      StoreToken('AEND',0);    % End of Channel Defn. EEG=AEND, Dipole = DEND, Probaility=PEND

  end  % Store Each Channel
end    % Store Each Trial

StoreTokenEndFile();

fclose(fID);

end

function StoreToken(ID,Length)
% fprintf('Token: %4s Length: %d \n',ID,Length);

global EEGDisp_FileParams;

  fwrite(EEGDisp_FileParams.fID,ID,'char*1');
  fwrite(EEGDisp_FileParams.fID,Length,'uint32');
end

function StoreTokenLong(ID,LongValue)
global EEGDisp_FileParams;

  StoreToken(ID,4);

%  fprintf('Value: %d \n',LongValue);

  fwrite(EEGDisp_FileParams.fID,LongValue,'int32');
end

function StoreTokenULong(ID,UlongValue)
global EEGDisp_FileParams;

  StoreToken(ID,4);

%  fprintf('Value: %d \n',UlongValue);

  fwrite(EEGDisp_FileParams.fID,UlongValue,'uint32');
end


function StoreTokenDouble(ID,DoubleValue)
global EEGDisp_FileParams;

  StoreToken(ID,4);

%  fprintf('Value: %f \n',DoubleValue);

  fwrite(EEGDisp_FileParams.fID,DoubleValue,'float64');
end

function StoreTokenFloat(ID,FloatValue)
global EEGDisp_FileParams;

  StoreToken(ID,4);

%  fprintf('Value: %f \n',FloatValue);

  fwrite(EEGDisp_FileParams.fID,FloatValue,'float32');
end

function StoreTokenString(ID,StringValue)
global EEGDisp_FileParams;

  StoreToken(ID,length(StringValue));

%  fprintf('Value: %s \n',StringValue);

  fwrite(EEGDisp_FileParams.fID,StringValue,'char*1');
end

function StoreTokenEndFile()
global EEGDisp_FileParams;

  StoreToken('CHKS',5);

%  fprintf('FileSize: %d CheckSum: %d\n',EEGDisp_FileParams.FileSize,EEGDisp_FileParams.CheckSum);

  fwrite(EEGDisp_FileParams.fID,EEGDisp_FileParams.FileSize,'uint32');
  fwrite(EEGDisp_FileParams.fID,EEGDisp_FileParams.CheckSum,'uint8');
end



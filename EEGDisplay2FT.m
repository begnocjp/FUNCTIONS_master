function [Data] = EEGDisplay2FT ( FileName )
% EEGDisplay2FT:  Read an EEGDisplay file into a Fieldtrip data structure
%
%   [Data] = EEGDisplay2FT ( FileName )
%
%       FileName = EEGDisplay binary data file
%
%       Data = Fieldtrip data structure containing file contents
%
% Version 1, 19/6/2014. Written by Ross Fulham

% initialise Return Data structure
Data = [];
Data.label = {};
Data.hdr = [];

% Imported information not otherwise defined by FieldTrip
Data.hdr.orig.ReferenceSites = {};

% Open Input Data File

fprintf('Loading EEGDisplay format file: %s\n',FileName);

[fID,errmsg] = fopen (FileName,'r');

if fID<0
    error([errmsg ': ' FileName])
end

global EEGDisp_FileParams;

EEGDisp_FileParams = {};       %  FileParams.SetDefaultValues();
EEGDisp_FileParams.fID = fID;

% Verify this is an EEGDisplay Binary Data file

[Token,Size,Success] = ReadToken();

if ~Success || ~strcmp(Token,'EEG ')
    error (['File is not an EEGDisplay Binary Data File: ' FileName])
end

DataSetNumber = 0;
CurveNumber = 0;

% Default Values 

nCases = 1;
DS.EventList = {};
InEventList = false;

while ~feof(fID)
    [Token,Size,Success] = ReadToken();
    if ~Success, break, end
    
    % fprintf('Token = %s  Size = %d\n',Token,Size);
    switch Token
        case 'IBM '         
            % Data format.  Always IBM
            
        case 'FVER'
            Data.hdr.orig.FVersion = ReadUint32();
            fprintf('File Version = %d\n',Data.hdr.orig.FVersion);
            if Data.hdr.orig.FVersion~=100
                warning ('EEGDisplay File has data format version %d.\nThis version might not be fully supported.',FVersion); 
            end
            
        case 'PVER'
            Data.hdr.orig.PVersion = ReadString(Size);
            fprintf('Program Version = %s\n',Data.hdr.orig.PVersion);
            
        case 'DSET'
            if DataSetNumber > 0
                GODS{DataSetNumber} = DS;
                clear DS;
            end
            DataSetNumber = DataSetNumber + 1;
            CurveNumber = 0;
            DS.EventList = {};
            
        case 'ELST'
            % Start of Event List
            InEventList = true;
            DS.EventList = {};
        
        case 'EEND'
            % Event List End
            InEventList = false;
            
        case 'PLST'
            PropertyList = {};
            NProperties = 0;
        
        case 'PLND'
            % Property List End
            if InEventList
                DS.EventList{end+1} = PropertyList;
            end
            
        case 'PNAM'
            PropertyName = ReadString(Size);
            
        case 'PVAL'
            PropertyValue = ReadString(Size);
            NProperties = NProperties + 1;
            PropertyList(NProperties).PropertyName = PropertyName;
            PropertyList(NProperties).PropertyValue= PropertyValue;
            
        case 'ASMP'
            % Number of Samples
            NSamples = ReadUint32();
            
            if (CurveNumber>0) && NSamples ~=DS.NSamples
                error 'Field trip does not support montages with variable samples in different channels';
            end
            
            DS.NSamples = NSamples;
            
        case 'TNT '
            % total Number of Trials
            TNT = ReadFloat32();
                
        case 'CASE'
            % Number of Cases
            NCases = ReadFloat32();
                
        case 'RATE'
            % milliseconds per Samples
            msPerSample = ReadDouble();
            
            Fs = 1000.0/msPerSample;     % Frequency of Samples (Hz)
            
            if exist('Data.hdr.Fs','var') && Fs~=Data.hdr.Fs
                error 'Field trip does not support data with variable sample rates in different channels/trials';
            end
            
            Data.hdr.Fs = Fs;
            % NOTE: Data.fsample is Deprecriated. Use Data.hdr.Fs instead
            
        case 'STRT'
            % Start Time in milliseconds
            StartTime = ReadFloat32();
            
            if (CurveNumber>0) && StartTime ~=DS.StartTime
                error 'Field trip does not support montages with variable start times in different channels';
            end
            
            DS.StartTime = StartTime;
          
        case 'CH# '
            % Physical Channel Number
            CHNumber = ReadUint32();
            
        case 'SITE'
            Site = ReadString(Size);
            
        case 'REF '
            Reference = ReadString(Size);
                      
        case 'CAL '
            % Calibration value. ALWAYS = 1.0
            Calibration = ReadFloat32();
                
        case 'OLDC'
            % Raw Calibration value. Can ignore
            OldCalibration = ReadFloat32();
                
        case 'DDAT'
            % EEG Data Block
            
            size_of_float32 = 4;
            if NSamples ~= Size/size_of_float32
                error('Invalid Data Block in File');
            end
            
            DataBlock = fread(EEGDisp_FileParams.fID,NSamples,'*float32');
        
        case 'AEND'
            % Import Curve data and all Curve properties
            CurveNumber = CurveNumber + 1;

            DS.DataBlock{CurveNumber} = DataBlock;
            clear DataBlock;
            
            if DataSetNumber == 1
                Data.label(CurveNumber,1) = {Site};
                Data.hdr.orig.ReferenceSites(CurveNumber,1) = {Reference};
            else
                if ~strcmp(Site,Data.label(CurveNumber,1))
                    error 'Field Trip does not support variable electrode montages across trials'
                end
                
                if ~strcmp(Reference,Data.hdr.orig.ReferenceSites(CurveNumber,1))
                    error 'Field Trip does not support variable electrode reference montages across trials'
                end
            end
            
            Data.hdr.orig.TotalNumberTrials(DataSetNumber,CurveNumber) = TNT;
            Data.hdr.orig.NumberCases(DataSetNumber,CurveNumber) = nCases;
            Data.hdr.orig.msPerSample(DataSetNumber,CurveNumber) = msPerSample;
            Data.hdr.orig.StartTime(DataSetNumber,CurveNumber) = StartTime;
            Data.hdr.orig.PhysicalChannelNumber(DataSetNumber,CurveNumber) = CHNumber;
            Data.hdr.orig.PropertyLists{DataSetNumber,CurveNumber} = PropertyList;
            
        case 'CHKS'
            % File Size & Check Sum. Always zero
            
            FSize = ReadUint32();
            CheckSum = ReadString(1);
            
        otherwise
            fprintf(['Unrecognised Token in Data File: ' Token]);
            error 'abort';
    end
end

GODS{DataSetNumber} = DS;
clear DS;   

% Update hdr Field

% This returns a header structure with the following elements
%   hdr.Fs                  sampling frequency
%   hdr.nChans              number of channels
%   hdr.nSamples            number of samples per trial
%   hdr.nSamplesPre         number of pre-trigger samples in each trial
%   hdr.nTrials             number of trials
%   hdr.label               Nx1 cell-array with the label of each channel
%   hdr.chantype            Nx1 cell-array with the channel type, see FT_CHANTYPE
%   hdr.chanunit            Nx1 cell-array with the physical units, see FT_CHANUNIT

nChans = length(GODS{1}.DataBlock);
for i=1:length(GODS)
    if nChans ~= length(GODS{i}.DataBlock)
        error 'Fieldtrip does not support trials with variable number of channels'
    end
end
Data.hdr.nChans = nChans;

Data.hdr.label = Data.label;

Data.hdr.nSamples = length(GODS{1}.DataBlock{1});

nTrials = length(GODS);
Data.hdr.nTrials = nTrials;

Data.hdr.nSamplesPre = 0 - floor(GODS{1}.StartTime / msPerSample);
for i=1:nTrials
    if Data.hdr.nSamplesPre ~= (0 - floor(GODS{i}.StartTime / msPerSample))
        warning 'Data.hdr.nSamplesPre is invalid for some all Trials'
        break;
    end
end

% Store EEG Data

Data.trial = {};
Data.time = {};
Data.trialinfo = zeros(nTrials,1);

for i=1:nTrials
    nSamples = length(GODS{i}.DataBlock{1});
    TrlData = zeros(nChans,nSamples);
    
    for c=1:nChans
        TrlData(c,:) = GODS{i}.DataBlock{c};
    end
    
    Data.trial{i} = TrlData;

    Data.time{i} = ([1:nSamples] - 1 - floor(GODS{i}.StartTime / msPerSample)) / Fs;
end

% Extract Condition Name from the Property List attached to the
% First Curve(channel) in each Dataset(trial)

[V,T] = EEGDisplayGetProperty(Data.hdr.orig.PropertyLists,'$Condition');
Data.trialinfo(:,1) = V;

% Extract Event Markers (from first data set only)
%
% Returns an event structure with the following fields
%    event.type      = string
%    event.sample    = expressed in samples, the first sample of a recording is 1
%    event.value     = number or string
%    event.offset    = expressed in samples
%    event.duration  = expressed in samples
%    event.timestamp = expressed in timestamp units, which vary over systems (optional)

nEvents = length(GODS{1}.EventList);
Data.hdr.orig.EventList = GODS{1}.EventList';

% event.type

[v_Type,t_Type] = EEGDisplayGetProperty(Data.hdr.orig.EventList,'#Type');

t_Type(find(v_Type==1)) = {'Stimulus'};
t_Type(find(v_Type==2)) = {'Response'};
t_Type(find(v_Type==3)) = {'Other'};
t_Type(find(v_Type==4)) = {'ArtifactMark'};

% event.sample, event.timestamp

[v_Time,t_Time] = EEGDisplayGetProperty(Data.hdr.orig.EventList,'#Time');

v_sample = floor(v_Time/msPerSample)+1;    % Convert to samples
v_timestamp = v_Time/1000.0;               % Convert to Seconds

% event.duration

[v_Dur,t_Dur] = EEGDisplayGetProperty(Data.hdr.orig.EventList,'#Duration');

v_duration = floor(v_Dur/msPerSample);

% event.code

[v_Code,t_Code] = EEGDisplayGetProperty(Data.hdr.orig.EventList,'$Code');

% Build full event struct array

for i=1:nEvents
    Data.event(i) = struct('type',t_Type(i), ...
                           'sample',v_sample(i), ...
                           'timestamp',v_timestamp(i), ...
                           'duration',v_duration(i), ...
                           'value',t_Code(i), ...
                           'offset',0);
end

fclose(fID);

end

function [Str] = ReadString(Length)
global EEGDisp_FileParams;

    [Str,Count] = fread(EEGDisp_FileParams.fID,Length,'*char*1');
    Str = Str';
    
    Success = (Count == Length);
end

function [Value] = ReadUint32()
global EEGDisp_FileParams;

    [Value,Count] = fread(EEGDisp_FileParams.fID,1,'*uint32');
    
    Success = (Count == 1);
end


function [Value] = ReadFloat32()
global EEGDisp_FileParams;

    [Value,Count] = fread(EEGDisp_FileParams.fID,1,'*float32');
    
    Success = (Count == 1);
end

function [Value] = ReadDouble()
global EEGDisp_FileParams;

    [Value,Count] = fread(EEGDisp_FileParams.fID,1,'*double');
    
    Success = (Count == 1);
end


function [Token,Size,Success] = ReadToken()
global EEGDisp_FileParams;

    [Token,Count1] = fread(EEGDisp_FileParams.fID,4,'*char*1');
    Token = Token';
    [Size,Count2] = fread(EEGDisp_FileParams.fID,1,'*uint32');
    
    Success = (Count1 == 4) && (Count2 == 1);
end

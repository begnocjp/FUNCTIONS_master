% Processing job for tDCS Connectivity Datasets
% Adapted from 'AGEILITY_connjob_2013' job written by Patrick Cooper
% Adapted by Alexander Conley, January 2014.

% Set up Global Variables
clear all
warning off;
% add path for fieldtrip
addpath(genpath('C:\Users\ac027\Documents\fieldtrip\')); 
% current working directory
CWD = 'F:\fieldtrip';
% addpath for custom ft_functions
addpath([CWD,'\FUNCTIONS']);
% raw data directory
RAW = '\RAW';
% preprocessing intermediate steps
PREPROC_OUTPUT = '\PREPROC_OUTPUT';
% List of participants
                  
names = struct('pnum',{ 'DCR102' 'DCR103' 'DCR104' 'DCR106' 'DCR107' 'DCR108' 'DCR109' 'DCR110' 'DCR111' ... 
    'DCR112' 'DCR113' 'DCR114' 'DCR115' 'DCR117' 'DCR118' 'DCR119' 'DCR120' 'DCR121' ...
    'DCR122' 'DCR123' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR204' 'DCR206' 'DCR207' ... 
    'DCR208' 'DCR209' 'DCR210' 'DCR211' 'DCR212' 'DCR213' 'DCR214' 'DCR215' 'DCR217' ... 
    'DCR218' 'DCR219' 'DCR220' 'DCR221' 'DCR222' 'DCR223' 'DCR224' 'DCR225' 'S1' 'S1B' ... 
    'S4' 'S4B' 'S5' 'S5B' 'S6' 'S6B' 'S7' 'S7B' 'S8' 'S8B' 'S10' 'S10B' 'S11' 'S11B' 'S12' 'S12B' 'S13' 'S13-1' 'S13B' ...
    'S14' 'S14B' 'S15' 'S15B' 'S16' 'S16B' 'S17' 'S17B' 'S18' 'S18B' 'S20' 'S20B' 'S21' 'S21B' ...
    'S22' 'S22B' 'S23' 'S23B' 'S24' 'S24B' 'S25' 'S25B' 'S26' 'S26B' 'S27' 'S27B' 'S28' 'S28B' 'S29' 'S29B' ...
    'S30' 'S30B' 'S31' 'S31B' 'S34' 'S34B' 'S36' 'S36B' 'S37' 'S37B' 'S38' 'S38B' ...
    'S39' 'S39B' 'S40' 'S40B' 'PF001' 'PF001B' 'PF001C' 'PF002' 'PF002B' 'PF002C' 'PF003' 'PF003B' 'PF003C'...
    'PF004' 'PF004B' 'PF004C' 'PF005' 'PF005B' 'PF005C' 'PF006' 'PF006B' 'PF006C' 'PF007' 'PF007B' 'PF007C'...
    'PF008' 'PF008B' 'PF008C' 'PF009' 'PF009B' 'PF009C' 'PM002' 'PM002B' 'PM002C' 'PM003' 'PM003B' 'PM003C'...
    'PM004' 'PM004B' 'PM004C' 'PM006' 'PM006B' 'PM006C' 'PM007' 'PM007B' 'PM007C' 'PM008' 'PM008B' 'PM008C' ...
    'PM009' 'PM009B' 'PM009C' 'PM010' 'PM010B' 'PM010C' 'PM014' 'PM014B' 'PM014C' 'PM015' 'PM015B' 'PM015C'...
    'PM016' 'PM016B' 'PM016C' 'PM017' 'PM017B' 'PM017C'}); %artefact rejection list
%% IMPORT,REREFERENCE & FILTER DATA
for name_i = 22:length(names)
    % IMPORT

    cd([CWD,RAW]);
    cfg = [];
    cfg.datafile = [names(1,name_i).pnum,'.bdf'];
    cfg.continuous = 'yes';
    dat = [];
    hdr = ft_read_header(strcat(names(1,name_i).pnum,'.bdf'));
    if hdr.nChans > 80
       CHANNEL_SEP = [1:64,257:264];
       CHANNEL_SEP = reshape(CHANNEL_SEP,4,18)';
    else
       CHANNEL_SEP = 1:72;
       CHANNEL_SEP = reshape(CHANNEL_SEP,4,18)';
    end
    for channel_array_i = 1:size(CHANNEL_SEP,1)    
        cfg.channel = CHANNEL_SEP(channel_array_i,:);%[1:20];
        %cfg.precision = 'single';
        dat_temp = ft_preprocessing(cfg); 
        %DownsampleData:
        cfg_2 = [];
        cfg_2.detrend = 'yes';
        cfg_2.resamplefs = 512;
        dat_temp = ft_resampledata(cfg_2,dat_temp);
        if isempty(dat)
            dat = dat_temp;
            clear dat_temp
        else
            dat.label(length(dat.label)+1:length(dat.label)+length(cfg.channel)) = dat_temp.label;
            dat.trial{1,1}(length(dat.label)+1:length(dat.label)+length(cfg.channel),:) = dat_temp.trial{1,1};
            clear dat_temp;
        end
        fclose all;
    end
    clear channel_array_i CHANNEL_SEP cfg_2
%     cd([CWD,RAW]);
%     fprintf('----- Begin Pre-Processing [Resampling and Filtering]: %s ------\n',names(1,name_i).pnum);
%     cfg = [];
%     cfg.datafile = [names(1,name_i).pnum '.bdf'];
%     cfg.continuous = 'yes';
%     dat = ft_preprocessing(cfg);
    

    % REREFERENCE to common average
    fprintf('----- Applying Cz Reference: ------\n');
    cfg = [];
    cfg.reref = 'yes';
    cfg.refchannel = 48;%Cz
    refdat = ft_preprocessing(cfg,dat);
    fprintf('Rereferencing done!\n');
    clear dat % tidying up as we go
    
    % FILTER
    %       notch
    %cfg.bsfilter = 'yes';
    
    cfg = [];
    cfg.bsfreq = [49 51];
    cfg.hpfilter = 'yes';
    cfg.hpfreq = [0.02];
    cfg.hpfiltdir = 'onepass';
    cfg.hpfiltord = 1;
    cfg.hpfilttype = 'but';   
    fprintf(1,'---- Performing 50Hz Rejection\n');
    fprintf(1,'---- Performing HP Filtering: CutOff = %1.2fHz using %s filter\n',cfg.hpfreq,cfg.hpfilttype);
    data = ft_preprocessing(cfg,refdat);
    clear refdat %tidying
    cd([CWD,PREPROC_OUTPUT]);
    save([names(1,name_i).pnum,'_REFnFILT'],'data','-v7.3');
    clear data cfg %tidying
 end%names loop - IMPORT,REREFERENCE & FILTER DATA
%% INSPECTION OF DATA - MANUAL STEP
% Use this step to identify in each participant the quality of the raw
% data and to find any noisy electrodes
% 
% If noisy electrodes are found - use the next processing step to
% interpolate with neighbouring channels
% 
% NOTE: This is a manual step!
PartID = {'DCR216'}; % change this to load each new participant in.
fprintf('Working on: %s \n',PartID{1,1});
cd([CWD,PREPROC_OUTPUT]);
load([PartID{1,1},'_REFnFILT']);
cfg = [];
cfg.layout = 'biosemi64.lay';
cfg.continuous = 'yes';
cfg.channel = 1:64;
cfg.viewmode = 'vertical';
cfg.blocksize = 60; % 1 minute per screen
cfg = ft_databrowser(cfg,data); % look for bad channels
%% SELECT BAD CHANNELS - MANUALLY TYPE THESE IN

badchann = {'C4', 'Fz', 'AF8', 'AFz', 'Fp1', 'AF3', 'P7', 'F8', 'AF7', 'F6', 'F2', 'P8'}; %fill in any bad channels - leave blank if data 
%                          is clean
fprintf('%s %s %s','For participant ',PartID{1,1},'the following channels were deemed BAD: ');
for bc_i = 1:length(badchann)
    fprintf('%s  ',badchann{1,bc_i});
end
fprintf('\n');
clear bc_i data cfg %tidying
save([PartID{1,1},'_badchannellist'],'badchann');

%% REMOVE BAD CHANNELS FROM DATA STRUCTURE - WILL REINCLUDE AFTER CSD

cd([CWD,PREPROC_OUTPUT]);
for name_i = 1:length(names)
    
   fprintf('Loading: %s%s \n',names(1,name_i).pnum,'''s common average referenced data. . .');
   load([names(1,name_i).pnum,'_REFnFILT']); %referenced data
   fprintf('Loading: %s%s \n',names(1,name_i).pnum,'''s bad channel list. . .');
   load([names(1,name_i).pnum,'_badchannellist']);%badchannel list
    
   %Generate a new strucute without the bad channels:
   
   time = data.time;
   label = cell((length(data.label)-length(badchann)),1);
   trial = cell(1,1);
   trial{1,1} = zeros((length(data.label)-length(badchann)),size(data.trial{1,1},2));
    mon_bad = 1;
    count = 1;
    for index_i = 1:(length(data.label))
    %Condition: Do not check for bad channels in list,as all have been
    %found
    if mon_bad > length(badchann)
        if index_i <= length(data.label)
            label(count,1)   = data.label(index_i,1);
            trial{1,1}(count,:) = data.trial{1,1}(index_i,:);
            count = count+1;
        end
        continue;
    end
    %fprintf('Comparing %s with %s \n', M.lab{mon_i,1}, badchann{1,mon_bad});
    %look for bad channels and append to new structure.
    if strcmp(data.label{index_i,1},badchann{1,mon_bad})
        mon_bad = mon_bad+1;
        continue;
    else
        label(count,1)   = data.label(index_i,1);
        trial{1,1}(count,:) = data.trial{1,1}(index_i,:);
        count = count+1;
    end
    end
    
   cfg = data.cfg;
   data_2 = struct('hdr',data.hdr,'fsample',data.fsample,'sampleinfo',data.sampleinfo,'trial',{trial},'time',{time},'cfg',cfg,'label',{label});
   clear data;
   data = data_2;
   clear data_2
   save([names(1,name_i).pnum,'_BadChannRemoved'],'data','-v7.3');
   %
   
end
%% INTERPOLATE NOISY ELECTRODES
% % This step uses the badchann structure from the previous step to
% % interpolate those elctrodes deemed to be noisy
% cd([CWD,PREPROC_OUTPUT]);
% for name_i = 1:length(names)
%     fprintf('Loading: %s%s \n',names(1,name_i).pnum,'''s common average referenced data. . .');
%     load([names(1,name_i).pnum,'_REFnFILT']); %referenced data
%     fprintf('Loading: %s%s \n',names(1,name_i).pnum,'''s bad channel list. . .');
%     load([names(1,name_i).pnum,'_badchannellist']);%badchannel list
%     fprintf('Preparing electrode neighbourhood. . . ');
%     cfg = [];
%     fprintf('. ');
%     cfg.method = 'triangulation';
%     fprintf('. ');
%     cfg.layout = 'biosemi64.lay';
%     fprintf('. \n');
%     neighbours = ft_prepare_neighbours(cfg, data);
%     fprintf('Selecting bad channels from prepared list. . . \n');
%     channel = ft_channelselection(badchann,data.cfg.channel);
%     fprintf('Channel selection complete! \n');
%     % repair bad channels
%     fprintf('Repairing bad channels. . .');
%     cfg.method = 'nearest';
%     fprintf('. ');
%     cfg.badchannel = badchann; % cell-array of channels from channel
%     fprintf('. ');
%     cfg.missingchannel = []; % can be the same
%     fprintf('. ');
%     cfg.neighbours = neighbours;
%     fprintf('. ');
%     cfg.trials = 'all';
%     fprintf('. ');
%     temp = data;
%     fprintf('. \n');
%     interp = ft_channelrepair(cfg, temp);
%     data = interp;
%     % Check if data is clean
%     % if it isn't you will need to rerun early stages
%     % if it is clean, data will be saved
% %     cfg = [];
% %     cfg.channel = 1:64;
% %     cfg.viewmode = 'vertical';
% %     cfg = ft_databrowser(cfg,data); % confirmation step below:
% %                                     requires user to press Y or N as
% %                                     a judgement call on the data quality
% fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s repaired data. . .');
% save([names(1,name_i).pnum,'_REPAIRED'],'data','-v7.3');
% fprintf('Data saved\n');
% clear channel badchann data interp lay neighbours w key temp %tidying
% end
% %     fprintf('If data is clean press ''Y'', else press ''N''\n');
% %     [~,~,key] = ginput(1);
% %     if key == 'y';
% %              fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s repaired data. . .');
% %              save([names(1,name_i).pnum,'_REPAIRED'],'data','-v7.3');
% %              fprintf('Data saved\n');
% %              close all
% %     elseif key == 'n';
% %         close all
% %         error('Channel repair failed. Re-run from early stage');
% %     end
% %     clear channel badchann data interp lay neighbours w key temp %tidying
% % end%names loop - INTERPOLATE NOISY ELECTRODES    
%% TRIAL DEFINITION & ICA
for name_i = 1:length(names)
    cd([CWD,PREPROC_OUTPUT]);
    load([names(1,name_i).pnum,'_BadChannRemoved']);
    cd([CWD,RAW]);
    cfg=[];
    cfg.hdr                   = ft_read_header(strcat(names(1,name_i).pnum,'.bdf'));
    cfg.event                 = ft_read_event(strcat(names(1,name_i).pnum,'.bdf'));
    cfg.trialfun              = 'tDCS';
    cfg.trialdef.pre          = 1; % latency in seconds
    cfg.trialdef.post         = 4;   % latency in seconds
    cfg.filename_original     = [names(1,name_i).pnum,'.bdf'];
    [trl] = ft_trialfun_Conflict(cfg,name_i); % for data recorded on new biosemi - else use normal function
    cfg.trl = trl;
    for trl_i = 1:length(cfg.trl)
        if cfg.hdr.Fs ~= data.fsample
            cfg.trl(trl_i,1) = round(cfg.trl(trl_i,1)/(cfg.hdr.Fs/data.fsample));
            cfg.trl(trl_i,2) = round(cfg.trl(trl_i,2)/(cfg.hdr.Fs/data.fsample));
            cfg.trl(trl_i,3) = round(cfg.trl(trl_i,3)/(cfg.hdr.Fs/data.fsample));
        end
    end
    trdat = ft_redefinetrial(cfg,data);
    trdat.trialinfo = trdat.trialinfo(:,1);
    clear data tdat%tidying
    cd([CWD,PREPROC_OUTPUT]);
    fprintf('%s %s %s \n','----- Begin ICA -----','Participant:',names(1,name_i).pnum);
    cfg = [];
    cfg.channel = 1:length(trdat.label);%include externals
    cfg.method = 'fastica';
    ic_data = ft_componentanalysis(cfg,trdat);
    clear dat %tidying
    fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s ICA data. . .');
    save([names(1,name_i).pnum,'_ICADATA'],'ic_data','-v7.3');
    fprintf('Save successful!\n');
    clear ic_data %tidying
end
%% REMOVE EOG COMPONENTS FROM ICA
%  note this a manual step
cd([CWD,PREPROC_OUTPUT]);
PartID = {'S40B'}; % change this to load each new participant in
load([PartID{1,1},'_ICADATA']);
cfg = [];
cfg.layout = 'biosemi64.lay';
cfg.viewmode = 'component';
ft_databrowser(cfg, ic_data)
%% REMOVE ICA COMPONENT RELATED TO EOG
cfg.component = [14, 50, 42]; % note the exact numbers will vary per run
eogcorr = ft_rejectcomponent(cfg, ic_data);
clear ic_data %tidying
fprintf('View data to see if ICA has worked\n');
 cfg          = [];
 cfg.channel  = 1:64;
 cfg.viewmode = 'vertical';
 cfg.ylim     = [-100 100]; 
 cfg = ft_databrowser(cfg, eogcorr);
fprintf('If data is clean press ''Y'', else press ''N''\n');
[~,~,key] = ginput(1);
if key == 'y';
    fprintf('Saving: %s%s \n',PartID{1,1},'''s blink corrected data. . .');
    save([PartID{1,1},'_EOGCORRECTED'],'eogcorr','-v7.3')
    fprintf('Data saved\n');
    close all
elseif key == 'n';
    close all
    error('EOG correction was not satisfactory. Re-run from early stage');
end
clear key eogcorr ans cfg PartID%tidying
%% Automatic Artifact Rejection
cd([CWD,PREPROC_OUTPUT]);
for name_i = 1:length(names)
    load([names(1,name_i).pnum,'_EOGCORRECTED.mat']);
    %automatic artifact rejection (standard approach)
    cfg = [];
    cfg.lpfilter = 'yes';
    cfg.lpfreq = [30];   
    cfg.lpfilttype = 'but';
    cfg.lpfiltord = 4;
    fprintf(1,'---- Performing LP Filtering: CuttOff = %1.1fHz\n',cfg.lpfreq);
    eogcorr = ft_preprocessing(cfg,eogcorr);
    cfg                               = [];
    cfg.artfctdef.threshold.channel   = 1:(length(eogcorr.label)-8);%don't include externals
    cfg.artfctdef.threshold.min       = -150;
    cfg.artfctdef.threshold.max       = 150;
    cfg.trl = eogcorr.cfg.previous.previous.previous.trl;
    cfg.bpfilter = 'no';
    cfg.artfctdef.bpfilter = 'no';
    cfg.artfctdef.threshold.bpfilter  = 'no';
    cfg.artfctdef.feedback = 'yes';
    %[cfg, artifact, art_ind] = ft_artifact_threshold(cfg, eogcorr);
    [cfg, artifact] = ft_artifact_threshold(cfg, eogcorr);
    nt  = (length(cfg.trl) - length(artifact));
    npt = (nt/length(cfg.trl)*100);
    fileid = fopen('TrialProcessingLog.txt','a');
    fprintf(fileid,'%s\t%i\t%3.1f',names(1,name_i).pnum,nt,npt);
    fprintf(fileid,'\r\n');
    fclose(fileid);
    [artrej] = ft_rejectartifact(cfg,eogcorr);
    clear eogcorr artifact nt npt ans
    % automatic artifact rejection based on z-values
    
%     cfg = [];
%     cfg.trl = artrej.cfg.trl;
%     cfg.continuous = 'yes';
%     cfg.artfctdef.zvalue.channel = 1:(length(artrej.label)-9);% subtract (status+external channels = 9)
%     cfg.artfctdef.zvalue.cutoff = 4;
%     cfg.feedback = 'yes'; 
%     cfg.artfctdef.zvalue.interactive = 'yes'   
%     cfg.artfctdef.zvalue.cumulative = 'no';
%     [cfg, artifact] = ft_artifact_zvalue(cfg,artrej);
    
%    [artrej] = ft_rejectartifact(cfg,artrej);
%     nt  = (length(cfg.trl) - length(artifact));
%     npt = (nt/length(cfg.trl)*100);
%     fileid = fopen('TrialProcessingLog.txt','a');
%     fprintf(fileid,'%s\t%i\t%3.1f',names(1,name_i).pnum,nt,npt);
%     fprintf(fileid,'\r\n');
%     fclose(fileid);
     close all
    data = artrej;
    save([names(1,name_i).pnum,'_ARTFREEDATA'],'data','-v7.3');  
    clear artrej eogcorr artifact cfg data %tidying
end
%% Scalp Current Density:
cd([CWD,PREPROC_OUTPUT]);
addpath(genpath([CWD,'\FUNCTIONS\CSDtoolbox']));


% load('CSD_Matrices_september');
cd([CWD,PREPROC_OUTPUT]);
    for name_i = 1:length(names);
        [M] = genMontage(CWD,PREPROC_OUTPUT,names,name_i);
        [G,H] = GetGH(M);
        load(strcat(names(1,name_i).pnum,'_ARTFREEDATA'));
        tic;
    %Extract artrej.trial
        for j = 1:size(data.trial,2)
        D = data.trial{1,j}(1:(length(M.lab)),:);
        X = CSD(D,G,H);
        X = single(X);
        data.trial{1,j}(1:(length(M.lab)),:) = X(:,:);
        end
        toc
    save(strcat(names(1,name_i).pnum,'_CSDDATA'), 'data','-v7.3');
    clear D X data j
    end
%% REINTERPOLTATE NOISY CHANNELS
cd([CWD,PREPROC_OUTPUT]);
for name_i = 1:length(names)
    fprintf('Loading: %s%s \n',names(1,name_i).pnum,'''s common average referenced data. . .');
    load([names(1,name_i).pnum,'_CSDDATA']); %CSD data
    fprintf('Loading: %s%s \n',names(1,name_i).pnum,'''s bad channel list. . .');
    load([names(1,name_i).pnum,'_badchannellist']);%badchannel list
    %Generating Full Array:
    
    %load original montage - Labels
    load('original_labels.mat');
    label = labels(1:64,1);
    
    %get new structure:
    time = data.time;
    
    trial = cell(1,size(data.trial,2));
    for i = 1:size(data.trial,2)
        trial{1,i} = zeros((length(label)),size(data.trial{1,1},2));
        %copy if labels match
        for index_i = 1:length(data.label)  % redduced label
            for j = 1:length(label)         % 64 Full Label
                if strcmp(data.label{index_i,1},label{j,1})
                    %fprintf('Data size: INDICES: %i,%i \t %i,%i',i,j, size(data.trial{1,1}(1,:),1), size(trial{1,i}(j,:),2))
                    trial{1,i}(j,:) = data.trial{1,i}(index_i,:); 
                    break;
                end
            end
        end
    end
    
    cfg = data.cfg;
    data_2 = struct('hdr',data.hdr,'fsample',data.fsample,'sampleinfo',data.sampleinfo,'trial',{trial},'time',{time},'cfg',cfg,'label',{label});
    clear data;
    data = data_2;
    clear data_2 trial time j i 
   
    fprintf('Preparing electrode neighbourhood. . . ');
    cfg = [];
    fprintf('. ');
    cfg.method = 'triangulation';
    fprintf('. ');
    cfg.layout = 'biosemi64.lay';
    fprintf('. \n');
    neighbours = ft_prepare_neighbours(cfg, data);
    fprintf('Selecting bad channels from prepared list. . . \n');
    channel = ft_channelselection(badchann,data.label);
    fprintf('Channel selection complete! \n');
    % repair bad channels
    fprintf('Repairing bad channels. . .');
    cfg.method = 'nearest';
    fprintf('. ');
    cfg.badchannel = badchann; % cell-array of channels from channel
    fprintf('. ');
    cfg.missingchannel = []; % can be the same
    fprintf('. ');
    cfg.neighbours = neighbours;
    fprintf('. ');
    cfg.trials = 'all';
    fprintf('. ');
    temp = data;
    fprintf('. \n');
    interp = ft_channelrepair(cfg, temp);
    refdat = interp;
    % REDO COMMON AVERAGE REFERENCE AFTER CHANNEL INTERPOLATION
%     fprintf('----- Re-Applying Common Average Reference: ------\n');
%     cfg = [];
%     cfg.reref = 'yes';
%     cfg.refchannel = 1:64;
%     refdat = ft_preprocessing(cfg,data);
%     fprintf('Rereferencing done!\n');
%     fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s repaired and rereferenced data. . .');
    save([names(1,name_i).pnum,'_REPAIRED_AND_REFERENCED'],'refdat','-v7.3');
    clear data channel badchann data interp lay neighbours w temp% tidying
end
%% CONVERT FROM FIELDTRIP TO EEG STRUCT
SaveoffIndividalConditions
%%
cd([CWD,PREPROC_OUTPUT]);
EEGLAB_DATA_FOLDER = 'EEGLAB_FORMAT';
cd (CWD);
mkdir(EEGLAB_DATA_FOLDER);
conditions = {'dirleft','dirright','nondirleft','nondirright'};
cond       = {'dl','dr','nl','nr'};
datname    = struct('nams',{'dldata','drdata','nldata','nrdata'});
for name_i = 1:length(names)
    
    cd ([CWD,'\',EEGLAB_DATA_FOLDER]);
    foldername_name = [names(1,name_i).pnum];
    mkdir(foldername_name);
    
    for cond_i = 1:length(conditions)
        cd ([CWD,PREPROC_OUTPUT]);
        filename = strcat(names(1,name_i).pnum,'_CSD_',conditions(1,cond_i),'.mat');
        load(filename{1,1});
        %Set Up new Directories:
        cd ([CWD,'\',EEGLAB_DATA_FOLDER ,'\',foldername_name]);
        foldercondition_name = [conditions{cond_i}];
        mkdir(foldercondition_name);
        cd (foldercondition_name);
        proc_string = ['data = ', datname(cond_i).nams, ';'];
        eval(proc_string);
        EEG = convert_ft2eeg_ch(data);
        %savename = strcat(names(1,name_i).pnum,'_',conditions(1,cond_i),'.mat');
        %fprintf('%s \t%s \t%s\n',filename{1,1},proc_string,savename{1,1});
        %save(savename{1,1},'data');
        %save(savename{1,1},'EEG');
        clear EEG savename filename ans data
    end
end


%% END
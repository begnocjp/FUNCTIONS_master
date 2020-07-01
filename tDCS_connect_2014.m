% Processing job for tDCS Connectivity Datasets
% Adapted from 'AGEILITY_connjob_2013' job written by Patrick Cooper
% Adapted by Alexander Conley, January 2014.

% Set up Global Variables
clear all
warning off;
% add path for fieldtrip
addpath(genpath('C:\Users\c3075693.UNCLE\Documents\fieldtrip\')); 
% current working directory
CWD = 'E:\fieldtrip';
% addpath for custom ft_functions
addpath([CWD,'\FUNCTIONS']);
% raw data directory
RAW = '\RAW';
% preprocessing intermediate steps
PREPROC_OUTPUT = '\PREPROC_OUTPUT';
% List of participants
                  
names = struct('pnum',{ 'DCR102' 'DCR103' 'DCR104' 'DCR105' 'DCR106' 'DCR107' 'DCR108' 'DCR109' 'DCR110' 'DCR111' ... 
    'DCR112' 'DCR113' 'DCR114' 'DCR115' 'DCR116' 'DCR117' 'DCR118' 'DCR119' 'DCR120' 'DCR121' ...
    'DCR122' 'DCR123' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR204' 'DCR205' 'DCR206' 'DCR207' ... 
    'DCR208' 'DCR209' 'DCR210' 'DCR211' 'DCR212' 'DCR213' 'DCR214' 'DCR215' 'DCR216' 'DCR217' ... 
    'DCR218' 'DCR219' 'DCR220' 'DCR221' 'DCR222' 'DCR223' 'DCR224' 'DCR225' 'S1' 'S1B' 'S3' 'S3B'... 
    'S4' 'S4B' 'S5' 'S5B' 'S6' 'S6B' 'S7' 'S7B' 'S8' 'S8B' 'S10' 'S10B' 'S11' 'S11B' 'S12' 'S12B' 'S13' 'S13-1' 'S13B' ...
    'S14' 'S14B' 'S15' 'S15B' 'S16' 'S16B' 'S17' 'S17B' 'S18' 'S18B' 'S19' 'S19B' 'S20' 'S20B' 'S21' 'S21B' ...
    'S22' 'S22B' 'S23' 'S23B' 'S24' 'S24B' 'S25' 'S25B' 'S26' 'S26B' 'S27' 'S27B' 'S28' 'S28B' 'S29' 'S29B' ...
    'S30' 'S30B' 'S31' 'S31B' 'S32' 'S32B' 'S33' 'S33B' 'S34' 'S34B' 'S36' 'S36B' 'S37' 'S37B' 'S38' 'S38B' ...
    'S39' 'S39B' 'S40' 'S40B'}); %artefact rejection list
%% IMPORT,REREFERENCE & FILTER DATA
for name_i = 1:length(names)
    % IMPORT
    
    cfg = [];
    cfg.datafile = [DATADIR,names(1,name_i).pnum,'.bdf'];
    cfg.continuous = 'yes';
    cfg.channel = [1:20];
    %cfg.precision = 'single';
    dat1 = ft_preprocessing(cfg);

    % Down Sample Data:
    cfg = [];
    cfg.detrend    = 'yes';
    cfg.resamplefs = 512;
    [dat1] = ft_resampledata(cfg, dat1);


    cfg = [];
    cfg.datafile = [DATADIR,names(1,name_i).pnum,'.bdf'];
    cfg.continuous = 'yes';
    cfg.channel = [21:40];
    %cfg.precision = 'single';
    dat2 = ft_preprocessing(cfg);

    % Down Sample Data:
    cfg = [];
    cfg.detrend    = 'yes';
    cfg.resamplefs = 512;
    [dat2] = ft_resampledata(cfg, dat2);

    cfg = [];
    cfg.datafile = [DATADIR,names(1,name_i).pnum,'.bdf'];
    cfg.continuous = 'yes';
    cfg.channel = [41:60];
    %cfg.precision = 'single';
    dat3 = ft_preprocessing(cfg);

    % Down Sample Data:
    cfg = [];
    cfg.detrend    = 'yes';
    cfg.resamplefs = 512;
    [dat3] = ft_resampledata(cfg, dat3);



    cfg = [];
    cfg.datafile = [DATADIR,names(1,name_i).pnum,'.bdf'];
    cfg.continuous = 'yes';
    cfg.channel = [61:72];
    %cfg.precision = 'single';
    dat4 = ft_preprocessing(cfg);

    % Down Sample Data:
    cfg = [];
    cfg.detrend    = 'yes';
    cfg.resamplefs = 512;
    [dat4] = ft_resampledata(cfg, dat4);


    % Recombine Data:
    dat = dat1;
    dat.label = [dat.label;dat2.label;dat3.label;dat4.label];
    dat.trial{1,1} = [dat.trial{1,1};dat2.trial{1,1};dat3.trial{1,1};dat4.trial{1,1}];
    clear dat1 dat2 dat3 dat4
    
    cd([CWD,RAW]);
    fprintf('----- Begin Pre-Processing [Resampling and Filtering]: %s ------\n',names(1,name_i).pnum);
    cfg = [];
    cfg.datafile = [names(1,name_i).pnum '.bdf'];
    cfg.continuous = 'yes';
    dat = ft_preprocessing(cfg);
    
    if dat.hdr.nChans > 80
       dat.hdr.nChans = 73;
       dat.hdr.label = [dat.hdr.label(1:64,1);dat.hdr.label(257:265,1)];
       dat.label = dat.hdr.label;
       dat.trial{1,1} = [dat.trial{1,1}([1:64],:);dat.trial{1,1}([257:265],:)];
    end
    % REREFERENCE to common average
    fprintf('----- Applying Common Average Reference: ------\n');
    cfg = [];
    cfg.reref = 'yes';
    cfg.refchannel = 1:64;
    refdat = ft_preprocessing(cfg,dat);
    fprintf('Rereferencing done!\n');
    clear dat % tidying up as we go
    cfg = [];
    % FILTER
    %       notch
    cfg.bsfilter = 'yes';
    cfg.bsfreq = [49 51];
    %       high pass
    cfg.hpfilter = 'yes';
    cfg.hpfreq = [0.1];
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
PartID = {'S4B'}; % change this to load each new participant in.
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

badchann = {'C5-1', 'T7', 'C6-1', 'T8'}; %fill in any bad channels - leave blank if data 
%                          is clean
fprintf('%s %s %s','For participant ',PartID{1,1},'the following channels were deemed BAD: ');
for bc_i = 1:length(badchann)
    fprintf('%s  ',badchann{1,bc_i});
end
fprintf('\n');
clear bc_i data cfg %tidying
save([PartID{1,1},'_badchannellist'],'badchann');
%% INTERPOLATE NOISY ELECTRODES
% This step uses the badchann structure from the previous step to
% interpolate those elctrodes deemed to be noisy
cd([CWD,PREPROC_OUTPUT]);
for name_i = 1:length(names)
    fprintf('Loading: %s%s \n',names(1,name_i).pnum,'''s common average referenced data. . .');
    load([names(1,name_i).pnum,'_REFnFILT']); %referenced data
    fprintf('Loading: %s%s \n',names(1,name_i).pnum,'''s bad channel list. . .');
    load([names(1,name_i).pnum,'_badchannellist']);%badchannel list
    fprintf('Preparing electrode neighbourhood. . . ');
    cfg = [];
    fprintf('. ');
    cfg.method = 'triangulation';
    fprintf('. ');
    cfg.layout = 'biosemi64.lay';
    fprintf('. \n');
    neighbours = ft_prepare_neighbours(cfg, data);
    fprintf('Selecting bad channels from prepared list. . . \n');
    channel = ft_channelselection(badchann,data.cfg.channel);
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
    data = interp;
    % Check if data is clean
    % if it isn't you will need to rerun early stages
    % if it is clean, data will be saved
%     cfg = [];
%     cfg.channel = 1:64;
%     cfg.viewmode = 'vertical';
%     cfg = ft_databrowser(cfg,data); % confirmation step below:
%                                     requires user to press Y or N as
%                                     a judgement call on the data quality
fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s repaired data. . .');
save([names(1,name_i).pnum,'_REPAIRED'],'data','-v7.3');
fprintf('Data saved\n');
clear channel badchann data interp lay neighbours w key temp %tidying
end
%     fprintf('If data is clean press ''Y'', else press ''N''\n');
%     [~,~,key] = ginput(1);
%     if key == 'y';
%              fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s repaired data. . .');
%              save([names(1,name_i).pnum,'_REPAIRED'],'data','-v7.3');
%              fprintf('Data saved\n');
%              close all
%     elseif key == 'n';
%         close all
%         error('Channel repair failed. Re-run from early stage');
%     end
%     clear channel badchann data interp lay neighbours w key temp %tidying
% end%names loop - INTERPOLATE NOISY ELECTRODES    
%% TRIAL DEFINITION & ICA
for name_i = 1:length(names)
    cd([CWD,PREPROC_OUTPUT]);
    load([names(1,name_i).pnum,'_REPAIRED']);
    cd([CWD,RAW]);
    cfg=[];
    cfg.hdr                   = ft_read_header(strcat(names(1,name_i).pnum,'.bdf'));
    cfg.event                 = ft_read_event(strcat(names(1,name_i).pnum,'.bdf'));
    cfg.trialfun              = 'tDCS';
    cfg.trialdef.pre          = 1; % latency in seconds
    cfg.trialdef.post         = 4;   % latency in seconds
    cfg.filename_original     = [names(1,name_i).pnum,'.bdf'];
    [trl] = ft_trialfun_Conflict(cfg,name_i); % for data recorded on new biosemi - else use normal function
%     tdat = ft_definetrial(cfg);
    cfg.trl = trl;
    trdat = ft_redefinetrial(cfg,data);
    clear data tdat%tidying
    cd([CWD,PREPROC_OUTPUT]);
%     fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s epoched data. . .');
%     save([names(1,name_i).pnum,'_EPOCHED'],'trdat','-v7.3');
%     fprintf('Save successful!\n');
    
    fprintf('Remove noisy trials\n    USE VAR - REMOVE OUTLIERS\n    USE MAXABS - IF GREATER THAN 1000 REMOVE\n    USE ZVALUE - REMOVE GREATER THAN 4\n');
    cfg = [];
    cfg.method = 'summary';
    dat = ft_rejectvisual(cfg, trdat);
    clear trdat
    fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s epoched data. . .');
    save([names(1,name_i).pnum,'_EPOCHED'],'dat','-v7.3');
    fprintf('Save successful!\n');
    clear dat
end
%% 
for name_i = 1:length(names) % change back to 1:length(names)
    fprintf('Loading: %s%s \n',names(1,name_i).pnum,'''s epoched data. . .');
    cd([CWD,PREPROC_OUTPUT]);
    load([names(1,name_i).pnum,'_EPOCHED']);
    for j = 1:length(dat.trial)
        dat.trial{1,j} = single(dat.trial{1,j});
    end;
    fprintf('Beginning ICA for %s%s \n',names(1,name_i).pnum,'    NOTE THIS TAKES AGES!');
    cfg = [];
    cfg.channel = 1:64;
    cfg.method = 'fastica';
%     cfg.numcomponent = 10;
%     cfg.fastica.epsilon = 0.01;
%     cfg.fastica.lastEig = 10;
%     cfg.fastica.maxNumIterations = 50;
    ic_data = ft_componentanalysis(cfg,dat);
    clear dat %tidying
    fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s ICA data. . .');
    save([names(1,name_i).pnum,'_ICADATA'],'ic_data','-v7.3');
    fprintf('Save successful!\n');
    clear ic_data %tidying
end
%% REMOVE EOG COMPONENTS FROM ICA
%  note this a manual step
cd([CWD,PREPROC_OUTPUT]);
PartID = {'S4B'}; % change this to load each new participant in
load([PartID{1,1},'_ICADATA']);
cfg = [];
cfg.layout = 'biosemi64.lay';
cfg.viewmode = 'component';
ft_databrowser(cfg, ic_data)
%% REMOVE ICA COMPONENT RELATED TO EOG
cfg.component = [22]; % note the exact numbers will vary per run
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
for name_i = 83:length(names)
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
    cfg.artfctdef.threshold.channel   = 1:64;
    cfg.artfctdef.threshold.min       = -125;
    cfg.artfctdef.threshold.max       = 125;
    cfg.trl = eogcorr.cfg.previous.previous.previous.previous.trl;
    cfg.bpfilter = 'no';
    cfg.artfctdef.bpfilter = 'no';
    cfg.artfctdef.threshold.bpfilter  = 'no';
    cfg.artfctdef.feedback = 'yes';
    [cfg, artifact, art_ind] = ft_artifact_threshold(cfg, eogcorr);
    nt  = (length(cfg.trl) - length(artifact));
    npt = (nt/length(cfg.trl)*100);
    fileid = fopen('TrialProcessingLog.txt','a');
    fprintf(fileid,'%s\t%i\t%3.1f',names(1,name_i).pnum,nt,npt);
    fprintf(fileid,'\r\n');
    fclose(fileid);
    [artrej, rej_ind] = ft_rejectartifact(cfg,eogcorr);
    close all
    fprintf('Final visual inspection of data\n');
    cfg = [];
    cfg.method = 'summary';
    data = ft_rejectvisual(cfg, artrej);
    save([names(1,name_i).pnum,'_ARTFREEDATA'],'data','-v7.3');  
    clear artrej eogcorr artifact cfg data %tidying
end
%% Scalp Current Density:
cd([CWD,PREPROC_OUTPUT]);
    load('CSD_Matrices_september');
    for name_i = 1:length(names);
        load(strcat(names(1,name_i).pnum,'_ARTFREEDATA'));
        tic;

    %Extract artrej.trial
        for j = 1:size(data.trial,2)
        D = data.trial{1,j}(1:64,:);
        X = CSD(D,G,H);
        X = single(X);
        data.trial{1,j}(1:64,:) = X(:,:);
        end

        toc
    save(strcat(names(1,name_i).pnum,'_CSDDATA'), 'data','-v7.3');
    clear D X data j
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
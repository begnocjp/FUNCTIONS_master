% Processing job for Age-ility Connectivity Datasets
% Adapted from 'p122_B2' job written by Alex Provost
% Adapted by Patrick Cooper and Aaron Wong, October 2013 - April 2014.

% Set up Global Variables
close all
clear all
warning off;
% add path for fieldtrip
addpath(genpath('C:\Users\c3075693\Documents\fieldtrip\')); 
% current working directory
CWD = 'E:\fieldtrip\DOWNSAMPLE';
% addpath for custom ft_functions
addpath([CWD,'\FUNCTIONS']);
% raw data directory
RAW = '\RAW';
% preprocessing intermediate steps
PREPROC_OUTPUT = '\PREPROC_OUTPUT';
% List of participants
% names = struct('pnum',{ 'AGE001' 'AGE002' 'AGE003' 'AGE005' 'AGE007' ...
%                         'AGE008' 'AGE012' 'AGE013' 'AGE014' 'AGE015' ...
%                         'AGE017' 'AGE018' 'AGE019' 'AGE020' 'AGE021' ...
%                         'AGE022' 'AGE023' ...
%                         'AGE024' 'AGE026' 'AGE027' 'AGE028' 'AGE030' ...
%                         'AGE032' 'AGE033' 'AGE035' 'AGE036' 'AGE038' ...
%                         'AGE042' 'AGE046' 'AGE047' 'AGE050' 'AGE051' ...
%                         'AGE052' 'AGE058'}); %participant list
                    
% names = struct('pnum',{ 'AGE001' 'AGE002' 'AGE003' 'AGE005' ...
%                         'AGE008' 'AGE012' 'AGE013' 'AGE014' 'AGE015' ...
%                         'AGE017' 'AGE018' 'AGE019' 'AGE020' 'AGE021' ...
%                         'AGE022' 'AGE023' ...
%                         'AGE024' 'AGE026' 'AGE027' 'AGE028' 'AGE030' ...
%                         'AGE032' 'AGE033' 'AGE035' 'AGE036' 'AGE038' ...
%                         'AGE046' 'AGE047' 'AGE050' 'AGE051' ...
%                         'AGE052' 'AGE058'}); %ICA participant list
                    
names = struct('pnum',{ 'AGE002' 'AGE003' ...
                        'AGE008' 'AGE012' 'AGE013' 'AGE014' 'AGE015' ...
                        'AGE017' 'AGE018' 'AGE019' 'AGE021' ...
                        'AGE022' 'AGE023' ...
                        'AGE024' 'AGE026' 'AGE027' 'AGE028' 'AGE030' ...
                        'AGE032' 'AGE033' 'AGE035' 'AGE036' 'AGE038' ...
                        'AGE046' 'AGE047' 'AGE050' 'AGE051' ...
                        'AGE052' 'AGE058'}); %artefact rejection list
%% IMPORT,REREFERENCE & FILTER DATA
for name_i = 1:length(names)
    % IMPORT
    cd([CWD,RAW]);
    fprintf('----- Begin Pre-Processing [Resampling and Filtering]: %s ------\n',names(1,name_i).pnum);
    cfg = [];
    cfg.datafile = [names(1,name_i).pnum '_TSWT.bdf'];
    cfg.continuous = 'yes';
    dat = ft_preprocessing(cfg);
    % DOWNSAMPLE
    % ADDED BY PATRICK 27/03/2014
    % data
    dat.trial{1,1} = ft_preproc_resample(cell2mat(dat.trial(1,1)), dat.fsample, 512, 'resample');
    %times
    dat.time{1,1} = ft_preproc_resample(cell2mat(dat.time(1,1)), dat.fsample, 512, 'resample');
    dat.fsample = 512;
    dat.sampleinfo = [1 length(dat.trial{1,1})];
    % REREFERENCE to common average
    fprintf('----- Applying Common Average Reference: ------\n');
    cfg = [];
    cfg.reref = 'yes';
    cfg.refchannel = 48;%Cz
    %cfg.precision = 'single';
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
    mkdir([CWD,PREPROC_OUTPUT])
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
PartID = {'AGE012'}; % change this to load each new participant in.
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
badchann = {'Fp1','AF7','AF8','T8','F8','Iz'}; %fill in any bad channels - leave blank if data is clean
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
%     % REDO COMMON AVERAGE REFERENCE AFTER CHANNEL INTERPOLATION
%     fprintf('----- Re-Applying Common Average Reference: ------\n');
%     cfg = [];
%     cfg.reref = 'yes';
%     cfg.refchannel = 1:64;
%     refdat = ft_preprocessing(cfg,data);
%     fprintf('Rereferencing done!\n');
%     fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s repaired and rereferenced data. . .');
%     save([names(1,name_i).pnum,'_REPAIRED_AND_REFERENCED'],'refdat','-v7.3');
%     clear data channel badchann data interp lay neighbours w temp% tidying
% end%name_i loop
%% TRIAL DEFINITION & ICA
for name_i = 1:length(names)
    fprintf('%s %s %s \n','----- Begin Trial Definition -----','Participant:',names(1,name_i).pnum);
    cd([CWD,PREPROC_OUTPUT]);
    load([names(1,name_i).pnum,'_BadChannRemoved']);
    cd([CWD,RAW]);
    cfg=[];
    cfg.hdr                   = ft_read_header(strcat(names(1,name_i).pnum,'_TSWT.bdf'));
    cfg.event                 = ft_read_event(strcat(names(1,name_i).pnum,'_TSWT.bdf'));
    cfg.trialfun              = 'Agility';
    cfg.trialdef.pre          = 1; % latency in seconds
    cfg.trialdef.post         = 3.5;   % latency in seconds
    cfg.filename_original     = [names(1,name_i).pnum,'_TSWT.bdf'];
    [trl] = ft_trialfun_Agility(cfg,name_i); % for data recorded on new biosemi - else use normal function
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
PartID = {'AGE002'}; % change this to load each new participant in
load([PartID{1,1},'_ICADATA']);
cfg = [];
cfg.layout = 'biosemi64.lay';
cfg.viewmode = 'component';
ft_databrowser(cfg, ic_data)
cfg.component = [15]; % note the exact numbers will vary per run
eogcorr = ft_rejectcomponent(cfg, ic_data);
clear ic_data %tidying
fprintf('Saving: %s%s \n',PartID{1,1},'''s blink corrected data. . .');
save([PartID{1,1},'_EOGCORRECTED'],'eogcorr','-v7.3')
fprintf('Data saved\n');
close all
clear eogcorr cfg PartID%tidying
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
    cfg.artfctdef.threshold.min       = -100;
    cfg.artfctdef.threshold.max       = 100;
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
%     close all
    data = artrej;
    save([names(1,name_i).pnum,'_ARTFREEDATA'],'data','-v7.3');  
    clear artrej eogcorr artifact cfg data %tidying
end
%% Scalp Current Density:
cd([CWD,PREPROC_OUTPUT]);
addpath(genpath([CWD,'..\FUNCTIONS']));
[M] = genMontage(CWD,PREPROC_OUTPUT,names,name_i);
[G,H] = GetGH(M);

% load('CSD_Matrices_september');
cd([CWD,PREPROC_OUTPUT]);
    for name_i = 1:length(names);
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
        for index_i = 1:length(data.label)
            for j = 1:length(label)
                if strcmp(data.label{index_i,1},label{j,1})
                    trial{1,i}(j,:) = data.trial{1,i}(j,:);
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
    data = interp;
    % REDO COMMON AVERAGE REFERENCE AFTER CHANNEL INTERPOLATION
    fprintf('----- Re-Applying Common Average Reference: ------\n');
    cfg = [];
    cfg.reref = 'yes';
    cfg.refchannel = 1:64;
    refdat = ft_preprocessing(cfg,data);
    fprintf('Rereferencing done!\n');
    fprintf('Saving: %s%s \n',names(1,name_i).pnum,'''s repaired and rereferenced data. . .');
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
conditions = {'mixrepeat','switchto','switchaway','noninf'};
cond       = {'mr','st','sa','ni'};
datname    = struct('nams',{'mrdata','stdata','sadata','nidata'});
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
        clear EEG savename filename ans data
    end
end
%% END
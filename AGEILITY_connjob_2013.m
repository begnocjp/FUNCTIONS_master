% Processing job for Age-ility Connectivity Datasets
% Adapted from 'p122_B2' job written by Alex Provost
% Adapted by Patrick Cooper, October 2013.

% Set up Global Variables
clear all
warning off;
% add path for fieldtrip
addpath(genpath('C:\Users\c3075693.UNCLE\Documents\fieldtrip\')); 
% current working directory
CWD = 'F:\fieldtrip';
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
    %cfg.precision = 'single';
    dat = ft_preprocessing(cfg);
    % REREFERENCE to common average
    fprintf('----- Applying Common Average Reference: ------\n');
    cfg = [];
    cfg.reref = 'yes';
    cfg.refchannel = 1:64;
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
%     data.trial{1,1} = single(data.trial{1,1});
%     data.time{1,1}  = single(data.time{1,1});
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

badchann = {'Fp1','AF7','AF8','T8','F8','Iz'}; %fill in any bad channels - leave blank if data 
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
for name_i = 33:length(names)
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
for name_i = 33:length(names)
    cd([CWD,PREPROC_OUTPUT]);
    load([names(1,name_i).pnum,'_REPAIRED']);
    cd([CWD,RAW]);
    cfg=[];
    cfg.hdr                   = ft_read_header(strcat(names(1,name_i).pnum,'_TSWT.bdf'));
    cfg.event                 = ft_read_event(strcat(names(1,name_i).pnum,'_TSWT.bdf'));
    cfg.trialfun              = 'Agility';
    cfg.trialdef.pre          = 1; % latency in seconds
    cfg.trialdef.post         = 3.5;   % latency in seconds
    cfg.filename_original     = [names(1,name_i).pnum,'_TSWT.bdf'];
    [trl] = ft_trialfun_Agility_biosemi2(cfg,name_i); % for data recorded on new biosemi - else use normal function
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
for name_i = 14:length(names) % change back to 1:length(names)
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
PartID = {'AGE058'}; % change this to load each new participant in
load([PartID{1,1},'_ICADATA']);
cfg = [];
cfg.layout = 'biosemi64.lay';
cfg.viewmode = 'component';
ft_databrowser(cfg, ic_data)
%% REMOVE ICA COMPONENT RELATED TO EOG
cfg.component = [7]; % note the exact numbers will vary per run
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
for name_i = 8:length(names)
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
    cfg.artfctdef.threshold.min       = -100;
    cfg.artfctdef.threshold.max       = 100;
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
        %savename = strcat(names(1,name_i).pnum,'_',conditions(1,cond_i),'.mat');
        %fprintf('%s \t%s \t%s\n',filename{1,1},proc_string,savename{1,1});
        %save(savename{1,1},'data');
        %save(savename{1,1},'EEG');
        clear EEG savename filename ans data
    end
end


%% END
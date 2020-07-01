%% Statistical Analyses of Connectivity Data
% Reworked version of ImportandCondenseMatrices 
% Removed reliance on eval functions to speed up processing pipeline
% Reworked script of Patrick Cooper by Alexander Conley, University of Newcastle
% May, 2014
%% Set up globals
clear all
close all
warning off;
names = { 'DCR102' 'DCR103' 'DCR104' 'DCR106' 'DCR107' 'DCR108' 'DCR109' 'DCR110' 'DCR111' ... 
    'DCR112' 'DCR113' 'DCR114' 'DCR115' 'DCR117' 'DCR118' 'DCR119' 'DCR120' 'DCR121' ...
    'DCR122' 'DCR123' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR204' 'DCR206' 'DCR207' ... 
    'DCR208' 'DCR209' 'DCR210' 'DCR211' 'DCR212' 'DCR213' 'DCR214' 'DCR215' 'DCR217' ... 
    'DCR218' 'DCR219' 'DCR220' 'DCR221' 'DCR222' 'DCR223' 'DCR224' 'DCR225' 'S1' 'S1B' ... 
    'S4' 'S4B' 'S5' 'S5B' 'S6' 'S6B' 'S7' 'S7B' 'S8' 'S8B' 'S10' 'S10B' 'S11' 'S11B' 'S12' 'S12B' ...
    'S14' 'S14B' 'S15' 'S15B' 'S16' 'S16B' 'S17' 'S17B' 'S18' 'S18B' 'S20' 'S20B' 'S21' 'S21B' ...
    'S22' 'S22B' 'S23' 'S23B' 'S24' 'S24B' 'S25' 'S25B' 'S26' 'S26B' 'S27' 'S27B' 'S28' 'S28B' 'S29' 'S29B' ...
    'S30' 'S30B' 'S31' 'S31B' 'S34' 'S34B' 'S36' 'S36B' 'S37' 'S37B' 'S38' 'S38B' ...
    'S39' 'S39B' 'S40' 'S40B'}; %artefact rejection list
conditions = {'dirleft','dirright','nondirleft','nondirright'};
stim = {'active','sham'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
times = {};
starttime = 0:100:2300;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%adjust these
endtime   = starttime+200;
for time_i = 1:length(starttime)
    times{time_i} = strcat(num2str(starttime(time_i)),'to',num2str(endtime(time_i)));
end

CWD   = 'F:\fieldtrip';
NWD = 'E:\fieldtrip';

IMAG ='\IMAGCOH_OUPUT';
addpath(genpath([CWD,'\FUNCTIONS\mass_uni_toolbox'])); %for FDR correction
addpath([CWD,'\FUNCTIONS']);
addpath([CWD,IMAG]);
%% Generate file list and load files into structure
% list of files to be read in
filelist{1,(length(names)*length(conditions)*length(times))} = [];
count = 0;
for name_i = 1:length(names)
    for cond_i = 1:length(conditions)
        for time_i = 1:length(times)
            count = count+1;
            filelist(count) = strcat(CWD,IMAG,'\',names(name_i),'\',conditions(cond_i),'\',conditions(cond_i),times(time_i),'_CONECTIVITY_IMAG.mat');
        end%time_i loop
    end%cond_i loop
end%name_i loop
clear count name_i cond_i time_i freqstruct condstruct
%% Preallocate structure that house ALL data
%  ALLDATA.conditions.{condition}.{frequency}(Subject,Times,64,64)
%  {condition} == switchto switchaway noninf mixrepeat
%  {frequency} == delta theta loweralpha upperalpha beta
freqstruct = struct('delta',zeros(length(names),length(times),64,64),'theta',zeros(length(names),length(times),64,64), ...
                    'loweralpha',zeros(length(names),length(times),64,64),'upperalpha',zeros(length(names),length(times),64,64), ...
                    'beta',zeros(length(names),length(times),64,64));
condstruct = struct('dirleft',freqstruct,'dirright',freqstruct,'nondirleft',freqstruct,'nondirright',freqstruct);
ALLDATA = struct('conditions',condstruct);
% load data into structure
count = 0;
tic;
fprintf('Loading data for:\n');
for name_i = 1:length(names)
    fprintf('\n%s %s\t','Participant',names{name_i})
    for cond_i = 1:length(conditions)
        if cond_i == 1
            fprintf('%s\t',conditions{cond_i});
        elseif cond_i ~= 1
            fprintf('\t\t\t\t\t%s\t',conditions{cond_i});
        end
        for time_i = 1:length(times)
            fprintf('.');
            count = count+1;
            filename = filelist(1,count);
            ALLDATA = readConnMats(filename,name_i,cond_i,time_i,ALLDATA);
        end%time_i loop
%         sprintf(char(hex2dec('2713')))%checkmark
        fprintf('\n');
    end%cond_i loop
end%name_i loop
toc
clear count cond_i name_i time_i
% save off structure
mkdir([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save('ALLDATA','ALLDATA');
%% Create ACTIVE and SHAM structures
% Preallocate structures
load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ALLDATA.mat']);
freqstruct = struct('delta',zeros((length(names)/2),length(times),64,64),'theta',zeros((length(names)/2),length(times),64,64), ...
                    'loweralpha',zeros((length(names)/2),length(times),64,64),'upperalpha',zeros((length(names)/2),length(times),64,64), ...
                    'beta',zeros((length(names)/2),length(times),64,64));
condstruct = struct('dirleft',freqstruct,'dirright',freqstruct,'nondirleft',freqstruct,'nondirright',freqstruct);
ACTIVE_DATA = struct('conditions',condstruct);
SHAM_DATA   = struct('conditions',condstruct);
% create active and sham session lists
% WE REMOVED S13, S13-1, and S13B because S13,and S13-1 were slpit
% recordings.
ACTIVE = {'DCR202','DCR203','DCR104','DCR206','DCR107','DCR208', ...
    'DCR209','DCR110','DCR111','DCR112','DCR213','DCR214','DCR115', ...
    'DCR217','DCR118','DCR119','DCR220','DCR221','DCR122','DCR223','DCR124', ...
    'DCR125','S1','S4','S5B','S6B','S7B','S8','S10','S11B','S12','S14', ...
    'S15B','S16B','S17','S18','S20','S21','S22B','S23B','S24','S25B', ...
    'S26','S27','S28B','S29B','S30','S31','S34B','S36','S37B', ...
    'S38B','S39','S40'};
SHAM   = {'DCR102','DCR103','DCR204','DCR106','DCR207','DCR108', ...
    'DCR109','DCR210','DCR211','DCR212','DCR113','DCR114','DCR215', ...
    'DCR117','DCR218','DCR219','DCR120','DCR121','DCR222','DCR123','DCR224', ...
    'DCR225','S1B','S4B','S5','S6','S7','S8B','S10B','S11','S12B','S14B', ...
    'S15','S16','S17B','S18B','S20B','S21B','S22','S23','S24B','S25', ...
    'S26B','S27B','S28','S29','S30B','S31B','S34','S36B','S37', ...
    'S38','S39B','S40B'};
tic;
% combine SB13 and SB13-1
% SHAM   = {'DCR102','DCR103','DCR204','DCR106','DCR207','DCR108', ...
%     'DCR109','DCR210','DCR211','DCR212','DCR113','DCR114','DCR215', ...
%     'DCR117','DCR218','DCR219','DCR120','DCR121','DCR222','DCR123','DCR224', ...
%     'DCR225','S1B','S4B','S5','S6','S7','S8B','S10B','S11','S12B','S13','S14B', ...
%     'S15','S16','S17B','S18B','S20B','S21B','S22','S23','S24B','S25', ...
%     'S26B','S27B','S28','S29','S30B','S31B','S34','S36B','S37', ...
%     'S38','S39B','S40B'};
% %get data into temp variables: name_i = 63 and name_i = 64
% temp_name_i = 63;
% temp_name_j = 63+1;
% tempA = ALLDATA()
%join data
%reinsert data
%reshape ALLDATA

fprintf('Assigning connectivity matrices to active and sham sessions:\n');
for name_i = 1:length(names)
    fprintf('\n%s %s\t','Participant',names{name_i})
    for cond_i = 1:length(conditions)
        if cond_i == 1
            fprintf('%s\t',conditions{cond_i});
        elseif cond_i ~= 1
            fprintf('\t\t\t\t\t%s\t',conditions{cond_i});
        end
        for time_i = 1:length(times)
            isActive = zeros(length(ACTIVE));
            isSham   = zeros(length(SHAM));
            fprintf('.');
            for active_i = 1:length(ACTIVE)
                isActive(active_i) = strcmp(ACTIVE{1,active_i},names{1,name_i});
                isSham(active_i)   = strcmp(SHAM{1,active_i},names{1,name_i});
            end%active_i loop
            if sum(any(isActive)) ==1;
                 fprintf('%s\t%s\n','Found ACTIVE: ',names{1,name_i});
                [ACTIVE_DATA,SHAM_DATA] = assignActiveSham(name_i,cond_i,time_i,ALLDATA,ACTIVE_DATA,SHAM_DATA,isActive,isSham);
            elseif sum(any(isSham)) ==1;
                 fprintf('%s\t%s\n','Found SHAM: ',names{1,name_i});
                [ACTIVE_DATA,SHAM_DATA] = assignActiveSham(name_i,cond_i,time_i,ALLDATA,ACTIVE_DATA,SHAM_DATA,isActive,isSham);
            end
            clear isActive isSham
        end%time_i loop
        fprintf('\n');
    end%cond_i loop
end%name_i loop
toc
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','ACTIVE_DATA'],'ACTIVE_DATA');
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','SHAM_DATA'],'SHAM_DATA');
%% Preallocate average structures
load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','ACTIVE_DATA']);
load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','SHAM_DATA']);

freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
                    'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
                    'beta',zeros(length(times),64,64));
condstruct = struct('dirleft',freqstruct,'dirright',freqstruct,'nondirleft',freqstruct,'nondirright', freqstruct);
ACTIVE_AVDATA = struct('conditions',condstruct);
SHAM_AVDATA = struct('conditions',condstruct);
clear freqstruct condstruct
tic;
fprintf('Averaging connectivity matrices for:\n');
%partgroup = 22;%index for participants per age group
for name_i = 1:length(names)%partgroup
    fprintf('\n%s %s\t','%i: Participant',name_i,names{name_i})
    for cond_i = 1:length(conditions)
        if cond_i == 1
            fprintf('\n\t%s',conditions{cond_i});
        elseif cond_i ~= 1
            fprintf('\n\t%s',conditions{cond_i});
        end
        
        for time_i = 1:length(times)
            fprintf('.');
            [ACTIVE_AVDATA,SHAM_AVDATA] = averageConnMats(ACTIVE_DATA,SHAM_DATA,cond_i,time_i,ACTIVE_AVDATA,SHAM_AVDATA);
        end%time_i loop
%         sprintf(char(hex2dec('2713')))%checkmark
        fprintf('\n');
    end%cond_i loop
end%name_i loop
toc
clear count cond_i name_i time_i
%cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','ACTIVE_AVDATA'],'ACTIVE_AVDATA');
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','SHAM_AVDATA'],'SHAM_AVDATA');
%% Statistics
% First create difference matrices (i.e. condition - mixrepeat)
% Preallocate difference structure

%Load Data:
load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\SHAM_DATA.mat']);
load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ACTIVE_DATA.mat']);

freqstruct = struct('delta',zeros(length(names)/2,length(times),64,64,'single'),...
                    'theta',zeros(length(names)/2,length(times),64,64,'single'), ...
                    'loweralpha',zeros(length(names)/2,length(times),64,64,'single'),...
                    'upperalpha',zeros(length(names)/2,length(times),64,64,'single'), ...
                    'beta',zeros(length(names)/2,length(times),64,64,'single'));

condstruct = struct('dirleft',freqstruct,...
                    'dirright',freqstruct,...
                    'nondirleft',freqstruct,...
                    'nondirright',freqstruct);
                
%Difference between Active and Sham, size = names/2,timebins,64,64 electrodes
DIFFDATA = struct('conditions',condstruct); 
clear condstruct

%Difference between Directional and Non-directional
condstruct = struct('dir',freqstruct,'non',freqstruct);
DIFFCUEDATA = struct('conditions',condstruct);
%Make A Copy of Data for storage:
ACTIVEDIRDATA = DIFFCUEDATA;
SHAMDIRDATA   = DIFFCUEDATA;
clear condstruct

%Difference by Hand: Left or Right:
condstruct = struct('left',freqstruct,'right',freqstruct);
DIFFHANDDATA = struct('conditions',condstruct);
%Make A Copy of Data for storage:
ACTIVEHANDDATA = DIFFHANDDATA;
SHAMHANDDATA = DIFFHANDDATA;
clear condstruct

%Global Average between Active and SHAM
condstruct = struct('active',freqstruct,'sham',freqstruct);
ACTIVE_SHAM_STIMDATA = struct('conditions',condstruct);
clear condstruct
%Same section as before, but Calculate the difference.
condstruct = struct('activevssham',freqstruct);
DIFFSTIMDATA = struct('conditions',condstruct);
clear condstruct freqstruct

fprintf('Creating difference matrices for\n');
%tic;

DIFFDATA = diffConnMats_AW(ACTIVE_DATA,SHAM_DATA,DIFFDATA);


% 
% for name_i = 1:(length(names)/2)
%     fprintf('\n%s %s\t','Participant',names{name_i});
%     
%     for cond_i = 1:length(conditions)
%         
%         if cond_i == 1
%             fprintf('%s\t',conditions{cond_i});
%         elseif cond_i ~= 1
%             fprintf('\t\t\t\t\t%s\t',conditions{cond_i});
%         end
%         for time_i = 1:length(times)
%             fprintf('.');
%             [DIFFDATA] = diffConnMats(ACTIVE_DATA,SHAM_DATA,cond_i,name_i,time_i,DIFFDATA);
%             [DIFFCUEDATA,ACTIVEDIRDATA,SHAMDIRDATA] = diffCueConnMats(ACTIVE_DATA,SHAM_DATA,name_i,time_i,DIFFCUEDATA,ACTIVEDIRDATA,SHAMDIRDATA);
%             [DIFFHANDDATA,ACTIVEHANDDATA,SHAMHANDDATA] = diffHandConnMats(ACTIVE_DATA,SHAM_DATA,name_i,time_i,DIFFHANDDATA,ACTIVEHANDDATA,SHAMHANDDATA);
%             [ACTIVE_SHAM_STIMDATA,DIFFSTIMDATA] = diffStimConnMats(ACTIVE_DATA,SHAM_DATA,name_i,time_i,ACTIVE_SHAM_STIMDATA,DIFFSTIMDATA);
%         end%time_i loop
%         sprintf(char(hex2dec('2713')));%checkmark
%         fprintf('\n');
%     end%cond_i loop
% end%name_i loop
toc

save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','DIFFDATA'],'DIFFDATA');
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','DIFFCUEDATA'],'DIFFCUEDATA');
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','ACTIVEDIRDATA'],'ACTIVEDIRDATA');
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','SHAMDIRDATA'],'SHAMDIRDATA');
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','DIFFHANDDATA'],'DIFFHANDDATA');
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','ACTIVEHANDDATA'],'ACTIVEHANDDATA');
save('SHAMHANDDATA','SHAMHANDDATA');
save('ACTIVE_SHAM_STIMDATA','ACTIVE_SHAM_STIMDATA');
save('DIFFSTIMDATA','DIFFSTIMDATA');
%% Compute t-tests
% First create t-test matrices that will store t-values
% Preallocate t-value & p-value structure
cd([NWD '\FUNCTIONS'])
freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
                    'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
                    'beta',zeros(length(times),64,64));
%condstruct = struct('activedir',freqstruct,'activenondir',freqstruct);
condstruct = struct('dirleft',freqstruct,...
                    'dirright',freqstruct,...
                    'nondirleft',freqstruct,...
                    'nondirright',freqstruct);
                
TVALS_ACTIVE_DATA = struct('conditions',condstruct);
PVALS_ACTIVE_DATA = struct('conditions',condstruct);
TVALS_SHAM_DATA = struct('conditions',condstruct);
PVALS_SHAM_DATA = struct('conditions',condstruct);
clear freqstruct condstruct
fprintf('Computing t-tests for:\n');


[TVALS_ACTIVE_DATA,PVALS_ACTIVE_DATA] = ttestConnMats_young_AW(ACTIVE_DATA,TVALS_ACTIVE_DATA,PVALS_ACTIVE_DATA);
[TVALS_SHAM_DATA,PVALS_SHAM_DATA] = ttestConnMats_young_AW(SHAM_DATA,TVALS_SHAM_DATA,PVALS_SHAM_DATA);

% for cond_i = 1:length(conditions)
%     if cond_i == 1
%         fprintf('%s\t',conditions{cond_i});
%     elseif cond_i ~= 1
%         fprintf('\t\t\t\t\t%s\t',conditions{cond_i});
%     end
%     tic;
%     for time_i = 1:length(times)
%         fprintf('.');
%         [TVALS_CUEDATA,PVALS_CUEDATA] = ttestCueConnMats_young(ACTIVE_AVCUEDATA,SHAM_AVCUEDATA,cond_i,time_i,TVALS_CUEDATA,PVALS_CUEDATA);
%     end%time_i loop
%     toc
% %     sprintf(char(hex2dec('2713')));%checkmark
%     fprintf('\n');
% end%cond_i loop
% fprintf('%s\t',conditions{cond_i});
% freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
%                     'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
%                     'beta',zeros(length(times),64,64));
% condstruct = struct('dir',freqstruct,'nondir',freqstruct);
% TVALS_CUEDATA = struct('conditions',condstruct);
% PVALS_CUECUE = struct('conditions',condstruct);
% 
% tic;
% for time_i = 1:length(times)
%     fprintf('.');
% %         [TVALS_ACTIVE_SHAM_STIMDATA,PVALS_ACTIVE_SHAM_STIMDATA] = ttestConnMats_ACTIVE_SHAM_STIMDATA(ACTIVE_SHAM_STIMDATA,time_i,TVALS_ACTIVE_SHAM_STIMDATA,PVALS_ACTIVE_SHAM_STIMDATA);
% %         [TVALS_ACTIVE_SHAM_STIMDATA,PVALS_ACTIVE_SHAM_STIMDATA] = ttestConnMats_ACTIVE_SHAM_STIMDATA_young(ACTIVE_SHAM_STIMDATA,time_i,TVALS_ACTIVE_SHAM_STIMDATA,PVALS_ACTIVE_SHAM_STIMDATA);
%           [TVALS_CUEDATA,PVALS_CUEDATA] = ttestCueConnMats_young(ACTIVE_AVCUEDATA,SHAM_AVCUEDATA,cond_i,time_i,TVALS_CUEDATA,PVALS_CUEDATA);
% end%time_i loop
% toc
% fprintf('\n');

%cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','TVALS_ACTIVE_young'],'TVALS_ACTIVE_DATA');
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','PVALS_ACTIVE_young'],'PVALS_ACTIVE_DATA');
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','TVALS_SHAM_young'],'TVALS_SHAM_DATA');
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','PVALS_SHAM_young'],'PVALS_SHAM_DATA');
%save('TVALS_DIFFDATA_ORDER_young','TVALS_ACTIVE_SHAM_STIMDATA_ORDER');

%save('PVALS_DIFFDATA_ORDER_young','PVALS_ACTIVE_SHAM_STIMDATA_ORDER');

%save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','TVALS_ACTIVE_STIMDATA_DIR_young'],'TVALS_ACTIVE_STIMDATA_DIR');
%save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','PVALS_ACTIVE_STIMDATA_DIR_young'],'PVALS_ACTIVE_STIMDATA_NONDIR');
%save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','TVALS_SHAM_STIMDATA_NONDIR_young'],'TVALS_SHAM_STIMDATA_DIR');
%save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','PVALS_SHAM_STIMDATA_NONDIR_young'],'PVALS_SHAM_STIMDATA_NONDIR');
%% Find Significant t-values
% First create t-test matrices that will store significant t-values
% Preallocate t-value & p-value structure
%freqstruct = struct('delta',zeros(length(times),48,48),'theta',zeros(length(times),48,48), ...
%                    'loweralpha',zeros(length(times),48,48),'upperalpha',zeros(length(times),48,48), ...
%                    'beta',zeros(length(times),48,48));
%load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','TVALS_DIFFDATA_young'],'TVALS_DIFFDATA');
%load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','PVALS_DIFFDATA_young'],'PVALS_DIFFDATA');

load([CWD,'TVALS_ACTIVE_young'],'TVALS_ACTIVE_DATA');
load([CWD,'PVALS_ACTIVE_young'],'PVALS_ACTIVE_DATA');
load([CWD,'TVALS_SHAM_young'],'TVALS_SHAM_DATA');
load([CWD,'PVALS_SHAM_young'],'PVALS_SHAM_DATA');

addpath(genpath([NWD '\FUNCTIONS\mass_uni_toolbox']))
cd([NWD '\FUNCTIONS\'])
freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
                    'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
                    'beta',zeros(length(times),64,64));
condstruct = struct('dirleft',freqstruct,...
                    'dirright',freqstruct,...
                    'nondirleft',freqstruct,...
                    'nondirright',freqstruct);
SIGTVALS_ACTIVE_DATA = struct('conditions',condstruct);
SIGTVALS_SHAM_DATA = struct('conditions',condstruct);
clear freqstruct condstruct
fprintf('Searching t-maps for significant values for:\n');

SIGNIFICANCE = 0.01; 
[SIGTVALS_ACTIVE_DATA] = findSigTVALS_ACTIVE_STIMDATA_AW_PC(TVALS_ACTIVE_DATA,PVALS_ACTIVE_DATA,SIGTVALS_ACTIVE_DATA,SIGNIFICANCE);
[SIGTVALS_SHAM_DATA] = findSigTVALS_SHAM_STIMDATA_AW_PC(TVALS_SHAM_DATA,PVALS_SHAM_DATA,SIGTVALS_SHAM_DATA,SIGNIFICANCE);

save([CWD,'SIGTVALS_ACTIVE_young'],'SIGTVALS_ACTIVE_DATA');
save([CWD,'SIGTVALS_SHAM_young'],'SIGTVALS_SHAM_DATA');
% 
% for cond_i = 1:length(conditions)
%     fprintf('%s\t',conditions{cond_i});
%     for time_i = 1:length(times)
%         fprintf('.');
%         SIGNIFICANCE = 0.005; %threshold of significance
%         [SIGTVALS_ACTIVE_SHAM_STIMDATA] = findSigTVALS_ACTIVE_SHAM_STIMDATA(TVALS_DIFFDATA,PVALS_DIFFDATA,cond_i,time_i,SIGTVALS_ACTIVE_SHAM_DIFFDATA,SIGNIFICANCE);
%     end%time_i loop
% %     sprintf(char(hex2dec('2713')));%checkmark
%     fprintf('\n');
% end%cond_i loop
% 
% 
% %active vs sham
% fprintf('Searching t-maps for significant values for:\n');
% freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
%                     'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
%                     'beta',zeros(length(times),64,64));
% condstruct = struct('dir',freqstruct,'nondir',freqstruct);
% SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE = struct('conditions',condstruct);
% cond = {'dir','nondir'};
% for cond_i = 1:length(cond)
%     fprintf('%s\t',cond{cond_i});
%     for time_i = 1:length(times)
%         fprintf('.');
% %         SIGNIFICANCE = 0.005; %threshold of significance
%         [SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE] = findSigTVALS_ACTIVE_SHAM_STIMDATA_CUE(TVALS_ACTIVE_SHAM_STIMDATA_CUE,PVALS_ACTIVE_SHAM_STIMDATA_CUE,cond_i,time_i,SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE,SIGNIFICANCE);
%     end%time_i loop
% %     sprintf(char(hex2dec('2713')));%checkmark
%     fprintf('\n');
% end%cond_i loop

%cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);


%% Reorder t-Maps to better reflect topology and save off maps
%load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','SIGTVALS_ACTIVE_SHAM_STIMDATA_young'],'SIGTVALS_DIFFDATA');
load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','SIGTVALS_ACTIVE_young'],'SIGTVALS_ACTIVE_DATA');
load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','SIGTVALS_SHAM_young'],'SIGTVALS_SHAM_DATA');
cd([NWD '\FUNCTIONS\'])
freqstruct = struct('delta',zeros(length(times),48,48),'theta',zeros(length(times),48,48), ...
                    'loweralpha',zeros(length(times),48,48),'upperalpha',zeros(length(times),48,48), ...
                    'beta',zeros(length(times),48,48));
condstruct = struct('dirleft',freqstruct,...
                    'dirright',freqstruct,...
                    'nondirleft',freqstruct,...
                    'nondirright',freqstruct);
REORDSIGTVALS_ACTIVE_DATA = struct('conditions',condstruct);
REORDSIGTVALS_SHAM_DATA = struct('conditions',condstruct);
fprintf('Reordering t-maps to better reflect topology for:\n');


for cond_i = 1:length(conditions)
    fprintf('%s\t',conditions{cond_i});
    for time_i = 1:length(times)
        fprintf('.');
        [REORDSIGTVALS_ACTIVE_DATA] = reorderSigTVals(SIGTVALS_ACTIVE_DATA,cond_i,time_i,REORDSIGTVALS_ACTIVE_DATA);
        [REORDSIGTVALS_SHAM_DATA] = reorderSigTVals(SIGTVALS_SHAM_DATA,cond_i,time_i,REORDSIGTVALS_SHAM_DATA);
    end%time_i loop
%     sprintf(char(hex2dec('2713')));%checkmark
    fprintf('\n');
end%cond_i loop
save([CWD,'REORDSIGTVALS_ACTIVE_young'],'REORDSIGTVALS_ACTIVE_DATA');
save([CWD,'REORDSIGTVALS_SHAM_young'],'REORDSIGTVALS_SHAM_DATA');
% 
% freqstruct = struct('delta',zeros(length(times),48,48),'theta',zeros(length(times),48,48), ...
%                     'loweralpha',zeros(length(times),48,48),'upperalpha',zeros(length(times),48,48), ...
%                     'beta',zeros(length(times),48,48));
% condstruct = struct('dir',freqstruct,'nondir',freqstruct);
% REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_CUE = struct('conditions',condstruct);
% fprintf('Reordering t-maps to better reflect topology for:\n');
% for cond_i = 1:length(conditions)
%     fprintf('%s\t',cond{cond_i});
%     for time_i = 1:length(times)
%         fprintf('.');
%         [REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_CUE] = reorderSigTVals_ACTIVE_SHAM_STIMDATA_CUE(SIGTVALS_ACTIVE_SHAM_STIMDATA_CUE,cond_i,time_i,REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_CUE);
%     end%time_i loop
% %     sprintf(char(hex2dec('2713')));%checkmark
%     fprintf('\n');
% end%cond_i loop


cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','REORDSIGTVALS_DIFFDATA_young'],'REORDSIGTVALS_DIFFDATA');
% save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\','REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER_young'],'REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER');
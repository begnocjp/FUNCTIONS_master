%% Statistical Analyses of Connectivity Data
% Reworked version of ImportandCondenseMatrices 
% Removed reliance on eval functions to speed up processing pipeline
% Reworked script of Patrick Cooper by Alexander Conley, University of Newcastle
% May, 2014
%% Set up globals
clear all
close all
warning off;
names = { 'DCR102' 'DCR103' 'DCR106' 'DCR108' 'DCR109' 'DCR113' 'DCR114' 'DCR117' 'DCR120' 'DCR121' ...
    'DCR123' 'DCR204' 'DCR207' 'DCR210' 'DCR211' 'DCR212' 'DCR215' 'DCR218' 'DCR219' 'DCR222' 'DCR224' 'DCR225' 'S1B' ... 
    'S4B' 'S5' 'S6' 'S7' 'S8B' 'S10B' 'S11' 'S12B' 'S13' 'S13-1' 'S14B' 'S15' 'S16' 'S17B' 'S18B' 'S20B' 'S21B' ...
    'S22' 'S23' 'S24B' 'S25' 'S26B' 'S27B' 'S28' 'S29' 'S30B' 'S31B' 'S34' 'S36B' 'S37' 'S38' ...
    'S39B' 'S40B' 'PF001C' 'PF002' 'PF003' 'PF004' 'PF005' 'PF006B' 'PF007B'...
    'PF008C' 'PF009C' 'PM003C' 'PM004C' 'PM006B' 'PM007B' 'PM008B' 'PM009C' 'PM010' 'PM014B' 'PM015'...
    'PM016B' 'PM017C'}; %artefact rejection list
conditions = {'dirleft','dirright','nondirleft','nondirright'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
times = {};
starttime = -500:100:2500;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%adjust these
endtime   = starttime+200;
for time_i = 1:length(starttime)
    times{time_i} = strcat(num2str(starttime(time_i)),'to',num2str(endtime(time_i)));
end

CWD   = 'E:\fieldtrip';
NWD = 'F:\fieldtrip';

IMAG ='\IMAGCOH_OUTPUT';
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
            filelist(count) = strcat(NWD,IMAG,'\',names(name_i),'\',conditions(cond_i),'\',conditions(cond_i),times(time_i),'_CONECTIVITY_IMAG.mat');
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
% %% Create ACTIVE and SHAM structures
% % Preallocate structures
% load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ALLDATA.mat']);
% freqstruct = struct('delta',zeros((length(names)/2),length(times),64,64),'theta',zeros((length(names)/2),length(times),64,64), ...
%                     'loweralpha',zeros((length(names)/2),length(times),64,64),'upperalpha',zeros((length(names)/2),length(times),64,64), ...
%                     'beta',zeros((length(names)/2),length(times),64,64));
% condstruct = struct('dirleft',freqstruct,'dirright',freqstruct,'nondirleft',freqstruct,'nondirright',freqstruct);
% ACTIVE_DATA = struct('conditions',condstruct);
% SHAM_DATA   = struct('conditions',condstruct);
% % create active and sham session lists
% % WE REMOVED S13, S13-1, and S13B because S13,and S13-1 were slpit
% % recordings.
% ACTIVE = {'DCR202','DCR203','DCR104','DCR206','DCR107','DCR208', ...
%     'DCR209','DCR110','DCR111','DCR112','DCR213','DCR214','DCR115', ...
%     'DCR217','DCR118','DCR119','DCR220','DCR221','DCR122','DCR223','DCR124', ...
%     'DCR125','S1','S4','S5B','S6B','S7B','S8','S10','S11B','S12','S14', ...
%     'S15B','S16B','S17','S18','S20','S21','S22B','S23B','S24','S25B', ...
%     'S26','S27','S28B','S29B','S30','S31','S34B','S36','S37B', ...
%     'S38B','S39','S40'};
% SHAM   = {'DCR102','DCR103','DCR204','DCR106','DCR207','DCR108', ...
%     'DCR109','DCR210','DCR211','DCR212','DCR113','DCR114','DCR215', ...
%     'DCR117','DCR218','DCR219','DCR120','DCR121','DCR222','DCR123','DCR224', ...
%     'DCR225','S1B','S4B','S5','S6','S7','S8B','S10B','S11','S12B','S14B', ...
%     'S15','S16','S17B','S18B','S20B','S21B','S22','S23','S24B','S25', ...
%     'S26B','S27B','S28','S29','S30B','S31B','S34','S36B','S37', ...
%     'S38','S39B','S40B'};
% tic;
% % combine SB13 and SB13-1
% % SHAM   = {'DCR102','DCR103','DCR204','DCR106','DCR207','DCR108', ...
% %     'DCR109','DCR210','DCR211','DCR212','DCR113','DCR114','DCR215', ...
% %     'DCR117','DCR218','DCR219','DCR120','DCR121','DCR222','DCR123','DCR224', ...
% %     'DCR225','S1B','S4B','S5','S6','S7','S8B','S10B','S11','S12B','S13','S14B', ...
% %     'S15','S16','S17B','S18B','S20B','S21B','S22','S23','S24B','S25', ...
% %     'S26B','S27B','S28','S29','S30B','S31B','S34','S36B','S37', ...
% %     'S38','S39B','S40B'};
% % %get data into temp variables: name_i = 63 and name_i = 64
% % temp_name_i = 63;
% % temp_name_j = 63+1;
% % tempA = ALLDATA()
% %join data
% %reinsert data
% %reshape ALLDATA
% 
% fprintf('Assigning connectivity matrices to active and sham sessions:\n');
% for name_i = 1:length(names)
%     fprintf('\n%s %s\t','Participant',names{name_i})
%     for cond_i = 1:length(conditions)
%         if cond_i == 1
%             fprintf('%s\t',conditions{cond_i});
%         elseif cond_i ~= 1
%             fprintf('\t\t\t\t\t%s\t',conditions{cond_i});
%         end
%         for time_i = 1:length(times)
%             isActive = zeros(length(ACTIVE));
%             isSham   = zeros(length(SHAM));
%             fprintf('.');
%             for active_i = 1:length(ACTIVE)
%                 isActive(active_i) = strcmp(ACTIVE{1,active_i},names{1,name_i});
%                 isSham(active_i)   = strcmp(SHAM{1,active_i},names{1,name_i});
%             end%active_i loop
%             if sum(any(isActive)) ==1;
%                  fprintf('%s\t%s\n','Found ACTIVE: ',names{1,name_i});
%                 [ACTIVE_DATA,SHAM_DATA] = assignActiveSham(name_i,cond_i,time_i,ALLDATA,ACTIVE_DATA,SHAM_DATA,isActive,isSham);
%             elseif sum(any(isSham)) ==1;
%                  fprintf('%s\t%s\n','Found SHAM: ',names{1,name_i});
%                 [ACTIVE_DATA,SHAM_DATA] = assignActiveSham(name_i,cond_i,time_i,ALLDATA,ACTIVE_DATA,SHAM_DATA,isActive,isSham);
%             end
%             clear isActive isSham
%         end%time_i loop
%         fprintf('\n');
%     end%cond_i loop
% end%name_i loop
% toc
% save('ACTIVE_DATA','ACTIVE_DATA');
% save('SHAM_DATA','SHAM_DATA');
% %% Preallocate average structures
% freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
%                     'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
%                     'beta',zeros(length(times),64,64));
% condstruct = struct('dirleft',freqstruct,'dirright',freqstruct,'nondirleft',freqstruct,'nondirright',freqstruct);
% ACTIVE_AVDATA = struct('conditions',condstruct);
% SHAM_AVDATA   = struct('conditions',condstruct);
% clear freqstruct condstruct
% tic;
% fprintf('Averaging connectivity matrices for:\n');
% for name_i = 1:length(names)
%     fprintf('\n%s %s\t','Participant',names{name_i})
%     for cond_i = 1:length(conditions)
%         if cond_i == 1
%             fprintf('%s\t',conditions{cond_i});
%         elseif cond_i ~= 1
%             fprintf('\t\t\t\t\t%s\t',conditions{cond_i});
%         end
%         for time_i = 1:length(times)
%             fprintf('.');
%             [ACTIVE_AVDATA,SHAM_AVDATA] = averageConnMats(ACTIVE_DATA,SHAM_DATA,cond_i,time_i,ACTIVE_AVDATA,SHAM_AVDATA);
%         end%time_i loop
% %         sprintf(char(hex2dec('2713')))%checkmark
%         fprintf('\n');
%     end%cond_i loop
% end%name_i loop
% toc
% clear count cond_i name_i time_i
% cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
% save('ACTIVE_AVDATA','ACTIVE_AVDATA');
% save('SHAM_AVDATA','SHAM_AVDATA');
% %% Statistics
% % First create difference matrices (i.e. condition - mixrepeat)
% % Preallocate difference structure
% 
% %Load Data:
% load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\SHAM_DATA.mat']);
% load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ACTIVE_DATA.mat']);
% 
% freqstruct = struct('delta',zeros(length(names)/2,length(times),64,64,'single'),...
%                     'theta',zeros(length(names)/2,length(times),64,64,'single'), ...
%                     'loweralpha',zeros(length(names)/2,length(times),64,64,'single'),...
%                     'upperalpha',zeros(length(names)/2,length(times),64,64,'single'), ...
%                     'beta',zeros(length(names)/2,length(times),64,64,'single'));
% 
% condstruct = struct('dirleft',freqstruct,...
%                     'dirright',freqstruct,...
%                     'nondirleft',freqstruct,...
%                     'nondirright',freqstruct);
%                 
% %Difference between Active and Sham, size = names/2,timebins,64,64 electrodes
% DIFFDATA = struct('conditions',condstruct); 
% clear condstruct
% 
% condstruct = struct('dir',freqstruct,'non',freqstruct);
% DIFFCUEDATA = struct('conditions',condstruct);
% ACTIVEDIRDATA = DIFFCUEDATA;
% SHAMDIRDATA   = ACTIVEDIRDATA;
% clear condstruct
% 
% condstruct = struct('left',freqstruct,'right',freqstruct);
% DIFFHANDDATA = struct('conditions',condstruct);
% ACTIVEHANDDATA = DIFFHANDDATA;
% SHAMHANDDATA = ACTIVEHANDDATA;
% clear condstruct
% 
% condstruct = struct('active',freqstruct,'sham',freqstruct);
% ACTIVE_SHAM_STIMDATA = struct('conditions',condstruct);
% clear condstruct
% 
% condstruct = struct('activevssham',freqstruct);
% DIFFSTIMDATA = struct('conditions',condstruct);
% clear condstruct freqstruct
% 
% fprintf('Creating difference matrices for\n');
% %tic;
% for name_i = 1:(length(names)/2)
%     fprintf('\n%s %s\t','Participant',names{name_i});
%     for cond_i = 1:length(conditions)
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
% %         sprintf(char(hex2dec('2713')));%checkmark
%         fprintf('\n');
%     end%cond_i loop
% end%name_i loop
% %toc
% cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
% save('DIFFDATA','DIFFDATA');
% save('DIFFCUEDATA','DIFFCUEDATA');
% save('ACTIVEDIRDATA','ACTIVEDIRDATA');
% save('SHAMDIRDATA','SHAMDIRDATA');
% save('DIFFHANDDATA','DIFFHANDDATA');
% save('ACTIVEHANDDATA','ACTIVEHANDDATA');
% save('SHAMHANDDATA','SHAMHANDDATA');
% save('ACTIVE_SHAM_STIMDATA','ACTIVE_SHAM_STIMDATA');
% save('DIFFSTIMDATA','DIFFSTIMDATA');
%% Compute t-tests
% First create t-test matrices that will store t-values
% Preallocate t-value & p-value structure
cd([NWD '\FUNCTIONS'])
freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
                    'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
                    'beta',zeros(length(times),64,64));
condstruct = struct('dirleft',freqstruct,'dirright',freqstruct,'nondirleft',freqstruct,'nondirright',freqstruct);
TVALS_DIFFDATA = struct('conditions',condstruct);
PVALS_DIFFDATA = struct('conditions',condstruct);
clear freqstruct condstruct
fprintf('Computing t-tests for:\n');
for cond_i = 1:length(conditions)
    if cond_i == 1
        fprintf('%s\t',conditions{cond_i});
    elseif cond_i ~= 1
        fprintf('\t\t\t\t\t%s\t',conditions{cond_i});
    end
    tic;
    for time_i = 1:length(times)
        fprintf('.');
        [TVALS_DIFFDATA,PVALS_DIFFDATA] = ttestConnMats(DIFFDATA,cond_i,time_i,TVALS_DIFFDATA,PVALS_DIFFDATA);
    end%time_i loop
    toc
%     sprintf(char(hex2dec('2713')));%checkmark
    fprintf('\n');
end%cond_i loop
fprintf('%s\t',conditions{cond_i});
freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
                    'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
                    'beta',zeros(length(times),64,64));
condstruct = struct('active',freqstruct,'sham',freqstruct);
TVALS_ACTIVE_SHAM_STIMDATA = struct('conditions',condstruct);
PVALS_ACTIVE_SHAM_STIMDATA = struct('conditions',condstruct);

tic;
for time_i = 1:length(times)
    fprintf('.');
        [TVALS_ACTIVE_SHAM_STIMDATA,PVALS_ACTIVE_SHAM_STIMDATA] = ttestConnMats_ACTIVE_SHAM_STIMDATA(ACTIVE_SHAM_STIMDATA,time_i,TVALS_ACTIVE_SHAM_STIMDATA,PVALS_ACTIVE_SHAM_STIMDATA);
end%time_i loop
toc
fprintf('\n');

cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save('TVALS_DIFFDATA','TVALS_DIFFDATA');
save('PVALS_DIFFDATA','PVALS_DIFFDATA');
%% Find Significant t-values
% First create t-test matrices that will store significant t-values
% Preallocate t-value & p-value structure
%freqstruct = struct('delta',zeros(length(times),48,48),'theta',zeros(length(times),48,48), ...
%                    'loweralpha',zeros(length(times),48,48),'upperalpha',zeros(length(times),48,48), ...
%                    'beta',zeros(length(times),48,48));
addpath(genpath([NWD '\FUNCTIONS\mass_uni_toolbox']))
cd([NWD '\FUNCTIONS\'])
freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
                    'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
                    'beta',zeros(length(times),64,64));
condstruct = struct('dirleft',freqstruct,'dirright',freqstruct,'nondirleft',freqstruct,'nondirright',freqstruct);
SIGTVALS_DIFFDATA = struct('conditions',condstruct);
SIGTVALS_ACTIVESHAMSTIMDATA = struct('conditions',condstruct);
clear freqstruct condstruct
fprintf('Searching t-maps for significant values for:\n');
for cond_i = 1:length(conditions)
    fprintf('%s\t',conditions{cond_i});
    for time_i = 1:length(times)
        fprintf('.');
        SIGNIFICANCE = 0.05; %threshold of significance
        [SIGTVALS_DIFFDATA] = findSigTVals(TVALS_DIFFDATA,PVALS_DIFFDATA,cond_i,time_i,SIGTVALS_DIFFDATA,SIGNIFICANCE);
        [SIGTVALS_ACTIVESHAMSTIMDATA] = findSigTVals(TVALS_ACTIVESHAMSTIMDATA,PVALS_ACTIVESHAMSTIMDATA,cond_i,time_i,SIGTVALS_ACTIVESHAMSTIMDATA,SIGNIFICANCE);
    end%time_i loop
%     sprintf(char(hex2dec('2713')));%checkmark
    fprintf('\n');
end%cond_i loop

cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save('SIGTVALS_DIFFDATA','SIGTVALS_DIFFDATA');
%% Reorder t-Maps to better reflect topology and save off maps
cd([NWD '\FUNCTIONS\'])
freqstruct = struct('delta',zeros(length(times),48,48),'theta',zeros(length(times),48,48), ...
                    'loweralpha',zeros(length(times),48,48),'upperalpha',zeros(length(times),48,48), ...
                    'beta',zeros(length(times),48,48));
condstruct = struct('dirleft',freqstruct,'dirright',freqstruct,'nondirleft',freqstruct,'nondirright',freqstruct);
REORDSIGTVALS_DIFFDATA = struct('conditions',condstruct);
fprintf('Reordering t-maps to better reflect topology for:\n');
for cond_i = 1:length(conditions)
    fprintf('%s\t',conditions{cond_i});
    for time_i = 1:length(times)
        fprintf('.');
        [REORDSIGTVALS_DIFFDATA] = reorderSigTVals(SIGTVALS_DIFFDATA,cond_i,time_i,REORDSIGTVALS_DIFFDATA);
    end%time_i loop
%     sprintf(char(hex2dec('2713')));%checkmark
    fprintf('\n');
end%cond_i loop
cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save('REORDSIGTVALS_DIFFDATA','REORDSIGTVALS_DIFFDATA');
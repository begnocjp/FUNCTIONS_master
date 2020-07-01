%% Statistical Analyses of Connectivity Data
% Reworked version of ImportandCondenseMatrices 
% Removed reliance on eval functions to speed up processing pipeline
% Patrick Cooper, University of Newcastle
% March, 2014
%% Set up globals
clear all
close all
warning off;
feature('DefaultCharacterSet','UTF-8');%for checkmarks
names = { 'AGE002' 'AGE003' 'AGE008' 'AGE012' 'AGE013' 'AGE014' ...
          'AGE015' 'AGE017' 'AGE018' 'AGE019' 'AGE021' 'AGE022' ...
          'AGE023' 'AGE024' 'AGE026' 'AGE027' 'AGE028' 'AGE030' ...
          'AGE032' 'AGE033' 'AGE035' 'AGE036' 'AGE038' 'AGE046' ...
          'AGE047' 'AGE050' 'AGE051' 'AGE052' 'AGE058'};
conditions = {'switchto','switchaway','mixrepeat','noninf'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
times = {};
starttime = -200:100:1400;
endtime   = starttime+200;
for time_i = 1:length(starttime)
    times{time_i} = strcat(num2str(starttime(time_i)),'to',num2str(endtime(time_i)));
end
CWD  ='E:\fieldtrip\DOWNSAMPLE';
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
condstruct = struct('switchto',freqstruct,'switchaway',freqstruct,'mixrepeat',freqstruct,'noninf',freqstruct);
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
%% Preallocate average structures
freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
                    'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
                    'beta',zeros(length(times),64,64));
condstruct = struct('switchto',freqstruct,'switchaway',freqstruct,'mixrepeat',freqstruct,'noninf',freqstruct);
AVDATA = struct('conditions',condstruct);
clear freqstruct condstruct
tic;
fprintf('Averaging connectivity matrices for:\n');
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
            [AVDATA] = averageConnMats(ALLDATA,cond_i,time_i,AVDATA);
        end%time_i loop
%         sprintf(char(hex2dec('2713')))%checkmark
        fprintf('\n');
    end%cond_i loop
end%name_i loop
toc
clear count cond_i name_i time_i
cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save('AVDATA','AVDATA');
%% Statistics
% First create difference matrices (i.e. condition - mixrepeat)
% Preallocate difference structure
freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
                    'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
                    'beta',zeros(length(times),64,64));
condstruct = struct('switchto',freqstruct,'switchaway',freqstruct,'mixrepeat',freqstruct,'noninf',freqstruct);
DIFFDATA = struct('conditions',condstruct);
clear freqstruct condstruct
fprintf('Creating difference matrices for\n');
tic;
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
            [DIFFDATA] = diffConnMats(ALLDATA,cond_i,name_i,time_i,DIFFDATA);
        end%time_i loop
%         sprintf(char(hex2dec('2713')));%checkmark
        fprintf('\n');
    end%cond_i loop
end%name_i loop
toc
cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save('DIFFDATA','DIFFDATA');
%% Compute t-tests
% First create t-test matrices that will store t-values
% Preallocate t-value & p-value structure
freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
                    'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
                    'beta',zeros(length(times),64,64));
condstruct = struct('switchto',freqstruct,'switchaway',freqstruct,'mixrepeat',freqstruct,'noninf',freqstruct);
TVALS = struct('conditions',condstruct);
PVALS = struct('conditions',condstruct);
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
        [TVALS,PVALS] = ttestConnMats(DIFFDATA,cond_i,time_i,TVALS,PVALS);
    end%time_i loop
    toc
%     sprintf(char(hex2dec('2713')));%checkmark
    fprintf('\n');
end%cond_i loop
cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save('TVALS','TVALS');
save('PVALS','PVALS');
%% Find Significant t-values
% First create t-test matrices that will store significant t-values
% Preallocate t-value & p-value structure
%freqstruct = struct('delta',zeros(length(times),48,48),'theta',zeros(length(times),48,48), ...
%                    'loweralpha',zeros(length(times),48,48),'upperalpha',zeros(length(times),48,48), ...
%                    'beta',zeros(length(times),48,48));
freqstruct = struct('delta',zeros(length(times),64,64),'theta',zeros(length(times),64,64), ...
                    'loweralpha',zeros(length(times),64,64),'upperalpha',zeros(length(times),64,64), ...
                    'beta',zeros(length(times),64,64));
condstruct = struct('switchto',freqstruct,'switchaway',freqstruct,'mixrepeat',freqstruct,'noninf',freqstruct);
SIGTVALS = struct('conditions',condstruct);
clear freqstruct condstruct
fprintf('Searching t-maps for significant values for:\n');
for cond_i = 1:length(conditions)
    fprintf('%s\t',conditions{cond_i});
    for time_i = 1:length(times)
        fprintf('.');
        SIGNIFICANCE = 0.005; %threshold of significance
        [SIGTVALS] = findSigTVals(TVALS,PVALS,cond_i,time_i,SIGTVALS,SIGNIFICANCE);
    end%time_i loop
%     sprintf(char(hex2dec('2713')));%checkmark
    fprintf('\n');
end%cond_i loop
cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save('SIGTVALS','SIGTVALS');
%% Reorder t-Maps to better reflect topology and save off maps
freqstruct = struct('delta',zeros(length(times),48,48),'theta',zeros(length(times),48,48), ...
                    'loweralpha',zeros(length(times),48,48),'upperalpha',zeros(length(times),48,48), ...
                    'beta',zeros(length(times),48,48));
condstruct = struct('switchto',freqstruct,'switchaway',freqstruct,'mixrepeat',freqstruct,'noninf',freqstruct);
REORDSIGTVALS = struct('conditions',condstruct);
fprintf('Reordering t-maps to better reflect topology for:\n');
for cond_i = 1:length(conditions)
    fprintf('%s\t',conditions{cond_i});
    for time_i = 1:length(times)
        fprintf('.');
        [REORDSIGTVALS] = reorderSigTVals(SIGTVALS,cond_i,time_i,REORDSIGTVALS);
    end%time_i loop
%     sprintf(char(hex2dec('2713')));%checkmark
    fprintf('\n');
end%cond_i loop
cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
save('REORDSIGTVALS','REORDSIGTVALS');
%% extract raw data for statistical analyses
% Preferred data structure: 1 line per subject, 72 columns per subject, 3 separate .txt files, one for each different P3 latency window (350-400, 550-600, 750-850):
% O.C.ST.FP	O.C.ST.F	        O.C.ST.C	        O.C.ST.P	      O.C.SW.FP	O.C.SW.F	O.C.SW.C	O.C.SW.P	
% N.C.ST.FP	N.C.ST.F	        N.C.ST.C	        N.C.ST.P	      N.C.SW.FP	N.C.SW.F	N.C.SW.C	N.C.SW.P	
% S.C.ST.FP	S.C.ST.F	        S.C.ST.C	        S.C.ST.P	      S.C.SW.FP	S.C.SW.F	S.C.SW.C	S.C.SW.P	
% O.T1.ST.FP	O.T1.ST.F	O.T1.ST.C	O.T1.ST.P	O.T1.SW.FP	O.T1.SW.F	O.T1.SW.C	O.T1.SW.P	
% N.T1.ST.FP	N.T1.ST.F	N.T1.ST.C	N.T1.ST.P	N.T1.SW.FP	N.T1.SW.F	N.T1.SW.C	N.T1.SW.P	
% S.T1.ST.FP	S.T1.ST.F	S.T1.ST.C	S.T1.ST.P	S.T1.SW.FP	S.T1.SW.F	S.T1.SW.C	S.T1.SW.P	
% O.T3.ST.FP	O.T3.ST.F	O.T3.ST.C	O.T3.ST.P	O.T3.SW.FP	O.T3.SW.F	O.T3.SW.C	O.T3.SW.P	
% N.T3.ST.FP	N.T3.ST.F	N.T3.ST.C	N.T3.ST.P	N.T3.SW.FP	N.T3.SW.F	N.T3.SW.C	N.T3.SW.P	
% S.T3.ST.FP	S.T3.ST.F	S.T3.ST.C	S.T3.ST.P	S.T3.SW.FP	S.T3.SW.F	S.T3.SW.C	S.T3.SW.P
% 
% O= Oddball, N= Go/NoGo, S= Switch
% C= Cue, T1= target1, T3= target3
% ST= stay trial run (horizontal grey Gabor)
% SW= switch trial run (vertical gre Gabor)
% FP= frontopolar ROI, F= frontal ROI, C= central ROI, P= parietal ROI
% Patrick Cooper, 2015
%% 1. Determine study specific working parameters.
clc; clear all; close all;
disp('1. Determine study specific working parameters.');
% set up data directories
workingvolume = 'E:\'; %this would vary per operating system.
wpms          = [];       %working parameters
wpms.dirs     = struct('CWD',[workingvolume 'UIB_DATA' filesep]);
wpms.dirs     = struct('CWD',[workingvolume 'UIB_DATA' filesep], ...
    'PACKAGES',[wpms.dirs.CWD 'PACKAGES' filesep], ...
    'FUNCTIONS',[wpms.dirs.CWD 'FUNCTIONS' filesep], ...
    'PREPROC', [wpms.dirs.CWD 'MTV3 data' filesep], ...
    'DATA_DIR',[wpms.dirs.CWD 'CSD_DATAIN' filesep], ...
    'WAVELET_OUTPUT_DIR',[wpms.dirs.CWD 'WAVELET_OUTPUT' filesep],...
    'COHERENCE_DIR',[wpms.dirs.CWD 'IMAGCOH_OUTPUT' filesep],...
    'ERP_DIR',[wpms.dirs.CWD 'ERP' filesep]);
% set up study conditions
listing                              = dir(wpms.dirs.PREPROC);
wpms.conditions{1,length(listing)-3}           = [];%preallocate,exclude 3 irrevlevant listings
wpms.conditionshort{1,length(wpms.conditions)} = [];
for list_i = 4:length(listing)
    wpms.conditions{1,(list_i-3)} = listing(list_i).name;
    space_index = strfind(wpms.conditions{list_i-3},' ');
    wpms.conditionshort{1,list_i-3} = [wpms.conditions{list_i-3}(1) '-' wpms.conditions{list_i-3}(space_index+1:space_index+3)];
    if wpms.conditionshort{1,list_i-3}(1) == 'G';%go/no go trials labelled as N not G
        wpms.conditionshort{1,list_i-3}(1) = 'N';
    end
end%list_i loop
%set blue gabor short labels
wpms.conditionshort{4} = 'O-blue-BL1';
wpms.conditionshort{5} = 'O-blue-BL3';
% set up participant list
cd([wpms.dirs.PREPROC filesep wpms.conditions{1}])
listing                       = dir('*.set');
participant_index             = find(listing(1).name=='_')-1;%determine location in listing,name where subject string ends
temp_names{1,length(listing)} = [];%preallocate
for list_i = 1:length(listing)
    temp_names{1,list_i} = listing(list_i).name(1:participant_index);
end%list_i loop
wpms.names = unique(temp_names);
wpms.responsetype   = {'R','S'};
clear workingvolume listing temp_names list_i participant_index space_index%tidy as we travel
% add relevant paths
fprintf('\t%s\t%s %s\n','Adding',wpms.dirs.FUNCTIONS,'to MATLAB path');
addpath(genpath(wpms.dirs.FUNCTIONS))%functions
fprintf('\t%s\t%s %s\n','Adding',[wpms.dirs.PACKAGES 'eeglab12_0_1_0b'],'to MATLAB path');
addpath(genpath([wpms.dirs.PACKAGES 'eeglab12_0_1_0b']));%eeglab
%% 2. Set up parameters for data extraction
disp('2. Set up parameters for data extraction');
filename = [wpms.dirs.PREPROC wpms.conditions{1} filesep wpms.names{1} ...
                        '_' wpms.conditionshort{1} '-' wpms.responsetype{1} ...
                        '-C-f.set'];
EEG = pop_loadset(filename);
% set up times
times = EEG.times; 
% set up ROIs
fprintf('\t%s\n','Setting up ROIs for desired output structure');
electrodes = {EEG.chanlocs(:).labels};
ROI_members = {{'Fp1','Fpz','Fp2'};{'F1','FZ','F2'};{'C1','CZ','C2'};{'P1','PZ','P2'}};
ROI = ROI_members;
for ROI_i = 1:length(ROI_members)
    ROI{ROI_i} = {find(ismember(electrodes,ROI_members{ROI_i}))};
end
clear EEG filename electrodes ROI_i%tidy as we travel
timesofinterest = {[350,400];[550,600];[750,850]};%times requested - structs T1,T2,T3 etc. will correspond to these
timestoextract = struct('T1',(find(times==timesofinterest{1}(1)):find(times==timesofinterest{1}(2))), ...
    'T2',(find(times==timesofinterest{2}(1)):find(times==timesofinterest{2}(2))),...
    'T3',(find(times==timesofinterest{3}(1)):find(times==timesofinterest{3}(2))));
timefields = fieldnames(timestoextract);
clear times 
%reorder conditions list to reflect desired output
fprintf('\t%s\n','Shuffling condition order for desired output structure');
conditions = {wpms.conditions{6},wpms.conditions{1},wpms.conditions{9},...
    wpms.conditions{7},wpms.conditions{2},wpms.conditions{10},...
    wpms.conditions{8},wpms.conditions{3},wpms.conditions{11}};
conditionshort = {wpms.conditionshort{6},wpms.conditionshort{1},wpms.conditionshort{9},...
    wpms.conditionshort{7},wpms.conditionshort{2},wpms.conditionshort{10},...
    wpms.conditionshort{8},wpms.conditionshort{3},wpms.conditionshort{11}};
wpms.conditions = conditions;%reordered and removed blue
wpms.conditionshort = conditionshort;
clear conditions conditionshort %tidy as we travel
reference_choice = questdlg('What reference montage do you wish to extract?', ...
	'Reference Data Extraction','Mastoid','Surface Laplacian','Mastoid');
switch reference_choice
    case 'Mastoid'
        datapath = uigetdir(wpms.dirs.ERP_DIR,'Where is mastoid referenced ERP data located?');
    case 'Surface Laplacian'
        datapath = uigetdir(wpms.dirs.ERP_DIR,'Where is surface Laplacian ERP data located?');
end
%% 3. Extract data Main Loop
disp('3. Extract data Main Loop');
for time_i = 1:length(timesofinterest)
    fprintf('\t%s %s %s %s %s %s','Working on temporal window:', num2str(time_i), ':', num2str(timesofinterest{time_i}(1)), 'to', num2str(timesofinterest{time_i}(2)));
    textfilename = [wpms.dirs.ERP_DIR 'Amps_' reference_choice '_' num2str(timesofinterest{time_i}(1)) 'to' num2str(timesofinterest{time_i}(2)) '.txt'];
    fid = fopen(textfilename,'w');
    for name_i = 1:length(wpms.names)
        fprintf('\n\t\t%s %s\t','Participant:', num2str(name_i));
        for cond_i = 1:length(wpms.conditions)
            fprintf('.');
            for response_i = 1:length(wpms.responsetype)
                filename = [datapath filesep ...
                    wpms.names{name_i} filesep wpms.conditions{cond_i} filesep ...
                    wpms.names{name_i} '_' wpms.conditionshort{cond_i} '_' ...
                    wpms.responsetype{response_i} '_erp.mat'];
                load(filename,'ERP');%only the ERP file is needed
                for ROI_i = 1:length(ROI)
                    datavalue = squeeze(mean(mean(ERP(ROI{ROI_i}{1},timestoextract.(timefields{time_i})),1),2));
                    fprintf(fid,'%2.5f\t',datavalue);clear datavalue
                end%ROI_i loop
            end%response_i loop
        end%cond_i loop
        fprintf(fid,'\n');
    end%name_i loop
    fprintf('\n');
    fclose(fid);
end%time_i loop
%% 4. Optional step: check header order is correct
disp('4. Optional step: check header order is correct');
header{1,(length(wpms.conditions)*length(wpms.responsetype)*length(ROI))} = [];
count=0;
for cond_i = 1:length(wpms.conditions)
    for response_i = 1:length(wpms.responsetype)
        for ROI_i = 1:length(ROI)
            count=count+1;
            header{1,count} = [wpms.conditionshort{cond_i} '_' wpms.responsetype{response_i} '_' ROI_members{ROI_i}{1}];
        end%ROI_i loop
    end%response_i loop
end%cond_i loop
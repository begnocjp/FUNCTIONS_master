%af7 af3 f5 f7 f3
clear all;
close all;
clc;
wpms.dirs  = struct('CWD','F:\fieldtrip\','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS\','RAW','RAW\','preproc','PREPROC_OUTPUT\', ...
    'DATA_DIR','EEGLAB_FORMAT\','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR\', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT\');

addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));



labels = {'Fp1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3'; ...
    'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3'; ...
    'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz'; ...
    'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8'; ...
    'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6'; ...
    'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2'};
names = {'DCR104' 'DCR107' 'DCR110' 'DCR111' 'DCR112' 'DCR115' 'DCR118' 'DCR119'...
    'DCR122' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR206' 'DCR208' 'DCR209'...
    'DCR213' 'DCR214' 'DCR217' 'DCR220' 'DCR221' 'DCR223'...
    'DCR204' 'DCR207' 'DCR210' 'DCR211' 'DCR212'  'DCR215' 'DCR218' 'DCR219' 'DCR222'...
    'DCR224' 'DCR225' 'DCR102' 'DCR103'  'DCR106' 'DCR108' 'DCR109' 'DCR113' 'DCR114' ...
    'DCR117' 'DCR120' 'DCR121' 'DCR123'  ...
    'S1' 'S6B' 'S8' 'S11B' 'S15B' 'S16B' 'S18' 'S21' 'S25B' 'S29B'...
    'S31B' 'S36' 'S39' 'S40'...
    'S1B' 'S6' 'S8B' 'S11' 'S15' 'S16' 'S18B' 'S21B' 'S25' 'S29' 'S31' ...
    'S36B' 'S39B' 'S40B'...
    'S4' 'S5B' 'S7B' 'S10' 'S12' 'S14' 'S17' 'S22B' 'S23B' 'S27' 'S28B' 'S30'...
    'S4B' 'S5' 'S7' 'S10B' 'S12B' 'S14B' 'S17B' 'S22' 'S23' 'S27B'...
    'S28' 'S30B'};
groups = {{names{2:22}},{names{23:44}},{names{45:58}},{names{59:71}},{names{73:84}},{names{86:96}}};
%group_names = {{'YoungActive'},{'YoungSham'},{'OldDomActive'},{'OldDomSham'},{'OldNonDomActive'},{'OldNonDomSham'}};
conditions = {'dirleft','dirright','nondirleft','nondirright'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
freq = [{1:18},{19:31},{35:40},{41:47},{48:68}];
increment = 40;
times = 1800:increment:6800;
channels = 1:64;

%make data structure
data.YoungActive = [];
data.YoungSham = [];
data.OldDomActive = [];
data.OldDomSham = [];
data.OldNonDomActive = [];
data.OldNonDomSham = [];

group_names = fieldnames(data);
%% Load and average per Group :
load('DATA_POWER_AVG_FREQ_TIME.mat');
tic;
clc;
for group_i = [6]
    data.(group_names{group_i}) = zeros(length(conditions),length(freq),length(channels),length(times),'single');
    fprintf('Working on GROUP: %s\n',group_names{group_i});
    for cond_i = 1:length(conditions)
        fprintf('\tWorking on Condition: %s\n',conditions{cond_i});
        
        for name_i = 1:length(groups{group_i})
            fprintf('\tWorking on Name: %s: ',groups{group_i}{name_i});
            count = 0;
            nanfound = false;
            for chann = 1:64
                count = count+1;
                fprintf('.');
                A = load([wpms.dirs.CWD  'WAVELET_OUTPUT_DIR' filesep groups{group_i}{name_i} filesep conditions{cond_i} filesep groups{group_i}{name_i} '_' conditions{cond_i} '_' num2str(chann) '_imagcoh_mwtf.mat']);
                for freq_i = 1:length(freq) 
                    for time_i = 1:length(times)
                        data.(group_names{group_i})(cond_i,freq_i,chann,time_i) = squeeze(data.(group_names{group_i})(cond_i,freq_i,chann,time_i)) + single(mean(mean(A.mw_tf(freq{freq_i},(times(time_i)-increment/2):(times(time_i)+increment/2-1)))));
                        if isnan(single(mean(mean(A.mw_tf(freq{freq_i},(times(time_i)-increment/2):(times(time_i)+increment/2-1))))))
                            nanfound = true;
                        end
                    end
                end
            end
            if nanfound == true
                fprintf('CHECK THIS DATAFILE (NAN FOUND)  ');
            end
            fprintf('\n');
        end
        data.(group_names{group_i})(cond_i,:,:,:) = data.(group_names{group_i})(cond_i,:,:,:)./length(groups{group_i});
    end
end
t = toc;
fprintf('Data Loaded: %5.5f Seconds\n',t);
save('DATA_POWER_AVG_FREQ_TIME.mat','data','-v7.3');

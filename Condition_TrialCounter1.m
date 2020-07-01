clear all;close all;clc;
% addpath(rmpath('E:\fieldtrip\PACKAGES\fieldtrip'));
% addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox'));
datadir = 'E:\fieldtrip\PREPROC_OUTPUT\';
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
% groups = {{names{1:22}},{names{23:44}},{names{45:58}},{names{59:72}},{names{73:84}},{names{85:96}}};
conditions = {'dirleft','dirright','nondirleft','nondirright'};

%% 

condlengths = zeros(length(names),length(conditions));

for name_i = 1:length(names);
    fprintf('.')
    for cond_i = 1:length(conditions); 
        filename = [datadir names{name_i} '_' conditions{cond_i} '.mat'];
        a = load (filename);
        cuename = fieldnames(a); 
        condlengths(name_i,cond_i) = length(a.(cuename{1}).trial);
       
    end    
end
for cond_i = 1:length(conditions)
av=mean(condlengths(45:96,cond_i));
st=std(condlengths(45:96,cond_i));
fprintf('%s\t%s\n',num2str(av),num2str(st));
end


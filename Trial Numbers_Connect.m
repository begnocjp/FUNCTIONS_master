%% Get trial numbers for brain connectivity methods section
clear all
close all
warning off;
DATADIR = 'E:\fieldtrip\PREPROC_OUTPUT\';
names = { 'DCR102' 'DCR103' 'DCR106' 'DCR108' 'DCR109' 'DCR113' 'DCR114' 'DCR117' 'DCR120' 'DCR121' ...
    'DCR123' 'DCR204' 'DCR207' 'DCR210' 'DCR211' 'DCR212' 'DCR215' 'DCR218' 'DCR219' 'DCR222' 'DCR224' 'DCR225' 'S1B' ... 
    'S4B' 'S5' 'S6' 'S7' 'S8B' 'S10B' 'S11' 'S12B' 'S14B' 'S15' 'S16' 'S17B' 'S18B' 'S20B' 'S21B' ...
    'S22' 'S23' 'S24B' 'S25' 'S26B' 'S27B' 'S28' 'S29' 'S30B' 'S31B' 'S34' 'S36B' 'S37' 'S38' ...
    'S39B' 'S40B' 'PF001C' 'PF002' 'PF003' 'PF004' 'PF005' 'PF006B' 'PF007B'...
    'PF008C' 'PF009C' 'PM003C' 'PM004C' 'PM006B' 'PM007B' 'PM008B' 'PM009C' 'PM010' 'PM014B' 'PM015'...
    'PM016B' 'PM017C'}; %artefact rejection list
conditions = {'dirleft','dirright','nondirleft','nondirright'};
trialcounts = zeros(length(names));
for name_i = 1:length(names)
    fprintf('.');
    A = load([DATADIR names{name_i} '_ICADATA']);
    datname = fieldnames(A);
    trialcounts(name_i) = length(A.(datname{1}).trialinfo);
end%name_i loop
save([DATADIR 'TrialCounts_priorartrej.txt'],'trialcounts','-ascii','-tabs');
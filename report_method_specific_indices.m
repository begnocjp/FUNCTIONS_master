%% get counts of trials and ICA components for methods section
clear all;close all;clc;
names = {'DCR102'	'DCR103'	'DCR204'	'DCR205'	'DCR106'	'DCR207'	'DCR108'	'DCR109'	'DCR210'	'DCR211'	'DCR212'	'DCR113'	'DCR114'	'DCR215'	'DCR116'	'DCR117'	'DCR218'	'DCR219'	'DCR120'	'DCR121'	'DCR222'	'DCR123'	'DCR224'	'DCR225'...
    'S1B'	'S3'	'S5'	'S6'	'S7'	'S8B'	'S10B'	'S11'	'S12B'	'S13'	'S14B'	'S15'	'S16'	'S17B'	'S18B'	'S20B'	'S21B'	'S22'	'S23'	'S24B'	'S25'	'S27B'	'S28'	'S29'	'S30B'	'S31B'	'S33'	'S34'	'S36B'	'S37'	'S38'	'S39B'	'S40B'};
datain = 'E:/fieldtrip/PREPROC_OUTPUT/';

ica_comp = zeros(1,length(names));
for name_i = 1:length(names)
    fprintf('.');
    filename = [datain names{name_i} '_EOGCORRECTED.mat'];
    load(filename);
    ica_comp(1,name_i) = length(eogcorr.cfg.component);
end

conditions = {'dirleft','dirright','nondirleft','nondirright','nogo'};

trials = zeros(length(names),length(conditions));

for name_i = 1:length(names)
    fprintf('\n%s\t%s\t','Working on Subject:',names{name_i});
    tic;
    for cond_i =1:length(conditions)
        fprintf('.');
        filename = [datain names{name_i} '_' conditions{cond_i} '.mat'];
        A=load(filename);
        fname = fieldnames(A);
        trials(name_i,cond_i) = length(A.(fname{1}).trial);
    end
    t=toc;
    fprintf('%3.2f %s',t,'s');
end
%% for reporting
clc;
for cond_i = 1:length(conditions)
    fprintf('\n%s\t%s\t%s\t%s',conditions{cond_i},num2str(mean(trials(:,cond_i))),'+/-',num2str(std(trials(:,cond_i))));
end
%% now check how many trials were invalid
valid_n = zeros(2,length(names));
for name_i = 1:length(names)
    fprintf('\n%s\t%s\t','Working on Subject:',names{name_i});
    tic;
    filename_prev = [datain names{name_i} '_BadChannRemoved.mat'];
    filename_aft = [datain names{name_i} '_ICADATA.mat'];
    fprintf('.\t');
    A=load(filename_prev);
    fprintf('.\t');
    B=load(filename_aft);
    Afnames = fieldnames(A);
    Bfnames = fieldnames(B);
    valid_n(1,name_i) = length(A.(Afnames{1}).trial);
    valid_n(2,name_i) = length(B.(Bfnames{1}).trial);
    t=toc;
    fprintf('%3.2f %s',t,'s');
end
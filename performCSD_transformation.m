%% performCSD_transformation
% Documentation here.
% Patrick Cooper, 2015
%%
function performCSD_transformation(wpms,name_i,labels)
% check labels is a nx1 array
if size(labels,1) == 1;
    labels = labels';
end
M = ExtractMontage('10-5-System_Mastoids_EGI129.csd',labels);
[G,H] = GetGH(M);
dat = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_ARTFREEDATA']);
datnames = fieldnames(dat);
fprintf('%s\n','Applying CSD transformation');
tic;
for trial_i = 1:length(dat.(datnames{1}).trialinfo);
    if mod(trial_i,50)==0
        fprintf('.');
    end
    tempdata = CSD(squeeze(dat.(datnames{1}).trial{trial_i}(1:64,:)),G,H);
    dat.(datnames{1}).trial{trial_i}(1:64,:) = tempdata;
end
toc

save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSDDATA'], 'dat','-v7.3');
clear D G H M data j
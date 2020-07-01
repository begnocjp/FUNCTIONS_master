function fnl_setup_eegstructure(wpms,conditions,cond,name_i)
%% FNL_SETUP_EEGSTRUCTURE
% Restructure the individual condition files into an EEGLab appropriate
% format for FFT analyses
% USEAGE:
%        fnl_setup_eegstructure(wpms,name_i)
% INPUTS:
%        wpms: working parameters stucture
%        conditions: cell array of conditions (e.g.
%        {'condition_a','condtion_b','condition_c'}
%        cond: cell array of conditions with shorthand labelling
%              can be useful for paradigms with long trial types names
%              -assign to conditions if not required
%        name_i: position in names index
% Patrick Cooper & Aaron Wong
% Functional Neuroimaging Laboratory, University of Newcastle 2014

EEGLAB_DATA_FOLDER = 'EEGLAB_FORMAT\';
mkdir([wpms.dirs.CWD EEGLAB_DATA_FOLDER]);
fieldnames{1,length(cond)} = [];
for cond_i = 1:length(cond)
    fieldnames{cond_i} = {[cond{cond_i} 'data']};
end
datname = struct('nams',fieldnames);
foldername_name = [wpms.names{name_i} '\'];
mkdir([wpms.dirs.CWD EEGLAB_DATA_FOLDER foldername_name]);

for cond_i =1:length(conditions)
    if cond_i == 1
        fprintf('%s\t%s\t%s\t%s\n','Working on:',wpms.names{name_i},'condition:',conditions{cond_i});
    elseif cond_i ~= 1
        fprintf('\t\t\t\t\t%s\t%s\n','condition:',conditions{cond_i});
    end
    mkdir([wpms.dirs.CWD EEGLAB_DATA_FOLDER foldername_name conditions{cond_i}]);
    load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_' conditions{cond_i} '.mat']);
    eval(['data =' datname(cond_i).nams{1,1} ';']);
    for ch_i=1:size(data.trial{1,1},1)
        fprintf('.');
        %determine max number of trials for EEG.data
        maxtime = 0;
        for trial_i = 1:size(data.trial,2)
            if size(data.trial{1,trial_i},2) > maxtime;
                maxtime = size(data.trial{1,trial_i},2);
            end
        end
        EEG.data = zeros(1,maxtime,size(data.trial,2));
        for i = 1:size(data.trial,2)
            for row = 1:size(data.trial{1,i}(ch_i,:),2)
                EEG.data(1,row,i) = single(data.trial{1,i}(ch_i,row));
            end
        end
        EEG.nbchan     = 1;
        EEG.trials     = size(data.trial,2);
        EEG.pnts       = size(data.trial{1},2);
        EEG.srate      = data.fsample;
        EEG.xmin       = data.time{1}(1);
        EEG.xmax       = data.time{1}(end);
        EEG.times      = data.time{1};
        EEG.ref        = []; %'common';
        EEG.comments   = ['Channel: ' ,num2str(ch_i),'(preprocessed with fieldtrip)' ];
        filename = [wpms.dirs.CWD EEGLAB_DATA_FOLDER foldername_name conditions{cond_i} '\' num2str(ch_i),'.mat'];
        save(filename,'EEG','-v7.3');
    end
    fprintf('\n');
end%cond_i loop
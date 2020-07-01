%CSD transform data
%first set up montage
clc;
disp('2. Transform data from mastoid reference to scalp current density montage.');
eeg_system = 'neuroscan';%recording system
cap_type   = '64';%electrode count
addpath(genpath([wpms.dirs.PACKAGES 'CSDtoolbox']));%CSD toolbox
nchans=60;
E = {EEG.chanlocs(1:nchans).labels}';
M = ExtractMontage('10-5-System_Mastoids_EGI129.csd',E);
MapMontage(M)
[G,H] = GetGH(M);%get montage
for name_i = 1:length(wpms.names)
    waitbar_string = sprintf('%s\n\n%s','Working on participant',wpms.names{name_i});
    h = waitbar(0,waitbar_string);
    for cond_i = 1:length(wpms.conditions)
        waitbar(cond_i/length(wpms.conditions),h);
        for response_i = 1:length(wpms.responsetype)
            if strcmp(wpms.conditions{cond_i}(end-2:end),'BL1')==1 || strcmp(wpms.conditions{cond_i}(end-2:end),'BL3')==1%blue oddball have different file names
                filename = [wpms.dirs.PREPROC wpms.conditions{cond_i} filesep wpms.names{name_i} ...
                '-' wpms.conditionshort{cond_i} '-' wpms.responsetype{response_i} ...
                '-f.set'];
            else
            filename = [wpms.dirs.PREPROC wpms.conditions{cond_i} filesep wpms.names{name_i} ...
                '_' wpms.conditionshort{cond_i} '-' wpms.responsetype{response_i} ...
                '-C-f.set'];
            end
            savedir = [wpms.dirs.DATA_DIR wpms.conditions{cond_i} filesep];
            mkdir(savedir);
            savename = [wpms.dirs.DATA_DIR wpms.conditions{cond_i} filesep wpms.names{name_i} ...
                '_' wpms.conditionshort{cond_i} '-' wpms.responsetype{response_i} ...
                '-CSD.set'];
            %first check file doesn't already exist
            if exist(savename,'file')~=2;%not found
                EEG = pop_loadset(filename);
                X = zeros(nchans+2,size(EEG.data,2),size(EEG.data,3));
                fprintf('\n%s %s %s\n','Transforming',num2str(size(EEG.data,3)),'trials');
                for trial_i = 1:size(EEG.data,3);
                    fprintf('.');
                    dat = squeeze(EEG.data(1:60,:,trial_i));
                    X(1:60,:,trial_i) = CSD(dat,G,H);
                end
                EEG.data = X;
                EEG = pop_saveset(EEG,'filename',savename);
            end
        end
    end
    delete(h);
end

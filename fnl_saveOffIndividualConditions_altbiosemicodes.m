function fnl_saveOffIndividualConditions_altbiosemicodes(wpms,name_i)
load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_REPAIRED_AND_REFERENCED.mat'])
data = refdat;
clear refdat;
fprintf('%s\t%s\n', 'Working on:', wpms.names{name_i});

%% AllRepeat
fprintf('\t\t\t%s\n', 'Searching for AllRepeat');
arv = [65411 65421 65431 65412 65422 65432];
indices = zeros(length(data.trial),1);
cnt = 0;
for k = 1:length(data.trialinfo(:,1));
    for j = 1:size(arv,2);
        if arv(1,j) == data.trialinfo(k,1);
            indices(k,1) = 1;
            cnt = cnt+1;
        end
    end
end
ardat = [];
tlen = length(data.time{1,1});
j = 1;
for k = 1:length(indices)
    if indices(k,1) == 1;
        x = data.trial{1,k}(1:72,1:tlen);
        ardat{1,j} = x;
        clear x
        x = data.trialinfo(k,1);
        artrinf(j,1) = x;
        clear x
        x = data.sampleinfo(k,1:2);
        arsmpinf(j,1:2) = x;
        clear x
        j = j +1;
    end
end
ardata = [];
ardata = data;
ardata.trial = ardat;
ardata.trialinfo = artrinf;
ardata.sampleinfo = arsmpinf;
y = length(ardata.trial);
ardata.time = data.time(1:y);
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSD_allrepeat.mat'],'ardata');
clear y ardata ardat artrinf arsmpinf
%% MixRepeat
fprintf('\t\t\t%s\n', 'Searching for MixRepeat');
mrv = [65441 65442 65451 65452 65461 65462];
indices = zeros(length(data.trial),1);
cnt = 0;
for k = 1:length(data.trialinfo(:,1));
    for j = 1:size(mrv,2);
        if mrv(1,j) == data.trialinfo(k,1);
            indices(k,1) = 1;
            cnt = cnt+1;
        end
    end
end
mrdat = [];
tlen = length(data.time{1,1});
j = 1;
for k = 1:length(indices)
    if indices(k,1) == 1;
        x = data.trial{1,k}(1:72,1:tlen);
        mrdat{1,j} = x;
        clear x
        x = data.trialinfo(k,1);
        mrtrinf(j,1) = x;
        clear x
        x = data.sampleinfo(k,1:2);
        mrsmpinf(j,1:2) = x;
        clear x
        j = j +1;
    end
end
mrdata = [];
mrdata = data;
mrdata.trial = mrdat;
mrdata.trialinfo = mrtrinf;
mrdata.sampleinfo = mrsmpinf;
y = length(mrdata.trial);
mrdata.time = data.time(1:y);
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSD_mixrepeat.mat'],'mrdata');
clear y mrdata mrdat mrtrinf mrsmpinf

%% SwitchTo
fprintf('\t\t\t%s\n', 'Searching for SwitchTo');
stv = [65443 65444 65453 65454 65463 65464];
indices = zeros(length(data.trial),1);
cnt = 0;
for k = 1:length(data.trialinfo(:,1));
    for j = 1:size(stv,2);
        if stv(1,j) == data.trialinfo(k,1);
            indices(k,1) = 1;
            cnt = cnt+1;
        end
    end
end
stdat = [];
tlen = length(data.time{1,1});
j = 1;
for k = 1:length(indices)
    if  indices(k,1) == 1;
        x = data.trial{1,k}(1:72,1:tlen);
        stdat{1,j} = x;
        clear x
        x = data.trialinfo(k,1);
        sttrinf(j,1) = x;
        clear x
        x = data.sampleinfo(k,1:2);
        stsmpinf(j,1:2) = x;
        clear x
        j = j +1;
    end
end

stdata = [];
stdata = data;
stdata.trial = stdat;
stdata.trialinfo = sttrinf;
stdata.sampleinfo = stsmpinf;
y = length(stdata.trial);
stdata.time = data.time(1:y);
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSD_switchto.mat'],'stdata');
clear y stdata stdat sttrinf stsmpinf

%% SwitchAway
fprintf('\t\t\t%s\n', 'Searching for SwitchAway');
sav = [65445 65446 65455 65456 65465 65466];
indices = zeros(length(data.trial),1);
cnt = 0;
for k = 1:length(data.trialinfo(:,1));
    for j = 1:size(sav,2);
        if sav(1,j) == data.trialinfo(k,1);
            indices(k,1) = 1;
            cnt = cnt+1;
        end
    end
end
sadat = [];
tlen = length(data.time{1,1});
j = 1;
for k = 1:length(indices)
    if  indices(k,1) == 1;
        x = data.trial{1,k}(1:72,1:tlen);
        sadat{1,j} = x;
        clear x
        x = data.trialinfo(k,1);
        satrinf(j,1) = x;
        clear x
        x = data.sampleinfo(k,1:2);
        sasmpinf(j,1:2) = x;
        clear x
        j = j +1;
    end
end
sadata = [];
sadata = data;
sadata.trial = sadat;
sadata.trialinfo = satrinf;
sadata.sampleinfo = sasmpinf;
y = length(sadata.trial);
sadata.time = data.time(1:y);
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSD_switchaway.mat'],'sadata');
clear y sadata sadat satrinf sasmpinf

%% NonInf
fprintf('\t\t\t%s\n', 'Searching for NonInformative');
niv = [65447 65448 65449 65450 65457 65458 65459 65460 65467 65468 65469 65470];
indices = zeros(length(data.trial),1);
cnt = 0;
for k = 1:length(data.trialinfo(:,1));
    for j = 1:size(niv,2);
        if niv(1,j) == data.trialinfo(k,1);
            indices(k,1) = 1;
            cnt = cnt+1;
        end
    end
end
nidat = [];
tlen = length(data.time{1,1});
j = 1;
for k = 1:length(indices)
    if  indices(k,1) == 1;
        x = data.trial{1,k}(1:72,1:tlen);
        nidat{1,j} = x;
        clear x
        x = data.trialinfo(k,1);
        nitrinf(j,1) = x;
        clear x
        x = data.sampleinfo(k,1:2);
        nismpinf(j,1:2) = x;
        clear x
        j = j +1;
    end
end
nidata = [];
nidata = data;
nidata.trial = nidat;
nidata.trialinfo = nitrinf;
nidata.sampleinfo = nismpinf;
y = length(nidata.trial);
nidata.time = data.time(1:y);
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSD_noninf.mat'],'nidata');
clear y nidata nidat nitrinf nismpinf

%% NonInfRepeat
nrv = [65447 65448 65457 65458 65467 65468];%[167 168  177 178  187 188 ];   %[169 170 179 180 189 190]
indices = zeros(length(data.trial),1);
cnt = 0;
for k = 1:length(data.trialinfo(:,1));
    for j = 1:size(nrv,2);
        if nrv(1,j) == data.trialinfo(k,1);
            indices(k,1) = 1;
            cnt = cnt+1;
        end
    end
end
nrdat = [];
tlen = length(data.time{1,1});
j = 1;
for k = 1:length(indices)
    if  indices(k,1) == 1;
        x = data.trial{1,k}(1:72,1:tlen);
        nrdat{1,j} = x;
        clear x
        x = data.trialinfo(k,1);
        nrtrinf(j,1) = x;
        clear x
        x = data.sampleinfo(k,1:2);
        nrsmpinf(j,1:2) = x;
        clear x
        j = j +1;
    end
end
nrdata = [];
nrdata = data;
nrdata.trial = nrdat;
nrdata.trialinfo = nrtrinf;
nrdata.sampleinfo = nrsmpinf;
y = length(nrdata.trial);
nrdata.time = data.time(1:y);
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSD_noninfrepeat.mat'],'nrdata');
clear y nrdata nrdat nrtrinf nrsmpinf

%% NonInfSwitch
nsv = [65449 65450 65459 65460  65469 65470];%[169 170 179 180 189 190];
indices = zeros(length(data.trial),1);
cnt = 0;
for k = 1:length(data.trialinfo(:,1));
    for j = 1:size(nsv,2);
        if nsv(1,j) == data.trialinfo(k,1);
            indices(k,1) = 1;
            cnt = cnt+1;
        end
    end
end
nsdat = [];
tlen = length(data.time{1,1});
j = 1;
for k = 1:length(indices)
    if  indices(k,1) == 1;
        x = data.trial{1,k}(1:72,1:tlen);
        nsdat{1,j} = x;
        clear x
        x = data.trialinfo(k,1);
        nstrinf(j,1) = x;
        clear x
        x = data.sampleinfo(k,1:2);
        nssmpinf(j,1:2) = x;
        clear x
        j = j +1;
    end
end
nsdata = [];
nsdata = data;
nsdata.trial = nsdat;
nsdata.trialinfo = nstrinf;
nsdata.sampleinfo = nssmpinf;
y = length(nsdata.trial);
nsdata.time = data.time(1:y);
save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_CSD_noninfswitch.mat'],'nsdata');
clear y nsdata nsdat nstrinf nssmpinf
clear all
%% extract conditions from trial info for processing
names = wpms.names;
for name_i = 1:length(names)
    load(strcat(names(1,name_i).pnum,'_CSDDATA.mat'));
    % Directional Left
    dlv = [21];
    indices = zeros(length(data.trial),1);
    cnt = 0;
    for k = 1:length(data.trialinfo(:,1));
        for j = 1:size(dlv,2);
            if dlv(1,j) == data.trialinfo(k,1);
                indices(k,1) = 1;
                cnt = cnt+1;
            end
        end
    end
    dldat = [];
    tlen = length(data.time{1,1});
    j = 1;
    for k = 1:length(indices)
        if indices(k,1) == 1;
            x = data.trial{1,k}(1:64,1:tlen);
            dldat{1,j} = x;
            clear x
            x = data.trialinfo(k,1);
            dltrinf(j,1) = x;
            clear x
            x = data.sampleinfo(k,1:2);
            dlsmpinf(j,1:2) = x;
            clear x
            j = j +1;
        end
    end
    dldata = [];
    dldata = data;
    dldata.trial = dldat;
    dldata.trialinfo = dltrinf;
    dldata.sampleinfo = dlsmpinf;
    y = length(dldata.trial);
    dldata.time = data.time(1:y);
    clear y
    save(strcat(names(1,name_i).pnum,'_CSD_dirleft.mat'),'dldata');
    clearvars -except data names name_i
    %Directional Right
    drv = [32];
    indices = zeros(length(data.trial),1);
    cnt = 0;
    for k = 1:length(data.trialinfo(:,1));
        for j = 1:size(drv,2);
            if drv(1,j) == data.trialinfo(k,1);
                indices(k,1) = 1;
                cnt = cnt+1;
            end
        end
    end
    drdat = [];
    tlen = length(data.time{1,1});
    j = 1;
    for k = 1:length(indices)
        if  indices(k,1) == 1;
            x = data.trial{1,k}(1:64,1:tlen);
            drdat{1,j} = x;
            clear x
            x = data.trialinfo(k,1);
            drtrinf(j,1) = x;
            clear x
            x = data.sampleinfo(k,1:2);
            drsmpinf(j,1:2) = x;
            clear x
            j = j +1;
        end
    end
    
    drdata = [];
    drdata = data;
    drdata.trial = drdat;
    drdata.trialinfo = drtrinf;
    drdata.sampleinfo = drsmpinf;
    y = length(drdata.trial);
    drdata.time = data.time(1:y);
    clear y
    save(strcat(names(1,name_i).pnum,'_CSD_dirright.mat'),'drdata');
    clearvars -except data names name_i
    %Non-Directional Left
    nlv = [11];
    indices = zeros(length(data.trial),1);
    cnt = 0;
    for k = 1:length(data.trialinfo(:,1));
        for j = 1:size(nlv,2);
            if nlv(1,j) == data.trialinfo(k,1);
                indices(k,1) = 1;
                cnt = cnt+1;
            end
        end
    end
    nldat = [];
    tlen = length(data.time{1,1});
    j = 1;
    for k = 1:length(indices)
        if  indices(k,1) == 1;
            x = data.trial{1,k}(1:64,1:tlen);
            nldat{1,j} = x;
            clear x
            x = data.trialinfo(k,1);
            nltrinf(j,1) = x;
            clear x
            x = data.sampleinfo(k,1:2);
            nlsmpinf(j,1:2) = x;
            clear x
            j = j +1;
        end
    end
    nldata = [];
    nldata = data;
    nldata.trial = nldat;
    nldata.trialinfo = nltrinf;
    nldata.sampleinfo = nlsmpinf;
    y = length(nldata.trial);
    nldata.time = data.time(1:y);
    clear y
    save(strcat(names(1,name_i).pnum,'_CSD_nondirleft.mat'),'nldata');
    clearvars -except data names name_i
    %Non-Directional Right
    nrv = [12];
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
            x = data.trial{1,k}(1:64,1:tlen);
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
    clear y
        save(strcat(names(1,name_i).pnum,'_CSD_nondirright.mat'),'nrdata');
    clearvars -except names name_i
end
clear all
%% extract conditions from trial info for processing

for name_i = [14 24 25 26 27 28 29]
    load(strcat(names(1,name_i).pnum,'_CSDDATA.mat'));
    % MixRepeat
    mrv = [161 162 171 172 181 182];
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
            x = data.trial{1,k}(1:64,1:tlen);
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
    clear y
    save(strcat(names(1,name_i).pnum,'_CSD_mixrepeat.mat'),'mrdata');
    clearvars -except data names name_i
    %SwitchTo
    stv = [163 164 173 174 183 184];
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
            x = data.trial{1,k}(1:64,1:tlen);
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
    clear y
    save(strcat(names(1,name_i).pnum,'_CSD_switchto.mat'),'stdata');
    clearvars -except data names name_i
    %SwitchAway
    sav = [165 166 175 176 185 186];
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
            x = data.trial{1,k}(1:64,1:tlen);
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
    clear y
    save(strcat(names(1,name_i).pnum,'_CSD_switchaway.mat'),'sadata');
    clearvars -except data names name_i
    %NonInf
    niv = [167 168 169 170 177 178 179 180 187 188 189 190];
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
            x = data.trial{1,k}(1:64,1:tlen);
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
    clear y
        save(strcat(names(1,name_i).pnum,'_CSD_noninf.mat'),'nidata');
    clearvars -except names name_i
end
clear all
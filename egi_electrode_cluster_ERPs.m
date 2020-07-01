%% Create ERP clusters
% Change the cluster name for each new


wpms.dirs  = struct('CWD','E:\fieldtrip\','packages','PACKAGES', ...
    'FUNCTIONS','FUNCTIONS\','RAW','RAW\','preproc','PREPROC_OUTPUT\', ...
    'DATA_DIR','EEGLAB_FORMAT\','WAVELET_OUTPUT_DIR','WAVELET_OUTPUT_DIR\', ...
    'COHERENCE_DIR','IMAGCOH_OUTPUT\','EEGDispOutput','EEGDISPLAY_OUTPUT\');

wpms.names = {'7108 CGNG002','7166 CGNG002','7166_2 CGNG002'}; 
% wpms.names = {'7102 Aud002','7108 Aud002','7151 Aud002','7166 AUD002','7170 Aud002','7175 Aud002','7191 Aud002','7195 Aud002',...
%     '7102_2Aud002','7108 2Aud002','7151 2Aud002','7166 2_AUD002','7170 2Aud002','7175 2Aud002','7191 2AUD002','7195_2 AUD002'};

%{'7187 CGNG002','7102 CGNG002','7108 CGNG002','7151 CGNG002','7166 CGNG002','7170 CGNG002','7175 CGNG002','7191 CGNG002','7195 CGNG002',...,
%     '7187 2 CGNG002','7102 2CGNG002','7108 2CGNG002','7151 2CGNG002','7166_2 CGNG002','7170 2CGNG002','7175 2CGNG002','7191 2CGNG002','7195_2 CGNG002'};
% wpms.names = {'7108 CGNG002','7151 CGNG002','7166 CGNG002','7170 CGNG002','7191 CGNG002','7195 CGNG002',...
%     '7108 2CGNG002','7151 2CGNG002','7166_2 CGNG002','7170 2CGNG002','7191 2CGNG002','7195_2 CGNG002'};

% conditions = {'std+','trgt'};
%shorthand for naming files and data structure:
% cond = {'std','tgt'};

condition_code_values.std = 1;
condition_code_values.tgt = 2;
sampling_frequency = 250;

labels = {'E1','E2','E3','E4','E5','E6','E7','E8','E9','E10','E11','E12','E13','E14','E15','E16','E17','E18','E19','E20','E21','E22','E23','E24','E25','E26',...
    'E27','E28','E29','E30','E31','E32','E33','E34','E35','E36','E37','E38','E39','E40','E41','E42','E43','E44','E45','E46','E47','E48','E49','E50','E51','E52',...
    'E53','E54','E55','E56','E57','E58','E59','E60','E61','E62','E63','E64','E65','E66','E67','E68','E69','E70','E71','E72','E73','E74','E75','E76','E77','E78',...
    'E79','E80','E81','E82','E83','E84','E85','E86','E87','E88','E89','E90','E91','E92','E93','E94','E95','E96','E97','E98','E99','E100','E101','E102','E103','E104',...
    'E105','E106','E107','E108','E109','E110','E111','E112','E113','E114','E115','E116','E117','E118','E119','E120','E121','E122','E123','E124','E125','E126','E127','E128'}';

% eleclist = {'54','55','61','62','68','79','80'};
% eleclist = [54; 55; 61; 62; 68; 79; 80];

addpath(genpath([wpms.dirs.CWD,wpms.dirs.FUNCTIONS]));
addpath(genpath([wpms.dirs.CWD,wpms.dirs.packages '\fieldtrip']));
%% Clusters for Oddball

FZeleclist = [4; 5; 10; 11; 12];
CZeleclist = [7; 32; 55; 81; 107];
PZeleclist = [54; 55; 61; 62; 68; 79; 80];
electrodelist = {FZeleclist, CZeleclist,PZeleclist};
clust = {'frontal','central','parietal'};
conditions = {'std+','trgt'};
cond = {'std','tgt'};

for list_i = 1:length(electrodelist)
    for name_i = 1:length(wpms.names)
        cond_i = 1; %:length(conditions)
        load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',conditions{cond_i},'.mat']);
        
        tmpdat = stddata.trial;
        tempdata = zeros(length(electrodelist{list_i}),501);
        tmpdata = tmpdat{1,1};
        cluster = [];
        cluster.trial = zeros(1,501);
        
        eleclist = electrodelist{list_i};
        
        for elec_i = 1:length(eleclist)
            
            tmpelec = tmpdata(eleclist(elec_i),:);
            
            %
            %         tempdata.trial = tmpdat.trial(eleclist);
            %         tempdata.trialinfo = mean_temptrinf;
            %         tempdata.sampleinfo = mean_tempsmpinf;
            %         y = length(tempdata.trial);
            
            tempdata(elec_i,:) = tmpelec;
            
            clear tmpelec
            
            %         tempdata.time = refdat.time(1:y);
            
            
        end
        meantmp = mean(tempdata(:,:));
        cluster.trial = {meantmp};
        cluster.trialinfo = stddata.trialinfo;
        cluster.sampleinfo = stddata.sampleinfo;
        cluster.fsample = 250;
        cluster.label = {labels{name_i}};
        cluster.time = stddata.time;
        
        varname = [cond{cond_i},'cluster'];
        eval([varname,' = cluster;']);
        
        
        save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',cond{cond_i}, clust{list_i} 'cluster.mat'], varname);
        cfg = [];
        
        eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',cond{cond_i},'_' clust{list_i} 'Cluster.erp'');'])
        
        clusterdata.std = cluster;
        
        clear cluster tmpdat tmpdata tempdata varname meantmp stddata
        
        %%  Second Condition
        
        cond_i = 2; %:length(conditions)
        load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',conditions{cond_i},'.mat']);
        
        tmpdat2 = tgtdata.trial;
        tempdata2 = zeros(length(electrodelist{list_i}),501);
        tmpdata2 = tmpdat2{1,1};
        cluster2 = [];
        cluster2.trial = zeros(1,501);
        eleclist = electrodelist{list_i};
        
        for elec_i = 1:length(eleclist)
            
            tmpelec2 = tmpdata2(eleclist(elec_i),:);
            
            %
            %         tempdata.trial = tmpdat.trial(eleclist);
            %         tempdata.trialinfo = mean_temptrinf;
            %         tempdata.sampleinfo = mean_tempsmpinf;
            %         y = length(tempdata.trial);
            
            tempdata2(elec_i,:) = tmpelec2;
            
            clear tmpelec2
            
            %         tempdata.time = refdat.time(1:y);
            
            
        end
        
        meantmp2 = mean(tempdata2(:,:));
        cluster2.trial = {meantmp2};
        cluster2.trialinfo = tgtdata.trialinfo;
        cluster2.sampleinfo = tgtdata.sampleinfo;
        cluster2.fsample = 250;
        cluster2.label = {labels{name_i}};
        cluster2.time = tgtdata.time;
        
        varname = [cond{cond_i},'cluster2'];
        eval([varname,' = cluster2;']);
        
        
        save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',cond{cond_i}, clust{list_i} 'cluster.mat'], varname);
        cfg = [];
        
        eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',cond{cond_i},'_' clust{list_i} 'Cluster.erp'');'])
        
        clear varname cluster2 tmpdat2 tempdata2 tgtdata
        
    end
end

%% Cz Cluster fo Go/Nogo

FZeleclist = [4; 5; 10; 11; 12];
CZeleclist = [7; 32; 55; 81; 107];
PZeleclist = [54; 55; 61; 62; 68; 79; 80];
electrodelist = {FZeleclist,CZeleclist,PZeleclist}; %
clust = {'frontal','central','pareital'}; % 
conditions = {'leftgo','rightgo','nogo'};
cond = {'ltar','rtar','nogo'};

for list_i = 1:length(electrodelist)
    for name_i = 1:length(wpms.names)
        cond_i = 1; %:length(conditions)
        load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',conditions{cond_i},'.mat']);
        
        tmpdat = ltardata.trial;
        tempdata = zeros(length(electrodelist{list_i}),1251);
        tmpdata = tmpdat{1,1};
        cluster = [];
        cluster.trial = zeros(1,1251);
        
        eleclist = electrodelist{list_i};
        
        for elec_i = 1:length(eleclist)
            
            tmpelec = tmpdata(eleclist(elec_i),:);
            
            %
            %         tempdata.trial = tmpdat.trial(eleclist);
            %         tempdata.trialinfo = mean_temptrinf;
            %         tempdata.sampleinfo = mean_tempsmpinf;
            %         y = length(tempdata.trial);
            
            tempdata(elec_i,:) = tmpelec;
            
            clear tmpelec
            
            %         tempdata.time = refdat.time(1:y);
            
            
        end
        meantmp = mean(tempdata(:,:));
        cluster.trial = {meantmp};
        cluster.trialinfo = ltardata.trialinfo;
        cluster.sampleinfo = ltardata.sampleinfo;
        cluster.fsample = 250;
        cluster.label = {labels{name_i}};
        cluster.time = ltardata.time;
        
        varname = [cond{cond_i},'cluster'];
        eval([varname,' = cluster;']);
        
        
        save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',cond{cond_i}, clust{list_i} 'cluster.mat'], varname);
        cfg = [];
        
        eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_', cond{cond_i},'_' clust{list_i} 'Cluster.erp'');'])
        
%         clusterdata.std = cluster;
        
        clear cluster tmpdat tmpdata tempdata varname meantmp stddata
        
        %%  Second Condition
        cond_i = 2; %:length(conditions)
        load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',conditions{cond_i},'.mat']);
        
        tmpdat2 = rtardata.trial;
        tempdata2 = zeros(length(electrodelist{list_i}),1251);
        tmpdata2 = tmpdat2{1,1};
        cluster2 = [];
        cluster2.trial = zeros(1,1251);
        eleclist = electrodelist{list_i};
        
        for elec_i = 1:length(eleclist)
            
            tmpelec2 = tmpdata2(eleclist(elec_i),:);
            
            %
            %         tempdata.trial = tmpdat.trial(eleclist);
            %         tempdata.trialinfo = mean_temptrinf;
            %         tempdata.sampleinfo = mean_tempsmpinf;
            %         y = length(tempdata.trial);
            
            tempdata2(elec_i,:) = tmpelec2;
            
            clear tmpelec2
            
            %         tempdata.time = refdat.time(1:y);
            
            
        end
        
        meantmp2 = mean(tempdata2(:,:));
        cluster2.trial = {meantmp2};
        cluster2.trialinfo = rtardata.trialinfo;
        cluster2.sampleinfo = rtardata.sampleinfo;
        cluster2.fsample = 250;
        cluster2.label = {labels{name_i}};
        cluster2.time = rtardata.time;
        
        varname = [cond{cond_i},'cluster2'];
        eval([varname,' = cluster2;']);
        
        
        save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',cond{cond_i}, clust{list_i} 'cluster.mat'], varname);
        cfg = [];
        
        eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',cond{cond_i},'_' clust{list_i} 'Cluster.erp'');'])
        
        clear varname cluster2 tmpdat2 tempdata2 tgtdata
        
        %%  Third Condition
        cond_i = 3; %:length(conditions)
        load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',conditions{cond_i},'.mat']);
        
        tmpdat3 = nogodata.trial;
        tempdata3 = zeros(length(electrodelist{list_i}),1251);
        tmpdata3 = tmpdat3{1,1};
        cluster3 = [];
        cluster3.trial = zeros(1,1251);
        eleclist = electrodelist{list_i};
        
        for elec_i = 1:length(eleclist)
            
            tmpelec3 = tmpdata3(eleclist(elec_i),:);
            
            %
            %         tempdata.trial = tmpdat.trial(eleclist);
            %         tempdata.trialinfo = mean_temptrinf;
            %         tempdata.sampleinfo = mean_tempsmpinf;
            %         y = length(tempdata.trial);
            
            tempdata3(elec_i,:) = tmpelec3;
            
            clear tmpelec3
            
            %         tempdata.time = refdat.time(1:y);
            
            
        end
        
        meantmp3 = mean(tempdata3(:,:));
        cluster3.trial = {meantmp3};
        cluster3.trialinfo = nogodata.trialinfo;
        cluster3.sampleinfo = nogodata.sampleinfo;
        cluster3.fsample = 250;
        cluster3.label = {labels{name_i}};
        cluster3.time = nogodata.time;
        
        varname = [cond{cond_i},'cluster3'];
        eval([varname,' = cluster3;']);
        
        
        save([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_',cond{cond_i}, clust{list_i} 'cluster.mat'], varname);
        cfg = [];
        
        eval(['FT2EEGDisplay(cfg,',varname,',''',wpms.dirs.CWD wpms.dirs.EEGDispOutput wpms.names{name_i} '_',cond{cond_i},'_' clust{list_i} 'Cluster.erp'');'])
        
        clear varname cluster3 tmpdat3 tempdata3 tgtdata
        
    end
end
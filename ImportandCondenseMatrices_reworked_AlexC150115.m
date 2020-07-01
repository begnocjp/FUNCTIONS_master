%% Statistical Analyses of Connectivity Data
% Reworked version of ImportandCondenseMatrices 
% Removed reliance on eval functions to speed up processing pipeline
% Reworked script of Patrick Cooper by Alexander Conley, University of Newcastle
% May, 2014
%% Set up globals
clear all
close all
warning off;
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
     'S28' 'S30B'}; %artefact rejection list
groups = {{names{1:22}},{names{23:44}},{names{45:58}},{names{59:72}},{names{73:84}},{names{85:96}}};
conditions = {'dirleft','dirright','nondirleft','nondirright'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
times = {};
starttime = -500:100:2500;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%adjust these
endtime   = starttime+200;
for time_i = 1:length(starttime)
    times{time_i} = strcat(num2str(starttime(time_i)),'to',num2str(endtime(time_i)));
end

CWD   = 'E:\fieldtrip';
% NWD = 'F:\fieldtrip';

IMAG ='\IMAGCOH_OUTPUT';
addpath(genpath('F:\fieldtrip\FUNCTIONS\mass_uni_toolbox')); %for FDR correction
addpath('F:\fieldtrip\FUNCTIONS');
addpath([CWD,IMAG]);
%% Generate file list and load files into structure
% list of files to be read in
filelist{1,(length(names)*length(conditions)*length(times))} = [];
count = 0;
for name_i = 1:length(names)
    for cond_i = 1:length(conditions)
        for time_i = 1:length(times)
            count = count+1;
            filelist(count) = strcat(CWD,IMAG,'\',names(name_i),'\',conditions(cond_i),'\',conditions(cond_i),times(time_i),'_CONECTIVITY_IMAG.mat');
        end%time_i loop
    end%cond_i loop
end%name_i loop
clear count name_i cond_i time_i freqstruct condstruct
%% Preallocate structure that house ALL data
%  ALLDATA.conditions.{condition}.{frequency}(Subject,Times,64,64)
%  {condition} == switchto switchaway noninf mixrepeat
%  {frequency} == delta theta loweralpha upperalpha beta
GROUPS = {'YOUNG_ACT','YOUNG_SHAM','DOM_ACT','DOM_SHAM','NONDOM_ACT','NONDOM_SHAM'};
count = 0;
for group_i = 1:length(GROUPS)
    freqstruct = struct('delta',zeros(length(groups{group_i}),length(times),64,64),'theta',zeros(length(groups{group_i}),length(times),64,64), ...
        'loweralpha',zeros(length(groups{group_i}),length(times),64,64),'upperalpha',zeros(length(groups{group_i}),length(times),64,64), ...
        'beta',zeros(length(groups{group_i}),length(times),64,64));
    condstruct = struct('dirleft',freqstruct,'dirright',freqstruct,'nondirleft',freqstruct,'nondirright',freqstruct);
    ALLDATA = struct('conditions',condstruct);
    % load data into structure
    tic;
    fprintf('Loading data for:\n');
    for name_i = 1:length(groups{group_i})
        fprintf('\n%s %s\t','Participant',groups{group_i}{name_i})
        for cond_i = 1:length(conditions)
            if cond_i == 1
                fprintf('%s\t',conditions{cond_i});
            elseif cond_i ~= 1
                fprintf('\t\t\t\t\t%s\t',conditions{cond_i});
            end
            for time_i = 1:length(times)
                fprintf('.');
                count = count+1;
                filename = filelist(1,count);
                ALLDATA = readConnMats(filename,name_i,cond_i,time_i,ALLDATA);
            end%time_i loop
            %         sprintf(char(hex2dec('2713')))%checkmark
            fprintf('\n');
        end%cond_i loop
    end%name_i loop
    toc
    % save off structure
    mkdir([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
    cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\']);
    save(['ALLDATA_' GROUPS{group_i}],'ALLDATA');
end%group_i loop
%% perform ttests
for group_i = 1:2:(length(GROUPS)-1)
    TVALS = zeros(length(times),length(conditions),length(frequencies),64,64);
    PVALS = zeros(length(times),length(conditions),length(frequencies),64,64);
    % load data into structure
    A= load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ALLDATA_' GROUPS{group_i}]);%active
    S= load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ALLDATA_' GROUPS{group_i+1}]);%sham
    for cond_i = 1:length(conditions)
        tic;
        if cond_i == 1
            fprintf('%s\t',conditions{cond_i});
        elseif cond_i ~= 1
            fprintf('\t\t\t\t\t%s\t',conditions{cond_i});
        end
        for time_i = 1:length(times)
            fprintf('.');
            for freq_i = 1:length(frequencies)
                for row = 1:64
                    for col = 1:64
                        x = abs(squeeze(A.ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(:,time_i,row,col)));
                        y = abs(squeeze(S.ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(:,time_i,row,col)));
                        [~,PVALS(time_i,cond_i,freq_i,row,col),~,stats] = ttest2(x,y);
                        TVALS(time_i,cond_i,freq_i,row,col) = stats.tstat;
                    end
                end
            end
        end%time_i loop
        fprintf('\n');
        toc
    end%cond_i loop
    % save off structure
    mkdir([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ABS\']);
    cd([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ABS\']);
    save(['TVALS' GROUPS{group_i}],'TVALS');
    save(['PVALS' GROUPS{group_i}],'PVALS');
end%group_i loop
%% now test for significance
SIGLEVEL = 0.01;
for group_i = 1:2:(length(GROUPS)-1)
    fprintf('\n%s\t%s\t','Working on group:',GROUPS{group_i});
    load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ABS\TVALS' GROUPS{group_i}]);
    load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ABS\PVALS' GROUPS{group_i}]);
    ADJ_P = zeros(size(PVALS));
    SIG_T = zeros(size(TVALS));
    for time_i = 1:length(times)
        fprintf('.');
        for cond_i = 1:length(conditions)
            for freq_i = 1:length(frequencies)
                [h,CP,ADJ_P(time_i,cond_i,freq_i,:,:)] = fdr_bh(tril(squeeze(PVALS(time_i,cond_i,freq_i,:,:))),SIGLEVEL,'pdep');
            end
        end
    end
    SIG_T(ADJ_P<0.01) = TVALS(ADJ_P<0.01);
    save(['ADJ_TVALS' GROUPS{group_i}],'SIG_T');
    save(['ADJ_PVALS' GROUPS{group_i}],'ADJ_P');
end%group_i loop
clims = [-4 4];
for i = 1:31
    count=0;
    for c = 1:4
        for f = 1:5
            count = count+1;
            subplot(4,5,count);imagesc(squeeze(SIG_T(i,c,f,:,:)),clims);title(['Time: ' times{i}]);
        end
    end
    pause(0.5)
end
%% visualise connections
labels = {'Fp1',	'AF7',	'AF3',	'F1',	'F3',	'F5',	'F7',	'FT7',	'FC5',	'FC3',	'FC1',	'C1',	'C3',	'C5',	'T7',	'TP7',	'CP5',	'CP3',	'CP1',	'P1',	'P3',	'P5',	'P7',	'P9',	'PO7',	'PO3',	'O1',	'Iz',	'Oz',	'POz',	'Pz',	'CPz',	'Fpz',	'Fp2',	'AF8',	'AF4',	'Afz',	'Fz',	'F2',	'F4',	'F6',	'F8',	'FT8',	'FC6',	'FC4',	'FC2',	'FCz',	'Cz',	'C2',	'C4',	'C6',	'T8',	'TP8',	'CP6',	'CP4',	'CP2',	'P2',	'P4',	'P6',	'P8',	'P10',	'PO8',	'PO4',	'O2'};
for group_i = 1:2:(length(GROUPS)-1)
    fprintf('\n%s\t%s\t','Working on group:',GROUPS{group_i});
    load([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ABS\ADJ_TVALS' GROUPS{group_i}]);
    for time_i = 1:length(times)
        fprintf('.');
        for cond_i = 1:length(conditions)
            for freq_i = 1:length(frequencies)
                [row_ind,col_ind] = find(tril(squeeze(SIG_T(time_i,cond_i,freq_i,:,:))));
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                    pairlist{row_i,3} = squeeze(SIG_T(time_i,cond_i,freq_i,row_ind(row_i),col_ind(row_i)));
                end%row_i loop
                figtitle = [conditions{cond_i},'-',frequencies{freq_i},'-',times{time_i}];
                mkdir([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ABS\', GROUPS{group_i},'\']);
                save([CWD,'\ANALYSES\CONNECTIVITY_MATRICES\ABS\', GROUPS{group_i},'\',figtitle,'_pairlist'],'pairlist');
            end
        end
    end
end%group_i loop
%% plot onto headmap
cd('E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\ABS\');
addpath(genpath('C:\Users\ac027\Documents\eeglab13_1_1b')); %for reading locations
eloc = readlocs('montage.sph','filetype','sph');
numchan = length(eloc)-8;
X = zeros(1,numchan);
Y = zeros(1,numchan);
Z = zeros(1,numchan);
count = 0;
name ={};
for i = 1:numchan;
    count = count+1;
    name{count} = eloc(1,i).labels;
    X(count) = eloc(1,i).X;
    Y(count) = eloc(1,i).Y;
    Z(count) = eloc(1,i).Z;
    
end
name{37} = 'Afz';
name{1} = 'Fp1';
for group_i =   1:2:(length(GROUPS)-1)
    cd(['E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\ABS\' GROUPS{group_i}]);
    figure1 = figure();
    listing_pairlist = dir(['*_pairlist.mat']);
    for file_i = 1:length(listing_pairlist)
        load(listing_pairlist(file_i).name)
        scatter3(X,Y,Z,10,'filled');
        view(gca,[-90 90]);
        axis('equal')
        grid('off')
        hold on;    
        %test pair
        count_array = ones(length(X),1);
        ACTIVE_COUNT = 0;
        SHAM_COUNT = 0;
        for pair_i = 1:size(pairlist,1)
%             name{26} = 'Afz';
            p1 = pairlist(pair_i,1);
            p2 = pairlist(pair_i,2);        
            [~,index1] = ismember(p1,name);
            [~,index2] = ismember(p2,name);
            count_array(index1) = count_array(index1)+1;
            count_array(index2) = count_array(index2)+1;        
            fprintf('%s, %s: %i, %i \n', pairlist{pair_i,1}, pairlist{pair_i,2}, index1, index2)
            plotX = [X(index1),X(index2)];
            plotY = [Y(index1),Y(index2)];
            plotZ = [Z(index1),Z(index2)];
            if pairlist{pair_i,3} < 0;
                plot3(plotX,plotY,plotZ,'Color','blue');
                SHAM_COUNT = SHAM_COUNT+1;
            elseif pairlist{pair_i,3} > 0;
                ACTIVE_COUNT = ACTIVE_COUNT+1;
                plot3(plotX,plotY,plotZ,'Color','red');
            end
            CONN_COUNT(group_i, cond_i, freq_i, time_i, 1) = ACTIVE_COUNT;
            CONN_COUNT(group_i, cond_i, freq_i, time_i, 2) = SHAM_COUNT;
            
        end
        scatter3(X,Y,Z,20*count_array,'filled');
        for name_i = 1:length(name)
            text(X(name_i),Y(name_i),Z(name_i),[' ',name{name_i}]);

        end
        set(gcf,'Color','white');
        axis off;
        saveas(gcf, [listing_pairlist(file_i).name,'.fig'], 'fig');
        saveas(gcf, [listing_pairlist(file_i).name,'.pdf'], 'pdf');
        close all;
    end
end%group_i loop

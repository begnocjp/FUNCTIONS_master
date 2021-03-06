%analysis job for connectivity data
%global variables
clear all
close all
warning off;
names = { 'DCR102' 'DCR104' 'DCR105' 'DCR106' 'DCR107' 'DCR108' 'DCR109' 'DCR110' 'DCR111' ... 
    'DCR112' 'DCR113' 'DCR114' 'DCR115' 'DCR116' 'DCR117' 'DCR118' 'DCR119' 'DCR120' 'DCR121' ...
    'DCR122' 'DCR123' 'DCR124' 'DCR125' 'DCR202' 'DCR204' 'DCR205' 'DCR206' 'DCR207' ... 
    'DCR208' 'DCR209' 'DCR210' 'DCR211' 'DCR212' 'DCR213' 'DCR214' 'DCR215' 'DCR216' 'DCR217' ... 
    'DCR218' 'DCR219' 'DCR220' 'DCR221' 'DCR222' 'DCR223' 'DCR224' 'DCR225' 'S1' 'S1B' 'S3' 'S3B'... 
    'S4' 'S4B' 'S5' 'S5B' 'S6' 'S6B' 'S7' 'S7B' 'S8' 'S8B' 'S10' 'S10B' 'S11' 'S11B' 'S12' 'S12B'  ...
    'S14' 'S14B' 'S15' 'S15B' 'S16' 'S16B' 'S17' 'S17B' 'S18' 'S18B' 'S19' 'S19B' 'S20' 'S20B' 'S21' 'S21B' ...
    'S22' 'S22B' 'S23' 'S23B' 'S24' 'S24B' 'S25' 'S25B' 'S26' 'S26B' 'S27' 'S27B' 'S28' 'S28B' 'S29' 'S29B' ...
    'S30' 'S30B' 'S31' 'S31B' 'S32' 'S32B' 'S33' 'S33B' 'S34' 'S34B' 'S36' 'S36B' 'S37' 'S37B' 'S38' 'S38B' ...
    'S39' 'S39B' 'S40' 'S40B'};
conditions  = {'dirleft','dirright','nondirleft','nondirright'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
CWD  ='E:\fieldtrip';
IMAG ='\IMAGCOH_OUPUT';
addpath(genpath([CWD,'\FUNCTIONS\mass_uni_toolbox\'])); %for FDR correction
addpath(genpath([CWD,'\FUNCTIONS']));


START_ARRAY = [200,1300];

load([CWD,'\FUNCTIONS\LIST_ACTIVE_SHAM.mat']);
%% load in networks for each participant per time bin
% preallocate arrays for each time bin
% this outputs 3D matrices - first dimension = participant
%                          - second and third are 64x64 matrix
% output variable names are in the format:
%                                         frequency_starttimetoendtime

% The following 2 variables are times which the analysis should run: 
% i.e. START_T is the Start time for filename start number
% i.e. END_T is the end time for the filename number
% So the loop can know where to start the analysis and stop the analysis.

%START_T = 0;
%END_T = 400;


%[ACTIVE_OR_SHAM, NAMES/2 or SIZE(ACTIVE or SHAM), ELECTRODESxELECTRODES]

for freq_i = 1:length(frequencies)
    for cond_i = 1:length(conditions)
        for starttime = START_ARRAY; %START_T:100END_T
            endtime = starttime + 200;
            freq = cell2mat(frequencies(1,freq_i));
            cond = cell2mat(conditions(1,cond_i));
            matname = [freq,'_',cond,'_',num2str(starttime),'to',num2str(endtime)];
            eval([matname '= zeros(2,length(names)/2,64,64);']) 
            %fprintf('.');
        end%starttime loop
    end%conditions loop
end%frequency loop
fprintf('\n');
%preallocate average structures
%[ACTIVE_OR_SHAM, ELECTRODESxELECTRODES]
for freq_i = 1:length(frequencies)
    for cond_i = 1:length(conditions)
        for starttime = START_ARRAY; %START_T:100END_T
            endtime = starttime + 200;
            freq = cell2mat(frequencies(1,freq_i));
            cond = cell2mat(conditions(1,cond_i));
            matname = [freq,'_',cond,'_',num2str(starttime),'to',num2str(endtime),'_average'];
            eval([matname '= zeros(2,64,64);'])
            %fprintf('.');
        end%starttime loop
    end%conditions loop
end%frequency loop
fprintf('\n');
clear freq cond matname ans freq_i cond_i starttime endtime
% load each participant's data into the above matrices
CWD = 'F:\fieldtrip';
for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    fprintf('%s %4.0f %s %4.0f\n','Collapsing matrices from:',starttime,'to',endtime);
    for active_sham_count = 1:2
        if active_sham_count == 1
            names = ACTIVE;
        else 
            names = SHAM;
        end
        for names_i = 1:length(names)
            currentparticipant = names(1,names_i);
            fprintf('%s %s\n\n','Current Participant Processing:', currentparticipant{1,1});
              for cond_i = 1:length(conditions)
                tic;
                currentcond = conditions(1,cond_i);
                fprintf('%s %s \n','Currently Processing: ',currentcond{1,1});
                DIR = strcat(CWD,IMAG,'\',names(1,names_i),'\');
                filename = strcat(DIR,conditions(1,cond_i),'\',conditions(1,cond_i),num2str(starttime),'to',num2str(endtime),'_CONECTIVITY_IMAG');
                dat = load(filename{1,1});
                outputmatrixsuffix = ['_',num2str(starttime),'to',num2str(endtime)];
                %create frequency names for matrices below
                deltamat      = ['delta_' currentcond{1,1} outputmatrixsuffix];
                thetamat      = ['theta_' currentcond{1,1} outputmatrixsuffix];
                loweralphamat = ['loweralpha_' currentcond{1,1} outputmatrixsuffix];
                upperalphamat = ['upperalpha_' currentcond{1,1} outputmatrixsuffix];
                betamat       = ['beta_' currentcond{1,1} outputmatrixsuffix];
                for matdim_a = 1:64;
                    %fprintf('\n');
                    for matdim_b = 1:64;
                        %fprintf('.');
                        eval([deltamat '(active_sham_count,names_i,matdim_a,matdim_b) = dat.ConnectivityMatrix_delta(matdim_a,matdim_b);']);
                        %fprintf('.');
                        eval([thetamat '(active_sham_count,names_i,matdim_a,matdim_b) = dat.ConnectivityMatrix_theta(matdim_a,matdim_b);']);
                        %fprintf('.');
                        eval([loweralphamat '(active_sham_count,names_i,matdim_a,matdim_b) = dat.ConnectivityMatrix_loweralpha(matdim_a,matdim_b);']);
                        %fprintf('.');
                        eval([upperalphamat '(active_sham_count,names_i,matdim_a,matdim_b) = dat.ConnectivityMatrix_upperalpha(matdim_a,matdim_b);']);
                        %fprintf('.');
                        eval([betamat '(active_sham_count,names_i,matdim_a,matdim_b) = dat.ConnectivityMatrix_beta(matdim_a,matdim_b);']);
                        %fprintf('.');
                    end%matdim_b loop
                end%matdim_a loop
                fprintf('\n');
                toc;
              end%cond_i loop
        end%names_i loop
    end%ACTIVE_SHAM LOOP
end%starttime loop

%% Save collapsed and average matrices
conndir = strcat(CWD,'\','CONNECTIVITY_MATRICES');
mkdir(conndir);
for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timedir = strcat('\',num2str(starttime),'to',num2str(endtime));
    for cond_i = 1:length(conditions)
        conddir   = strcat(conndir,'\',conditions(1,cond_i),timedir);
        conddirav = strcat(conddir,'\','AVERAGEMATRIX');
        mkdir(conddir{1,1});
        mkdir(conddirav{1,1});
        for freq_i = 1:length(frequencies)
            filename   = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',num2str(starttime),'to',num2str(endtime));
            avfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',num2str(starttime),'to',num2str(endtime),'_average');
            filedir    = strcat(conddir,'\');
            filedirav  = strcat(conddirav,'\');
            savename   = strcat(filedir,filename);
            savenameav = strcat(filedirav,avfilename);
            save(savename{1,1},filename{1,1});
%             for dim1 = 1:size(delta_switchto_0to200,1) % poor form to have variable name like this but can't think of solution
                for dim2 = 1:size(delta_nondirleft_1300to1500,3)
                    for dim3 = 1:size(delta_nondirleft_1300to1500,4)
                        eval([avfilename{1,1} '(1,dim2,dim3) = mean(' filename{1,1} '(1,1:size(' filename{1,1} ,',1),dim2,dim3));']);
                        eval([avfilename{1,1} '(2,dim2,dim3) = mean(' filename{1,1} '(2,1:size(' filename{1,1} ,',1),dim2,dim3));']);
                    end%dim3 loop
                end%dim2 loop
%             end%dim1 loop
            save(savenameav{1,1},avfilename{1,1});
            figure();
            eval(['imagesc(squeeze(' avfilename{1,1} '(1,:,:)))']);
            title([avfilename{1,1}, ' ACTIVE']);
            saveas(gcf,strcat(savenameav{1,1},'ACTIVE'),'fig');
            saveas(gcf,strcat(savenameav{1,1},'ACTIVE'), 'psc2');
            figure();
            eval(['imagesc(squeeze(' avfilename{1,1} '(2,:,:)))']);
            title([avfilename{1,1}, ' SHAM']);
            %saveas(gcf,strcat(savenameav{1,1}),'bmp');
            saveas(gcf,strcat(savenameav{1,1},'SHAM'),'fig');
            saveas(gcf,strcat(savenameav{1,1},'SHAM'), 'psc2');
            close all
        end%freq_i loop
    end%cond_i loop
end%starttime loop

%% Statistics
% Compute t-values
% only do this on non-edge electrodes to control for CSD edge effects

% load matrices from above step
conndir = strcat(CWD,'\','CONNECTIVITY_MATRICES');
cd(conndir);
for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timedir = strcat('\',num2str(starttime),'to',num2str(endtime));
    for cond_i = 1:length(conditions)
        conddir   = strcat(conndir,'\',conditions(1,cond_i),timedir);
        conddirav = strcat(conddir,'\','AVERAGEMATRIX');
        for freq_i = 1:length(frequencies)
            filename   = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',num2str(starttime),'to',num2str(endtime));
            avfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',num2str(starttime),'to',num2str(endtime),'_average');
            filedir    = strcat(conddir,'\');
            filedirav  = strcat(conddirav,'\');
            savename   = strcat(filedir,filename);
            savenameav = strcat(filedirav,avfilename);
            load(savename{1,1},filename{1,1});
        end%freq_i loop
    end%cond_i loop
end%starttime loop
%%
% preallocate matrices
for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Preallocate matrices:',timeperiod);
    for cond_i = 1:2 % 1:4
        fprintf('\n');
        for freq_i = 1:length(frequencies)
            fprintf('.');
            differencename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff_CUE');
            eval([differencename{1,1} ' = zeros(size(ACTIVE),64,64);']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop

% create differences for each condition
% Make the basecondition SHAM:
%
% we should have 59 participants
% each participant has one active, and one sham.

for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timeperiod = [num2str(starttime) 'to' num2str(endtime)];
    fprintf('%s %s\n','Computing differences during:',timeperiod);
    for cond_i = 1:2 %exclude mixrepeats as this condition is the reference condition
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies) 
            tic;
            
            fprintf('\n');
            fprintf('%s %s\n','Current Frequency band:',frequencies{1,freq_i});
            filename        = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod);
            referencename1  = strcat(frequencies(1,freq_i),'_',conditions(1,3),'_',timeperiod);
            referencename2  = strcat(frequencies(1,freq_i),'_',conditions(1,4),'_',timeperiod);
            a1 = reshape(eval(referencename1{1,1}),2*59,64,64);
            a2 = reshape(eval(referencename2{1,1}),2*59,64,64);
            NONDIR = [a1;a2];
            mean_NONDIR = squeeze(mean(NONDIR,1));
            
            differencename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff_CUE');
            for dim1 = 1:size(delta_nondirleft_1300to1500,2)
                fprintf('.');
                for dim2 = 1:64
                    for dim3 = 1:64
                        str = [differencename{1,1} '(dim1,dim2,dim3) = ' filename{1,1} '(2,dim1,dim2,dim3) - mean_NONDIR(dim2,dim3);'];
                        %display(str)
                        eval(str);
                    end
                end
            end
            toc
        end%freq_i loop
    end%cond_i loop
end%starttime loop
%
% save difference for each condition
mkdir([CWD '\' 'ANALYSES\SHAM\DifferenceMatrices']);
cd([CWD '\' 'ANALYSES\SHAM\DifferenceMatrices']);
for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timeperiod = [num2str(starttime) 'to' num2str(endtime)];
    fprintf('%s %s\n','Saving during:',timeperiod);
    for cond_i = 1:2 % 1:4 %exclude mixrepeats as this condition is the reference condition
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies)
            filename       = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff_CUE');
            eval(['save(''' filename{1,1} '.mat'', ''' filename{1,1} ''')']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop

% load differences for each condition
cd([CWD '\' 'ANALYSES\SHAM\DifferenceMatrices']);
for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timeperiod = [num2str(starttime) 'to' num2str(endtime)];
    fprintf('%s %s\n','Loading during:',timeperiod);
    for cond_i = 1:2 % 1:4 %exclude mixrepeats as this condition is the reference condition
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies)
            filename       = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff_CUE');
            eval(['load(''' filename{1,1} '.mat'')']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop

%
% compute ttests
for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Computing tmaps for:',timeperiod);
    for cond_i = 1:2 % 1:4;
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
%        dir = strcat(CWD,'\CONNECTIVITY_MATRICES\',conditions(1,cond_i),'\',timeperiod);
%        cd(dir{1,1});
        for freq_i = 1:length(frequencies)
            fprintf('\n');
            fprintf('%s %s\n','Current Frequency band:',frequencies{1,freq_i});
            differencename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff_CUE');
            for dim1 = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 ...
                    25 26 27 29 30 31 32 36 37 38 39 40 41 44 45 46 ...
                    47 48 49 50 51 54 55 56 57 58 59 60 62 63 64];
                fprintf('.');
                for dim2 = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 ...
                        25 26 27 29 30 31 32 36 37 38 39 40 41 44 45 46 ...
                        47 48 49 50 51 54 55 56 57 58 59 60 62 63 64];
                    eval(['[h,p,ci,tstat] = ttest(' differencename{1,1} '(:,dim1,dim2),0);']);
                    eval([differencename{1,1} '_tvals(dim1,dim2) = tstat.tstat;']);
                    eval([differencename{1,1} '_pvals(dim1,dim2) = p;']);
                end%dim2 loop
            end%dim1 loop
        end%freq_i loop
    end%cond_i loop
end%starttime loop

%% find significant differences
% if found, place tvalue in new structure
% preallocate matrices
for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Preallocate matrices:',timeperiod);
    for cond_i = 1:2 % 1:4
        fprintf('\n');
%         fprintf('     ');
        for freq_i = 1:length(frequencies)
%             fprintf('\b\b\b\b%1.2f',freq_i/length(frequencies)); 
            fprintf('.');
            tmapfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_CUE_TMAP');
            SIMfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_CUE_SIM');
            eval([tmapfilename{1,1} ' = zeros(64,64);']);
            eval([SIMfilename{1,1} ' = zeros(64,64);']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop


for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Searching pvals and tmaps for:',timeperiod);
    for cond_i = 1:2 % 1:4
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
%         dir = strcat(CWD,'\CONNECTIVITY_MATRICES\',conditions(1,cond_i),'\',timeperiod);
%         cd(dir{1,1});
        for freq_i = 1:length(frequencies)
            fprintf('\n');
            fprintf('%s %s\n','Current Frequency band:',frequencies{1,freq_i});
            pvalfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff_CUE_pvals');
            tvalfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff_CUE_tvals');
            tmapfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_CUE_TMAP');
            SIMfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_CUE_SIM');
            for dim1 = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 ...
                    25 26 27 29 30 31 32 36 37 38 39 40 41 44 45 46 ...
                    47 48 49 50 51 54 55 56 57 58 59 60 62 63 64];
                 fprintf('.');
                for dim2 = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 ...
                        25 26 27 29 30 31 32 36 37 38 39 40 41 44 45 46 ...
                        47 48 49 50 51 54 55 56 57 58 59 60 62 63 64];
                       eval(['[h, crit_p, adj_p] = fdr_bh(' pvalfilename{1,1} '(dim1,dim2), 0.005, ''pdep'',''no'');']);
                        if h == 1;
                            %beep
                            eval([tmapfilename{1,1} '(dim1,dim2) = ' tvalfilename{1,1} '(dim1,dim2);']);
                            eval([SIMfilename{1,1} '(dim1,dim2) = ' 'adj_p;']);
                            % build tmap value count here!
                        end%logical test search loop
                end%dim2 loop
            end%dim1 loop
        end%freq_i loop
    end%cond_i loop
end%starttime loop

% display and save off tmaps
% first reorder and remove channels
maxcount = 0;
for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Trimming tmaps:',timeperiod);
    for cond_i = 1:2 % 1:4
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies)
            fprintf('\n');
            fprintf('%s %s\n','Current Frequency band:',frequencies{1,freq_i});
            SIMfilename     = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_CUE_SIM');
            tmapfilename     = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_CUE_TMAP');
            tmaptrimfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_TMAP_trimmed');
            SIMtrimfilename  = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_SIM_trimmed');
            count = 0;
            for olddim_row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 ...
                    25 26 27 29 30 31 32 36 37 38 39 40 41 44 45 46 ...
                    47 48 49 50 51 54 55 56 57 58 59 60 62 63 64];
                count = count + 1;
                cnt = 0;
                for olddim_col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 ...
                        25 26 27 29 30 31 32 36 37 38 39 40 41 44 45 46 ...
                        47 48 49 50 51 54 55 56 57 58 59 60 62 63 64];
                    cnt = cnt+1;
                    eval([tmaptrimfilename{1,1} '(count,cnt) = ' tmapfilename{1,1} '(olddim_row,olddim_col);']);
                    eval([SIMtrimfilename{1,1} '(count,cnt) = ' SIMfilename{1,1} '(olddim_row,olddim_col);']);
                end%olddim_row
            end%olddim_col
            %min max value calculation here!
            maxcount = maxcount + 1;
            eval(['maxvals(1,maxcount) = max(max(abs(' tmaptrimfilename{1,1} ')));']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop
%reorder matrices to better reflect topology
mkdir([CWD,'\ANALYSES\SHAM\SIM']);
cd([CWD,'\ANALYSES\SHAM\SIM']);
for starttime = START_ARRAY; %START_T:100END_T
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Reordering and saving tmaps:',timeperiod);
    for cond_i = 1:2 % 1:4
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies)
            fprintf('\n');
            fprintf('%s %s\n','Current Frequency band:',frequencies{1,freq_i});
            tmaptrimfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_TMAP_trimmed');
            tmapreorderfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_TMAP_reordered');
            SIMtrimfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_SIM_trimmed');
            SIMreorderfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_SIM_reordered');
            count = 0;
            for olddim_row = [1 2 3 4 25 26 27 28 29 30 5 6 7 31 32 33 34 ...
                    8 9 10 35 36 37 38 11 12 13 39 40 41 24 14 15 16 ...
                    17 23 42 43 44 45 18 19 20 21 22 46 47 48];
                    count = count + 1;
                    cnt = 0;
                for olddim_col = [1 2 3 4 25 26 27 28 29 30 5 6 7 31 32 33 34 ...
                        8 9 10 35 36 37 38 11 12 13 39 40 41 24 14 15 16 ...
                        17 23 42 43 44 45 18 19 20 21 22 46 47 48];
                    cnt = cnt+1;
                    eval([tmapreorderfilename{1,1} '(count,cnt) = ' tmaptrimfilename{1,1} '(olddim_row,olddim_col);']);
                    eval([SIMreorderfilename{1,1} '(count,cnt) = ' SIMtrimfilename{1,1} '(olddim_row,olddim_col);']);
                end%olddim_row
            end%olddim_col
            xlabels = {'AF3','F1','F3','F5','AF4','Afz','Fz','F2','F4', ...
                'F6','FC5','FC3','FC1','FC6','FC4','FC2','FCz','C1', ...
                'C3','C5','Cz','C2','C4','C6','CP5','CP3','CP1', ...
                'CP6','CP4','CP2','CPz','P1','P3','P5','P7','Pz', ...
                'P2','P4','P6','P8','PO7','PO3','O1','Oz','POz', ...
                'PO8','PO4','O2'};
            figure();
            clims = [ -6 6 ];
            eval(['imagesc(' tmapreorderfilename{1,1} ',clims);'])
            set(gca,'XTick',1:48);
            set(gca,'XTickLabel',xlabels);
            xticklabel_rotate([],90,[],'Fontsize',7);
            set(gca,'YTick',1:48);
            set(gca,'YTickLabel',xlabels);
            set(gca,'YDir','normal');
            set(gca,'Fontsize',7);
            title(tmapreorderfilename{1,1});
            colorbar;
            savedir = strcat(CWD,'\ANALYSES\SHAM\SIM\');
%            mkdir(savedir);
             savename    = strcat(savedir,tmapreorderfilename{1,1});
            savenameSIM = strcat(savedir,SIMreorderfilename{1,1});
             saveas(gcf,savename,'bmp');
             saveas(gcf,savename,'fig');
            close all
             save(savename,tmapreorderfilename{1,1});
            save(savenameSIM,SIMreorderfilename{1,1});
        end%freq_i loop
    end%cond_i loop
end%starttime loop

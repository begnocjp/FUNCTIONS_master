%analysis job for connectivity data
%global variables
clear all
close all
warning off;
names = {'AGE002','AGE003','AGE008','AGE012','AGE013','AGE014', ...
         'AGE015','AGE017','AGE018','AGE019','AGE021','AGE022', ...
         'AGE023','AGE024','AGE026','AGE027','AGE028','AGE030', ...
         'AGE032','AGE033','AGE035','AGE036','AGE038','AGE046', ...
         'AGE047','AGE050','AGE051','AGE052','AGE058'};
conditions = {'switchto','switchaway','noninf','mixrepeat'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
CWD  ='E:\fieldtrip';
IMAG ='\IMAGCOH_OUPUT';
addpath(genpath('C:\Users\c3075693\Documents\fdr_bh')); %for FDR correction
%% load in networks for each participant per time bin
% preallocate arrays for each time bin
% this outputs 3D matrices - first dimension = participant
%                          - second and third are 64x64 matrix
% output variable names are in the format:
%                                         frequency_starttimetoendtime
for freq_i = 1:length(frequencies)
    for cond_i = 1:length(conditions)
        for starttime = 0:100:1400;
            endtime = starttime + 200;
            freq = cell2mat(frequencies(1,freq_i));
            cond = cell2mat(conditions(1,cond_i));
            matname = [freq,'_',cond,'_',num2str(starttime),'to',num2str(endtime)];
            eval([matname '= zeros(length(names),64,64);'])
            fprintf('.');
        end%starttime loop
    end%conditions loop
end%frequency loop
fprintf('\n');
%preallocate average structures
for freq_i = 1:length(frequencies)
    for cond_i = 1:length(conditions)
        for starttime = 0:100:1400;
            endtime = starttime + 200;
            freq = cell2mat(frequencies(1,freq_i));
            cond = cell2mat(conditions(1,cond_i));
            matname = [freq,'_',cond,'_',num2str(starttime),'to',num2str(endtime),'_average'];
            eval([matname '= zeros(64,64);'])
            fprintf('.');
        end%starttime loop
    end%conditions loop
end%frequency loop
fprintf('\n');
clear freq cond matname ans freq_i cond_i starttime endtime
% load each participant's data into the above matrices
for starttime = 0:100:1400
    endtime = starttime + 200;
    fprintf('%s %4.0f %s %4.0f\n','Collapsing matrices from:',starttime,'to',endtime);
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
                fprintf('\n');
                for matdim_b = 1:64;
                    fprintf('.');
                    eval([deltamat '(names_i,matdim_a,matdim_b) = dat.ConnectivityMatrix_delta(matdim_a,matdim_b);']);
                    fprintf('.');
                    eval([thetamat '(names_i,matdim_a,matdim_b) = dat.ConnectivityMatrix_theta(matdim_a,matdim_b);']);
                    fprintf('.');
                    eval([loweralphamat '(names_i,matdim_a,matdim_b) = dat.ConnectivityMatrix_loweralpha(matdim_a,matdim_b);']);
                    fprintf('.');
                    eval([upperalphamat '(names_i,matdim_a,matdim_b) = dat.ConnectivityMatrix_upperalpha(matdim_a,matdim_b);']);
                    fprintf('.');
                    eval([betamat '(names_i,matdim_a,matdim_b) = dat.ConnectivityMatrix_beta(matdim_a,matdim_b);']);
                    fprintf('.');
                end%matdim_b loop
            end%matdim_a loop
            fprintf('\n');
            toc;
          end%cond_i loop
    end%names_i loop
end%starttime loop

%% Save collapsed and average matrices
conndir = strcat(CWD,'\','CONNECTIVITY_MATRICES');
mkdir(conndir);
for starttime = 0:100:1400
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
                for dim2 = 1:size(delta_switchto_0to200,2)
                    for dim3 = 1:size(delta_switchto_0to200,3)
                        eval([avfilename{1,1} '(dim2,dim3) = mean(' filename{1,1} '(1:size(' filename{1,1} ,',1),dim2,dim3));']);
                    end%dim3 loop
                end%dim2 loop
%             end%dim1 loop
            save(savenameav{1,1},avfilename{1,1});
            figure();
            eval(['imagesc(' avfilename{1,1} ')']);
            title(avfilename{1,1});
            saveas(gcf,strcat(savenameav{1,1}),'bmp');
            saveas(gcf,strcat(savenameav{1,1}),'fig');
            saveas(gcf,strcat(savenameav{1,1}), 'psc2');
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
for starttime = 0:100:1400
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

% preallocate matrices
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Preallocate matrices:',timeperiod);
    for cond_i = 1:3
        fprintf('\n');
        for freq_i = 1:length(frequencies)
            fprintf('.');
            differencename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff');
            eval([differencename{1,1} ' = zeros(29,64,64);']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop

% create differences for each condition
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = [num2str(starttime) 'to' num2str(endtime)];
    fprintf('%s %s\n','Computing differences during:',timeperiod);
    for cond_i = 1:3 %exclude mixrepeats as this condition is the reference condition
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies) 
            tic;
            fprintf('\n');
            fprintf('%s %s\n','Current Frequency band:',frequencies{1,freq_i});
            filename       = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod);
            referencename  = strcat(frequencies(1,freq_i),'_mixrepeat_',timeperiod);
            differencename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff');
            for dim1 = 1:size(beta_mixrepeat_0to200,1)
                fprintf('.');
                for dim2 = 1:64
                    for dim3 = 1:64
                        eval([differencename{1,1} '(dim1,dim2,dim3) = ' filename{1,1} '(dim1,dim2,dim3) - ' referencename{1,1} '(dim1,dim2,dim3);']);
                    end
                end
            end
            toc
        end%freq_i loop
    end%cond_i loop
end%starttime loop

% save difference for each condition
cd([CWD '\' 'ANALYSES\DifferenceMatrices']);
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = [num2str(starttime) 'to' num2str(endtime)];
    fprintf('%s %s\n','Saving during:',timeperiod);
    for cond_i = 1:3 %exclude mixrepeats as this condition is the reference condition
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies)
            filename       = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff');
            eval(['save(''' filename{1,1} '.mat'', ''' filename{1,1} ''')']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop

% load differences for each condition
cd([CWD '\' 'ANALYSES\DifferenceMatrices']);
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = [num2str(starttime) 'to' num2str(endtime)];
    fprintf('%s %s\n','Loading during:',timeperiod);
    for cond_i = 1:3 %exclude mixrepeats as this condition is the reference condition
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies)
            filename       = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff');
            eval(['load(''' filename{1,1} '.mat'')']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop


% compute ttests
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Computing tmaps for:',timeperiod);
    for cond_i = 1:3;
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        dir = strcat(CWD,'\CONNECTIVITY_MATRICES\',conditions(1,cond_i),'\',timeperiod);
        cd(dir{1,1});
        for freq_i = 1:length(frequencies)
            fprintf('\n');
            fprintf('%s %s\n','Current Frequency band:',frequencies{1,freq_i});
            differencename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff');
            for dim1 = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 ...
                    25 26 27 29 30 31 32 36 37 38 39 40 41 44 45 46 ...
                    47 48 49 50 51 54 55 56 57 58 59 60 62 63 64];
                fprintf('.');
                for dim2 = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 ...
                        25 26 27 29 30 31 32 36 37 38 39 40 41 44 45 46 ...
                        47 48 49 50 51 54 55 56 57 58 59 60 62 63 64];
                    eval(['[h,p,ci,tstat] = ttest(' differencename{1,1} '(1:29,dim1,dim2),0);']);
                    eval([differencename{1,1} '_tvals(dim1,dim2) = tstat.tstat;']);
                    eval([differencename{1,1} '_pvals(dim1,dim2) = p;']);
                end%dim2 loop
            end%dim1 loop
        end%freq_i loop
    end%cond_i loop
end%starttime loop

% find significant differences
% if found, place tvalue in new structure
% preallocate matrices
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Preallocate matrices:',timeperiod);
    for cond_i = 1:3
        fprintf('\n');
%         fprintf('     ');
        for freq_i = 1:length(frequencies)
%             fprintf('\b\b\b\b%1.2f',freq_i/length(frequencies)); 
            fprintf('.');
            tmapfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_TMAP');
            SIMfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_SIM');
            eval([tmapfilename{1,1} ' = zeros(64,64);']);
            eval([SIMfilename{1,1} ' = zeros(64,64);']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop


for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Searching pvals and tmaps for:',timeperiod);
    for cond_i = 1:3
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
%         dir = strcat(CWD,'\CONNECTIVITY_MATRICES\',conditions(1,cond_i),'\',timeperiod);
%         cd(dir{1,1});
        for freq_i = 1:length(frequencies)
            fprintf('\n');
            fprintf('%s %s\n','Current Frequency band:',frequencies{1,freq_i});
            pvalfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff_pvals');
            tvalfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff_tvals');
            tmapfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_TMAP');
            SIMfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_SIM');
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

%% display and save off tmaps
% first reorder and remove channels
maxcount = 0;
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Trimming tmaps:',timeperiod);
    for cond_i = 1:3
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies)
            fprintf('\n');
            fprintf('%s %s\n','Current Frequency band:',frequencies{1,freq_i});
            SIMfilename     = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_SIM');
            tmapfilename     = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_TMAP');
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
cd('E:\fieldtrip\ANALYSES\SIM');
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Reordering and saving tmaps:',timeperiod);
    for cond_i = 1:3
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
%             xlabels = {'AF3','F1','F3','F5','AF4','Afz','Fz','F2','F4', ...
%                 'F6','FC5','FC3','FC1','FC6','FC4','FC2','FCz','C1', ...
%                 'C3','C5','Cz','C2','C4','C6','CP5','CP3','CP1', ...
%                 'CP6','CP4','CP2','CPz','P1','P3','P5','P7','Pz', ...
%                 'P2','P4','P6','P8','PO7','PO3','O1','Oz','POz', ...
%                 'PO8','PO4','O2'};
%             figure();
%             clims = [ -6 6 ];
%             eval(['imagesc(' tmapreorderfilename{1,1} ',clims);'])
%             set(gca,'XTick',1:48);
%             set(gca,'XTickLabel',xlabels);
%             xticklabel_rotate([],90,[],'Fontsize',7);
%             set(gca,'YTick',1:48);
%             set(gca,'YTickLabel',xlabels);
%             set(gca,'YDir','normal');
%             set(gca,'Fontsize',7);
%             title(tmapreorderfilename{1,1});
%             colorbar;
            savedir = strcat(CWD,'\ANALYSES\SIM\');
            mkdir(savedir);
%             savename    = strcat(savedir,tmapreorderfilename{1,1});
            savenameSIM = strcat(savedir,SIMreorderfilename{1,1});
%             saveas(gcf,savename,'bmp');
%             saveas(gcf,savename,'fig');
            close all
%             save(savename,tmapreorderfilename{1,1});
            save(savenameSIM,SIMreorderfilename{1,1});
        end%freq_i loop
    end%cond_i loop
end%starttime loop

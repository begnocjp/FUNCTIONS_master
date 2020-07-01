%% Graph theory Analyses on diff mats from Cooper et al 2014
% Graph theoretical analyses are computed on the difference matrices for
% each condition.
% a) import difference matrices
% b) normalise networks (normalize, binarize, distance)
% c) threshold networks based on strongest percent
% c) compute graph metrics on observed network (clustering, path length)
% d) compute graph metrics on random (null model) network
% e) compute small-worldedness
% f) export for visualisation
%
% Patrick Cooper 2014
% University of Newcastle, Australia

%% set up globals
addpath(genpath('C:\Users\c3075693\Desktop\BCT'));%connectivity toolbox
CWD   = 'E:\fieldtrip';
DIFF   = '\ANALYSES\DifferenceMatrices'; %statistical interaction maps
GRAPH = '\ANALYSES\GRAPH';
cd(CWD);
conditions  = {'switchto','switchaway','noninf'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
%% load in DIFFS
cd([CWD DIFF]);
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = [num2str(starttime) 'to' num2str(endtime)];
    for cond_i = 1:3
        for freq_i = 1:length(frequencies)
            DIFFfile       = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_diff');
            eval(['load(''' DIFFfile{1,1} '.mat'')']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop
%% Create multi-dimensional matrices to fascilitate parfor loops
% preallocate
%                  subject,freq,time, corrmat
switchto   = zeros(     29,   5,  15, 64, 64);
switchaway = zeros(     29,   5,  15, 64, 64);
noninf     = zeros(     29,   5,  15, 64, 64);
timecount = 0; %timebin count
for subject = 1:29 %participant numbers
    fprintf('%s %1.0f\n', 'Subject:', subject);
    for starttime = 0:100:1400
        fprintf('.');
        endtime = starttime+200;
        timecount = timecount+1;
        timeperiod = strcat(num2str(starttime), 'to', num2str(endtime));
        for cond_i = 1:length(conditions)
            for freq_i = 1:length(frequencies)
                filename = strcat(frequencies(1,freq_i), '_', conditions(1,cond_i), '_', timeperiod, '_diff');
                if cond_i == 1
                    for row = 1:64 %size of correlation matrix
                        for col = 1:64 %size of correlation matrix
                            eval(['switchto(subject,freq_i,timecount,row,col) = '  filename{1,1} '(subject,row,col);']);
                        end%col loop
                    end%row loop
                elseif cond_i ==2
                    for row = 1:64 %size of correlation matrix
                        for col = 1:64 %size of correlation matrix
                            eval(['switchaway(subject,freq_i,timecount,row,col) = '  filename{1,1} '(subject,row,col);']);
                        end%col loop
                    end%row loop
                elseif cond_i == 3
                    for row = 1:64 %size of correlation matrix
                        for col = 1:64 %size of correlation matrix
                            eval(['noninf(subject,freq_i,timecount,row,col) = '  filename{1,1} '(subject,row,col);']);
                        end%col loop
                    end%row loop
                end%logic test to determine condition matrix
            end%freq_i loop
        end%cond_i loop
    end%starttime loop
end%subject matrices loop
fprintf('\n');
clear *_diff cond_i freq_i starttime endtime subject row col timecount timeperiod filename
%% Save above matrices
savedir = [CWD,GRAPH,'\'];
save(strcat(savedir,'switchto.mat'),'switchto');
save(strcat(savedir,'switchaway.mat'),'switchaway');
save(strcat(savedir,'noninf.mat'),'noninf');
clear savedir
%% Preallocate matrices for graph theory
%                      subject,time,freq,cond,thresh
clustering_obs = zeros(     29,  15,   5,   3,    10);
transitivi_obs = zeros(     29,  15,   5,   3,    10);
pathlength_obs = zeros(     29,  15,   5,   3,    10);
clustering_ran = zeros(     29,  15,   5,   3,    10);
transitivi_ran = zeros(     29,  15,   5,   3,    10);
pathlength_ran = zeros(     29,  15,   5,   3,    10);
smallworld_clu = zeros(     29,  15,   5,   3,    10); %smallworld ratio
smallworld_tra = zeros(     29,  15,   5,   3,    10); %smallworld ratio
%% Graph loop
% matlabpool(4); %parfor
subjectcount = 0;
% try
    for subject = 1:1:29 %number of subjects
        fprintf('%s %1.0f\n', 'Processing Subject: ', subject);
        subjectcount = subjectcount+1;
        timecount = 0;
        for starttime = 0:100:1400
            endtime = starttime + 200;
            timecount = timecount + 1; %current timebin
            fprintf('%s %3.0f %s %3.0f%s\n', 'Computing Graph Metrics for:', starttime, 'to', endtime, 'timewindow');
            tic;
            for freq_i = 1:length(frequencies) %switchto loop
                fprintf('\n%s%s\n', 'Current Frequency: ', frequencies{1,freq_i});
                switchto_net = weight_conversion(squeeze(switchto(subject,freq_i,timecount,:,:)),'normalize');
                fprintf('Percent Complete: \n');
                thresh = 0.01:0.01:0.1;
                for thresh_i = 1:length(thresh)
                    fprintf('\b\b\b%3.0f',(thresh_i/length(thresh)*100));
                    switchto_thrnet = threshold_proportional(switchto_net,thresh(thresh_i));
                    switchto_thrnet = weight_conversion(switchto_thrnet,'binarize');
                    switchto_dis = distance_bin(switchto_thrnet);
                    edgecount = 0;
                    for row = 1:length(switchto_thrnet)
                        for col = 1:length(switchto_thrnet)
                            if switchto_thrnet(row,col) ~= 0
                                edgecount = edgecount+1;
                            end%test if random rewire possibile
                        end%colcount
                    end%rowcount
                    if edgecount <= 4
                        switchto_ran = switchto_thrnet;
                    else switchto_ran = randmio_und(switchto_thrnet,1000);
                    end%random rewire fix
                    switchto_rad = distance_bin(switchto_ran);%random_dist
                    clustering_obs(subjectcount,timecount,freq_i,1,thresh_i) = mean(clustering_coef_bu(switchto_thrnet)~=0);
                    clustering_ran(subjectcount,timecount,freq_i,1,thresh_i) = mean(clustering_coef_bu(switchto_ran)~=0);
                    transitivi_obs(subjectcount,timecount,freq_i,1,thresh_i) = transitivity_bu((switchto_thrnet)~=0);
                    transitivi_ran(subjectcount,timecount,freq_i,1,thresh_i) = transitivity_bu((switchto_ran)~=0);
                    pathlength_obs(subjectcount,timecount,freq_i,1,thresh_i) = charpath((switchto_dis)~=0);
                    pathlength_ran(subjectcount,timecount,freq_i,1,thresh_i) = charpath((switchto_rad)~=0);
                    smallworld_clu(subjectcount,timecount,freq_i,1,thresh_i) = ((clustering_obs(subjectcount,timecount,freq_i,1,thresh_i) ...
                        /clustering_ran(subjectcount,timecount,freq_i,1,thresh_i)) ...
                        /pathlength_obs(subjectcount,timecount,freq_i,1,thresh_i) ...
                        /pathlength_ran(subjectcount,timecount,freq_i,1,thresh_i));
                    smallworld_tra(subjectcount,timecount,freq_i,1,thresh_i) = ((transitivi_obs(subjectcount,timecount,freq_i,1,thresh_i) ...
                        /transitivi_ran(subjectcount,timecount,freq_i,1,thresh_i)) ...
                        /pathlength_obs(subjectcount,timecount,freq_i,1,thresh_i) ...
                        /pathlength_ran(subjectcount,timecount,freq_i,1,thresh_i));
                end%thresh loop
            end%freq_i loop
            fprintf('\nSwitchTo complete\n');
            for freq_i = 1:length(frequencies) %switchaway loop
                fprintf('\n%s%s\n', 'Current Frequency: ', frequencies{1,freq_i});
                switchaw_net = weight_conversion(squeeze(switchaway(subject,freq_i,timecount,:,:)),'normalize');
                fprintf('Percent Complete: \n');
                thresh = 0.01:0.01:0.1;
                for thresh_i = 1:length(thresh)
                    fprintf('\b\b\b%3.0f',(thresh_i/length(thresh)*100));
                    switchaw_thrnet = threshold_proportional(switchaw_net,thresh(thresh_i));
                    switchaw_thrnet = weight_conversion(switchaw_thrnet,'binarize');
                    switchaw_dis = distance_bin(switchaw_thrnet);
                    edgecount = 0;
                    for row = 1:length(switchaw_thrnet)
                        for col = 1:length(switchaw_thrnet)
                            if switchaw_thrnet(row,col) ~= 0
                                edgecount = edgecount+1;
                            end%test if random rewire possibile
                        end%colcount
                    end%rowcount
                    if edgecount <= 4
                        switchaw_ran = switchaw_thrnet;
                    else switchaw_ran = randmio_und(switchaw_thrnet,1000);
                    end%random rewire fix
                    switchaw_rad = distance_bin(switchaw_ran);%random_dist
                    clustering_obs(subjectcount,timecount,freq_i,2,thresh_i) = mean(clustering_coef_bu(switchaw_thrnet)~=0);
                    clustering_ran(subjectcount,timecount,freq_i,2,thresh_i) = mean(clustering_coef_bu(switchaw_ran)~=0);
                    transitivi_obs(subjectcount,timecount,freq_i,2,thresh_i) = transitivity_bu((switchaw_thrnet)~=0);
                    transitivi_ran(subjectcount,timecount,freq_i,2,thresh_i) = transitivity_bu((switchaw_ran)~=0);
                    pathlength_obs(subjectcount,timecount,freq_i,2,thresh_i) = charpath((switchaw_dis)~=0);
                    pathlength_ran(subjectcount,timecount,freq_i,2,thresh_i) = charpath((switchaw_rad)~=0);
                    smallworld_clu(subjectcount,timecount,freq_i,2,thresh_i) = ((clustering_obs(subjectcount,timecount,freq_i,2,thresh_i) ...
                        /clustering_ran(subjectcount,timecount,freq_i,2,thresh_i)) ...
                        /pathlength_obs(subjectcount,timecount,freq_i,2,thresh_i) ...
                        /pathlength_ran(subjectcount,timecount,freq_i,2,thresh_i));
                    smallworld_tra(subjectcount,timecount,freq_i,2,thresh_i) = ((transitivi_obs(subjectcount,timecount,freq_i,2,thresh_i) ...
                        /transitivi_ran(subjectcount,timecount,freq_i,2,thresh_i)) ...
                        /pathlength_obs(subjectcount,timecount,freq_i,2,thresh_i) ...
                        /pathlength_ran(subjectcount,timecount,freq_i,2,thresh_i));
                end%thresh loop
            end%freq_i loop
            fprintf('SwitchAway complete\n');
            for freq_i = 1:length(frequencies) %noninf loop
                fprintf('\n%s%s\n', 'Current Frequency: ', frequencies{1,freq_i});
                noninfor_net = weight_conversion(squeeze(noninf(subject,freq_i,timecount,:,:)),'normalize');
                fprintf('\nPercent Complete: \n');
                thresh = 0.01:0.01:0.1;
                for thresh_i = 1:length(thresh)
                    fprintf('\b\b\b%3.0f',(thresh_i/length(thresh)*100));
                    noninfor_thrnet = threshold_proportional(noninfor_net,thresh(thresh_i));
                    noninfor_thrnet = weight_conversion(noninfor_thrnet,'binarize');
                    edgecount = 0;
                    noninfor_dis = distance_bin(noninfor_thrnet);
                    for row = 1:length(noninfor_thrnet)
                        for col = 1:length(noninfor_thrnet)
                            if noninfor_net(row,col) ~= 0
                                edgecount = edgecount+1;
                            end%test if random rewire possibile
                        end%colcount
                    end%rowcount
                    if edgecount <= 4
                        noninfor_ran = noninfor_thrnet;
                    else noninfor_ran = randmio_und(noninfor_thrnet,1000);
                    end%random rewire fix
                    noninfor_rad = distance_bin(noninfor_ran);%random_dist
                    clustering_obs(subjectcount,timecount,freq_i,3,thresh_i) = mean(clustering_coef_bu(noninfor_thrnet)~=0);
                    clustering_ran(subjectcount,timecount,freq_i,3,thresh_i) = mean(clustering_coef_bu(noninfor_ran)~=0);
                    transitivi_obs(subjectcount,timecount,freq_i,3,thresh_i) = transitivity_bu((noninfor_thrnet)~=0);
                    transitivi_ran(subjectcount,timecount,freq_i,3,thresh_i) = transitivity_bu((noninfor_ran)~=0);
                    pathlength_obs(subjectcount,timecount,freq_i,3,thresh_i) = charpath((noninfor_dis)~=0);
                    pathlength_ran(subjectcount,timecount,freq_i,3,thresh_i) = charpath((noninfor_rad)~=0);
                    smallworld_clu(subjectcount,timecount,freq_i,3,thresh_i) = ((clustering_obs(subjectcount,timecount,freq_i,3,thresh_i) ...
                        /clustering_ran(subjectcount,timecount,freq_i,3,thresh_i)) ...
                        /pathlength_obs(subjectcount,timecount,freq_i,3,thresh_i) ...
                        /pathlength_ran(subjectcount,timecount,freq_i,3,thresh_i));
                    smallworld_tra(subjectcount,timecount,freq_i,3,thresh_i) = ((transitivi_obs(subjectcount,timecount,freq_i,3,thresh_i) ...
                        /transitivi_ran(subjectcount,timecount,freq_i,3,thresh_i)) ...
                        /pathlength_obs(subjectcount,timecount,freq_i,3,thresh_i) ...
                        /pathlength_ran(subjectcount,timecount,freq_i,3,thresh_i));
                end%thresh loop
            end%freq_i loop
            fprintf('\nNonInf complete\n');
            toc
        end%starttime loop
    end%subject loop
% catch exception
%     exception;
%     matlabpool close force;
% end
% matlabpool close;

%% visualise network metrics

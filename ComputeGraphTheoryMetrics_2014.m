%% Graph theory Analyses on tmaps from Cooper et al 2014
% Graph theoretical analyses are computed on the statistical interaction
% maps (SIM) derived from the t-tests with FDR correction (<.005)
% SIMs contain the pvalues that survive FDR correction and graph theory is
% ran on these data.
% 
% a) import SIMS
% b) normalise networks (normalize, binarize, distance)
% c) compute graph metrics on observed network (clustering, path length)
% d) compute graph metrics on random (null model) network
% e) compute small-worldedness
% f) export for visualisation
%
% Patrick Cooper 2014
% University of Newcastle, Australia

%% set up globals
addpath(genpath('C:\Users\c3075693\Documents\BCT'));%connectivity toolbox
CWD   = 'E:\fieldtrip';
SIM   = '\ANALYSES\SIM'; %statistical interaction maps
GRAPH = '\ANALYSES\GRAPH';
cd(CWD);
conditions  = {'switchto','switchaway','noninf'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
%% load in SIMS
cd([CWD SIM]);
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = [num2str(starttime) 'to' num2str(endtime)];
    for cond_i = 1:3
        for freq_i = 1:length(frequencies)
            SIMfile       = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'_SIM_reordered');
            eval(['load(''' SIMfile{1,1} '.mat'')']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop
%% Create multi-dimensional matrices to fascilitate parfor loops
% preallocate
%                  freq,time, corrmat
switchto   = zeros(   5,  15, 48, 48);
switchaway = zeros(   5,  15, 48, 48);
noninf     = zeros(   5,  15, 48, 48);
timecount = 0; %timebin count
for starttime = 0:100:1400
    fprintf('.');
    endtime = starttime+200;
    timecount = timecount+1;
    timeperiod = strcat(num2str(starttime), 'to', num2str(endtime));
    for cond_i = 1:length(conditions)
        for freq_i = 1:length(frequencies)
            filename = strcat(frequencies(1,freq_i), '_', conditions(1,cond_i), '_', timeperiod, '_SIM_reordered');
            if cond_i == 1
                for row = 1:48 %size of correlation matrix
                    for col = 1:48 %size of correlation matrix
                        eval(['switchto(freq_i,timecount,row,col) = '  filename{1,1} '(row,col);']);
                    end%col loop
                end%row loop
            elseif cond_i ==2
                for row = 1:48 %size of correlation matrix
                    for col = 1:48 %size of correlation matrix
                        eval(['switchaway(freq_i,timecount,row,col) = '  filename{1,1} '(row,col);']);
                    end%col loop
                end%row loop
            elseif cond_i == 3
                for row = 1:48 %size of correlation matrix
                    for col = 1:48 %size of correlation matrix
                        eval(['noninf(freq_i,timecount,row,col) = '  filename{1,1} '(row,col);']);
                    end%col loop
                end%row loop
            end%logic test to determine condition matrix
        end%freq_i loop
    end%cond_i loop
end%starttime loop
fprintf('\n');
clear *_SIM_reordered
%% Preallocate matrices for graph theory
%                      time,freq,cond
matlabpool(4);
clustering_obs = zeros(  15,   5,   3);
transitivi_obs = zeros(  15,   5,   3);
pathlength_obs = zeros(  15,   5,   3);
clustering_ran = zeros(  15,   5,   3);
transitivi_ran = zeros(  15,   5,   3);
pathlength_ran = zeros(  15,   5,   3);
smallworld_clu = zeros(  15,   5,   3); %smallworld ratio
smallworld_tra = zeros(  15,   5,   3); %smallworld ratio
%% Graph loop
try
timecount = 0;
for starttime = 0:100:1400
    endtime = starttime + 200;
    timecount = timecount + 1; %current timebin
    fprintf('%s %3.0f %s %3.0f%s\n', 'Computing Graph Metrics for:', starttime, 'to', endtime, 'timewindow');
    edgecount = 0;
    tic;
    parfor freq_i = 1:length(frequencies) %switchto loop
        edgecount = 0;
        switchto_net = weight_conversion(squeeze(switchto(freq_i,timecount,:,:)),'binarize');
        switchto_dis = distance_bin(switchto_net);
        for row = 1:length(switchto_net)
            for col = 1:length(switchto_net)
                if switchto_net(row,col) ~= 0
                    edgecount = edgecount+1;
                end%test if random rewire possibile
            end%colcount
        end%rowcount
        if edgecount <= 4
            switchto_ran = switchto_net;
        else switchto_ran = randmio_und(switchto_net,10000);
        end%random rewire fix
        switchto_rad = distance_bin(switchto_ran);%random_dist
        clustering_obs(timecount,freq_i,1) = mean(clustering_coef_bu(switchto_net)~=0);
        clustering_ran(timecount,freq_i,1) = mean(clustering_coef_bu(switchto_ran)~=0);
        transitivi_obs(timecount,freq_i,1) = transitivity_bu((switchto_net)~=0);
        transitivi_ran(timecount,freq_i,1) = transitivity_bu((switchto_ran)~=0);
        pathlength_obs(timecount,freq_i,1) = charpath((switchto_dis)~=0);
        pathlength_ran(timecount,freq_i,1) = charpath((switchto_rad)~=0);
        smallworld_clu(timecount,freq_i,1) = ((clustering_obs(timecount,freq_i,1) ... 
                                                /clustering_ran(timecount,freq_i,1)) ...
                                                /pathlength_obs(timecount,freq_i,1) ...
                                                /pathlength_ran(timecount,freq_i,1));
        smallworld_tra(timecount,freq_i,1) = ((transitivi_obs(timecount,freq_i,1) ...
                                                /transitivi_ran(timecount,freq_i,1)) ...
                                                /pathlength_obs(timecount,freq_i,1) ...
                                                /pathlength_ran(timecount,freq_i,1));
    end%freq_i loop
    fprintf('SwitchTo complete\n');
    parfor freq_i = 1:length(frequencies) %switchaway loop
        edgecount = 0;
        switchaw_net = weight_conversion(squeeze(switchaway(freq_i,timecount,:,:)),'binarize');
        switchaw_dis = distance_bin(switchaw_net);
        for row = 1:length(switchaw_net)
            for col = 1:length(switchaw_net)
                if switchaw_net(row,col) ~= 0
                    edgecount = edgecount+1;
                end%test if random rewire possibile
            end%colcount
        end%rowcount
        if edgecount <= 4
            switchaw_ran = switchaw_net;
        else switchaw_ran = randmio_und(switchaw_net,10000);
        end%random rewire fix
        switchaw_rad = distance_bin(switchaw_ran);%random_dist
        clustering_obs(timecount,freq_i,2) = mean(clustering_coef_bu(switchaw_net)~=0);
        clustering_ran(timecount,freq_i,2) = mean(clustering_coef_bu(switchaw_ran)~=0);
        transitivi_obs(timecount,freq_i,2) = transitivity_bu((switchaw_net)~=0);
        transitivi_ran(timecount,freq_i,2) = transitivity_bu((switchaw_ran)~=0);
        pathlength_obs(timecount,freq_i,2) = charpath((switchaw_dis)~=0);
        pathlength_ran(timecount,freq_i,2) = charpath((switchaw_rad)~=0);
        smallworld_rat(timecount,freq_i,2) = ((clustering_obs(timecount,freq_i,2) ...
                                                /clustering_ran(timecount,freq_i,2)) ...
                                                /pathlength_obs(timecount,freq_i,2) ...
                                                /pathlength_ran(timecount,freq_i,2));
        smallworld_tra(timecount,freq_i,2) = ((transitivi_obs(timecount,freq_i,2) ...
                                                /transitivi_ran(timecount,freq_i,2)) ...
                                                /pathlength_obs(timecount,freq_i,2) ...
                                                /pathlength_ran(timecount,freq_i,2));
    end%freq_i loop
    fprintf('SwitchAway complete\n');
    parfor freq_i = 1:length(frequencies) %noninf loop
        edgecount = 0;
        noninfor_net = weight_conversion(squeeze(noninf(freq_i,timecount,:,:)),'binarize');
        noninfor_dis = distance_bin(noninfor_net);
        for row = 1:length(noninfor_net)
            for col = 1:length(noninfor_net)
                if noninfor_net(row,col) ~= 0
                    edgecount = edgecount+1;
                end%test if random rewire possibile
            end%colcount
        end%rowcount
        if edgecount <= 4
            noninfor_ran = noninfor_net;
        else noninfor_ran = randmio_und(noninfor_net,10000);
        end%random rewire fix        
        noninfor_rad = distance_bin(noninfor_ran);%random_dist
        clustering_obs(timecount,freq_i,3) = mean(clustering_coef_bu(noninfor_net)~=0);
        clustering_ran(timecount,freq_i,3) = mean(clustering_coef_bu(noninfor_ran)~=0);
        transitivi_obs(timecount,freq_i,3) = transitivity_bu((noninfor_net)~=0);
        transitivi_ran(timecount,freq_i,3) = transitivity_bu((noninfor_ran)~=0);
        pathlength_obs(timecount,freq_i,3) = charpath((noninfor_dis)~=0);
        pathlength_ran(timecount,freq_i,3) = charpath((noninfor_rad)~=0);
        smallworld_rat(timecount,freq_i,3) = ((clustering_obs(timecount,freq_i,3) ...
                                                /clustering_ran(timecount,freq_i,3)) ...
                                                /pathlength_obs(timecount,freq_i,3) ...
                                                /pathlength_ran(timecount,freq_i,3));
        smallworld_tra(timecount,freq_i,3) = ((transitivi_obs(timecount,freq_i,3) ...
                                                /transitivi_ran(timecount,freq_i,3)) ...
                                                /pathlength_obs(timecount,freq_i,3) ...
                                                /pathlength_ran(timecount,freq_i,3));
    end%freq_i loop
    fprintf('NonInf complete\n');
    toc
end%starttime loop
catch exception
    exception;
    matlabpool close force;
end
matlabpool close;

%% visualise network metrics

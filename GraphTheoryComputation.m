%% Compute graph theory metrices for imaginary coherence networks
% set up globals
CWD         = 'F:\fieldtrip';
GRAPH       = 'ANALYSES\GraphTheory';
addpath(genpath('C:\Users\c3075693\Documents\BCT'));
cd([CWD,'\',GRAPH]);
names       = {'AGE002','AGE003','AGE008','AGE012','AGE013','AGE014', ...
            'AGE015','AGE017','AGE018','AGE019','AGE021','AGE022', ...
            'AGE023','AGE024','AGE026','AGE027','AGE028','AGE030', ...
            'AGE032','AGE033','AGE035','AGE036','AGE038','AGE046', ...
            'AGE047','AGE050','AGE051','AGE052','AGE058'};
conditions  = {'switchto','switchaway','noninf','mixrepeat'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
starttime = 0:100:1400;
thresholds = 0.1:0.01:0.5;
%% preallocate matrices
conndir = strcat(CWD,'\','CONNECTIVITY_MATRICES');
cd(conndir);
% load connectivity matrices
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
% trim and reorder matrices
for starttime = 0:100:1400
    time_i = 1:length(starttime);
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    fprintf('%s %s\n','Trimming Connectivity matrices:',timeperiod);
    for cond_i = 1:length(conditions)
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies)
            fprintf('\n');
            fprintf('%s %s\n','Current Frequency band:',frequencies{1,freq_i});
            connfilename     = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod);
            conntrimfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'trim');
            tic;
            for dim1 = 1:size(beta_mixrepeat_0to200,1);
                count = 0;
                fprintf('.');
                for olddim_row = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 ...
                        25 26 27 29 30 31 32 36 37 38 39 40 41 44 45 46 ...
                        47 48 49 50 51 54 55 56 57 58 59 60 62 63 64];
                    count = count + 1;
                    cnt = 0;
                    for olddim_col = [3 4 5 6 9 10 11 12 13 14 17 18 19 20 21 22 23 ...
                            25 26 27 29 30 31 32 36 37 38 39 40 41 44 45 46 ...
                            47 48 49 50 51 54 55 56 57 58 59 60 62 63 64];
                        cnt = cnt+1;
                        eval([conntrimfilename{1,1} '(dim1,count,cnt) = ' connfilename{1,1} '(dim1,olddim_row,olddim_col);']);
                    end%olddim_row
                end%olddim_col
            end
            fprintf('\n');
            toc
        end%freq_i loop
    end%cond_i loop
end%starttime loop

for starttime = 0:100:1400
    time_i = 1:length(starttime);
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    for cond_i = 1:length(conditions)
        fprintf('\n');
        fprintf('%s %s\n','Current Condition:',conditions{1,cond_i});
        for freq_i = 1:length(frequencies)
            fprintf('\n');
            conntrimfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'trim');
            savename = strcat(CWD,'\','CONNECTIVITY_MATRICES','\',conditions(1,cond_i),'\',timeperiod,'\',conntrimfilename{1,1});
            eval(['save(''' savename{1,1} ''', ''' conntrimfilename{1,1} ''')']);
            fprintf('\n');
        end%freq_i loop
    end%cond_i loop
end%starttime loop

%% load data
fprintf('Loading Matrices\n');
for starttime = 0:100:1400
    time_i = 1:length(starttime);
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    for cond_i = 1:length(conditions)
        fprintf('.');
        for freq_i = 1:length(frequencies)
            conntrimfilename = strcat(frequencies(1,freq_i),'_',conditions(1,cond_i),'_',timeperiod,'trim');
            savename = strcat(CWD,'\','CONNECTIVITY_MATRICES','\',conditions(1,cond_i),'\',timeperiod,'\',conntrimfilename{1,1});
            eval(['load(''' savename{1,1} ''')']);
        end%freq_i loop
    end%cond_i loop
end%starttime loop
fprintf('Done!\n');

% preallocate matrices
clustering_observed = zeros(length(conditions),length(frequencies), ...
                       length(starttime),length(names),length(thresholds));
clustering_random   = zeros(length(conditions),length(frequencies), ...
                       length(starttime),length(names),length(thresholds));
pathlength_observed = zeros(length(conditions),length(frequencies), ...
                       length(starttime),length(names),length(thresholds));
pathlength_random   = zeros(length(conditions),length(frequencies), ...
                       length(starttime),length(names),length(thresholds));
clustratio_observed = zeros(length(conditions),length(frequencies), ...
                       length(starttime),length(names),length(thresholds));
pathratio_observed  = zeros(length(conditions),length(frequencies), ...
                       length(starttime),length(names),length(thresholds));
%% Graph Theory Analysis    
matlabpool(4);
try
    for cond_i = 1:length(conditions)
        currentcond = conditions(1,cond_i);
        fprintf('%s %s\n','Computing Network Metrics for:',currentcond{1,1});
        for freq_i = 1:length(frequencies)
            currentfreq = frequencies(1,freq_i);
            fprintf('%s %s\n','Computing Network Metrics for:',currentfreq{1,1});
            timecount = 0;
            for starttime = 0:100:1400
                timecount = timecount+1;
                endtime = starttime + 200;
                time_i = timecount;
                timeperiod = [num2str(starttime),'to',num2str(endtime)];
                fprintf('%s %s\n','Computing Network Metrics for timerange:',timeperiod);
                tic;
                clear currentnet net_norm net_thr rand_thr net_dis rand_dis
                currentnet = strcat(currentfreq{1,1},'_',currentcond{1,1},'_',timeperiod,'trim');
                eval(['currentnet = ' currentnet ';']);
                net_norm   = weight_conversion(currentnet,'normalize');
                threshcount = 0;
                for threshold = 0.1:0.01:0.5;
                    threshcount = threshcount + 1;
                    thresh_i = threshcount;
                    repeats = 10;
                    randnet = zeros(repeats,48,48);
                    for randcount = 1:repeats;
                        randnet(randcount,:,:) = rand(48,48).*2.-1;
                    end%randcount
                    %randnet = squeeze(mean(randnettmp,1));
                    fprintf('.');
                    parfor subj_i = 1:length(names)
                        net_extr = squeeze(net_norm(subj_i,:,:));
                        net_thr  = squeeze(threshold_proportional(net_extr,threshold));
                        net_bin  = weight_conversion(net_thr,'binarize');
                        net_dis  = squeeze(distance_wei(net_bin));
                        randnet_local = randnet;
                        rand_thr = zeros(size(randnet_local));
                        rand_bin = zeros(size(randnet_local));
                        rand_dis = zeros(size(randnet_local));
                        for randCount = 1:size(randnet_local,1)
                            rand_thr(randCount,:,:) = threshold_proportional(squeeze(randnet_local(randCount,:,:)),threshold);
                            rand_bin(randCount,:,:) = weight_conversion(squeeze(rand_thr(randCount,:,:)),'binarize');
                            rand_dis(randCount,:,:) = distance_wei(squeeze(rand_bin(randCount,:,:)));
                        end;
                        clustering_observed(cond_i,freq_i,time_i,subj_i,thresh_i) ...
                            = (mean(clustering_coef_wu(net_bin)));
                        pathlength_observed(cond_i,freq_i,time_i,subj_i,thresh_i) ...
                            =  (abs(charpath(net_dis)));
                        
                        tmp_ClustRand = zeros(1,size(randnet_local,1));
                        tmp_PathLRand = zeros(1,size(randnet_local,1));
                        tmp_ClusRatio = zeros(1,size(randnet_local,1));
                        tmp_PathRatio = zeros(1,size(randnet_local,1));
                        for randCount = 1:size(randnet_local,1)
                            tmp_ClustRand(1,randCount) = mean(clustering_coef_wu(squeeze(rand_bin(randCount,:,:))));
                            tmp_PathLRand(1,randCount) = abs(mean(charpath(squeeze(rand_dis(randCount,:,:)))));
                            tmp_ClusRatio(1,randCount) = abs(clustering_observed(cond_i,freq_i,time_i,subj_i,thresh_i)./ ...
                                tmp_ClustRand(1,randCount));
                            tmp_PathRatio(1,randCount) = abs(pathlength_observed(cond_i,freq_i,time_i,subj_i,thresh_i)./ ...
                                tmp_PathLRand(1,randCount));
                        end
                        for randCount = 1:size(randnet_local,1)
                            tmp_ClustRand(1,randCount(isinf(tmp_ClustRand(1,randCount))))= 0;
                            tmp_PathLRand(1,randCount(isinf(tmp_PathLRand(1,randCount))))= 0;
                            tmp_ClusRatio(1,randCount(isinf(tmp_ClusRatio(1,randCount))))= 0;
                            tmp_PathRatio(1,randCount(isinf(tmp_PathRatio(1,randCount))))= 0;
                        end
                        clustering_random(cond_i,freq_i,time_i,subj_i,thresh_i) ...
                            = (abs(mean(tmp_ClustRand)));
                        pathlength_random(cond_i,freq_i,time_i,subj_i,thresh_i)   ...
                            =  (abs(mean(tmp_PathLRand)));
                        clustratio_observed(cond_i,freq_i,time_i,subj_i,thresh_i) ...
                            = (abs(mean(tmp_ClusRatio)));
                        pathratio_observed(cond_i,freq_i,time_i,subj_i,thresh_i) ...
                            = (abs(mean(tmp_PathRatio)));
                        
                        
                    end
                end%threshold loop
                toc
            end%starttimeloop
        end%freq_i loop
    end%cond_i loop
    matlabpool close
catch exception
    matlabpool close force
end

%save graph theory structures
save('cc_obs_t001to05','clustering_observed');
save('cc_ran_t001to05','clustering_random');
save('pl_obs_t001to05','pathlength_observed');
save('pl_ran_t001to05','pathlength_random');
save('cc_ratio_t001to05','clustratio_observed');
save('pl_ratio_t001to05','pathratio_observed');
%% plot graph results
% clustering coefficient
warning off;
clustratio_observed(isnan(clustratio_observed)) = 0;
pathratio_observed(isnan(pathratio_observed)) =0;


for cond_i = 1:length(conditions)
    for freq_i = 1:length(frequencies)
        timecount = 0;
        for starttime = 0:100:1400
            endtime = starttime + 200;
            timecount = timecount + 1;
            time_i = timecount;
            if any(squeeze(clustering_observed(cond_i,freq_i,time_i,:,50))) == 0
                clustering_observed_tmp = zeros(29,50);
                clustering_observed_tmp(:,2:50) = squeeze(clustering_observed(cond_i,freq_i,time_i,:,1:49));
                clustering_observed(cond_i,freq_i,time_i,:,:) = clustering_observed_tmp;
            end
            if any(squeeze(clustering_random(cond_i,freq_i,time_i,:,50))) == 0
                clustering_random_tmp = zeros(29,50);
                clustering_random_tmp(:,2:50) = squeeze(clustering_random(cond_i,freq_i,time_i,:,1:49));
                clustering_random(cond_i,freq_i,time_i,:,:) = clustering_random_tmp;
            end
            if any(squeeze(pathlength_observed(cond_i,freq_i,time_i,:,50))) == 0
                pathlength_observed_tmp = zeros(29,50);
                pathlength_observed_tmp(:,2:50) = squeeze(pathlength_observed(cond_i,freq_i,time_i,:,1:49));
                pathlength_observed(cond_i,freq_i,time_i,:,:) = pathlength_observed_tmp;
            end
            if any(squeeze(pathlength_random(cond_i,freq_i,time_i,:,50))) == 0
                pathlength_random_tmp = zeros(29,50);
                pathlength_random_tmp(:,2:50) = squeeze(pathlength_random(cond_i,freq_i,time_i,:,1:49));
                pathlength_random(cond_i,freq_i,time_i,:,:) = pathlength_random_tmp;
            end
            if any(squeeze(pathratio_observed(cond_i,freq_i,time_i,:,50))) == 0
                pathratio_observed_tmp = zeros(29,50);
                pathratio_observed_tmp(:,2:50) = squeeze(pathratio_observed(cond_i,freq_i,time_i,:,1:49));
                pathratio_observed(cond_i,freq_i,time_i,:,:) = pathratio_observed_tmp;
            end
            if any(squeeze(clustratio_observed(cond_i,freq_i,time_i,:,50))) == 0
                clustratio_observed_tmp = zeros(29,50);
                clustratio_observed_tmp(:,2:50) = squeeze(clustratio_observed(cond_i,freq_i,time_i,:,1:49));
                clustratio_observed(cond_i,freq_i,time_i,:,:) = clustratio_observed_tmp;
            end
        end%starttimeloop
    end%freq_i loop
end%cond_i loop

for cond_i = 1:length(conditions)
    for freq_i = 1:length(frequencies)
        timecount = 0;
        for starttime = 0:100:1400
            endtime = starttime + 200;
            timecount = timecount + 1;
            time_i = timecount;
            currentconditionname     = strcat(conditions(1,cond_i),'_',frequencies(1,freq_i),'_',num2str(starttime),'to',num2str(endtime));
            currentconditionmean     = strcat(currentconditionname,'_','mean');
            currentconditionstd      = strcat(currentconditionname,'_','std');
            currentconditionposition = strcat(num2str(cond_i),',',num2str(freq_i),',',num2str(time_i),',',':',',',':');
%             for threshold = 0.01:0.01:0.2;
%                 for subj_i = 1:length(names)
                    eval(['clustratio_' currentconditionmean{1,1} ' = mean(squeeze(clustratio_observed(' currentconditionposition ')));']);
                    eval(['clustratio_' currentconditionstd{1,1} ' = (std(squeeze(clustratio_observed(' currentconditionposition ')))./length(names));']);
                    eval(['pathratio_' currentconditionmean{1,1} ' = mean(squeeze(pathratio_observed(' currentconditionposition ')));']);
                    eval(['pathratio_' currentconditionstd{1,1} ' = (std(squeeze(pathratio_observed(' currentconditionposition ')))./length(names));']);
                    eval(['pathratio_' currentconditionstd{1,1} '(isnan(pathratio_' currentconditionstd{1,1} ' )) = 0;'])
                    eval(['clustratio_' currentconditionstd{1,1} '(isnan(clustratio_' currentconditionstd{1,1} ' )) = 0;'])
                    eval(['pathratio_' currentconditionmean{1,1} '(isinf(pathratio_' currentconditionmean{1,1} ' )) = 0;'])
                    eval(['clustratio_' currentconditionmean{1,1} '(isinf(clustratio_' currentconditionmean{1,1} ' )) = 0;'])
%                 end
%             end%threshold loop
        end%starttimeloop
    end%freq_i loop
end%cond_i loop

% clustering ratio
% delta
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(clustratio_mixrepeat_delta_' timeperiod '_mean,clustratio_mixrepeat_delta_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(clustratio_switchto_delta_' timeperiod '_mean,clustratio_switchto_delta_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(clustratio_switchaway_delta_' timeperiod '_mean,clustratio_switchaway_delta_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(clustratio_noninf_delta_' timeperiod '_mean,clustratio_noninf_delta_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['delta ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%      set(gca,'YLim',[0, 1])
%     savedir = strcat(CWD,'\',GRAPH,'\Delta\');
%     mkdir(savedir);
%     savename = strcat(savedir,'ClusteringCoefficient_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% theta
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(clustratio_mixrepeat_theta_' timeperiod '_mean,clustratio_mixrepeat_theta_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(clustratio_switchto_theta_' timeperiod '_mean,clustratio_switchto_theta_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(clustratio_switchaway_theta_' timeperiod '_mean,clustratio_switchaway_theta_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(clustratio_noninf_theta_' timeperiod '_mean,clustratio_noninf_theta_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['theta ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0, 1])
%     savedir = strcat(CWD,'\',GRAPH,'\Theta\');
%     mkdir(savedir);
%     savename = strcat(savedir,'ClusteringCoefficient_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% lower alpha
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(clustratio_mixrepeat_loweralpha_' timeperiod '_mean,clustratio_mixrepeat_loweralpha_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(clustratio_switchto_loweralpha_' timeperiod '_mean,clustratio_switchto_loweralpha_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(clustratio_switchaway_loweralpha_' timeperiod '_mean,clustratio_switchaway_loweralpha_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(clustratio_noninf_loweralpha_' timeperiod '_mean,clustratio_noninf_loweralpha_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['loweralpha ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0, 1])
%     savedir = strcat(CWD,'\',GRAPH,'\Loweralpha\');
%     mkdir(savedir);
%     savename = strcat(savedir,'ClusteringCoefficient_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% upperalpha
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(clustratio_mixrepeat_upperalpha_' timeperiod '_mean,clustratio_mixrepeat_upperalpha_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(clustratio_switchto_upperalpha_' timeperiod '_mean,clustratio_switchto_upperalpha_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(clustratio_switchaway_upperalpha_' timeperiod '_mean,clustratio_switchaway_upperalpha_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(clustratio_noninf_upperalpha_' timeperiod '_mean,clustratio_noninf_upperalpha_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['upperalpha ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0, 1])
%     savedir = strcat(CWD,'\',GRAPH,'\Upperalpha\');
%     mkdir(savedir);
%     savename = strcat(savedir,'ClusteringCoefficient_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% beta
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(clustratio_mixrepeat_beta_' timeperiod '_mean,clustratio_mixrepeat_beta_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(clustratio_switchto_beta_' timeperiod '_mean,clustratio_switchto_beta_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(clustratio_switchaway_beta_' timeperiod '_mean,clustratio_switchaway_beta_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(clustratio_noninf_beta_' timeperiod '_mean,clustratio_noninf_beta_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['beta ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0, 1])
%     savedir = strcat(CWD,'\',GRAPH,'\Beta\');
%     mkdir(savedir);
%     savename = strcat(savedir,'ClusteringCoefficient_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all

% path ratio
% delta
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(pathratio_mixrepeat_delta_' timeperiod '_mean,pathratio_mixrepeat_delta_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(pathratio_switchto_delta_' timeperiod '_mean,pathratio_switchto_delta_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(pathratio_switchaway_delta_' timeperiod '_mean,pathratio_switchaway_delta_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(pathratio_noninf_delta_' timeperiod '_mean,pathratio_noninf_delta_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['delta ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0.5, 1.5])
%     savedir = strcat(CWD,'\',GRAPH,'\Delta\');
%     mkdir(savedir);
%     savename = strcat(savedir,'PathLength_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% theta
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(pathratio_mixrepeat_theta_' timeperiod '_mean,pathratio_mixrepeat_theta_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(pathratio_switchto_theta_' timeperiod '_mean,pathratio_switchto_theta_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(pathratio_switchaway_theta_' timeperiod '_mean,pathratio_switchaway_theta_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(pathratio_noninf_theta_' timeperiod '_mean,pathratio_noninf_theta_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['theta ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0.5, 1.5])
%     savedir = strcat(CWD,'\',GRAPH,'\Theta\');
%     mkdir(savedir);
%     savename = strcat(savedir,'PathLength_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% lower alpha
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(pathratio_mixrepeat_loweralpha_' timeperiod '_mean,pathratio_mixrepeat_loweralpha_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(pathratio_switchto_loweralpha_' timeperiod '_mean,pathratio_switchto_loweralpha_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(pathratio_switchaway_loweralpha_' timeperiod '_mean,pathratio_switchaway_loweralpha_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(pathratio_noninf_loweralpha_' timeperiod '_mean,pathratio_noninf_loweralpha_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['loweralpha ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0.5, 1.5])
%     savedir = strcat(CWD,'\',GRAPH,'\Loweralpha\');
%     mkdir(savedir);
%     savename = strcat(savedir,'PathLength_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% upperalpha
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(pathratio_mixrepeat_upperalpha_' timeperiod '_mean,pathratio_mixrepeat_upperalpha_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(pathratio_switchto_upperalpha_' timeperiod '_mean,pathratio_switchto_upperalpha_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(pathratio_switchaway_upperalpha_' timeperiod '_mean,pathratio_switchaway_upperalpha_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(pathratio_noninf_upperalpha_' timeperiod '_mean,pathratio_noninf_upperalpha_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['upperalpha ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
    set(gca,'YLim',[0.5, 1.5])
    savedir = strcat(CWD,'\',GRAPH,'\Upperalpha\');
    mkdir(savedir);
    savename = strcat(savedir,'PathLength_',timeperiod);
    saveas(gcf,savename,'bmp');
    saveas(gcf,savename,'fig');
end
close all
% beta
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(pathratio_mixrepeat_beta_' timeperiod '_mean,pathratio_mixrepeat_beta_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(pathratio_switchto_beta_' timeperiod '_mean,pathratio_switchto_beta_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(pathratio_switchaway_beta_' timeperiod '_mean,pathratio_switchaway_beta_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(pathratio_noninf_beta_' timeperiod '_mean,pathratio_noninf_beta_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['beta ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
    set(gca,'YLim',[0.3, 1.5])
    savedir = strcat(CWD,'\',GRAPH,'\Beta\');
    mkdir(savedir);
    savename = strcat(savedir,'PathLength_',timeperiod);
    saveas(gcf,savename,'bmp');
    saveas(gcf,savename,'fig');
end
close all
%% compute small-worldedness
for cond_i = 1:length(conditions)
    for freq_i = 1:length(frequencies)
        timecount = 0;
        for starttime = 0:100:1400
            endtime = starttime + 200;
            timecount = timecount + 1;
            time_i = timecount;
            currentconditionname     = strcat(conditions(1,cond_i),'_',frequencies(1,freq_i),'_',num2str(starttime),'to',num2str(endtime));
            currentconditionmean     = strcat(currentconditionname,'_','mean');
            currentconditionstd      = strcat(currentconditionname,'_','std');
            currentconditionposition = strcat(num2str(cond_i),',',num2str(freq_i),',',num2str(time_i),',',':',',',':');
%             for threshold = 0.01:0.01:0.2;
%                 for subj_i = 1:length(names)
            eval(['smallworld_' currentconditionmean{1,1} ' = mean(squeeze(clustratio_observed(' currentconditionposition ')))./mean(squeeze(pathratio_observed(' currentconditionposition ')));']);
            eval(['smallworld_' currentconditionstd{1,1} ' = std(squeeze(clustratio_observed(' currentconditionposition '))./(squeeze(pathratio_observed(' currentconditionposition ')))./length(names));']);
            eval(['smallworld_' currentconditionmean{1,1} '(isinf(smallworld_' currentconditionmean{1,1} ' )) = 0;'])
            eval(['smallworld_' currentconditionstd{1,1} '(isnan(smallworld_' currentconditionstd{1,1} ' )) = 0;'])
            eval(['smallworld_' currentconditionmean{1,1} '(isinf(smallworld_' currentconditionmean{1,1} ' )) = 0;'])
            eval(['smallworld_' currentconditionstd{1,1} '(isnan(smallworld_' currentconditionstd{1,1} ' )) = 0;'])
%                 end
%             end%threshold loop
        end%starttimeloop
    end%freq_i loop
end%cond_i loop

% plot
% smallworld ratio
% delta
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(smallworld_mixrepeat_delta_' timeperiod '_mean,smallworld_mixrepeat_delta_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(smallworld_switchto_delta_' timeperiod '_mean,smallworld_switchto_delta_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(smallworld_switchaway_delta_' timeperiod '_mean,smallworld_switchaway_delta_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(smallworld_noninf_delta_' timeperiod '_mean,smallworld_noninf_delta_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['delta ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0, 1.5])
%     savedir = strcat(CWD,'\',GRAPH,'\Delta\');
%     mkdir(savedir);
%     savename = strcat(savedir,'SmallWorld_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% theta
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(smallworld_mixrepeat_theta_' timeperiod '_mean,smallworld_mixrepeat_theta_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(smallworld_switchto_theta_' timeperiod '_mean,smallworld_switchto_theta_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(smallworld_switchaway_theta_' timeperiod '_mean,smallworld_switchaway_theta_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(smallworld_noninf_theta_' timeperiod '_mean,smallworld_noninf_theta_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['Theta ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0, 1.5])
%     savedir = strcat(CWD,'\',GRAPH,'\Theta\');
%     mkdir(savedir);
%     savename = strcat(savedir,'SmallWorld_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% lower alpha
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(smallworld_mixrepeat_loweralpha_' timeperiod '_mean,smallworld_mixrepeat_loweralpha_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(smallworld_switchto_loweralpha_' timeperiod '_mean,smallworld_switchto_loweralpha_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(smallworld_switchaway_loweralpha_' timeperiod '_mean,smallworld_switchaway_loweralpha_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(smallworld_noninf_loweralpha_' timeperiod '_mean,smallworld_noninf_loweralpha_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['LowerAlpha ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0, 1.5])
%     savedir = strcat(CWD,'\',GRAPH,'\LowerAlpha\');
%     mkdir(savedir);
%     savename = strcat(savedir,'SmallWorld_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% upperalpha
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(smallworld_mixrepeat_upperalpha_' timeperiod '_mean,smallworld_mixrepeat_upperalpha_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(smallworld_switchto_upperalpha_' timeperiod '_mean,smallworld_switchto_upperalpha_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(smallworld_switchaway_upperalpha_' timeperiod '_mean,smallworld_switchaway_upperalpha_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(smallworld_noninf_upperalpha_' timeperiod '_mean,smallworld_noninf_upperalpha_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['UpperAlpha ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0, 1.5])
%     savedir = strcat(CWD,'\',GRAPH,'\UpperAlpha\');
%     mkdir(savedir);
%     savename = strcat(savedir,'SmallWorld_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all
% beta
for starttime = 0:100:1400
    endtime = starttime + 200;
    timeperiod = strcat(num2str(starttime),'to',num2str(endtime));
    figure()
    eval(['errorbar(smallworld_mixrepeat_beta_' timeperiod '_mean,smallworld_mixrepeat_beta_' timeperiod '_std,''-r''' ')']); % mixrepeat
    hold on;
    eval(['errorbar(smallworld_switchto_beta_' timeperiod '_mean,smallworld_switchto_beta_' timeperiod '_std,''-b''' ')']); % switchto
    hold on;
    eval(['errorbar(smallworld_switchaway_beta_' timeperiod '_mean,smallworld_switchaway_beta_' timeperiod '_std,''-g''' ')']); % switchaway
    hold on;
    eval(['errorbar(smallworld_noninf_beta_' timeperiod '_mean,smallworld_noninf_beta_' timeperiod '_std,''-black''' ')']); % noninf
    hold on;
    title(['Beta ' timeperiod]);
    set(gca,'XLim',[0, 51])
    set(gca,'XTick',1:50)
    set(gca,'XTickLabel',{'0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.1', ...
        '0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19','0.2','0.21','0.22','0.23', ...
        '0.24','0.25','0.26','0.27','0.28','0.29','0.3','0.31','0.32','0.33','0.34','0.35','0.36', ...
        '0.37','0.38','0.39','0.4','0.41','0.42','0.43','0.44','0.45','0.46','0.47','0.48','0.49', ...
        '0.5'})
%     set(gca,'YLim',[0, 1.5])
%     savedir = strcat(CWD,'\',GRAPH,'\Beta\');
%     mkdir(savedir);
%     savename = strcat(savedir,'SmallWorld_',timeperiod);
%     saveas(gcf,savename,'bmp');
%     saveas(gcf,savename,'fig');
end
close all

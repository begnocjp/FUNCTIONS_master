%% Set up globals
clear all
close all
CWD = 'E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\';
addpath(genpath('C:\Users\c3075693\Desktop\BCT'));
addpath(genpath('C:\Users\c3075693\Desktop\multiWaitBar'));
load([CWD 'ALLDATA.mat']);
subject = 1:size(ALLDATA.conditions.dirleft.delta,1);
conditions = {'dirleft','dirright','nondirleft','nondirright'};
times = 1:size(ALLDATA.conditions.dirleft.delta,2);
thresholds = 0.10:0.05:0.5;
frequencies = {'beta'};
% first zscore ALLDATA coherence values
zdat = ALLDATA;%preallocate
for cond_i = 1:length(conditions)
    fprintf('\n')
    for freq_i = 1:length(frequencies)
        fprintf('.')
        for name_i = 1:length(subject)
            for time_i = 1:length(times)
                zdat.conditions.(conditions{cond_i}).(frequencies{freq_i})(name_i,time_i,:,:) = zscore(squeeze(ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(name_i,time_i,:,:)));
            end
        end
    end
end
        
alltree_measures.clustering   = zeros(length(subject),length(frequencies),length(thresholds),length(conditions),length(times));
alltree_measures.path = zeros(length(subject),length(frequencies),length(thresholds),length(conditions),length(times));
alltree_measures.rclub  = zeros(length(subject),length(frequencies),length(thresholds),length(conditions),length(times));
alltree_measures.clusteringrand  = zeros(length(subject),length(frequencies),length(thresholds),length(conditions),length(times));
alltree_measures.pathrand  = zeros(length(subject),length(frequencies),length(thresholds),length(conditions),length(times));
alltree_measures.rclubrand  = zeros(length(subject),length(frequencies),length(thresholds),length(conditions),length(times));
% alltree_measures.treeh      = zeros(length(subject),length(thresholds),length(conditions),length(times));
% DIFFDATA.conditions = rmfield(DIFFDATA.conditions, 'mixrepeat'); %no mixrepeat data
names = fieldnames(ALLDATA.conditions);%variable names within structure for looping
%% Generate Clustering Coefficent and Path Length for Raw Connectivity Matrices
multiWaitbar( 'CloseAll' );
matlabpool(4);
try
    for freq_i = 1:length(frequencies)
        multiWaitbar('Frequency',freq_i/length(frequencies));
        for thresh_i = 1:length(thresholds);
            multiWaitbar('Threshold',thresh_i/length(thresholds));
            for cond_i = 1:length(names)
                multiWaitbar('Condition',cond_i/length(names));
                G     = weight_conversion(abs(zdat.conditions.(names{cond_i}).(frequencies{freq_i})),'normalize');
                multiWaitbar('Processing','Reset');
                for subject = 1:size(G,1)
                    multiWaitbar('Processing',subject/size(G,1));
                    for time_i = 1:size(G,2)
                        G_thr(subject,time_i,:,:) = threshold_proportional(squeeze(G(subject,time_i,:,:)),thresholds(thresh_i));
                        %check undirected - sometimes threshold_proportional matrices arent't square
                        if ~isequal(squeeze(G_thr(subject,time_i,:,:)),squeeze(G_thr(subject,time_i,:,:)).');
                            fprintf('\n%s\t%s\%s\t%s\t%s\t%s\t%s\t%s','Fixing threshold for subject:',num2str(subject),'time:',num2str(time_i),'threshold:',num2str(thresholds(thresh_i)),'frequency:',frequencies{freq_i})
                            for row = 1:size(G_thr,3)
                                for col = 1:size(G_thr,4)
                                    G_thr(subject,time_i,row,col) = G_thr(subject,time_i,col,row);%copy cells to oppposite side of matrix
                                end
                            end
                        end
                    end
                end
                G_bin = weight_conversion(G_thr,'binarize');
                G_dis = zeros(size(G_bin));
                multiWaitbar('Processing','Reset');
                for subject = 1:size(G_bin,1)
                    multiWaitbar('Processing',subject/size(G,1));
                    parfor time_i = 1:size(G_bin,2)
                        G_dis(subject,time_i,:,:) = distance_bin(squeeze(G_bin(subject,time_i,:,:)));
                    end
                end
                multiWaitbar('Processing','Reset');
                for subject = 1:size(G_bin,1)
                    multiWaitbar('Processing',subject/size(G,1));
                    for time_i = 1:size(G_bin,2)
                        R(subject,time_i,:,:)     = randomizer_bin_und(squeeze(G_bin(subject,time_i,:,:)),0.5);%null model network
                    end
                end
                multiWaitbar('Processing','Reset');
                for subject = 1:size(R,1)
                    multiWaitbar('Processing',subject/size(G,1));
                    parfor time_i = 1:size(R,2)
                        R_dis(subject,time_i,:,:) = distance_bin(squeeze(R(subject,time_i,:,:)));
                    end
                end
                multiWaitbar('Processing','Reset');
                for subject = 1:size(R,1)
                    multiWaitbar('Processing',subject/size(G,1));
                    for time_i = 1:size(R,2)
                        alltree_measures.clustering(subject,freq_i,thresh_i,cond_i,time_i)     = mean(clustering_coef_bu(squeeze(G_bin(subject,time_i,:,:))));
                        alltree_measures.path(subject,freq_i,thresh_i,cond_i,time_i)           = abs(charpath(squeeze(G_dis(subject,time_i,:,:))));
                        alltree_measures.rclub(subject,freq_i,thresh_i,cond_i,time_i)          = max(rich_club_bu(squeeze(G_bin(subject,time_i,:,:))));
                        alltree_measures.clusteringrand(subject,freq_i,thresh_i,cond_i,time_i) = mean(clustering_coef_bu(squeeze(R(subject,time_i,:,:))));
                        alltree_measures.pathrand(subject,freq_i,thresh_i,cond_i,time_i)       = abs(charpath(squeeze(R_dis(subject,time_i,:,:))));
                        alltree_measures.rclubrand(subject,freq_i,thresh_i,cond_i,time_i)      = max(rich_club_bu(squeeze(R(subject,time_i,:,:))));
                    end
                end
                clear G* R*
            end%cond_i loop
        end%thresh_i loop
    end%freq_i loop
catch exception
    exception
    matlabpool close force;
end
matlabpool close;
graphmeasures = alltree_measures;
save(['F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\' frequencies{freq_i} '_graphmeasures_highthresh.mat'],'graphmeasures');
multiWaitbar( 'CloseAll' );
clear ALLDATA %free up some memory
%% Draw Subplots
% First need to make corrected clustering and path lengths
% Also make small worldedness measure from these
graphmeasures.clusteringcorr = graphmeasures.clustering./graphmeasures.clusteringrand;
graphmeasures.pathcorr       = graphmeasures.path./graphmeasures.pathrand;
graphmeasures.smallworld     = ((graphmeasures.clustering./graphmeasures.clusteringrand)./(graphmeasures.path./graphmeasures.pathrand));
graphmeasures.rclubcorr      = graphmeasures.rclub./graphmeasures.rclubrand;
conditions = {'dirleft','dirright','nondirleft','nondirright'};
times = {'-200 to 0','-100 to 100', '0 to 200', '100 to 300', '200 to 400', ...
    '300 to 500', '400 to 600', '500 to 700', '600 to 800', '700 to 900', ...
    '800 to 1000', '900 to 1100', '1000 to 1200', '1100 to 1300', ...
    '1200 to 1400', '1300 to 1500', '1400 to 1600','1500to1700','1600to1800', ...
    '1700to1900','1800to2000','1900to2100','2000to2200','2100to2300'};
linecolours = {'xr','xb','xg','xk';'or','ob','og','ok'; ...
    '+r','+b','+g','+k';'*r','*b','*g','*k'; ...
    '.r','.b','.g','.k'};
for time_i = 1:length(times)
    figure()
    for freq_i = 1:length(frequencies)
        hold on;
        %clustering coefficient
        subplot(2,2,1);
        title(['Clustering Coef: ' times{time_i}]);
        for thresh_i = 1:length(thresholds)
            for cond_i = 1:length(conditions)
                hold on;
                plot(thresholds(thresh_i),squeeze(mean(graphmeasures.clusteringcorr(1:48,freq_i,thresh_i,cond_i,time_i))),linecolours{freq_i,cond_i})
            end
        end
        %Path length
        subplot(2,2,2);
        title(['Path Length: ' times{time_i}]);
        for thresh_i = 1:length(thresholds)
            for cond_i = 1:length(conditions)
                hold on;
                plot(thresholds(thresh_i),squeeze(mean(graphmeasures.pathcorr(1:48,freq_i,thresh_i,cond_i,time_i))),linecolours{freq_i,cond_i})
            end
        end
        %Small World
        subplot(2,2,3);
        title(['Small World: ' times{time_i}]);
        for thresh_i = 1:length(thresholds)
            for cond_i = 1:length(conditions)
                hold on;
                plot(thresholds(thresh_i),squeeze(mean(graphmeasures.smallworld(1:48,freq_i,thresh_i,cond_i,time_i))),linecolours{freq_i,cond_i})
            end
        end
        %Rich Club
        subplot(2,2,4);
        title(['Rich Club: ' times{time_i}]);
        for thresh_i = 1:length(thresholds)
            for cond_i = 1:length(conditions)
                hold on;
                plot(thresholds(thresh_i),squeeze(mean(graphmeasures.rclubcorr(1:48,freq_i,thresh_i,cond_i,time_i))),linecolours{freq_i,cond_i})
            end
        end
    end
%     saveas(gcf,['F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\Graph_Measures_' times{time_i} '.pdf'],'pdf');
end

%% Save off data
clustering = [];
path = [];
smallworld = [];
richclub = [];
for freq_i = 1:length(frequencies)
%     load(['F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\' frequencies{freq_i} '_graphmeasures.mat']);
    for thresh_i = 1:length(thresholds)
        for cond_i = 1:length(conditions)
            for time_i = 1:length(times)
                clustering = [clustering, graphmeasures.clusteringcorr(:,freq_i,thresh_i,cond_i,time_i)];
                path = [path, graphmeasures.pathcorr(:,freq_i,thresh_i,cond_i,time_i)];
                smallworld = [smallworld, graphmeasures.smallworld(:,freq_i,thresh_i,cond_i,time_i)];
                richclub = [richclub, graphmeasures.rclubcorr(:,freq_i,thresh_i,cond_i,time_i)];
            end
        end
    end
end
filelist = {'clustering','path','smallworld','richclub'};
for file_i = 1:length(filelist)
    save(['F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\' filelist{file_i} '_highcutoff.txt'],filelist{file_i},'-ascii','-tabs')
end
%freq thresh condition time
labels{1,(length(frequencies)*length(thresholds)*length(conditions)*length(times))} = [];
cond_abrv = {'MR','ST','SA','NI'};
times = 1:17;
count = 0;
for freq_i =1:length(frequencies)
    multiWaitbar('Frequency:',freq_i/length(frequencies));
    for thresh_i = 1:length(thresholds)
            multiWaitbar('Threshold:',thresh_i/length(thresholds));
        for cond_i = 1:length(conditions)
                multiWaitbar('Condition:',cond_i/length(conditions));
            for time_i = 1:length(times)
                    multiWaitbar('Time:',time_i/length(times));
                count = count+1;
                labels{1,count} = [upper(frequencies{freq_i}(1)) '_' ... 
                    num2str(thresholds(thresh_i)) '_' cond_abrv{cond_i} '_' num2str(times(time_i))];
            end
        end
    end
end
multiWaitbar('CloseAll');


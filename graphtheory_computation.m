%% Graph theory metrics
% Uses brain connectivitytoolbox functions on
% 'raw' connectivity matrices
% Patrick Cooper, 2014
% Functional Neuroimaging Laboratory, University of Newcastle
%% Set up globals
clear all
close all
CWD = 'F:\FNL_EEG_TOOLBOX\ANALYSES\CONNECTIVITY_MATRICES\';
addpath(genpath('C:\Users\psc600\Desktop\BCT'));
addpath(genpath('C:\Users\psc600\Desktop\MultiWaitBar'));
load([CWD 'ALLDATA.mat']);
subject = 1:size(ALLDATA.conditions.switchto.delta,1);
conditions = {'mixrepeat','switchto','switchaway','noninf'};
times = 1:17;%size(DIFFDATA.conditions.switchto.delta,2);
thresholds = 0.8:0.05:0.95;
alltree_measures.clustering   = zeros(length(subject),length(thresholds),length(conditions),length(times));
alltree_measures.path = zeros(length(subject),length(thresholds),length(conditions),length(times));
alltree_measures.rclub  = zeros(length(subject),length(thresholds),length(conditions),length(times));
alltree_measures.clusteringrand  = zeros(length(subject),length(thresholds),length(conditions),length(times));
alltree_measures.pathrand  = zeros(length(subject),length(thresholds),length(conditions),length(times));
alltree_measures.rclubrand  = zeros(length(subject),length(thresholds),length(conditions),length(times));
% alltree_measures.treeh      = zeros(length(subject),length(thresholds),length(conditions),length(times));
% DIFFDATA.conditions = rmfield(DIFFDATA.conditions, 'mixrepeat'); %no mixrepeat data
names = fieldnames(ALLDATA.conditions);%variable names within structure for looping
%% Generate Clustering Coefficent and Path Length for Raw Connectivity Matrices
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
multiWaitbar( 'CloseAll' );
parfor bin = 1:length(frequencies)%freq_i = 1:length(frequencies)
    multiWaitbar('Frequency: ',freq_i/length(frequencies));
%     fprintf('\n%s\t%s','Processing Frequency:',frequencies{freq_i})
    for sub_i = 1:length(subject)
        multiWaitbar('Subject: ',sub_i/length(subject));
%         fprintf('\n%s\t%s\n%s','Processing Subject:',num2str(sub_i),'Threshold:    ');
        for thresh_i = 1:length(thresholds);
            multiWaitbar('Threshold: ',thresh_i/length(thresholds));
%             fprintf('\b\b\b\b%1.2f',thresholds(thresh_i));
            for time_i = 1:length(times)
                multiWaitbar('Time: ',time_i/length(times));
%                 fprintf('.');
                for field_i = 1:length(names)
                    multiWaitbar('Condition: ',field_i/length(names));
                    currentnet = weight_conversion(squeeze(ALLDATA.conditions.(names{field_i}).(frequencies{freq_i})(sub_i,time_i,:,:)),'normalize');
                    currentnet_thr = threshold_absolute(currentnet,thresholds(thresh_i));
                    currentnet_bin = weight_conversion(currentnet_thr,'binarize');
%                     currentnet_dis = weight_conversion(currentnet_thr,'lengths');
                    currentnet_dis = distance_bin(currentnet_bin);
                    %make random null model network
                    currentnet_rand = randomizer_bin_und(currentnet_bin,0.5);
%                     currentnet_rdis = weight_conversion(currentnet_rand,'lengths');
                    currentnet_rdis = distance_bin(currentnet_rand);
                    alltree_measures.clustering(sub_i,thresh_i,field_i,time_i) = mean(clustering_coef_bu(currentnet_bin)~=0);%clustering coef
                    alltree_measures.path(sub_i,thresh_i,field_i,time_i) = abs(charpath(currentnet_dis));%pathlength
                    alltree_measures.rclub(sub_i,thresh_i,field_i,time_i)  = max(rich_club_bu(currentnet_bin));
                    alltree_measures.clusteringrand(sub_i,thresh_i,field_i,time_i) = mean(clustering_coef_bu(currentnet_rand)~=0);%clustering coef
                    alltree_measures.pathrand(sub_i,thresh_i,field_i,time_i) = abs(charpath(currentnet_rdis));%pathlength
                    alltree_measures.rclubrand(sub_i,thresh_i,field_i,time_i)  = max(rich_club_bu(currentnet_rand));
%                     clear currentnet*
                end
%                 if time_i == length(times)
% %                     fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');%syntax sugar
%                 end
            end%time_i loop
        end%thresh_i loop
    end%sub_i loop
%     fprintf('\n');
    %% Create corrected values and small-worldedness ratios
    alltree_measures.clusteringcorr = alltree_measures.clustering./alltree_measures.clusteringrand;
    alltree_measures.pathcorr = alltree_measures.path./alltree_measures.pathrand;
    alltree_measures.smallworld = ((alltree_measures.clustering./alltree_measures.path)./(alltree_measures.clusteringrand./alltree_measures.pathrand));
    alltree_measures.rclubcorr = alltree_measures.rclub./alltree_measures.rclubrand;
%     graphmeasures = alltree_measures;
%     save(['F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\' frequencies{freq_i} '_graphmeasures_highthresh.mat'],'graphmeasures');

end%freq_i loop 
graphmeasures = alltree_measures;
save(['F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\' frequencies{freq_i} '_graphmeasures_highthresh.mat'],'graphmeasures');
multiWaitbar( 'CloseAll' );
clear ALLDATA %free up some memory
%% plot differences in graph metrics for each frequency band
thresholds = 0.10:0.05:0.3;
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
conditions = {'mixrepeat','switchto','switchaway','noninf'};
times = {'-200 to 0','-100 to 100', '0 to 200', '100 to 300', '200 to 400', ...
    '300 to 500', '400 to 600', '500 to 700', '600 to 800', '700 to 900', ...
    '800 to 1000', '900 to 1100', '1000 to 1200', '1100 to 1300', ...
    '1200 to 1400', '1300 to 1500', '1400 to 1600'};
linecolours = {'xr','xb','xg','xk';'or','ob','og','ok'; ...
    '+r','+b','+g','+k';'*r','*b','*g','*k'; ...
    '.r','.b','.g','.k'};
for time_i = 1:length(times)
    figure()
    for freq_i = 1:length(frequencies)
        load(['F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\' frequencies{freq_i} '_graphmeasures.mat']);
        hold on;
        %clustering coefficient
        subplot(2,2,1);
        title(['Clustering Coef: ' times{time_i}]);
        for thresh_i = 1:length(thresholds)
            for cond_i = 1:length(conditions)
                hold on;
                plot(thresholds(thresh_i),squeeze(mean(graphmeasures.clusteringcorr(:,thresh_i,cond_i,time_i))),linecolours{freq_i,cond_i})
            end
        end
        %Path length
        subplot(2,2,2);
        title(['Path Length: ' times{time_i}]);
        for thresh_i = 1:length(thresholds)
            for cond_i = 1:length(conditions)
                hold on;
                plot(thresholds(thresh_i),squeeze(mean(graphmeasures.pathcorr(:,thresh_i,cond_i,time_i))),linecolours{freq_i,cond_i})
            end
        end
        %Small World
        subplot(2,2,3);
        title(['Small World: ' times{time_i}]);
        for thresh_i = 1:length(thresholds)
            for cond_i = 1:length(conditions)
                hold on;
                plot(thresholds(thresh_i),squeeze(mean(graphmeasures.smallworld(:,thresh_i,cond_i,time_i))),linecolours{freq_i,cond_i})
            end
        end
        %Rich Club
        subplot(2,2,4);
        title(['Small World: ' times{time_i}]);
        for thresh_i = 1:length(thresholds)
            for cond_i = 1:length(conditions)
                hold on;
                plot(thresholds(thresh_i),squeeze(mean(graphmeasures.rclubcorr(:,thresh_i,cond_i,time_i))),linecolours{freq_i,cond_i})
            end
        end
    end
    saveas(gcf,['F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\Graph_Measures_' times{time_i} '.pdf'],'pdf');
end
clustering = [];
path = [];
smallworld = [];
richclub = [];
for freq_i = 1:length(frequencies)
    load(['F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\' frequencies{freq_i} '_graphmeasures.mat']);
    for thresh_i = 1:length(thresholds)
        for cond_i = 1:length(conditions)
            for time_i = 1:length(times)
                clustering = [clustering, graphmeasures.clusteringcorr(:,thresh_i,cond_i,time_i)];
                path = [path, graphmeasures.pathcorr(:,thresh_i,cond_i,time_i)];
                smallworld = [smallworld, graphmeasures.smallworld(:,thresh_i,cond_i,time_i)];
                richclub = [richclub, graphmeasures.rclubcorr(:,thresh_i,cond_i,time_i)];
            end
        end
    end
end
save('F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\clustering.txt','clustering','-ascii','-tabs')
save('F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\path.txt','path','-ascii','-tabs')
save('F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\smallworld.txt','smallworld','-ascii','-tabs')
save('F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\richclub.txt','richclub','-ascii','-tabs')
    
    %% Create corrected values and small-worldedness ratios
    alltree_measures.clusteringcorr = alltree_measures.clustering./alltree_measures.clusteringrand;
    alltree_measures.pathcorr = alltree_measures.path./alltree_measures.pathrand;
    alltree_measures.smallworld = ((alltree_measures.clustering./alltree_measures.path)./(alltree_measures.clusteringrand./alltree_measures.pathrand));
    graphmeasures = alltree_measures;
    save(['F:\FNL_EEG_TOOLBOX\ANALYSES\GRAPH_THEORY\' frequencies{freq_i} '_graphmeasures.mat'],'graphmeasures');
end%freq_i loop
%% Create figures for graph metrics
linepropsc = {'-r','-b','-g','-k'};
linepropsp = {'.-r','.-b','.-g','.-k'};
figure();
hold on
for time_i = 1:size(alltree_measures.clustering,4)
    figure();
    hold on;
    for thresh_i = 1:size(alltree_measures.clustering,2)-1
        for cond_i = 1:size(alltree_measures.clustering,3)
            plot(thresholds(thresh_i),squeeze(mean(alltree_measures.smallworld(:,thresh_i,cond_i,time_i))./mean(alltree_measures.pathrand(:,thresh_i,cond_i,time_i))),linepropsp{cond_i});
        end
    end
    hold off
end
%%
%figures
lineprops = {'.-r','.-b','.-g','.-k'};
subplot(2,2,1);
hold on;
xlabel('Time(ms)')
ylabel('Diameter')
title('Diameter')
for cond_i = 1:size(alltree_measures.diameter,2)
    plot(squeeze(mean(alltree_measures.diameter(:,cond_i,:))),lineprops{cond_i});
end
set(gca,'XTick',0:2:18,'XTickLabel',{'-200','C','200','400','600','800','T','200','400','600'});
% ylim([0 25])
subplot(2,2,2);
hold on;
xlabel('Time(ms)')
ylabel('Leaves')
title('Leaf Number')
for cond_i = 1:size(alltree_measures.diameter,2)
    plot(squeeze(mean(alltree_measures.leafnumber(:,cond_i,:))),lineprops{cond_i});
end
set(gca,'XTick',0:2:18,'XTickLabel',{'-200','C','200','400','600','800','T','200','400','600'});
% ylim([0 30])
subplot(2,2,3);
hold on;
xlabel('Time(ms)')
ylabel('Degree')
title('Maximum Degree')
for cond_i = 1:size(alltree_measures.diameter,2)
    plot(squeeze(mean(alltree_measures.maxdegree(:,cond_i,:))),lineprops{cond_i});
end
set(gca,'XTick',0:2:18,'XTickLabel',{'-200','C','200','400','600','800','T','200','400','600'});
% ylim([0 11])
subplot(2,2,4);
hold on;
xlabel('Time(ms)')
ylabel('Nodes (n)')
title('Tree h')
for cond_i = 1:size(alltree_measures.diameter,2)
    plot(squeeze(mean(alltree_measures.treeh(:,cond_i,:))),lineprops{cond_i});
end
set(gca,'XTick',0:2:18,'XTickLabel',{'-200','C','200','400','600','800','T','200','400','600'});
% ylim([63 65])
set(gcf,'Color',[1 1 1])
set(gcf, 'Position', [100, 100, 1920, 1280]);
legend(conditions);
hold off;
%%
saveas(gcf,'G:\MinSpanTree\MST_ICON\ALLDATA_n121.pdf','pdf');
close all
%% Perform statistical analyses
% columns = factor A, rows = factor B
names = fieldnames(alltree_measures);
for field_i = 1:length(names)
    fprintf('%s\t%s\n','Performing ANOVA on:',names{field_i});
    [p,table,stats] = anova2(reshape(alltree_measures.(names{field_i}),(length(subject)*length(conditions)),length(times)),size(ALLDATA.conditions.switchto.delta,1));
end
%remember to grab the values from the tables!
%finally run some t-test to see post-hoc where differences may occur
pvals = zeros(length(names),length(conditions),length(times));
for field_i = 1:length(names)
    for time_i = 1:length(times)
        [~,pvals(field_i,1,time_i)] = ttest(alltree_measures.(names{field_i})(:,1,time_i),alltree_measures.(names{field_i})(:,2,time_i));
        [~,pvals(field_i,2,time_i)] = ttest(alltree_measures.(names{field_i})(:,1,time_i),alltree_measures.(names{field_i})(:,3,time_i));
        [~,pvals(field_i,3,time_i)] = ttest(alltree_measures.(names{field_i})(:,2,time_i),alltree_measures.(names{field_i})(:,3,time_i));
    end
end
sigpairs = pvals<0.05;
contrastnames = cell(size(pvals));
pairnames = {'STvSA','STvNI','SAvNI'};
for ind1 = 1:size(sigpairs,1)
    for ind2 = 1:size(sigpairs,2)
        for ind3 = 1:size(sigpairs,3)
            contrastnames{ind1,ind2,ind3} = [names{ind1} '_' pairnames{ind2} '_' num2str(times(ind3))];
        end
    end
end
%now assign the sig pair names to a list, for easy identification
sigcontrasts = cell(1,length(any(sigpairs)));
count = 0;
for ind1 = 1:size(sigpairs,1)
    for ind2 = 1:size(sigpairs,2)
        for ind3 = 1:size(sigpairs,3)
            if sigpairs(ind1,ind2,ind3) == 1;
                count = count+1;
                sigcontrasts{1,count} = contrastnames{ind1,ind2,ind3};
            end
        end
    end
end
sigcontrasts = sigcontrasts';
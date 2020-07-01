%% Set up parameters
clear all;close all;clc;
datain = 'F:\fieldtrip\WAVELET_OUTPUT_DIR\';
dataout = 'F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\';
frex=logspace(log10(2),log10(50),80);
freqs = {1:18;19:35;36:49;50:68};%delta theta alpha beta
freq_labels ={'DELTA','THETA','ALPHA','BETA'};
times = -900:0.5:4000;
channels = 64;
labels = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5',...
    'T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
    'POz','Pz','CPz','Fpz','Fp2','AF8','AF4','AFz','Fz','F2','F4','F6','F8','FT8','FC6',...
    'FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6',...
    'P8','P10','PO8','PO4','O2'}';

names = {'DCR102'	'DCR103'	'DCR204'	'DCR205'	'DCR106'	'DCR207'	'DCR108'	'DCR109'	'DCR210'	'DCR211'	'DCR212'	'DCR113'	'DCR114'	'DCR215'	'DCR116'	'DCR117'	'DCR218'	'DCR219'	'DCR120'	'DCR121'	'DCR222'	'DCR123'	'DCR224'	'DCR225'...
    'S1B'	'S3'	'S5'	'S6'	'S7'	'S8B'	'S10B'	'S11'	'S12B'	'S13'	'S14B'	'S15'	'S16'	'S17B'	'S18B'	'S20B'	'S21B'	'S22'	'S23'	'S24B'	'S25'	'S27B'	'S28'	'S29'	'S30B'	'S31B'	'S33'	'S34'	'S36B'	'S37'	'S38'	'S39B'	'S40B'};
groupinds = [24,57];
young = [1:24];
old =  [25:length(names)];
age_group = {young, old};
blocks={'nogo'};%{'dirleft','dirright'};{'nogo'}'nondirleft','nondirright'
blocknames = {'nogo'};%,'dir',nogo,nondir};
clusternames={'F','FC','C','CP','P'};
addpath(genpath('E:\fieldtrip\PACKAGES\fieldtrip'));
stats = zeros(length(names),5,5,5);
%% Load in data
for block_i =1:length(blocks)
    conditions=blocks{block_i};
    clusters={{'F1','Fz','F2'},...
        {'FC1','FCz','FC2'},...
        {'C1','Cz','C2'},...
        {'CP1','CPz','CP2'},...
        {'P1','Pz','P2'}};
    
    % clusterelec = {'F1','Fz','F2'};
    % clusterelec = {'FC1','FCz','FC2'};
    for cluster_i=1:length(clusters)
        clusterelec = clusters{cluster_i};
        electrodes = find(ismember(labels,clusterelec));
        count1 = 0;
        count2 = count1;
        cond_mwtf1 = zeros(80,9801);
        cond_mwtf2 = cond_mwtf1;
        
        youngdata_forttest = zeros(length(1:24),80,9801);
        olddata_forttest =zeros(length(25:length(names)),80,9801);
        
        % for group_i = 1:length(age_group)
        for name_i = 1:24
            fprintf('\n%s\t%s','Working on subject:',names{name_i});
            tempdata = zeros(80,9801);
            for cond_i = 1:length(blocks)
                for elec_i = 1:length(electrodes)
                    fprintf('.');
                    load([datain names{name_i} filesep blocks{cond_i} filesep names{name_i} '_' blocks{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                    cond_mwtf1 = cond_mwtf1 + mw_tf;
                    count1 = count1+1;
                    tempdata = tempdata+mw_tf;
                end
            end
            youngdata_forttest(name_i,:,:) = tempdata./(length(electrodes)*length(conditions));
        end
        
        for name_i = 25:length(names)
            fprintf('\n%s\t%s','Working on subject:',names{name_i});
            tempdata = zeros(80,9801);
            for cond_i = 1:length(blocks)
                for elec_i = 1:length(electrodes)
                    fprintf('.');
                    load([datain names{name_i} filesep blocks{cond_i} filesep names{name_i} '_' blocks{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
                    cond_mwtf2 = cond_mwtf2 + mw_tf;
                    count2 = count2+1;
                    tempdata = tempdata+mw_tf;
                end
                
            end
            olddata_forttest(name_i,:,:) = tempdata./(length(electrodes)*length(conditions));
        end
%         if strcmpi(clusternames{cluster_i},'P')
%             p_young = zeros(68,length(1:9801));
%             for freq = 1:68
%                 [~,p_young(freq,:)] = ttest(squeeze(youngdata_forttest(:,freq,1:9801)));
%             end
%             
%             p_old = zeros(68,length(1:9801));
%             for freq = 1:68
%                 [~,p_old(freq,:)] = ttest(squeeze(olddata_forttest(:,freq,1:9801)));
%             end
%             
%             addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox\'));
%             thresh =0.005;
%             [~,crit_p]=fdr_bky(p_young,thresh,'no');
%             p_thresh_young=zeros(size(p_young));
%             p_thresh_young(p_young<crit_p)=1;
%             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_young' blocknames{block_i} '_Pz.mat'],'p_thresh_young');
%             
%             [~,crit_p]=fdr_bky(p_old,thresh,'no');
%             p_thresh_old=zeros(size(p_old));
%             p_thresh_old(p_old<crit_p)=1;
%             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_old' blocknames{block_i} '_Pz.mat'],'p_thresh_old');
%         end
        %% Avg across names
        young_avg = cond_mwtf1./count1;
        old_avg = cond_mwtf2./count2;
        % avg_group = cond_mwtf/length(names);
        
        save(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_avg' blocknames{block_i} '_' clusternames{cluster_i} '_power.mat'],'young_avg');
        save(['F:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_avg' blocknames{block_i} '_' clusternames{cluster_i} '_power.mat'],'old_avg');
        
        
        %% filter sig for plotting outlines
        
        %% Plot
%         figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);
%         %             subplot(1,2,1);contourf(times(801:6801),frex(1:68),young_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
% %         mask_data_young=zeros(size(young_avg(1:68,801:6801)));
% %         temp_data_young=young_avg(1:68,801:6801);
% %         mask_data_young(p_thresh_young(1:68,:)==1)=temp_data_young(p_thresh_young(1:68,:)==1);
%         subplot(1,2,1);contourf(times(1401:6201),frex(1:68),young_avg(1:68,1401:6201),50,'linecolor','none');caxis([-2 2])
%         hold on;
% %        subplot(1,2,1);contour(times(801:6801),frex(1:68),p_thresh_young(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
%         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
%         set(gca,'FontSize',18);title(['YOUNG ' clusternames{cluster_i} ' ' blocknames{block_i}]);axis square;
%         
% %         mask_data_old=zeros(size(old_avg(1:68,801:6801)));
% %         temp_data_old=old_avg(1:68,801:6801);
% %         mask_data_old(p_thresh_old(1:68,:)==1)=temp_data_old(p_thresh_old(1:68,:)==1);
%         subplot(1,2,2);contourf(times(1401:6201),frex(1:68),old_avg(1:68,1401:6201),50,'linecolor','none');caxis([-2 2])
%         
%         %             subplot(1,2,2);contourf(times(801:6801),frex(1:68),old_avg(1:68,801:6801),50,'linecolor','none');caxis([-2 2])
%         hold on;
% %         subplot(1,2,2);contour(times(801:6801),frex(1:68),p_thresh_old(1:68,:),1,'linecolor','k','linewidth',3);caxis([-2 2])
%         xlabel('Time (ms)','FontSize',18);ylabel('Frequency (Hz)','FontSize',18);
%         set(gca,'FontSize',18);title(['OLD ' clusternames{cluster_i} ' ' blocknames{block_i}]);axis square;
%         saveas(gcf,[dataout 'TIMEF_' clusternames{cluster_i} '_' blocknames{block_i} '_Power.pdf'],'pdf');
%         close
%         
        %         freqs = {1:18;19:35;36:48;49:67};
        %         fprintf('\n\n%s\t','**********EXTRACTING AVERAGE VALUES**********');
        % %         if strcmpi(clusternames{cluster_i},'FC')
        %             for freq_i = 1:length(freqs)
        %                 fprintf('.');
        %                 tmp_p = squeeze(p_thresh_young(freqs{freq_i},:));
        %                 tmp_data = zeros(length(freqs{freq_i}),length(801:6801));
        %                 tmp_data(tmp_p ~= 1) = NaN;
        %                 tmp_inds = ~isnan(tmp_data);
        %                 for name_i = 1:24
        %                     for cond_i = 1:length(conditions)
        %                         load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
        %                         tmp_data_squeezed = squeeze(mw_tf(freqs{freq_i},801:6801));
        %                         tmp_data_val = mean(tmp_data_squeezed(tmp_inds==1));
        %                         if strcmpi(blocknames{block_i},'nondir')
        %                             stats(name_i,(cond_i+length(blocknames{1})),cluster_i,freq_i) = tmp_data_val;
        %                         else
        %                             stats(name_i,cond_i,cluster_i,freq_i) = tmp_data_val;
        %                         end
        %
        %                     end
        %                 end
        %             end
        %             fprintf('\n');
        %             for freq_i = 1:length(freqs)
        %                 fprintf('.');
        %                 tmp_p = squeeze(p_thresh_old(freqs{freq_i},:));
        %                 tmp_data = zeros(length(freqs{freq_i}),length(801:6801));
        %                 tmp_data(tmp_p ~= 1) = NaN;
        %                 tmp_inds = ~isnan(tmp_data);
        %                 for name_i = 25:length(names)
        %                     for cond_i = 1:length(conditions)
        %                         load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
        %                         tmp_data_squeezed = squeeze(mw_tf(freqs{freq_i},801:6801));
        %                         tmp_data_val = mean(tmp_data_squeezed(tmp_inds==1));
        %                         if strcmpi(blocknames{block_i},'nondir')
        %                             stats(name_i,(cond_i+length(blocknames{1})),cluster_i,freq_i) = tmp_data_val;
        %                         else
        %                             stats(name_i,cond_i,cluster_i,freq_i) = tmp_data_val;
        %                         end
        %                     end
        %                 end
        %             end
        %         end
        
        
    end
end
%% plot
close all
subjs1 = 1:24;
subjs2=25:length(names);
for cluster_i=1:length(clusternames)
    figure();
    for freq_i=1:5
        subplot(2,3,freq_i);bar([squeeze(mean(stats(subjs1,:,cluster_i,freq_i),1)),squeeze(mean(stats(subjs2,:,cluster_i,freq_i),1))]);
        ylim([-2.5 2.5]);title(['freq: ' num2str(freq_i) ' ' clusternames{cluster_i}]);
    end
end
%% headplots
clear cond_mwtf1 cond_mwtf2 count* mw_tf olddata_forttest youngdata_forttest tempdata old_avg young_avg
% load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_young.mat');
% load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_old.mat');
timesets = {(1801:2801),(2801:6801)};
timeind = {1:length(1801:2801),1:length(2801:6801)};
% TIMECUTOFF = [2801;1001;4001];
for block_i =1:length(blocks)
    conditions=blocks{block_i};
    load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_data' blocknames{block_i} '.mat']);
    load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_data' blocknames{block_i} '.mat']);
    
    for cond_i = 1:length(blocks{block_i})
        fprintf('\n%s', conditions{cond_i})
        filename = ['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\' conditions{cond_i} '_topovals.txt'];
        header = {};
        
        for elec_i = 1:length(labels)
            for freq_i = 1:length(freqs)
                for time_i = 1:length(timesets)
                    header = [header; labels{elec_i} '.' freq_labels{freq_i} '.' num2str(time_i)];
                end
            end
        end
        header = header';
        fid = fopen(filename, 'w');
        fprintf(fid, '%s\t', 'Subject');
        for header_i = 1:length(header)
            if header_i ~= length(header)
                fprintf(fid, '%s\t', header{header_i})
            elseif header_i == length(header)
                fprintf(fid, '%s', header{header_i})
            end
        end
        
        for name_i = 1:length(names)
            fprintf('.')
            fprintf(fid, '\n%s\t', names{name_i});
            for elec_i = 1:length(labels)
                load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(elec_i) '_imagcoh_mwtf.mat'],'mw_tf');
                for freq_i = 1:length(freqs)
                    for time_i = 1:length(timesets)
                        if name_i < 25
                            %                             mask_data_young=zeros(1,size(freqs{freq_i}),length(timesets{time_i}));
                            temp_data_young = mw_tf(freqs{freq_i},timesets{time_i});
                            dataval=mean(temp_data_young(p_thresh_young(freqs{freq_i},timesets{time_i})==1));
                            fprintf(fid, '%2.4f\t', dataval);
                            
                        else
                            %                             mask_data_young=zeros(1,size(freqs{freq_i}),length(timesets{time_i}));
                            temp_data_old = mw_tf(freqs{freq_i},timesets{time_i});
                            dataval=mean(temp_data_old(p_thresh_old(freqs{freq_i},timesets{time_i})==1));
                            fprintf(fid, '%2.4f\t', dataval);
                            
                        end
                    end
                    
                end
            end
%             save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies' conditions{cond_i} 'matrix.mat',condmatrix]);
%             clear condmatrix
        end
        fclose(fid);
    end
end   
    
%     if block_i == 1
%         load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_young' blocknames{block_i} '_Pz.mat']);
%         load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_old' blocknames{block_i} '_Pz.mat']);
%     else
%         load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_youngNONDIR.mat');
%         load('E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\p_thresh_oldNONDIR.mat');
%     end    
    conditions=blocks{block_i};
    clusters={labels};
    
    % clusterelec = {'F1','Fz','F2'};
    % clusterelec = {'FC1','FCz','FC2'};
%     for cluster_i=1:length(clusters)
%         clusterelec = clusters{cluster_i};
%         electrodes = find(ismember(labels,clusterelec));
%         count1 = 0;
%         count2 = count1;        
%         % for group_i = 1:length(age_group)
%         young_data = zeros(64,80,9801);
%         for name_i = 1:24
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             tic;
%             for cond_i = 1:length(conditions)
%                 fprintf('.');
%                 for elec_i = 1:length(electrodes)
%                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     temp = squeeze(young_data(elec_i,:,:))+mw_tf;
%                     young_data(elec_i,:,:) = temp;
%                     clear temp;
% %                     for f=1:80
% %                         for t = 1:9801
% %                             young_data(elec_i,f,t) = young_data(elec_i,f,t)+mw_tf(f,t);
% %                         end
% %                     end
%                 end
%             end
%             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
%         end
%         young_data = young_data./(length(conditions)*24);
%         save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_data' blocknames{block_i} '.mat'],'young_data');
        load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\young_data' blocknames{block_i} '.mat']);
        
%         old_data = zeros(64,80,9801);for name_i = 25:length(names)
%             tic;
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             for cond_i = 1:length(conditions)                    
%                 fprintf('.');
%                 for elec_i = 1:length(electrodes)
%                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     temp = squeeze(old_data(elec_i,:,:))+mw_tf;
%                     old_data(elec_i,:,:) = temp;
%                     clear temp;
% %                     for f=1:80
% %                         for t = 1:9801
% %                             old_data(elec_i,f,t) = old_data(elec_i,f,t)+mw_tf(f,t);
% %                         end
% %                     end
%                 end
%                 
%             end
%             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
%         end
%         
%         old_data = old_data./length(conditions)*33;

%         old_data = zeros(64,80,9801);
%         for name_i = 25:length(names)
%             fprintf('\n%s\t%s','Working on subject:',names{name_i});
%             tic;
%             for cond_i = 1:length(conditions)
%                 fprintf('.');
%                 for elec_i = 1:length(electrodes)
%                     load([datain names{name_i} filesep conditions{cond_i} filesep names{name_i} '_' conditions{cond_i} '_' num2str(electrodes(elec_i)) '_imagcoh_mwtf.mat'],'mw_tf');
%                     temp = squeeze(old_data(elec_i,:,:))+mw_tf;
%                     old_data(elec_i,:,:) = temp;
%                     clear temp;
% %                     for f=1:80
% %                         for t = 1:9801
% %                             young_data(elec_i,f,t) = young_data(elec_i,f,t)+mw_tf(f,t);
% %                         end
% %                     end
%                 end
%             end
%             t=toc;fprintf('\t%s\t%3.2f','Time taken:',t)
%         end
%         old_data = old_data./(length(conditions)*33);
%         save(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_data' blocknames{block_i} '.mat'],'old_data');
        load(['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\old_data' blocknames{block_i} '.mat']);
        
        %% Avg across names
%         young_avg = squeeze(mean(young_data,1));
%         old_avg = squeeze(mean(old_data,1));
        % avg_group = cond_mwtf/length(names);
        TIMECUTOFF=[2801;1001;2001];
        scale = [-2 2];
        count = 0;
        cfg =[];%set up config
        cfg.highlight = 'off';
        cfg.layout = 'biosemi64.lay';
        cfg.marker = 'off';
        cfg.parameter = 'avg';
        cfg.comment = 'no';
        cfg.contournum = 2;
        cfg.gridscale = 150;
        cfg.shading = 'interp';
        cfg.interactive = 'no';
        dat.var = zeros(72,1);
        dat.label = labels(:,1);
        dat.time = 1;
        dat.dimord = 'chan_time';
        cfg.zlim = scale;
        figure();set(gcf,'Position',[0 0 1920 1080],'Color',[1 1 1]);

        %topoplot
        for freq_i =length(freq_labels):-1:1

            for time_i = 1:2
                switch time_i
                    case 1%less than 500ms
                        count = count + 1;
%                         cfg =[];%set up config
%                         cfg.highlight = 'off';
%                         cfg.layout = 'biosemi64.lay';
%                         cfg.marker = 'off';
%                         cfg.parameter = 'avg';
%                         cfg.comment = 'no';
%                         cfg.contournum = 2;
%                         cfg.gridscale = 150;
%                         cfg.shading = 'interp';
%                         cfg.interactive = 'no';
%                         dat.var = zeros(72,1);
%                         dat.label = labels(:,1);
%                         dat.time = 1;
%                         dat.dimord = 'chan_time';
%                         cfg.zlim = scale;
%                         cfg.zlim ='maxmin';
%                         dat.avg = zeros(72,1);
%                         mask_data_young=zeros(size(young_data(:,freqs{freq_i},1801:TIMECUTOFF(1))));
%                         temp_data_young=young_data(:,freqs{freq_i},1801:TIMECUTOFF(1));
%                         mask_data_young(:,p_thresh_young(freqs{freq_i},1:TIMECUTOFF(2))==1)=temp_data_young(:,p_thresh_young(freqs{freq_i},1:TIMECUTOFF(2))==1);
%                         dat.avg=[squeeze(mean(mean(mask_data_young,2),3));0;0;0;0;0;0;0;0];
% %                         dat.avg=[squeeze(mean(mean(temp_data_young,2),3));0;0;0;0;0;0;0;0];
%                         subplot(4,2,count);ft_topoplotER(cfg,dat);
                        
                        dat.avg = zeros(72,1);
                        mask_data_old=zeros(size(old_data(:,freqs{freq_i},1801:TIMECUTOFF(1))));
                        temp_data_old=old_data(:,freqs{freq_i},1801:TIMECUTOFF(1));
                        mask_data_old(:,p_thresh_old(freqs{freq_i},1:TIMECUTOFF(2))==1)=temp_data_old(:,p_thresh_old(freqs{freq_i},1:TIMECUTOFF(2))==1);
                        dat.avg=[squeeze(mean(mean(mask_data_old,2),3));0;0;0;0;0;0;0;0];
                        subplot(4,2,count);ft_topoplotER(cfg,dat);
%                         
                    case 2%above 500ms
                        count = count + 1;
%                         cfg =[];%set up config
%                         cfg.highlight = 'off';
%                         cfg.layout = 'biosemi64.lay';
%                         cfg.marker = 'off';
%                         cfg.parameter = 'avg';
%                         cfg.comment = 'no';
%                         cfg.contournum = 2;
%                         cfg.gridscale = 50;
%                         cfg.shading = 'interp';
%                         cfg.interactive = 'no';
%                         dat.var = zeros(72,1);
%                         dat.label = labels(:,1);
%                         dat.time = 1;
%                         dat.dimord = 'chan_time';
%                         cfg.zlim = scale;
% %                         cfg.zlim ='maxmin';
                        dat.avg = zeros(72,1);
%                         mask_data_young=zeros(size(young_data(:,freqs{freq_i},TIMECUTOFF(1):6801)));
%                         temp_data_young=young_data(:,freqs{freq_i},TIMECUTOFF(1):6801);
%                         mask_data_young(:,p_thresh_young(freqs{freq_i},TIMECUTOFF(3):end)==1)=temp_data_young(:,p_thresh_young(freqs{freq_i},TIMECUTOFF(3):end)==1);
%                         dat.avg=[squeeze(mean(mean(mask_data_young,2),3));0;0;0;0;0;0;0;0];
% %                         dat.avg=[squeeze(mean(mean(temp_data_young,2),3));0;0;0;0;0;0;0;0];
%                         subplot(4,2,count);ft_topoplotER(cfg,dat);
                        
                        mask_data_old=zeros(size(old_data(:,freqs{freq_i},TIMECUTOFF(1):6801)));
                        temp_data_old=old_data(:,freqs{freq_i},TIMECUTOFF(1):6801);
                        mask_data_old(:,p_thresh_old(freqs{freq_i},TIMECUTOFF(3):end)==1)=temp_data_old(:,p_thresh_old(freqs{freq_i},TIMECUTOFF(3):end)==1);
                        dat.avg=[squeeze(mean(mean(mask_data_old,2),3));0;0;0;0;0;0;0;0];
                        subplot(4,2,count);ft_topoplotER(cfg,dat);
                end
            end
        end%freq_i loop
        
%   saveas(gcf,['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\youngHeadplots' blocknames{block_i} 'v2.pdf'],'pdf');
  saveas(gcf,['E:\fieldtrip\WAVELET_OUTPUT_DIR\Movies\oldHeadplots' blocknames{block_i} 'v2.pdf'],'pdf');
  
%     end
% end

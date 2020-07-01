%% create erp figures.

figure();set(gcf,'Color',[1 1 1],'Position',[0 0 1920 1080]);
cond_inds = [1 6 9];
lw = 1;%line width for plotting
fs=8;
electrodes = 9:11;
cols_for_plotting = {':g','-g',':k','-k',':r','-r'};
count =0;
mvscale = [-2 12];
headers = {'Grey Gratings','Target 1','Target 3'};
for cond_i = 1:length(cond_inds)
    for response_i = 1:length(wpms.responsetype)
        count = count+1;
        subplot(2,3,1);plot(squeeze(mean(mean(grandaverage(:,cond_inds(cond_i),response_i,electrodes,:),1),4)),cols_for_plotting{count},'LineWidth',lw);hold on;
        axis square;set(gca,'YLim',mvscale,'XLim',[0 length(time)],'XTick',[0:100:length(time)],'XTickLabel',-200:200:1200,'FontSize',fs);
        title(headers{1},'FontSize',14);ylabel('Amplitude microvolts','FontSize',fs);xlabel('Time (ms)','FontSize',fs);
    end
end
cond_inds = cond_inds+1;
count =0;
for cond_i = 1:length(cond_inds)
    for response_i = 1:length(wpms.responsetype)
        count = count+1;
    subplot(2,3,2);plot(squeeze(mean(mean(grandaverage(:,cond_inds(cond_i),response_i,electrodes,:),1),4)),cols_for_plotting{count},'LineWidth',lw);hold on;
    axis square;set(gca,'YLim',mvscale,'XLim',[0 length(time)],'XTick',[0:100:length(time)],'XTickLabel',-200:200:1200,'FontSize',fs);
    title(headers{2},'FontSize',14);ylabel('Amplitude microvolts','FontSize',fs);xlabel('Time (ms)','FontSize',fs);
    end
end
cond_inds = cond_inds+1;
count =0;
for cond_i = 1:length(cond_inds)
    for response_i = 1:length(wpms.responsetype)
        count = count+1;
    subplot(2,3,3);plot(squeeze(mean(mean(grandaverage(:,cond_inds(cond_i),response_i,electrodes,:),1),4)),cols_for_plotting{count},'LineWidth',lw);hold on;
    axis square;set(gca,'YLim',mvscale,'XLim',[0 length(time)],'XTick',[0:100:length(time)],'XTickLabel',-200:200:1200,'FontSize',fs);
    title(headers{3},'FontSize',14);ylabel('Amplitude microvolts','FontSize',fs);xlabel('Time (ms)','FontSize',fs);
    end
end
% figure();
cond_inds = [1 6 9];
% lw = 2;%line width for plotting
electrodes = 45:47;
% cols_for_plotting = {'--g','-g','--k','-k','--r','-r'};
count =0;
for cond_i = 1:length(cond_inds)
    for response_i = 1:length(wpms.responsetype)
        count = count+1;
    subplot(2,3,4);plot(squeeze(mean(mean(grandaverage(:,cond_inds(cond_i),response_i,electrodes,:),1),4)),cols_for_plotting{count},'LineWidth',lw);hold on;
    axis square;set(gca,'YLim',mvscale,'XLim',[0 length(time)],'XTick',[0:100:length(time)],'XTickLabel',-200:200:1200,'FontSize',fs);
    ylabel('Amplitude microvolts','FontSize',fs);xlabel('Time (ms)','FontSize',fs);
    end
end
cond_inds = cond_inds+1;
count =0;
for cond_i = 1:length(cond_inds)
    for response_i = 1:length(wpms.responsetype)
        count = count+1;
    subplot(2,3,5);plot(squeeze(mean(mean(grandaverage(:,cond_inds(cond_i),response_i,electrodes,:),1),4)),cols_for_plotting{count},'LineWidth',lw);hold on;
    axis square;set(gca,'YLim',mvscale,'XLim',[0 length(time)],'XTick',[0:100:length(time)],'XTickLabel',-200:200:1200,'FontSize',fs);
    ylabel('Amplitude microvolts','FontSize',fs);xlabel('Time (ms)','FontSize',fs);
    end
end
cond_inds = cond_inds+1;
count =0;
for cond_i = 1:length(cond_inds)
    for response_i = 1:length(wpms.responsetype)
        count = count+1;
    subplot(2,3,6);plot(squeeze(mean(mean(grandaverage(:,cond_inds(cond_i),response_i,electrodes,:),1),4)),cols_for_plotting{count},'LineWidth',lw);hold on;
    axis square;set(gca,'YLim',mvscale,'XLim',[0 length(time)],'XTick',[0:100:length(time)],'XTickLabel',-200:200:1200,'FontSize',fs);
    ylabel('Amplitude microvolts','FontSize',fs);xlabel('Time (ms)','FontSize',fs);
    end
end
% saveas(gcf,'ERP_Waveforms.pdf','pdf');close;

%% extract data values
%frontal
fid = fopen('Frontal_Sites.txt','w');
for cond_i = 1:length(wpms.conditions)
    for response_i=1:length(wpms.responsetype)
        for time_i = 1:size(grandaverage,5);
            datapoint = squeeze(mean(mean(grandaverage(:,cond_i,response_i,9:11,time_i),4),1));
            fprintf(fid,'\t%s',num2str(datapoint));
        end
        fprintf(fid,'\n');
    end
end
fclose(fid);

fid = fopen('Parietal_Sites.txt','w');
for cond_i = 1:length(wpms.conditions)
    for response_i=1:length(wpms.responsetype)
        for time_i = 1:size(grandaverage,5);
            datapoint = squeeze(mean(mean(grandaverage(:,cond_i,response_i,45:47,time_i),4),1));
            fprintf(fid,'\t%s',num2str(datapoint));
        end
        fprintf(fid,'\n');
    end
end
fclose(fid);
%% headplots Fig4.
% EEG = pop_loadset([wpms.dirs.DATA_DIR wpms.conditions{1} filesep wpms.names{1} '_N-CUE-R-CSD.set']);
EEG = pop_loadset([wpms.dirs.PREPROC wpms.conditions{1} filesep wpms.names{1} '_N-CUE-R-C-f.set']);
times = EEG.times;
gscale = 300;
ncont = 6;
clims = [-18 18];
time = [find(times==-200):find(times==1200)]; %wanted extraction time
times_for_plotting = {[find(time==find(times==350)):find(time==find(times==450))],...
                      [find(time==find(times==550)):find(time==find(times==600))],...
                      [find(time==find(times==750)):find(time==find(times==850))]};
cond_of_interest = 9:11;%switch conds
response_of_interest = 2;%vertical bars
labels = {'P3','LP1','LP2'};
addpath(genpath('E:\UIB_DATA\PACKAGES\mass_uni_toolbox\'));
%bad_elecs = {'Fpz','Fz','FCz','CZ','CPZ','Pz','POZ','OZ'};
%bad_inds = find(ismember({EEG.chanlocs(:).labels},bad_elecs));
%bad_neighbours = {[1 3 4 5];[9 11 4 5 18 20];[18 20 9 11 27 29];[27 29 18 20 36 38];...
%                  [36 38 27 29 45 47];[45 47 36 38 53 55];[53 55 45 47 58 60]; [53 55 58 60]};
for time_i = 1:length(times_for_plotting);
    for cond_i = 1:length(cond_of_interest)
        figure();
        datavector = squeeze(mean(mean(grandaverage(:,cond_of_interest(cond_i),response_of_interest,1:60,times_for_plotting{time_i}),5),1));
        %datavector_temp = datavector;
        %count = 0;
        %for chan = 1:length(datavector_temp)
        %    if ismember(chan,bad_inds) ==1
        %        count = count+1;
        %        datavector_temp(chan) = mean(datavector_temp([bad_neighbours{count}]));
        %    end
        %end
        h = zeros(1,size(grandaverage,4));
        p = zeros(size(h));
        for channel = 1:size(grandaverage,4)-2
            ttestvector = squeeze(mean(grandaverage(:,cond_of_interest(cond_i),response_of_interest,channel,times_for_plotting{time_i}),5));
            [h(1,channel),p(1,channel)] = ttest(ttestvector);
        end
        [h,~,adj_p] = fdr_bh(p,0.05,'pdep');
        plotchans = find(h==1);%adj_p<0.05;
%         topoplot(datavector_temp,EEG.chanlocs,'numcontour',ncont,'whitebk','on','gridscale',gscale,'shading','interp','maplimits',clims,'colormap','jet','plotchans',plotchans,'emarker',{'.','k',6,1});
        topoplot(datavector,EEG.chanlocs,'numcontour',ncont,'whitebk','on','gridscale',gscale,'shading','interp','maplimits',clims,'colormap','jet','plotchans',plotchans,'emarker',{'.','k',6,1});
%         saveas(gcf,[labels{time_i} '_' wpms.conditions{cond_of_interest(cond_i)} '_topoplot_CSD.fig'],'fig');close;
    end
end
%% headplots Fig5.
EEG = pop_loadset([wpms.dirs.PREPROC wpms.conditions{1} filesep wpms.names{1} '_N-CUE-R-C-f.set']);
times = EEG.times;
gscale = 300;
ncont = 6;
clims = [-12 12];
time = [find(times==-200):find(times==1200)]; %wanted extraction time
times_for_plotting = {[find(time==find(times==350)):find(time==find(times==450))],...
                      [find(time==find(times==550)):find(time==find(times==600))],...
                      [find(time==find(times==750)):find(time==find(times==850))]};
cond_of_interest = [1:3 6:11];%
labels = {'P3','LP1','LP2'};
addpath(genpath('E:\UIB_DATA\PACKAGES\mass_uni_toolbox\'));
for time_i = 1:length(times_for_plotting);
    for cond_i = 1:length(cond_of_interest)
        for response_i = 1:length(wpms.responsetype)
            figure();
            datavector = squeeze(mean(mean(grandaverage(:,cond_of_interest(cond_i),response_i,:,times_for_plotting{time_i}),5),1));
            h = zeros(1,size(grandaverage,4));
            p = zeros(size(h));
            for channel = 1:size(grandaverage,4)-2
                ttestvector = squeeze(mean(grandaverage(:,cond_of_interest(cond_i),response_i,channel,times_for_plotting{time_i}),5));
                [h(1,channel),p(1,channel)] = ttest(ttestvector);
            end
            [h,~,adj_p] = fdr_bh(p,0.05,'pdep');
            plotchans = find(h==1);%adj_p<0.05;
            topoplot(datavector,EEG.chanlocs,'numcontour',ncont,'whitebk','on','gridscale',gscale,'shading','interp','maplimits',clims,'colormap','jet','plotchans',plotchans,'emarker',{'.','k',6,1});
            saveas(gcf,[labels{time_i} '_' wpms.conditions{cond_of_interest(cond_i)} '_' wpms.responsetype{response_i} '_topoplot_meanamps.tif'],'tiffn');close;
        end
    end
end

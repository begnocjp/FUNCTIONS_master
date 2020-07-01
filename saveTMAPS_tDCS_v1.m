%% SAVE TMAPS FIGURES

function saveTMAPS_tDCS_v1(filename)%clear all
%close all
CWD = 'F:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\';
cd(CWD)
%load('REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER_young');
%filename = 'REORDSIGTVALS_DIFFDATA_young';

load([CWD,filename]);
a  = who('REORD*');
REORDSIGTVALS_DATA = eval(a{1,1});
eval( ['clear ',a{1,1}]);

%stim = {'activeone','shamone','activetwo','shamtwo'};
%0:100:2300
conds = fieldnames(REORDSIGTVALS_DATA.conditions);
frequencies = fieldnames(REORDSIGTVALS_DATA.conditions.(conds{1}));
times = {'0to200','100to300','200to400','300to500','400to600' ...
    '500to700','600to800','700to900','800to1000','900to1100', ...
    '1000to1200','1100to1300','1200to1400','1300to1500','1400to1600', ...
    '1500to1700','1600to1800','1700to1900','1800to2000','1900to2100', ...
    '2000to2200','2100to2300','2200to2400','2300to2500'};
%frequencies = {'delta','theta','loweralpha','upperalhpa','beta'};
labels      = {'AF3','F1','F3','F5','AF4','Afz','Fz','F2','F4', ...
                'F6','FC5','FC3','FC1','FC6','FC4','FC2','FCz','C1', ...
                'C3','C5','Cz','C2','C4','C6','CP5','CP3','CP1', ...
                'CP6','CP4','CP2','CPz','P1','P3','P5','P7','Pz', ...
                'P2','P4','P6','P8','PO7','PO3','O1','Oz','POz', ...
                'PO8','PO4','O2'};
ind = regexpi(filename,'_');
OUTPUT =  filename(ind(1)+1:length(filename));
mkdir([CWD,'\', OUTPUT]);
for cond_i = 1:length(conds)
    for time_i = 1:length(times)
        for freq_i = 1:length(frequencies)
            figure();
            hold on
            figtitle = [conds{cond_i},'-',frequencies{freq_i},'-',times{time_i}];
            title(figtitle)
            imagesc(squeeze(REORDSIGTVALS_DATA.conditions.(conds{cond_i}).(frequencies{freq_i})(time_i,:,:)));
            saveas(gcf,[CWD,'\', OUTPUT,'\',figtitle],'fig')
            saveas(gcf,[CWD,'\', OUTPUT,'\',figtitle],'bmp');
            hold off
            close all
            %create pair list structure here
            tmp = (squeeze(REORDSIGTVALS_DATA.conditions.(conds{cond_i}).(frequencies{freq_i})(time_i,:,:)));
            [row_ind,col_ind] = find(tmp);
            pairlist = {};
            for row_i = 1:length(row_ind)
                pairlist{row_i,1} = [labels{row_ind(row_i)}];
                pairlist{row_i,2} = [labels{col_ind(row_i)}];
            end%row_i loop
            save([CWD,'\', OUTPUT,'\',figtitle,'_pairlist'],'pairlist');
            clear tmp figtitle row_ind col_ind pairlist
        end
    end
end
% mkdir([CWD,'\activeone_young']);
% mkdir([CWD,'\shamone_young']);
% mkdir([CWD,'\activetwo_young']);
% mkdir([CWD,'\shamtwo_young']);
% for time_i = 1:length(times)
%     for stim_i = 1:length(stim)
%         switch stim_i
%             case 1
%                 cd([CWD,'\activeone_young'])
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{1},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.delta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.delta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{2},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.theta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.theta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{3},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.loweralpha(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.loweralpha(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{4},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.upperalpha(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.upperalpha(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{5},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.beta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                  %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activeone.beta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%             case 2
%                 cd([CWD,'\shamone_young'])
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{1},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.delta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.delta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{2},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.theta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.theta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{3},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.loweralpha(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.loweralpha(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{4},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.upperalpha(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.upperalpha(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{5},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.beta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                  %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamone.beta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%             case 3
%                 cd([CWD,'\activetwo_young'])
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{1},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.delta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.delta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{2},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.theta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.theta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{3},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.loweralpha(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.loweralpha(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{4},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.upperalpha(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.upperalpha(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{5},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.beta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                  %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.activetwo.beta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%             case 4
%                 cd([CWD,'\shamtwo_young'])
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{1},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.delta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.delta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{2},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.theta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.theta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{3},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.loweralpha(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.loweralpha(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{4},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.upperalpha(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                 %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.upperalpha(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%                 figure();
%                 hold on
%                 figtitle = [stim{stim_i},'_',frequencies{5},'_',times{time_i}];
%                 title(figtitle)
%                 imagesc(squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.beta(time_i,:,:)));
%                 saveas(gcf,figtitle,'fig')
%                 saveas(gcf,figtitle,'bmp');
%                 hold off
%                 close all
%                  %create pair list structure here
%                 tmp = (squeeze(REORDSIGTVALS_ACTIVE_SHAM_STIMDATA_ORDER.conditions.shamtwo.beta(time_i,:,:)));
%                 [row_ind,col_ind] = find(tmp);
%                 pairlist = {};
%                 for row_i = 1:length(row_ind)
%                     pairlist{row_i,1} = [labels{row_ind(row_i)}];
%                     pairlist{row_i,2} = [labels{col_ind(row_i)}];
%                 end%row_i loop
%                 save([figtitle,'_pairlist'],'pairlist');
%                 clear tmp figtitle row_ind col_ind pairlist
%         end
%         
%     end%cond_i loop
% end%time_i loop
end
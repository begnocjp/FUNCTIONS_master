%% SAVE TMAPS FIGURES
clear all
close all
CWD = 'E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES';
cd(CWD)
load('REORDSIGTVALS_DIFFDATA_young');
conditions = {'dirleft','dirright','nondirleft','nondirright'};
%0:100:2300
times = {'0to200','100to300','200to400','300to500','400to600' ...
    '500to700','600to800','700to900','800to1000','900to1100', ...
    '1000to1200','1100to1300','1200to1400','1300to1500','1400to1600', ...
    '1500to1700','1600to1800','1700to1900','1800to2000','1900to2100', ...
    '2000to2200','2100to2300','2200to2400','2300to2500'};
frequencies = {'delta','theta','loweralpha','upperalhpa','beta'};
labels      = {'AF3','F1','F3','F5','AF4','Afz','Fz','F2','F4', ...
                'F6','FC5','FC3','FC1','FC6','FC4','FC2','FCz','C1', ...
                'C3','C5','Cz','C2','C4','C6','CP5','CP3','CP1', ...
                'CP6','CP4','CP2','CPz','P1','P3','P5','P7','Pz', ...
                'P2','P4','P6','P8','PO7','PO3','O1','Oz','POz', ...
                'PO8','PO4','O2'};
mkdir([CWD,'\dirleft_young']);
mkdir([CWD,'\dirright_young']);
mkdir([CWD,'\nondirleft_young']);
mkdir([CWD,'\nondirright_young']);
for time_i = 1:length(times)
    for cond_i = 1:length(conditions)
        switch cond_i
            case 1
                cd([CWD,'\dirleft_young'])
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{1},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirleft.delta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirleft.delta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{2},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirleft.theta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirleft.theta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{3},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirleft.loweralpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirleft.loweralpha(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{4},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirleft.upperalpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirleft.upperalpha(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{5},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirleft.beta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                 %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirleft.beta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
            case 2
                cd([CWD,'\dirright_young'])
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{1},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirright.delta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirright.delta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{2},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirright.theta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirright.theta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{3},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirright.loweralpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirright.loweralpha(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{4},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirright.upperalpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirright.upperalpha(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{5},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirright.beta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                 %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.dirright.beta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
            case 3
                cd([CWD,'\nondirleft_young'])
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{1},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirleft.delta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirleft.delta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{2},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirleft.theta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirleft.theta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{3},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirleft.loweralpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirleft.loweralpha(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{4},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirleft.upperalpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirleft.upperalpha(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{5},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirleft.beta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                 %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirleft.beta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
            case 4
                cd([CWD,'\nondirright_young'])
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{1},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirright.delta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirright.delta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{2},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirright.theta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirright.theta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{3},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirright.loweralpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirright.loweralpha(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{4},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirright.upperalpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirright.upperalpha(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{5},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirright.beta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS_DIFFDATA.conditions.nondirright.beta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
        end%switch
    end%cond_i loop
end%time_i loop
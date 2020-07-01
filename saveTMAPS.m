%% SAVE TMAPS FIGURES
clear all
close all
CWD = 'E:\fieldtrip\DOWNSAMPLE\ANALYSES\CONNECTIVITY_MATRICES';
cd(CWD)
load('REORDSIGTVALS');
conditions = {'switchto','switchaway','noninf'};
times = {'-200to0','-100to100','0to200','100to300','200to400','300to500','400to600' ...
    '500to700','600to800','700to900','800to1000','900to1100', ...
    '1000to1200','1100to1300','1200to1400','1300to1500','1400to1600'};
frequencies = {'delta','theta','loweralpha','upperalhpa','beta'};
labels      = {'AF3','F1','F3','F5','AF4','Afz','Fz','F2','F4', ...
                'F6','FC5','FC3','FC1','FC6','FC4','FC2','FCz','C1', ...
                'C3','C5','Cz','C2','C4','C6','CP5','CP3','CP1', ...
                'CP6','CP4','CP2','CPz','P1','P3','P5','P7','Pz', ...
                'P2','P4','P6','P8','PO7','PO3','O1','Oz','POz', ...
                'PO8','PO4','O2'};
mkdir([CWD,'\switchto']);
mkdir([CWD,'\switchaway']);
mkdir([CWD,'\noninf']);
for time_i = 1:length(times)
    for cond_i = 1:length(conditions)
        switch cond_i
            case 1
                cd([CWD,'\switchto'])
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{1},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS.conditions.switchto.delta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.switchto.delta(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.switchto.theta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.switchto.theta(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.switchto.loweralpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.switchto.loweralpha(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.switchto.upperalpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.switchto.upperalpha(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.switchto.beta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                 %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.switchto.beta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
            case 2
                cd([CWD,'\switchaway'])
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{1},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS.conditions.switchaway.delta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.switchaway.delta(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.switchaway.theta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.switchaway.theta(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.switchaway.loweralpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.switchaway.loweralpha(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.switchaway.upperalpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.switchaway.upperalpha(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.switchaway.beta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                 %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.switchaway.beta(time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
            case 3
                cd([CWD,'\noninf'])
                figure();
                hold on
                figtitle = [conditions{cond_i},'_',frequencies{1},'_',times{time_i}];
                title(figtitle)
                imagesc(squeeze(REORDSIGTVALS.conditions.noninf.delta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.noninf.delta(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.noninf.theta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.noninf.theta(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.noninf.loweralpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.noninf.loweralpha(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.noninf.upperalpha(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.noninf.upperalpha(time_i,:,:)));
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
                imagesc(squeeze(REORDSIGTVALS.conditions.noninf.beta(time_i,:,:)));
                saveas(gcf,figtitle,'fig')
                saveas(gcf,figtitle,'bmp');
                hold off
                close all
                 %create pair list structure here
                tmp = (squeeze(REORDSIGTVALS.conditions.noninf.beta(time_i,:,:)));
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
%% Compute t-tests
% Compute one-sample t-tests for comparisons within each: freq x time x condition x group
%% Define groups
YOUNG  = 1:22;%index
OLD    = [23:44 46:56];%index
STROKE = 57:length(names);%index
condfield = fieldnames(ALLDATA.conditions);
freqfield = fieldnames(ALLDATA.conditions.(condfield{1}));
times = 1:size(ALLDATA.conditions.(condfield{1}).(freqfield{1}),2);
TVALS_YOUNG = zeros(length(condfield),length(freqfield),length(times),64,64);
PVALS_YOUNG = zeros(size(TVALS_YOUNG));
TVALS_OLD = zeros(length(condfield),length(freqfield),length(times),64,64);
PVALS_OLD = zeros(size(TVALS_OLD));
TVALS_STROKE = zeros(length(condfield),length(freqfield),length(times),64,64);
PVALS_STROKE = zeros(size(TVALS_STROKE));
%main loop
for cond_i = 1:length(condfield)
    fprintf('\n%s',condfield{cond_i});
    for freq_i = 1:length(freqfield)
        fprintf('\n%s\t\t',freqfield{freq_i});
        tic;
        for time_i = 1:length(times)
            fprintf('.');
            for row = 1:64;
                for col = 1:64;
%                     %young
%                     [h,p,~,stats] = ttest(squeeze(ALLDATA.conditions.(condfield{cond_i}).(freqfield{freq_i})(YOUNG,time_i,row,col)),0);
%                     if h == 1;
%                         PVALS_YOUNG(cond_i,freq_i,time_i,row,col) = p;
%                         TVALS_YOUNG(cond_i,freq_i,time_i,row,col) = stats.tstat;
%                     end%test h0
                    clear h p stats
                    %old
                    [h,p,~,stats] = ttest(squeeze(ALLDATA.conditions.(condfield{cond_i}).(freqfield{freq_i})(OLD,time_i,row,col)),0);
                    if h == 1;
                        PVALS_OLD(cond_i,freq_i,time_i,row,col) = p;
                        TVALS_OLD(cond_i,freq_i,time_i,row,col) = stats.tstat;
                    end%test h0
%                     clear h p stats
%                     %stroke
%                     [h,p,~,stats] = ttest(squeeze(ALLDATA.conditions.(condfield{cond_i}).(freqfield{freq_i})(STROKE,time_i,row,col)),0);
%                     if h == 1;
%                         PVALS_STROKE(cond_i,freq_i,time_i,row,col) = p;
%                         TVALS_STROKE(cond_i,freq_i,time_i,row,col) = stats.tstat;
%                     end%test h0
                    clear h p stats
                end%col loop
            end%row loop
        end%time_i loop
        toc
    end%freq_i loop
end%cond_i loop
%% Search for significant t-tests
clear ALLDATA
% SIGTVALS_YOUNG = zeros(length(condfield),length(freqfield),length(times),64,64);
SIGTVALS_OLD = zeros(length(condfield),length(freqfield),length(times),64,64);
% SIGTVALS_STROKE = zeros(length(condfield),length(freqfield),length(times),64,64);
SIGNIFICANCE = 0.05;
%main loop
for cond_i = 1:length(condfield)
    fprintf('\n%s',condfield{cond_i});
    for freq_i = 1:length(freqfield)
        fprintf('\n%s\t\t',freqfield{freq_i});
        tic;
        for time_i = 1:length(times)
            fprintf('.');
            for row = 1:64;
                for col = 1:64;
%                     %young
%                     [h,~,~] = fdr_bh(PVALS_YOUNG(cond_i,freq_i,time_i,row,col),SIGNIFICANCE,'pdep','no');
%                     if h == 1;
%                         SIGTVALS_YOUNG(cond_i,freq_i,time_i,row,col) = TVALS_YOUNG(cond_i,freq_i,time_i,row,col);
%                     end
%                     clear h
                    %old
                    [h,~,~] = fdr_bh(PVALS_OLD(cond_i,freq_i,time_i,row,col),SIGNIFICANCE,'pdep','no');
                    if h == 1;
                        SIGTVALS_OLD(cond_i,freq_i,time_i,row,col) = TVALS_OLD(cond_i,freq_i,time_i,row,col);
                    end
%                     clear h
%                     %stroke
%                     [h,~,~] = fdr_bh(PVALS_STROKE(cond_i,freq_i,time_i,row,col),SIGNIFICANCE,'pdep','no');
%                     if h == 1;
%                         SIGTVALS_STROKE(cond_i,freq_i,time_i,row,col) = TVALS_STROKE(cond_i,freq_i,time_i,row,col);
%                     end
                    clear h
                end%col loop
            end%row loop
        end%time_i loop
        toc
    end%freq_i loop
end%cond_i loop
save('SIGTVALS_YOUNG','SIGTVALS_YOUNG');
save('SIGTVALS_OLD','SIGTVALS_OLD');
save('SIGTVALS_STROKE','SIGTVALS_STROKE');
%% Save off pairlists and images
CWD = 'E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\';
GROUPS = {'YOUNG','OLD','STROKE'};
conds = {'dirleft','dirright','nondirleft','nondirright'};
times = {'-500to-300','-400to-200','-300to-100','-200to0','-100to100', ...
    '0to200','100to300','200to400','300to500','400to600' ...
    '500to700','600to800','700to900','800to1000','900to1100', ...
    '1000to1200','1100to1300','1200to1400','1300to1500','1400to1600', ...
    '1500to1700','1600to1800','1700to1900','1800to2000','1900to2100', ...
    '2000to2200','2100to2300','2200to2400','2300to2500','2400to2600','2500to2700'};
frequencies = {'delta','theta','loweralpha','upperalpha','beta'};
labels      = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3', ...
    'FC1','C1','C3','C5','T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7', ...
    'P9','PO7','PO3','O1','Iz','Oz','POz','Pz','CPz','Fpz','Fp2','AF8','AF4', ...
    'Afz','Fz','F2','F4','F6','F8','FT8','FC6','FC4','FC2','FCz','Cz','C2','C4', ...
    'C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6','P8','P10','PO8','PO4','O2'};
for group_i = 2%1:length(GROUPS)
    load([CWD,'SIGTVALS_',GROUPS{group_i}]);
    eval(['SIGTVALS = SIGTVALS_' GROUPS{group_i} ';']);
    OUTPUT = [CWD, GROUPS{group_i}];
    mkdir(OUTPUT);
    for cond_i = 1:length(conds)
        for time_i = 1:length(times)
            for freq_i = 1:length(frequencies)
                figure();
                hold on
                figtitle = [conds{cond_i},'-',frequencies{freq_i},'-',times{time_i}];
                title(figtitle)
                imagesc(squeeze(SIGTVALS(cond_i,freq_i,time_i,:,:)));
                saveas(gcf,[OUTPUT,'\',figtitle],'fig')
                saveas(gcf,[OUTPUT,'\',figtitle],'bmp');
                hold off
                close all
                %create pair list structure here
                tmp = (squeeze(SIGTVALS(cond_i,freq_i,time_i,:,:)));
                [row_ind,col_ind] = find(tmp);
                pairlist = {};
                for row_i = 1:length(row_ind)
                    pairlist{row_i,1} = [labels{row_ind(row_i)}];
                    pairlist{row_i,2} = [labels{col_ind(row_i)}];
                end%row_i loop
                save([OUTPUT,'\',figtitle,'_pairlist'],'pairlist');
                clear tmp figtitle row_ind col_ind pairlist
            end%freq_i loop
        end%time_i loop
    end%cond_i loop
end%group_i loop
%% Scatter plot montage
cd('E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\')
addpath(genpath('C:\Users\ac027\Documents\eeglab13_1_1b'));
eloc = readlocs('montage.sph','filetype','sph');
for group_i = 2%1:length(GROUPS)
   CWD         = ['E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\',GROUPS{group_i}];
   notInclude = [];
   numchan = length(eloc);
    numexc=length(notInclude);
    X = zeros(1,numchan-numexc);
    Y = zeros(1,numchan-numexc);
    Z = zeros(1,numchan-numexc);
    count = 0;
    for i = 1:numchan;
        if ismember(i,notInclude) 
            continue;
        end
        count = count+1;
        name{count} = eloc(1,i).labels;
        X(count) = eloc(1,i).X;
        Y(count) = eloc(1,i).Y;
        Z(count) = eloc(1,i).Z;

    end
    name{1}  = 'FP1';
    name{37} = 'Afz';

cd(CWD);
figure1 = figure();
    listing_pairlist = dir(['*_pairlist.mat']);
    
    for file_i = 1:length(listing_pairlist)
        load(listing_pairlist(file_i).name)
        scatter3(X,Y,Z,10,'filled');
        view(gca,[-90 90]);
        axis('equal')
        grid('off')    
        hold on;
        
        
        %test pair
        count_array = ones(length(X),1);
        for pair_i = 1:length(pairlist)
            name{1} = 'Fp1';
            name{37} = 'Afz';
            p1 = pairlist(pair_i,1);
            p2 = pairlist(pair_i,2);

            [~,index1] = ismember(p1,name);
            [~,index2] = ismember(p2,name);
            count_array(index1) = count_array(index1)+1;
            count_array(index2) = count_array(index2)+1;

            fprintf('%s, %s: %i, %i \n', pairlist{pair_i,1}, pairlist{pair_i,2}, index1, index2)
            plotX = [X(index1),X(index2)];
            plotY = [Y(index1),Y(index2)];
            plotZ = [Z(index1),Z(index2)];

            plot3(plotX,plotY,plotZ,'Color',[0.5 0.5 0.5]);
        
        end
        scatter3(X,Y,Z,20*count_array,'filled');
        for name_i = 1:length(name)
            text(X(name_i),Y(name_i),Z(name_i),[' ',name{name_i}]);
            
        end
        set(gcf,'Color','white');
        axis off;
        saveas(gcf, [listing_pairlist(file_i).name,'.fig'], 'fig');
        saveas(gcf, [listing_pairlist(file_i).name,'.pdf'], 'pdf');
        close all;
    end
end
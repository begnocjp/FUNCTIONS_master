%% Generate Minimum Spanning Tree
% Set up globals
clear all
close all
CWD = 'F:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\';
addpath(genpath('E:\fieldtrip\PACKAGES\BCT'))
cd(CWD);
GROUPS = {'YOUNG','OLD','STROKE'};
conditions = {'dirleft','dirright','nondirleft','nondirright'};
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
load([CWD 'ALLDATA']);
GROUPINDS = {1:22 23:56 57:size(ALLDATA.conditions.dirleft.delta,1)};
%% Preallocate
diameter = zeros(size(ALLDATA.conditions.dirleft.delta,1),length(conditions),length(frequencies),length(times));
leaves = zeros(size(diameter));
%% main loop
for group_i = 1:length(GROUPS)
    fprintf('\n%s\t%s\t','Processing Group:',GROUPS{group_i});
    load([CWD 'SIGTVALS_' GROUPS{group_i}]);
    eval(['SIGTVALS = SIGTVALS_' GROUPS{group_i} ';']);
    subjs = GROUPINDS{group_i};
    for name_i = 1:length(subjs)
        if name_i == 1;
            fprintf('\t%s\t',num2str(subjs(name_i)));
        else
            fprintf('\n\t\t\t\t\t\t\t\t%s\t',num2str(subjs(name_i)));
        end
        for cond_i = 1:length(conditions)
            if cond_i == 1;
                fprintf('\t%s\t',conditions{cond_i});
            else
                fprintf('\n\t\t\t\t\t\t\t\t%s\t',conditions{cond_i});
            end
            tic;
            for freq_i = 1:length(frequencies)
                fprintf('.')
                for time_i = 1:length(times)
                    mask = squeeze(SIGTVALS(cond_i,freq_i,time_i,:,:));
                    maskind = mask~=0;
                    dat = zeros(64,64);
                    dat(maskind==1) = squeeze(ALLDATA.conditions.(conditions{cond_i}).(frequencies{freq_i})(subjs(name_i),time_i,maskind));
                    G = sparse(dat);
                    [T,~] = graphminspantree(G,'METHOD','Kruskal');
                    %                 h = view(biograph(T,labels,'LayoutType','equilibrium'));
                    %                 [S,C] = graphconncomp(G,'Directed','false');%find subnetworks
                    %                 colors = summer(S);
                    %                 for i = 1:numel(h.nodes)
                    %                     h.Nodes(i).Color = colors(C(i),:);
                    %                 end
                    %                 child_handles = allchild(0);
                    %                 names = get(child_handles,'Name');
                    %                 k = find(strncmp('Biograph Viewer', names, 15));
                    %                 saveas(child_handles(k),[CWD GROUPS{group_i} '\' conditions{cond_i} '_' frequencies{freq_i} '_' times{time_i} '_tree.fig'],'fig')
                    %                 saveas(child_handles(k),[CWD GROUPS{group_i} '\' conditions{cond_i} '_' frequencies{freq_i} '_' times{time_i} '_tree.pdf'],'pdf')
                    %                 close(child_handles(k))
                    % get diameter
                    d = distance_wei(abs(full(G)));%convert to distance
                    [~,~,~,~,diameter(subjs(name_i),cond_i,freq_i,time_i)] = charpath(d);
                    % find leaves
                    count = 0;
                    for row = 1:64
                        deg = unique(full(T(row,:)));
                        if length(deg) == 2;
                            count = count+1;
                        end
                    end%find leaves
                    leaves(subjs(name_i),cond_i,freq_i,time_i) = count;
                end%time_i loop
            end%freq_i loop
            toc
        end%cond_i loop
    end%name_i loop
end%group_i loop

save('diameter','diameter');
save('leaves','leaves');

x = reshape(diameter,76,(4*5*31));
y = reshape(leaves,76,(4*5*31));

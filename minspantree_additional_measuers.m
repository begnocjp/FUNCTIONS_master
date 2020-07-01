%% Generate Minimum Spanning Tree
% Set up globals
clear all
close all
CWD = 'E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\';
addpath(genpath('F:\fieldtrip\PACKAGES\BCT'))
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
GROUPINDS = {1:22 [23:44 46:56] 57:size(ALLDATA.conditions.dirleft.delta,1)};
%% First remake networks to reflect average connectivity across directional types
conditionnams = fieldnames(ALLDATA.conditions);
freqnams      = fieldnames(ALLDATA.conditions.(conditionnams{1}));
%Preallocate
NEWDATA = struct();
for freq_i = 1:length(freqnams)
    NEWDATA.conditions.dir.(freqnams{freq_i}) = zeros(size(ALLDATA.conditions.(conditionnams{1}).(freqnams{1})));
    NEWDATA.conditions.nondir.(freqnams{freq_i}) = zeros(size(ALLDATA.conditions.(conditionnams{1}).(freqnams{1})));
end
% Take average across response hands to fill
dir_inds = [1 2];
non_inds = [3 4];
for name_i = 1:size(ALLDATA.conditions.(conditionnams{1}).(freqnams{1}),1)
    fprintf('.');
    for time_i = 1:size(ALLDATA.conditions.(conditionnams{1}).(freqnams{1}),2)
        for freq_i = 1:length(freqnams)
            NEWDATA.conditions.dir.(freqnams{freq_i})(name_i,time_i,:,:) = mean([ALLDATA.conditions.(conditionnams{dir_inds(1)}).(freqnams{freq_i})(name_i,time_i,:,:) ALLDATA.conditions.(conditionnams{dir_inds(2)}).(freqnams{freq_i})(name_i,time_i,:,:)]);
            NEWDATA.conditions.non.(freqnams{freq_i})(name_i,time_i,:,:) = mean([ALLDATA.conditions.(conditionnams{non_inds(1)}).(freqnams{freq_i})(name_i,time_i,:,:) ALLDATA.conditions.(conditionnams{non_inds(2)}).(freqnams{freq_i})(name_i,time_i,:,:)]);
        end
    end
end
save([CWD 'NEWDATA.mat'],'NEWDATA','-v7.3');
% % %check numbers change
% % for i = 1:76
% %     imagesc(squeeze(NEWDATA.conditions.non.theta(i,1,:,:)))
% %     pause(0.2)
% % end
%% Run ttests on NEWDATA for average of conditions
%GROUPINDS = {1:22 23:56 57:size(ALLDATA.conditions.dirleft.delta,1)};
conditions_av = {'dir','non'};
%Preallocate
SIGTVALS_YOUNG = zeros(length(conditions_av),length(freqnams),length(times),64,64);
TVALS_YOUNG = zeros(length(conditions_av),length(freqnams),length(times),64,64);
PVALS_YOUNG = zeros(length(conditions_av),length(freqnams),length(times),64,64);
SIGTVALS_OLD = zeros(length(conditions_av),length(freqnams),length(times),64,64);
TVALS_OLD = zeros(length(conditions_av),length(freqnams),length(times),64,64);
PVALS_OLD = zeros(length(conditions_av),length(freqnams),length(times),64,64);
SIGTVALS_STROKE = zeros(length(conditions_av),length(freqnams),length(times),64,64);
TVALS_STROKE = zeros(length(conditions_av),length(freqnams),length(times),64,64);
PVALS_STROKE = zeros(length(conditions_av),length(freqnams),length(times),64,64);

%main loop
for cond_i = 1:length(conditions_av)
    fprintf('\n%s',conditions_av{cond_i});
    for freq_i = 1:length(freqnams)
        fprintf('\n%s\t\t',freqnams{freq_i});
        tic;
        for time_i = 1:length(times)
            fprintf('.');
            for row = 1:64;
                for col = 1:64;
                    %young
                    [h,p,~,stats] = ttest(squeeze(NEWDATA.conditions.(conditions_av{cond_i}).(freqnams{freq_i})(GROUPINDS{1},time_i,row,col)),0);
                    if h == 1;
                        PVALS_YOUNG(cond_i,freq_i,time_i,row,col) = p;
                        TVALS_YOUNG(cond_i,freq_i,time_i,row,col) = stats.tstat;
                    end%test h0
                    clear h p stats
                    %old
                    [h,p,~,stats] = ttest(squeeze(NEWDATA.conditions.(conditions_av{cond_i}).(freqnams{freq_i})(GROUPINDS{2},time_i,row,col)),0);
                    if h == 1;
                        PVALS_OLD(cond_i,freq_i,time_i,row,col) = p;
                        TVALS_OLD(cond_i,freq_i,time_i,row,col) = stats.tstat;
                    end%test h0
                    clear h p stats
                    %stroke
                    [h,p,~,stats] = ttest(squeeze(NEWDATA.conditions.(conditions_av{cond_i}).(freqnams{freq_i})(GROUPINDS{3},time_i,row,col)),0);
                    if h == 1;
                        PVALS_STROKE(cond_i,freq_i,time_i,row,col) = p;
                        TVALS_STROKE(cond_i,freq_i,time_i,row,col) = stats.tstat;
                    end%test h0
                    clear h p stats
                end%col loop
            end%row loop
        end%time_i loop
        toc
    end%freq_i loop
end%cond_i loop
%% Search for significant t-tests
clear ALLDATA
SIGTVALS_YOUNG = zeros(length(conditions_av),length(freqnams),length(times),64,64);
SIGTVALS_OLD = zeros(length(conditions_av),length(freqnams),length(times),64,64);
SIGTVALS_STROKE = zeros(length(conditions_av),length(freqnams),length(times),64,64);
SIGNIFICANCE = 0.05;
addpath(genpath('E:\fieldtrip\PACKAGES\mass_uni_toolbox'));
%main loop
for cond_i = 1:length(conditions_av)
    fprintf('\n%s',conditions_av{cond_i});
    for freq_i = 1:length(freqnams)
        fprintf('\n%s\t\t',freqnams{freq_i});
        tic;
        for time_i = 1:length(times)
            fprintf('.');
            for row = 1:64;
                for col = 1:64;
                    %young
                    [h,~,~] = fdr_bh(PVALS_YOUNG(cond_i,freq_i,time_i,row,col),SIGNIFICANCE,'pdep','no');
                    if h == 1;
                        SIGTVALS_YOUNG(cond_i,freq_i,time_i,row,col) = TVALS_YOUNG(cond_i,freq_i,time_i,row,col);
                    end
                    clear h
                    %old
                    [h,~,~] = fdr_bh(PVALS_OLD(cond_i,freq_i,time_i,row,col),SIGNIFICANCE,'pdep','no');
                    if h == 1;
                        SIGTVALS_OLD(cond_i,freq_i,time_i,row,col) = TVALS_OLD(cond_i,freq_i,time_i,row,col);
                    end
                    clear h
                    %stroke
                    [h,~,~] = fdr_bh(PVALS_STROKE(cond_i,freq_i,time_i,row,col),SIGNIFICANCE,'pdep','no');
                    if h == 1;
                        SIGTVALS_STROKE(cond_i,freq_i,time_i,row,col) = TVALS_STROKE(cond_i,freq_i,time_i,row,col);
                    end
                    clear h
                end%col loop
            end%row loop
        end%time_i loop
        toc
    end%freq_i loop
end%cond_i loop
save('E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\MST_AllMeasures\SIGTVALS_YOUNG','SIGTVALS_YOUNG');
save('E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\MST_AllMeasures\SIGTVALS_OLD','SIGTVALS_OLD');
save('E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\MST_AllMeasures\SIGTVALS_STROKE','SIGTVALS_STROKE');
%% Preallocate
conditions_av = {'dir','non'};
diameter     = zeros(size(NEWDATA.conditions.dir.delta,1),length(conditions_av),length(frequencies),length(times));
ecc          = zeros(size(diameter));
leaves       = zeros(size(diameter));
nodecount    = zeros(size(diameter));
between_norm = zeros(size(diameter));
between_max  = zeros(size(diameter));
degrees_av   = zeros(size(diameter));
degrees_max  = zeros(size(diameter));
degree_corr  = zeros(size(diameter));
%% main loop
for group_i = 1:length(GROUPS)
    fprintf('\n%s\t%s\t','Processing Group:',GROUPS{group_i});
    load(['E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\MST_AllMeasures\SIGTVALS_' GROUPS{group_i}]);
    eval(['SIGTVALS = SIGTVALS_' GROUPS{group_i} ';']);
    subjs = GROUPINDS{group_i};
    for name_i = 1:length(subjs)
        if name_i == 1;
            fprintf('\t%s\t',num2str(subjs(name_i)));
        else
            fprintf('\n\t\t\t\t\t\t\t\t%s\t',num2str(subjs(name_i)));
        end
        for cond_i = 1:length(conditions_av)
            if cond_i == 1;
                fprintf('\t%s\t',conditions_av{cond_i});
            else
                fprintf('\n\t\t\t\t\t\t\t\t%s\t',conditions_av{cond_i});
            end
            tic;
            for freq_i = 1:length(frequencies)
                fprintf('.')
                for time_i = 1:length(times)
                    mask = squeeze(SIGTVALS(cond_i,freq_i,time_i,:,:));
                    maskind = mask~=0;
                    dat = zeros(64,64);
                    dat(maskind==1) = squeeze(NEWDATA.conditions.(conditions_av{cond_i}).(frequencies{freq_i})(subjs(name_i),time_i,maskind));
                    G = sparse(dat);
                    [T,~] = graphminspantree(G,'METHOD','Kruskal');
                    T = double(full(abs(T)));%convert back to full and double precision
                    for row = 1:64
                        for col = 1:64
                            T(row,col) = T(col,row);%make matrix square again
                        end
                    end
                    % get diameter
                    T = weight_conversion(T,'binarize');
                    T_d = weight_conversion(T,'lengths');
                    d = distance_bin(T_d);%convert to distance
                    [~,~,e,~,diameter(subjs(name_i),cond_i,freq_i,time_i)] = charpath(d);
                    ecc(subjs(name_i),cond_i,freq_i,time_i) = mean(e);
                    %                     find leaves
                    count = 0;
                    for row = 1:64
                        %                         deg = unique(T(row,:));
                        deg = find(T(row,:)==1);
                        %                         fprintf('%s\n',num2str(deg));
                        if length(deg) == 1;
                            count = count+1;
                        end
                    end%find leaves
                    leaves(subjs(name_i),cond_i,freq_i,time_i) = count;
                    nodecount(subjs(name_i),cond_i,freq_i,time_i) = length(nonzeros(tril(T)));%get node count
                    %                     betweenness centrality
                    bc = (betweenness_bin(T)/(((nodecount(subjs(name_i),cond_i,freq_i,time_i)-1)*(nodecount(subjs(name_i),cond_i,freq_i,time_i)-2))));%normalise using BC/[(N-1)(N-2)]
                    between_norm(subjs(name_i),cond_i,freq_i,time_i) = mean(bc); %normalise using BC/[(N-1)(N-2)]
                    between_max(subjs(name_i),cond_i,freq_i,time_i) = max(bc);%max BC
                    %                     degree
                    degrees_av(subjs(name_i),cond_i,freq_i,time_i) = mean(degrees_und(T));%mean degree of network
                    degrees_max(subjs(name_i),cond_i,freq_i,time_i) = max(degrees_und(T));%max degree of network
                    degree_corr(subjs(name_i),cond_i,freq_i,time_i) = assortativity_bin(T,0);% degree correlation
                end%time_i loop
            end%freq_i loop
            toc
        end%cond_i loop
    end%name_i loop
end%group_i loop
leafprop = leaves./nodecount;
treeh = leaves./(2.*nodecount-1.*between_max);%compute tree hierachy

save('diameter','diameter');
save('ecc','ecc');
save('leaves','leaves')
save('nodecount','nodecount')
save('between_norm','between_norm');
save('between_max','between_max');
save('degrees_av','degrees_av');
save('degrees_max','degrees_max');
save('degree_corr','degree_corr');
save('leafprop','leafprop');
save('treeh','treeh');

savedir = 'E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\MST_AllMeasures\';
listing = dir([savedir '*.mat*']);
vars{length(listing),1} = [];
for i = 4:length(listing)
    vars{i,1} = listing(i).name(1:end-4);
end
for i = 4:length(vars)
    eval(['x = reshape(' vars{i} ',76,(2*5*31));']);
    save([vars{i} '.txt.'],'x','-ascii','-tabs','-v7.3');
end
%% Make figures
loc = [9.95004165300000,0.998334166000000,0;9.80066577800000,1.98669330800000,0;9.58243875500000,2.85952225100000,0;9.24909059900000,3.80188415100000,0;8.82332858600000,4.70625888200000,0;8.30940679100000,5.56361022900000,0;7.71246015000000,6.36537182200000,0;7.03845315700000,7.10353272400000,0;6.37151144200000,7.70738878900000,0;5.57022546800000,8.30497370500000,0;4.71328364200000,8.81957806900000,0;3.80924824400000,9.24606012400000,0;2.86715209600000,9.58015860300000,0;1.89640831300000,9.81853530400000,0;1.00625733400000,9.94924349800000,0;0.00796326700000000,9.99999682900000,0;-0.990410366000000,9.95083349800000,0;-1.97888814600000,9.80224472800000,0;-2.94759353000000,9.55571516900000,0;-4.69923113700000,8.82707350800000,0;-5.55699146300000,8.31383460800000,0;-6.35922816600000,7.71752662000000,0;-7.09792556400000,7.04410765800000,0;-7.76570283500000,6.30030630000000,0;-8.35588777100000,5.49355436400000,0;-8.81582195900000,4.72030541300000,0;-9.24302378600000,3.81660992100000,0;-9.99964658500000,-0.0840724740000000,0;-9.95808324500000,0.914646422000000,0;-9.81702203000000,1.90422647400000,0;-9.57787237600000,2.87478012300000,0;-3.88684753400000,9.21370806200000,0;10,0,0;9.95661390200000,-0.930505033000000,0;9.81397680700000,-1.91985916700000,0;9.60170286700000,-2.79415498200000,0;9.27478430700000,-3.73876664800000,0;8.85519516900000,-4.64602179400000,0;8.34712784800000,-5.50685542600000,0;7.75565878500000,-6.31266637900000,0;7.08669774300000,-7.05540325600000,0;6.42388657600000,-7.66379026700000,0;5.62669153400000,-8.26682178200000,0;4.77327645000000,-8.78725394700000,0;3.87216836500000,-9.21988677500000,0;2.93237085400000,-9.56039754300000,0;1.96327406300000,-9.80538397800000,0;1.07403448200000,-9.94215519500000,0;0.0761094610000000,-9.99971036300000,0;-0.922576020000000,-9.95735173100000,0;-1.91204342700000,-9.81550253100000,0;-2.88240632800000,-9.57558007400000,0;-3.82396917700000,-9.23998158700000,0;-4.63896869300000,-8.85889211300000,0;-5.50020663900000,-8.35151045800000,0;-6.30648833900000,-7.76068327100000,0;-7.04975769200000,-7.09231390200000,0;-7.72258819600000,-6.35308047700000,0;-8.31825715200000,-5.55036917200000,0;-8.78345007400000,-4.78027246100000,0;-9.21680034100000,-3.87950917900000,0;-9.55805938600000,-2.93998312400000,0;-9.80381746100000,-1.97108172900000,0;-9.95161903300000,-0.982485937000000,0;];
freqs = {'Delta','Theta','Lower Alpha', 'Upper Alpha', 'Beta'};
for freq_i = 3:length(frequencies)
    count = 0;
    figure()
    set(gcf,'Color',[1 1 1]);
    hold on;
    for cond_i = 1:length(conditions_av)
        for group_i = 1:length(GROUPS)
            load(['E:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\MST_AllMeasures\SIGTVALS_' GROUPS{group_i}]);
            eval(['SIGTVALS = SIGTVALS_' GROUPS{group_i} ';']);
            subjs = GROUPINDS{group_i};
            count = count+1;
            net = squeeze(SIGTVALS(cond_i,freq_i,:,:,:));
            net = squeeze(mean(net,1));
            net = sparse(net);
            [T,~] = graphminspantree(net,'METHOD','Kruskal');
            T = double(full(abs(T)));%convert back to full and double precision
            for row = 1:64
                for col = 1:64
                    T(row,col) = T(col,row);%make matrix square again
                end
            end
            [x,y,z] = adjacency_plot_und(T,loc);
            %subplot(2,3,count);plot3(loc(:,1),loc(:,2),loc(:,3),'x');hold on;plot3(x,y,z);title([GROUPS{group_i} ' ' upper(conditions_av{cond_i}) ' ' upper(freqs{freq_i})]);axis square;axis off;view([90 90]);
            subplot(2,3,count);plot3(loc([1:7,33:42],1),loc([1:7,33:42],2),loc([1:7,33:42],3),'ro','MarkerFaceColor','red','MarkerSize',6);hold on;plot3(x,y,z);title([GROUPS{group_i}  ' ' upper(conditions_av{cond_i}) ' ' upper(freqs{freq_i})]);axis square;axis off;view([-90 90]);%frontal
            subplot(2,3,count);plot3(loc([8:11,43:47],1),loc([8:11,43:47],2),loc([8:11,43:47],3),'ro','MarkerFaceColor','red','MarkerSize',6);hold on;plot3(x,y,z);title([GROUPS{group_i} ' ' upper(conditions_av{cond_i}) ' ' upper(freqs{freq_i})]);axis square;axis off;view([-90 90]);%frontocentral
            subplot(2,3,count);plot3(loc([12:15,48:52],1),loc([12:15,48:52],2),loc([12:15,48:52],3),'bo','MarkerFaceColor','blue','MarkerSize',6);hold on;plot3(x,y,z);title([GROUPS{group_i} ' ' upper(conditions_av{cond_i}) ' ' upper(freqs{freq_i})]);axis square;axis off;view([-90 90]);%central
            subplot(2,3,count);plot3(loc([16:19,53:56],1),loc([16:19,53:56],2),loc([16:19,53:56],3),'bo','MarkerFaceColor','blue','MarkerSize',6);hold on;plot3(x,y,z);title([GROUPS{group_i} ' ' upper(conditions_av{cond_i}) ' ' upper(freqs{freq_i})]);axis square;axis off;view([-90 90]);%centroparietal
            subplot(2,3,count);plot3(loc(32,1),loc(32,2),loc(32,3),'bo','MarkerFaceColor','blue','MarkerSize',6);hold on;plot3(x,y,z);title([GROUPS{group_i} ' ' upper(conditions_av{cond_i}) ' ' upper(freqs{freq_i})]);axis square;axis off;view([-90 90]);%centroparietal
            subplot(2,3,count);plot3(loc([20:31,57:64],1),loc([20:31,57:64],2),loc([20:31,57:64],3),'mo','MarkerFaceColor','magenta','MarkerSize',6);hold on;plot3(x,y,z,'-k');title([GROUPS{group_i} ' ' upper(conditions_av{cond_i}) ' ' upper(freqs{freq_i})]);axis square;axis off;view([-90 90]);%parietal-occipital
        end
    end
    saveas(gcf,[CWD freqs{freq_i} '.pdf'],'pdf');
    close
end
%% Create representative network graphic for labelling electrodes
figure()
set(gcf,'Color',[1 1 1]);
hold on
plot3(loc([1:7,33:42],1),loc([1:7,33:42],2),loc([1:7,33:42],3),'ro','MarkerFaceColor','red','MarkerSize',6);
plot3(loc([8:11,43:47],1),loc([8:11,43:47],2),loc([8:11,43:47],3),'ro','MarkerFaceColor','red','MarkerSize',6);
plot3(loc([12:15,48:52],1),loc([12:15,48:52],2),loc([12:15,48:52],3),'bo','MarkerFaceColor','blue','MarkerSize',6);
plot3(loc([16:19,53:56],1),loc([16:19,53:56],2),loc([16:19,53:56],3),'bo','MarkerFaceColor','blue','MarkerSize',6);
plot3(loc(32,1),loc(32,2),loc(32,3),'bo','MarkerFaceColor','blue','MarkerSize',6);
plot3(loc([20:31,57:64],1),loc([20:31,57:64],2),loc([20:31,57:64],3),'mo','MarkerFaceColor','magenta','MarkerSize',6);axis square;axis off;view([-90 90]);%parietal-occipital

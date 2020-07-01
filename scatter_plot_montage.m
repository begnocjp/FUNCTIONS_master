%clear all
function scatter_plot_montage(foldername)
addpath(genpath('C:\Users\ac027\Documents\eeglab13_2_2b'));
% addpath(genpath('H:\FNL\eeglab12_0_1_0b'));
cd('F:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\')

%FP1    1
%AF7    2
%F7     7
%FT7    8
%T7     15
%TP7    16
%P9     24
%Iz     28
%FPz    33
%FP2    34
%AF8    35
%F8     42
%FT8    43
%T8     52
%TP8    53
%P10    61
%M1     65
%M2     66
%LO1    67
%LO2    68
%SO1    69
%SO2    70
%IO1    71
%IO2    72
%= 48 left

notInclude = [1,2,7,8,15,16,24,28,33,34,35,42,43,52,53,61,65,66,67,68,69,70,71,72];


% cd E:\fieldtrip\ANALYSES\SIM

eloc = readlocs('montage.sph','filetype','sph');

   
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

    name{26} = 'Afz';

CWD         = 'F:\fieldtrip\ANALYSES\CONNECTIVITY_MATRICES\';
%conditions  = {'dirleft', 'dirright', 'nondirleft','nondirright'};
%conditions = {'activeone','shamone','activetwo','shamtwo'};
%frequencies = {'delta', 'theta', 'loweralpha', 'upperalpha', 'beta'};
% times       = {'100to300', '1200to1400'};
% times       = {'200to0', '100to100'};
%times = {'0to200','100to300','200to400','300to500','400to600' ...
%     '500to700','600to800','700to900','800to1000','900to1100', ...
%     '1000to1200','1100to1300','1200to1400','1300to1500','1400to1600', ...
%     '1500to1700','1600to1800','1700to1900','1800to2000','1900to2100', ...
%     '2000to2200','2100to2300','2200to2400','2300to2500'};

cd(CWD);
figure1 = figure();
%axes1 = axes('Visible','off','Parent',figure1,'DataAspectRatio',[1 1 1]);
%for cond_i = 1:length(conditions)
    cd([CWD,foldername]);
    %cd([CWD,'SHAM_young']);
    listing_pairlist = dir(['*_pairlist.mat']);
    
    for file_i = 1:length(listing_pairlist)
        load(listing_pairlist(file_i).name)
%         CWD         = 'E:\fieldtrip\ANALYSES\SIM';
        
    
        %col = jet(numchan-numexc);
        scatter3(X,Y,Z,10,'filled');
        view(gca,[-90 90]);
        axis('equal')
        grid('off')    
        hold on;
        
        
        %test pair
        count_array = ones(length(X),1);
        for pair_i = 1:length(pairlist)
            name{26} = 'Afz';
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

%end
end

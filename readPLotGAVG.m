% reader  for MUL file for plotting from BESA
clear all
close all
path(pathdef)
clc

% path to fieldtrip for reader function among other things
cd('C:\Users\alp514.UNCLE\Documents\MATLAB\')
% add path for fieldtrip
addpath (genpath('C:\Users\alp514.UNCLE\Documents\MATLAB\fieldtrip-20130811') ); 
% this is mainly for the subplot tight, which I could move somewhere more
% sensible
addpath(genpath('C:\Users\alp514.UNCLE\Documents\MATLAB\OPTA_WOPTA'));

% path to BESA data for MR2012 project
% O:\research\ERPOurimbah\data_2012\MentalRotation2012_Alex\EEG\Exp1\grandAverage
cd('O:\research\ERPOurimbah\data_2012\MentalRotation2012_Alex\EEG\Exp1\grandAverage')

% NOTE this organisation works for the first session only, for the second
% session different plots will be necessary
timelock = besa2fieldtrip('M&F_S1_cc-export.mul');
males_E1S1 = timelock.avg(:,1:18000);
females_E1S1 = timelock.avg(:,34001:52000);
combined_E1S1 = (males + females)/2;

%% plotting
    time = -200:1:1599;
    %electrode = '60';
    whiteSpace = [0.05 0.04];
    globalxlim = [-200 1000];
    globalylim = [-4 6];
    scrsz = get(0,'ScreenSize');
    %axisSizeSignal = ([0 2200 -3 3]);
    %signalSize = '800:3000';
    electrodes = ([21;19;17;30;28;26;40;38;36;50;48;46;61;62;63]);
    elNames = cell({'FC4','FCz','FC3','C4','Cz','C3','CP4','CPz','CP3','P4','Pz','P3','O2','Oz','O1'});
    h = figure('Position',[1 1 scrsz(3) scrsz(4)]);

    % males figure
    for i = 1:length(electrodes)
        electrode = electrodes(i);
        subplot_tight(5,3,i,whiteSpace)
        plot(time, males_E1S1(electrode,1:1800),'k','LineWidth',1);
        hold on;
        plot(time, males_E1S1(electrode,1801:3600),'r','LineWidth',1);
        plot(time, males_E1S1(electrode,3601:5400),'b','LineWidth',1);
        plot(time, males_E1S1(electrode,5401:7200),'c','LineWidth',1);
        plot(time, males_E1S1(electrode,7201:9000),'--k','LineWidth',1);
        if ((i == 1) || (i == 4) || (i == 7) || (i == 10) || (i == 13))
            ylabel('\muV','fontsize',10,'LineWidth',4);
        end
        if ((i == 13) || (i == 14) || (i == 15))
            xlabel('Time (s)','fontsize',10,'LineWidth',4);
        end
        if ((i == 15))
            legend({'0','45','90','135','180'},'fontsize',10);
        end
        xlim(globalxlim);
        ylim(globalylim);
        title(elNames(i),'fontsize',10);
        box off
        set(gca,'fontsize',10)
        
        %xlabel('Time (s)','fontsize',10,'LineWidth',4);
        %set(gca,'XTickLabel',{'-.2','0','.2','.4','.6','.8','1'})
        %legend({'0','45','90','135','180'},'fontsize',10);
    end
    
    h = figure('Position',[1 1 scrsz(3) scrsz(4)]);

    % females figure
    for i = 1:length(electrodes)
        electrode = electrodes(i);
        subplot_tight(5,3,i,whiteSpace)
        plot(time, females_E1S1(electrode,1:1800),'k','LineWidth',1);
        hold on;
        plot(time, females_E1S1(electrode,1801:3600),'r','LineWidth',1);
        plot(time, females_E1S1(electrode,3601:5400),'b','LineWidth',1);
        plot(time, females_E1S1(electrode,5401:7200),'c','LineWidth',1);
        plot(time, females_E1S1(electrode,7201:9000),'--k','LineWidth',1);
        if ((i == 1) || (i == 4) || (i == 7) || (i == 10) || (i == 13))
            ylabel('\muV','fontsize',10,'LineWidth',4);
        end
        if ((i == 13) || (i == 14) || (i == 15))
            xlabel('Time (s)','fontsize',10,'LineWidth',4);
        end
        if ((i == 15))
            legend({'0','45','90','135','180'},'fontsize',10);
        end
        xlim(globalxlim);
        ylim(globalylim);
        title(elNames(i),'fontsize',10);
        box off
        set(gca,'fontsize',10)
        
        %xlabel('Time (s)','fontsize',10,'LineWidth',4);
        %set(gca,'XTickLabel',{'-.2','0','.2','.4','.6','.8','1'})
        %legend({'0','45','90','135','180'},'fontsize',10);
    end    
    
    h = figure('Position',[1 1 scrsz(3) scrsz(4)]);

    % averaged across male and female figure
    for i = 1:length(electrodes)
        electrode = electrodes(i);
        subplot_tight(5,3,i,whiteSpace)
        plot(time, combined_E1S1(electrode,1:1800),'k','LineWidth',1);
        hold on;
        plot(time, combined_E1S1(electrode,1801:3600),'r','LineWidth',1);
        plot(time, combined_E1S1(electrode,3601:5400),'b','LineWidth',1);
        plot(time, combined_E1S1(electrode,5401:7200),'c','LineWidth',1);
        plot(time, combined_E1S1(electrode,7201:9000),'--k','LineWidth',1);
        if ((i == 1) || (i == 4) || (i == 7) || (i == 10) || (i == 13))
            ylabel('\muV','fontsize',10,'LineWidth',4);
        end
        if ((i == 13) || (i == 14) || (i == 15))
            xlabel('Time (s)','fontsize',10,'LineWidth',4);
        end
        if ((i == 15))
            legend({'0','45','90','135','180'},'fontsize',10);
        end
        xlim(globalxlim);
        ylim(globalylim);
        title(elNames(i),'fontsize',10);
        box off
        set(gca,'fontsize',10)
        
        %xlabel('Time (s)','fontsize',10,'LineWidth',4);
        %set(gca,'XTickLabel',{'-.2','0','.2','.4','.6','.8','1'})
        %legend({'0','45','90','135','180'},'fontsize',10);
    end    


%% session 2 experiment 1
timelock = besa2fieldtrip('M&F_S2_cc-export.mul');
males_E1S6 = timelock.avg(:,1:36000);
females_E1S6 = timelock.avg(:,68001:104000);
combined_E1S6 = (males_E1S6 + females_E1S6)/2;

    time = -200:1:1599;
    %electrode = '60';
    whiteSpace = [0.05 0.04];
    globalxlim = [-200 1000];
    globalylim = [-4 6];
    scrsz = get(0,'ScreenSize');
    %axisSizeSignal = ([0 2200 -3 3]);
    %signalSize = '800:3000';
    electrodes = ([21;19;17;30;28;26;40;38;36;50;48;46;61;62;63]);
    elNames = cell({'FC4','FCz','FC3','C4','Cz','C3','CP4','CPz','CP3','P4','Pz','P3','O2','Oz','O1'});
    h = figure('Position',[1 1 scrsz(3) scrsz(4)]);

    % these plots are for the practiced stimuli
    
    % males figure
    for i = 1:length(electrodes)
        electrode = electrodes(i);
        subplot_tight(5,3,i,whiteSpace)
        plot(time, males_E1S6(electrode,1:1800),'k','LineWidth',1);
        hold on;
        plot(time, males_E1S6(electrode,1801:3600),'r','LineWidth',1);
        plot(time, males_E1S6(electrode,3601:5400),'b','LineWidth',1);
        plot(time, males_E1S6(electrode,5401:7200),'c','LineWidth',1);
        plot(time, males_E1S6(electrode,7201:9000),'--k','LineWidth',1);
        if ((i == 1) || (i == 4) || (i == 7) || (i == 10) || (i == 13))
            ylabel('\muV','fontsize',10,'LineWidth',4);
        end
        if ((i == 13) || (i == 14) || (i == 15))
            xlabel('Time (s)','fontsize',10,'LineWidth',4);
        end
        if ((i == 15))
            legend({'0','45','90','135','180'},'fontsize',10);
        end
        xlim(globalxlim);
        ylim(globalylim);
        title(elNames(i),'fontsize',10);
        box off
        set(gca,'fontsize',10)
        
        %xlabel('Time (s)','fontsize',10,'LineWidth',4);
        %set(gca,'XTickLabel',{'-.2','0','.2','.4','.6','.8','1'})
        %legend({'0','45','90','135','180'},'fontsize',10);
    end
    
    h = figure('Position',[1 1 scrsz(3) scrsz(4)]);

    % females figure
    for i = 1:length(electrodes)
        electrode = electrodes(i);
        subplot_tight(5,3,i,whiteSpace)
        plot(time, females_E1S6(electrode,1:1800),'k','LineWidth',1);
        hold on;
        plot(time, females_E1S6(electrode,1801:3600),'r','LineWidth',1);
        plot(time, females_E1S6(electrode,3601:5400),'b','LineWidth',1);
        plot(time, females_E1S6(electrode,5401:7200),'c','LineWidth',1);
        plot(time, females_E1S6(electrode,7201:9000),'--k','LineWidth',1);
        if ((i == 1) || (i == 4) || (i == 7) || (i == 10) || (i == 13))
            ylabel('\muV','fontsize',10,'LineWidth',4);
        end
        if ((i == 13) || (i == 14) || (i == 15))
            xlabel('Time (s)','fontsize',10,'LineWidth',4);
        end
        if ((i == 15))
            legend({'0','45','90','135','180'},'fontsize',10);
        end
        xlim(globalxlim);
        ylim(globalylim);
        title(elNames(i),'fontsize',10);
        box off
        set(gca,'fontsize',10)
        
        %xlabel('Time (s)','fontsize',10,'LineWidth',4);
        %set(gca,'XTickLabel',{'-.2','0','.2','.4','.6','.8','1'})
        %legend({'0','45','90','135','180'},'fontsize',10);
    end    
    
    h = figure('Position',[1 1 scrsz(3) scrsz(4)]);

    % averaged across male and female figure
    for i = 1:length(electrodes)
        electrode = electrodes(i);
        subplot_tight(5,3,i,whiteSpace)
        plot(time, combined_E1S6(electrode,1:1800),'k','LineWidth',1);
        hold on;
        plot(time, combined_E1S6(electrode,1801:3600),'r','LineWidth',1);
        plot(time, combined_E1S6(electrode,3601:5400),'b','LineWidth',1);
        plot(time, combined_E1S6(electrode,5401:7200),'c','LineWidth',1);
        plot(time, combined_E1S6(electrode,7201:9000),'--k','LineWidth',1);
        if ((i == 1) || (i == 4) || (i == 7) || (i == 10) || (i == 13))
            ylabel('\muV','fontsize',10,'LineWidth',4);
        end
        if ((i == 13) || (i == 14) || (i == 15))
            xlabel('Time (s)','fontsize',10,'LineWidth',4);
        end
        if ((i == 15))
            legend({'0','45','90','135','180'},'fontsize',10);
        end
        xlim(globalxlim);
        ylim(globalylim);
        title(elNames(i),'fontsize',10);
        box off
        set(gca,'fontsize',10)
        
        %xlabel('Time (s)','fontsize',10,'LineWidth',4);
        %set(gca,'XTickLabel',{'-.2','0','.2','.4','.6','.8','1'})
        %legend({'0','45','90','135','180'},'fontsize',10);
    end 

    
% now for the novel stimulus    
% 19800	0
% 21600	45
% 23400	90
% 25200	135
% 27000	180
% 28800	0
% 30600	45
% 32400	90
% 34200	135
% 36000	180

    % males figure
    for i = 1:length(electrodes)
        electrode = electrodes(i);
        subplot_tight(5,3,i,whiteSpace)
        plot(time, males_E1S6(electrode,19801:21600),'k','LineWidth',1);
        hold on;
        plot(time, males_E1S6(electrode,21601:23400),'r','LineWidth',1);
        plot(time, males_E1S6(electrode,23401:25200),'b','LineWidth',1);
        plot(time, males_E1S6(electrode,25201:27000),'c','LineWidth',1);
        plot(time, males_E1S6(electrode,27001:28800),'--k','LineWidth',1);
        if ((i == 1) || (i == 4) || (i == 7) || (i == 10) || (i == 13))
            ylabel('\muV','fontsize',10,'LineWidth',4);
        end
        if ((i == 13) || (i == 14) || (i == 15))
            xlabel('Time (s)','fontsize',10,'LineWidth',4);
        end
        if ((i == 15))
            legend({'0','45','90','135','180'},'fontsize',10);
        end
        xlim(globalxlim);
        ylim(globalylim);
        title(elNames(i),'fontsize',10);
        box off
        set(gca,'fontsize',10)
        
        %xlabel('Time (s)','fontsize',10,'LineWidth',4);
        %set(gca,'XTickLabel',{'-.2','0','.2','.4','.6','.8','1'})
        %legend({'0','45','90','135','180'},'fontsize',10);
    end
    
    h = figure('Position',[1 1 scrsz(3) scrsz(4)]);

    % females figure
    for i = 1:length(electrodes)
        electrode = electrodes(i);
        subplot_tight(5,3,i,whiteSpace)
        plot(time, females_E1S6(electrode,19801:21600),'k','LineWidth',1);
        hold on;
        plot(time, females_E1S6(electrode,21601:23400),'r','LineWidth',1);
        plot(time, females_E1S6(electrode,23401:25200),'b','LineWidth',1);
        plot(time, females_E1S6(electrode,25201:27000),'c','LineWidth',1);
        plot(time, females_E1S6(electrode,27001:28800),'--k','LineWidth',1);
        if ((i == 1) || (i == 4) || (i == 7) || (i == 10) || (i == 13))
            ylabel('\muV','fontsize',10,'LineWidth',4);
        end
        if ((i == 13) || (i == 14) || (i == 15))
            xlabel('Time (s)','fontsize',10,'LineWidth',4);
        end
        if ((i == 15))
            legend({'0','45','90','135','180'},'fontsize',10);
        end
        xlim(globalxlim);
        ylim(globalylim);
        title(elNames(i),'fontsize',10);
        box off
        set(gca,'fontsize',10)
        
        %xlabel('Time (s)','fontsize',10,'LineWidth',4);
        %set(gca,'XTickLabel',{'-.2','0','.2','.4','.6','.8','1'})
        %legend({'0','45','90','135','180'},'fontsize',10);
    end    
    
    h = figure('Position',[1 1 scrsz(3) scrsz(4)]);

    % averaged across male and female figure
    for i = 1:length(electrodes)
        electrode = electrodes(i);
        subplot_tight(5,3,i,whiteSpace)
        plot(time, combined_E1S6(electrode,19801:21600),'k','LineWidth',1);
        hold on;
        plot(time, combined_E1S6(electrode,21601:23400),'r','LineWidth',1);
        plot(time, combined_E1S6(electrode,23401:25200),'b','LineWidth',1);
        plot(time, combined_E1S6(electrode,25201:27000),'c','LineWidth',1);
        plot(time, combined_E1S6(electrode,27001:28800),'--k','LineWidth',1);
        if ((i == 1) || (i == 4) || (i == 7) || (i == 10) || (i == 13))
            ylabel('\muV','fontsize',10,'LineWidth',4);
        end
        if ((i == 13) || (i == 14) || (i == 15))
            xlabel('Time (s)','fontsize',10,'LineWidth',4);
        end
        if ((i == 15))
            legend({'0','45','90','135','180'},'fontsize',10);
        end
        xlim(globalxlim);
        ylim(globalylim);
        title(elNames(i),'fontsize',10);
        box off
        set(gca,'fontsize',10)
        
        %xlabel('Time (s)','fontsize',10,'LineWidth',4);
        %set(gca,'XTickLabel',{'-.2','0','.2','.4','.6','.8','1'})
        %legend({'0','45','90','135','180'},'fontsize',10);
    end
    %up to here
    set(h,'PaperOrientation','landscape')
    saveas(h,'combination' ,'pdf')

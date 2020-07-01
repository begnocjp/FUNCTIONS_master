%% GENERATE MATRIX:
clear all;
ConnectivityMatrix_delta = zeros(64,64);
ConnectivityMatrix_theta = zeros(64,64);
ConnectivityMatrix_loweralpha = zeros(64,64);
ConnectivityMatrix_upperalpha = zeros(64,64);
ConnectivityMatrix_beta = zeros(64,64);
CWD   = 'F:\fieldtrip';
NWD   = 'E:\fieldtrip';
names = {'DCR202' 'DCR203' 'DCR206' 'DCR208' 'DCR209' 'DCR213' 'DCR214' 'DCR217' 'DCR220' 'DCR221' ...
    'DCR223' 'DCR104' 'DCR107' 'DCR110' 'DCR111' 'DCR112' 'DCR115' 'DCR118' 'DCR119' 'DCR122' 'DCR124' 'DCR125' 'S1' ... 
    'S4' 'S5B' 'S6B' 'S7B' 'S8' 'S10' 'S11B' 'S12' 'S13B' 'S14' 'S15B' 'S16B' 'S17' 'S18' 'S20' 'S21' ...
    'S22B' 'S23B' 'S24' 'S25B' 'S26' 'S27' 'S28B' 'S29B' 'S30' 'S31' 'S34B' 'S36' 'S37B' 'S38B' ...
    'S39' 'S40'}; %'PF001C' 'PF002' 'PF003' 'PF004' 'PF005' 'PF006B' 'PF007B'...
    %'PF008C' 'PF009C' 'PM003C' 'PM004C' 'PM006B' 'PM007B' 'PM008B' 'PM009C' 'PM010' 'PM014B' 'PM015'...
    %'PM016B' 'PM017C'}; %artefact rejection list
cond  = {'dirleft','dirright','nondirleft','nondirright'};
%% CHANGE HERE FOR DIFFERENT STARTS:
START = 0;
%%
endtime = 1000+START;
% fixation = 800 (or 0ms)
for starttime = 800+START:200:6800;
    endtime = endtime+200;
    for names_i = 1 :length(names) %usage: names{1,names_i}
        tic;
        fprintf('Processing: %s:  ', names{1,names_i});
        for cond_i = 1:length(cond)%usage: cond{1,cond_i}
            fprintf('\t%s:  ', cond{1,cond_i});
            for chx = 1:64
                for chy = chx+1:64
                    DIR = [NWD,'\','IMAGCOH_OUTPUT','\',names{1,names_i},'\',cond{1,cond_i}];
                    filename = [DIR,'\','IMAGCOH_CH',num2str(chx),'_CH',num2str(chy),'.mat'];
                    %tic;
                    load(filename);
                    %Time: 0-400 = 800 - 1600
                    time = starttime:endtime;
                    %Frequencies delta      = 1 - 18
                    averageImgCoh = mean(mean(CROSSSPEC(1:18,time)));
                    ConnectivityMatrix_delta(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_delta(chy,chx) = averageImgCoh;
                    %Frequency Theta        = 19 - 31
                    averageImgCoh = mean(mean(CROSSSPEC(19:31,time)));
                    ConnectivityMatrix_theta(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_theta(chy,chx) = averageImgCoh;
                    %Frequency Lower Alpha  = 35 - 40
                    averageImgCoh = mean(mean(CROSSSPEC(35:40,time)));
                    ConnectivityMatrix_loweralpha(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_loweralpha(chy,chx) = averageImgCoh;
                    %Frequency Upper Alpha  = 41 - 47
                    averageImgCoh = mean(mean(CROSSSPEC(41:47,time)));
                    ConnectivityMatrix_upperalpha(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_upperalpha(chy,chx) = averageImgCoh;
                    %Frequency Beta         = 48 - 68
                    averageImgCoh = mean(mean(CROSSSPEC(48:68,time)));
                    ConnectivityMatrix_beta(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_beta(chy,chx) = averageImgCoh;
                end
            end
            DIR = [NWD,'\','IMAGCOH_OUTPUT','\',names{1,names_i},'\',cond{1,cond_i}];
            timeperiod1 = num2str(((starttime/2)-900));
            timeperiod2 = num2str(((endtime/2)-900));
            Condition = cond{1,cond_i};
            save([DIR,'\',Condition,timeperiod1,'to',timeperiod2,'_CONECTIVITY_IMAG.mat'],'Conn*','-v7.3');
            close all;
        end
        t = toc;
        fprintf('%3.2f s\n',t);
    end
end

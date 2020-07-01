%% GENERATE MATRIX:
clear all;

ConnectivityMatrix_delta = zeros(64,64);
ConnectivityMatrix_theta = zeros(64,64);
ConnectivityMatrix_loweralpha = zeros(64,64);
ConnectivityMatrix_upperalpha = zeros(64,64);
ConnectivityMatrix_beta = zeros(64,64);

CWD   = 'F:\fieldtrip';
NWD   = 'E:\fieldtrip';

names = {'DCR102' 'DCR103' 'DCR104' 'DCR106' 'DCR107' 'DCR108' 'DCR109' 'DCR110' 'DCR111' ... 
    'DCR112' 'DCR113' 'DCR114' 'DCR115' 'DCR117' 'DCR118' 'DCR119' 'DCR120' 'DCR121' ...
    'DCR122' 'DCR123' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR204' 'DCR206' 'DCR207' ... 
    'DCR208' 'DCR209' 'DCR210' 'DCR211' 'DCR212' 'DCR213' 'DCR214' 'DCR215' 'DCR217' ... 
    'DCR218' 'DCR219' 'DCR220' 'DCR221' 'DCR222' 'DCR223' 'DCR224' 'DCR225' 'S1' 'S1B' ... 
    'S4' 'S4B' 'S5' 'S5B' 'S6' 'S6B' 'S7' 'S7B' 'S8' 'S8B' 'S10' 'S10B' 'S11' 'S11B' 'S12' 'S12B' 'S13' 'S13-1' 'S13B' ...
    'S14' 'S14B' 'S15' 'S15B' 'S16' 'S16B' 'S17' 'S17B' 'S18' 'S18B' 'S20' 'S20B' 'S21' 'S21B' ...
    'S22' 'S22B' 'S23' 'S23B' 'S24' 'S24B' 'S25' 'S25B' 'S26' 'S26B' 'S27' 'S27B' 'S28' 'S28B' 'S29' 'S29B' ...
    'S30' 'S30B' 'S31' 'S31B' 'S34' 'S34B' 'S36' 'S36B' 'S37' 'S37B' 'S38' 'S38B' ...
    'S39' 'S39B' 'S40' 'S40B'}; %artefact rejection list


cond  = {'dirleft','dirright','nondirleft','nondirright'};


%% CHANGE HERE FOR DIFFERENT STARTS:

START = 0;

%%
endtime = 1000+START;

for starttime = 800+START:200:6800;
    endtime = endtime+200;
    for names_i = 1 :length(names) %usage: names{1,names_i}
        tic;
        fprintf('Processing: %s:  ', names{1,names_i});
        for cond_i = 1:length(cond)%usage: cond{1,cond_i}
            fprintf('\t%s:  ', cond{1,cond_i});
            for chx = 1:64
                for chy = chx+1:64
                    DIR = [CWD,'\','IMAGCOH_OUPUT','\',names{1,names_i},'\',cond{1,cond_i}];
                    filename = [DIR,'\','IMAGCOH_CH',num2str(chx),'_CH',num2str(chy),'.mat'];
                    %fprintf('Processing: %s  ', filename);
                    %tic;
                    load(filename);
                    %                 CROSSSPEC =  squeeze(CROSSSPEC); - already squeezed
                    %                 for starttime = [800:200:3600];
                    %Time: 0-400 = 800 - 1600
                    time = starttime:endtime;
                    %Frequencies delta      = 1 - 18
                    averageImgCoh = mean(mean(CROSSSPEC(1:18,time)));
                    ConnectivityMatrix_delta(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_delta(chy,chx) = averageImgCoh;
                    %fprintf(' .. ');
                    %Frequency Theta        = 19 - 31
                    averageImgCoh = mean(mean(CROSSSPEC(19:31,time)));
                    ConnectivityMatrix_theta(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_theta(chy,chx) = averageImgCoh;
                    %fprintf(' .. ');
                    %Frequency Lower Alpha  = 35 - 40
                    averageImgCoh = mean(mean(CROSSSPEC(35:40,time)));
                    ConnectivityMatrix_loweralpha(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_loweralpha(chy,chx) = averageImgCoh;
                    %fprintf(' .. ');
                    %Frequency Upper Alpha  = 41 - 47
                    averageImgCoh = mean(mean(CROSSSPEC(41:47,time)));
                    ConnectivityMatrix_upperalpha(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_upperalpha(chy,chx) = averageImgCoh;
                    %fprintf(' .. ');
                    %Frequency Beta         = 48 - 68
                    averageImgCoh = mean(mean(CROSSSPEC(48:68,time)));
                    ConnectivityMatrix_beta(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_beta(chy,chx) = averageImgCoh;
                    %fprintf(' .. ');
                    %t = toc;
                    %fprintf('%3.2f s\n',t);
                end
                
            end
            
            DIR = [NWD,'\','IMAGCOH_OUPUT','\',names{1,names_i},'\',cond{1,cond_i}];
            timeperiod1 = num2str(((starttime/2)-400));
            timeperiod2 = num2str(((endtime/2)-400));
            Condition = cond{1,cond_i};
            figure();
            imagesc(ConnectivityMatrix_delta);
            title([Condition,' Delta']);
            %saveas(gcf,[DIR,Condition,'_Delta'],'bmp');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Delta'],'fig');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Delta','.eps'], 'psc2');
            
            
            figure();
            imagesc(ConnectivityMatrix_theta);
            title([Condition,'Theta']);
            %saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Theta'],'bmp');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Theta'],'fig');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Theta','.eps'], 'psc2');
            
            figure();
            imagesc(ConnectivityMatrix_loweralpha);
            title([Condition,' Lower Alpha']);
            %saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_LowerAlpha'],'bmp');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_LowerAlpha'],'fig');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_LowerAlpha','.eps'], 'psc2');
            
            
            figure();
            imagesc(ConnectivityMatrix_upperalpha);
            title([Condition,' Upper Alpha']);
            %saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_UpperAlpha'],'bmp');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_UpperAlpha'],'fig');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_UpperAlpha','.eps'], 'psc2');
            
            figure();
            imagesc(ConnectivityMatrix_beta);
            title([Condition,' Beta']);
            %saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Beta'],'bmp');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Beta'],'fig');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Beta','.eps'], 'psc2');

            save([DIR,'\',Condition,timeperiod1,'to',timeperiod2,'_CONECTIVITY_IMAG.mat'],'Conn*','-v7.3');
            close all;
        end
        t = toc;
        fprintf('%3.2f s\n',t);
    end
end

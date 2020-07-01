%% GENERATE MATRIX:
clear all;

ConnectivityMatrix_delta = zeros(64,64);
ConnectivityMatrix_theta = zeros(64,64);
ConnectivityMatrix_loweralpha = zeros(64,64);
ConnectivityMatrix_upperalpha = zeros(64,64);
ConnectivityMatrix_beta = zeros(64,64);

CWD   = 'F:\fieldtrip';
names = {'AGE018','AGE019','AGE021','AGE022','AGE023','AGE024','AGE026','AGE038' ...
         'AGE046','AGE047','AGE050','AGE051','AGE052','AGE058'};
cond  = {'switchto','switchaway','noninf','mixrepeat'};
endtime = 1000;

for starttime = 800:200:3600;
    endtime = endtime+200;
    for names_i = 1:length(names) %usage: names{1,names_i}
        for cond_i = 1:length(cond)%usage: cond{1,cond_i}
            for chx = 1:64
                for chy = chx+1:64
                    DIR = [CWD,'\','IMAGCOH_OUPUT','\',names{1,names_i},'\',cond{1,cond_i}];
                    filename = [DIR,'\','IMAGCOH_CH',num2str(chx),'_CH',num2str(chy),'.mat'];
                    fprintf('Processing: %s  ', filename);
                    tic;
                    load(filename);
                    %                 CROSSSPEC =  squeeze(CROSSSPEC); - already squeezed
                    %                 for starttime = [800:200:3600];
                    %Time: 0-400 = 800 - 1600
                    time = starttime:endtime;
                    %Frequencies delta      = 1 - 18
                    averageImgCoh = mean(mean(CROSSSPEC(1:18,time)));
                    ConnectivityMatrix_delta(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_delta(chy,chx) = averageImgCoh;
                    fprintf(' .. ');
                    %Frequency Theta        = 19 - 31
                    averageImgCoh = mean(mean(CROSSSPEC(19:31,time)));
                    ConnectivityMatrix_theta(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_theta(chy,chx) = averageImgCoh;
                    fprintf(' .. ');
                    %Frequency Lower Alpha  = 35 - 40
                    averageImgCoh = mean(mean(CROSSSPEC(35:40,time)));
                    ConnectivityMatrix_loweralpha(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_loweralpha(chy,chx) = averageImgCoh;
                    fprintf(' .. ');
                    %Frequency Upper Alpha  = 41 - 47
                    averageImgCoh = mean(mean(CROSSSPEC(41:47,time)));
                    ConnectivityMatrix_upperalpha(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_upperalpha(chy,chx) = averageImgCoh;
                    fprintf(' .. ');
                    %Frequency Beta         = 48 - 68
                    averageImgCoh = mean(mean(CROSSSPEC(48:68,time)));
                    ConnectivityMatrix_beta(chx,chy) = averageImgCoh;
                    ConnectivityMatrix_beta(chy,chx) = averageImgCoh;
                    fprintf(' .. ');
                    t = toc;
                    fprintf('%3.2f s\n',t);
                end
                
            end
            timeperiod1 = num2str(((starttime/2)-400));
            timeperiod2 = num2str(((endtime/2)-400));
            Condition = cond{1,cond_i};
            figure();
            imagesc(ConnectivityMatrix_delta);
            title([Condition,' Delta']);
            saveas(gcf,[DIR,Condition,'_Delta'],'bmp');
            saveas(gcf,[DIR,Condition,'_Delta'],'fig');
            saveas(gcf,[DIR,Condition,'_Delta','.eps'], 'psc2');
            
            
            figure();
            imagesc(ConnectivityMatrix_theta);
            title([Condition,'Theta']);
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Theta'],'bmp');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Theta'],'fig');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Theta','.eps'], 'psc2');
            
            figure();
            imagesc(ConnectivityMatrix_loweralpha);
            title([Condition,' Lower Alpha']);
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_LowerAlpha'],'bmp');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_LowerAlpha'],'fig');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_LowerAlpha','.eps'], 'psc2');
            
            
            figure();
            imagesc(ConnectivityMatrix_upperalpha);
            title([Condition,' Upper Alpha']);
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_UpperAlpha'],'bmp');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_UpperAlpha'],'fig');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_UpperAlpha','.eps'], 'psc2');
            
            figure();
            imagesc(ConnectivityMatrix_beta);
            title([Condition,' Beta']);
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Beta'],'bmp');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Beta'],'fig');
            saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Beta','.eps'], 'psc2');

            save([DIR,'\',Condition,timeperiod1,'to',timeperiod2,'_CONECTIVITY_IMAG.mat'],'Conn*','-v7.3');
            close all;
        end
    end
end

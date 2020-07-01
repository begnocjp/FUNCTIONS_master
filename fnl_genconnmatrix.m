function fnl_genconnmatrix(wpms,channelcount,conditions,starttimes,endtime,freq_names,freq,name_i)
%% FNL_GENCONNMATRIX_ANALYSIS
% Generates connectivity matrix from imaginary coherence output
%
% USEAGE:
%        fnl_genconnmatrix(wpms,channelcount,times,frequencies,name_i)
%
% INPUTS:
%        wpms:  working parameters structure
%               (must include names and the current working,
%                data and wavelet_ouput directories)
%        channelcount: number of channels for connectivity matrix e.g. 64
%        conditions: cell array containing condition names (e.g.
%        {'condition_a','condition_b'})
%        startimes: array of starting times for sliding windows
%        endtimes: single number that corresponds to end point for first 
%        time bin - this combined with startimes array facilitates window 
%        size calculation
%        freq_names: cell array containing required frequency names (e.g.
%        {'delta','theta'})
%        freq: cell arrays containing required frequency ranges that
%        correspond to freq_names.
%              NOTE: frequencies are arranged in log space
%        name_i: current index in names list
%
%
% Patrick Cooper & Aaron Wong
% Functional Neuroimaging Laboratory, University of Newcastle 2014
% Edited by Alexander Conley
% Center for Cognitive Medicine, Vanderbilt University Medical Center, 2019
%% Preallocate matrices
for freq_i = 1:length(freq_names)
    eval(['ConnectivityMatrix_' freq_names{freq_i} '= zeros(' num2str(channelcount) ',' num2str(channelcount) ');']);
end
for starttime = 1:length(starttimes)
    endtime = endtime+200;
    for cond_i = 1:length(conditions)%usage: cond{1,cond_i}
        for chx = 1:channelcount
            for chy = chx+1:channelcount
                DIR = [wpms.dirs.CWD,wpms.dirs.COHERENCE_DIR,wpms.names{name_i},'\',conditions{cond_i},'\'];
                filename = [DIR,'IMAGCOH_CH',num2str(chx),'_CH',num2str(chy),'.mat'];
                fprintf('Processing: %s  ', filename);
                tic;
                load(filename);
                %Time: 0-400 = 800 - 1600
                time = starttimes(starttime):endtime;
                %Frequencies delta      = 1 - 18
                averageImgCoh = mean(mean(CROSSSPEC(freq{1},time)));
                ConnectivityMatrix_delta(chx,chy) = averageImgCoh;
                ConnectivityMatrix_delta(chy,chx) = averageImgCoh;
                fprintf(' .. ');
                %Frequency Theta        = 19 - 31
                averageImgCoh = mean(mean(CROSSSPEC(freq{2},time)));
                ConnectivityMatrix_theta(chx,chy) = averageImgCoh;
                ConnectivityMatrix_theta(chy,chx) = averageImgCoh;
                fprintf(' .. ');
                %Frequency Lower Alpha  = 35 - 40
                averageImgCoh = mean(mean(CROSSSPEC(freq{3},time)));
                ConnectivityMatrix_loweralpha(chx,chy) = averageImgCoh;
                ConnectivityMatrix_loweralpha(chy,chx) = averageImgCoh;
                fprintf(' .. ');
                %Frequency Upper Alpha  = 41 - 47
                averageImgCoh = mean(mean(CROSSSPEC(freq{4},time)));
                ConnectivityMatrix_upperalpha(chx,chy) = averageImgCoh;
                ConnectivityMatrix_upperalpha(chy,chx) = averageImgCoh;
                fprintf(' .. ');
                %Frequency Beta         = 48 - 68
                averageImgCoh = mean(mean(CROSSSPEC(freq{5},time)));
                ConnectivityMatrix_beta(chx,chy) = averageImgCoh;
                ConnectivityMatrix_beta(chy,chx) = averageImgCoh;
                fprintf(' .. ');
                t = toc;
                fprintf('%3.2f s\n',t);
            end
        end
        timeperiod1 = num2str(((starttimes(starttime)/2)-400));
        timeperiod2 = num2str(((endtime/2)-400));
        Condition = conditions{cond_i};
        figure();
        imagesc(ConnectivityMatrix_delta);
        title([Condition,' Delta']);
        saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Delta'],'bmp');
        saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Delta'],'fig');
        saveas(gcf,[DIR,Condition,timeperiod1,'to',timeperiod2,'_Delta','.eps'], 'psc2');
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
        save([DIR,'\',Condition,timeperiod1,'to',timeperiod2,'_CONNECTIVITY_IMAG.mat'],'Conn*','-v7.3');
        close all;
    end
end
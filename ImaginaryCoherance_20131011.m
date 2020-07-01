%Calculate:
clear all;
close all;

warning off; %#ok<WNOFF>

% matlabpool(4);
% try
    
    CWD   = 'E:\fieldtrip';
   names = struct('pnum',{ 'DCR102' 'DCR103' 'DCR104' 'DCR105' 'DCR106' 'DCR107' 'DCR108' 'DCR109' 'DCR110' 'DCR111' ... 
    'DCR112' 'DCR113' 'DCR114' 'DCR115' 'DCR116' 'DCR117' 'DCR118' 'DCR119' 'DCR120' 'DCR121' ...
    'DCR122' 'DCR123' 'DCR124' 'DCR125' 'DCR202' 'DCR204' 'DCR205' 'DCR206' 'DCR207' ... 
    'DCR208' 'DCR209' 'DCR210' 'DCR211' 'DCR212' 'DCR213' 'DCR214' 'DCR215' 'DCR216' 'DCR217' ... 
    'DCR218' 'DCR219' 'DCR220' 'DCR221' 'DCR222' 'DCR223' 'DCR224' 'DCR225' 'S1' 'S1B' 'S3' 'S3B'... 
    'S4' 'S4B' 'S5' 'S5B' 'S6' 'S6B' 'S7' 'S7B' 'S8' 'S8B' 'S10' 'S10B' 'S11' 'S11B' 'S12' 'S12B' 'S13' 'S13-1' 'S13B' ...
    'S14' 'S14B' 'S15' 'S15B' 'S16' 'S16B' 'S17' 'S17B' 'S18' 'S18B' 'S19' 'S19B' 'S20' 'S20B' 'S21' 'S21B' ...
    'S22' 'S22B' 'S23' 'S23B' 'S24' 'S24B' 'S25' 'S25B' 'S26' 'S26B' 'S27' 'S27B' 'S28' 'S28B' 'S29' 'S29B' ...
    'S30' 'S30B' 'S31' 'S31B' 'S32' 'S32B' 'S33' 'S33B' 'S34' 'S34B' 'S36' 'S36B' 'S37' 'S37B' 'S38' 'S38B' ...
    'S39' 'S39B' 'S40' 'S40B'}); %artefact rejection list
    cond  = {'dirleft','dirright','nondirleft','nondirright'};
    for names_i = 1:length(names)
        for cond_i = 1:length(cond)
            for chx = 1:64
                for chy = chx+1:64
                    filename1 = [CWD,'\','WAVELET_OUTPUT\',names{1,names_i},'\',cond{1,cond_i}, ...
                        '\',names{1,names_i},'_',cond{1,cond_i}, ...
                        '_',num2str(chx),'_imagcoh_mwtf.mat'];
                    filename2 = [CWD,'\','WAVELET_OUTPUT\',names{1,names_i},'\',cond{1,cond_i}, ...
                        '\',names{1,names_i},'_',cond{1,cond_i}, ...
                        '_',num2str(chy),'_imagcoh_mwtf.mat'];
                    [data1] = open(filename1);
                    [data2] = open(filename2);
                    %channel 1:
                    complex_mw_tf_1 = squeeze(data1.complex_mw_tf);
                    complex_mw_tf_2 = squeeze(data2.complex_mw_tf);
                    
                    CROSSSPEC = zeros(size(complex_mw_tf_1,1),size(complex_mw_tf_1,2),'single');
                    
                    for bin = 1:size(complex_mw_tf_1,1) %parfor
                        fft_x = complex_mw_tf_1(bin,:);
                        fft_y_conj = conj(complex_mw_tf_2(bin,:));
                        Cross = squeeze(fft_x.*fft_y_conj);
                        
                        %fprintf('REading FREQ: %i Ch: %i and %i\n',bin,chx,chy);
                        %Cross = Cross./length(fft_x);
                        PSD1 = complex_mw_tf_1(bin,:).*conj(complex_mw_tf_1(bin,:));
                        PSD2 = complex_mw_tf_2(bin,:).*conj(complex_mw_tf_2(bin,:));
                        den = ((squeeze(PSD1).*squeeze(PSD2)).^(0.5));
                        
                        
                        Coh = Cross./den;
                        ImagCoh = squeeze(imag(Coh));
                        
                        
                        CROSSSPEC(bin,:) = ImagCoh;
                        
                        
                    end
                    
                    t = [0 200 400 600 800 1000 1200 1400 1600 1800 2000 2200 2400 2600 2800 3000 3200 3400 3600];
                    tms = (t - 800)/2048*1000;
                    tmscell = cell(1,length(tms));
                    for  i =1:length(tms)
                        tmscell{1,i} = num2str(round(tms(1,i)));
                    end
                    CHIGH = 20.0;
                    CLOW = -20.0;
                    bins = 80;
                    times2test=-400:0.5:2200; % in ms
                    
                    
                    current_file = 'IMAGCOH';
                    mkdir([CWD,'\','IMAGCOH_OUPUT']);
                    mkdir([CWD,'\','IMAGCOH_OUPUT','\',names{1,names_i}]);
                    mkdir([CWD,'\','IMAGCOH_OUPUT','\',names{1,names_i},'\',cond{1,cond_i}])
                    savefilename = [CWD,'\','IMAGCOH_OUPUT','\',names{1,names_i},'\',cond{1,cond_i}, ...
                        '\',current_file,'_CH',num2str(chx), ...
                        '_CH',num2str(chy),'.mat'];
                    save(savefilename, 'CROSSSPEC', '-v7.3');
                    %
                    %                 for chani = 1:size(CROSSSPEC,1)
                    %
                    %                     screen_size = get(0, 'ScreenSize');
                    %                     f1 = figure();
                    %                     set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
                    %                     n = 3*4;
                    %                     plotdata = reshape(CROSSSPEC(chani,1:bins-n,:),bins-n,length(times2test(:)));
                    %                     %imagesc (plotdata,[CLOW CHIGH]);
                    %                     imagesc (plotdata);
                    %                     titlename = ['Condition: ','SwitchAway','  Channel: ',num2str(chx),' with ', num2str(chy),];
                    %                     title(titlename);
                    %                     set(gca,'YDir','normal')
                    %                     set(gca,'YTick',[1 19 32 36 47 68]);
                    %                     set(gca,'YTickLabel',{'2.0','4.2','7.1','8.3','13.0','30.7'});
                    %
                    %                     set(gca,'XTick',t);
                    %                     set(gca,'XTickLabel',tmscell);
                    %                     set(get(gca,'YLabel'),'String','Frequency (Hz)');
                    %                     set(get(gca,'XLabel'),'String','Time (ms)');
                    %                     grid on;
                    %                     colorbar;
                    %
                    %                     saveas(gcf,[CWD,'RESULTS\',current_file,'_CH',num2str(chx),'_CH',num2str(chy)],'bmp');
                    %                     saveas(gcf,[CWD,'RESULTS\',current_file,'_CH',num2str(chx),'_CH',num2str(chy)],'fig');
                    %                     saveas(gcf,[CWD,'RESULTS\',current_file,'_CH',num2str(chx),'_CH',num2str(chy),'.eps'], 'psc2');
                    %
                    %                     close all;
                end
            end
        end
    end
% catch exception
%     exception
%     matlabpool close force;
% end

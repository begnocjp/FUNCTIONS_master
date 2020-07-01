function bdf128_wavelet_analysis(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i)
%% FNL_WAVELET_ANALYSIS
% Performs FFT analysis on epoched data using wavelets
%
% USEAGE:
%        fnl_wavelet_analysis(wpms,times,windowsize,bins,name_i)
%
% INPUTS:
%        wpms:  working parameters structure
%               (must include names and the current working,
%                data and wavelet_ouput directories)
%        times: 1xn array of times to test (e.g. -400:0.5:2200)
%               NOTE: these times are in ms
%        windowsize: size of FFT window (in ms)
%        bins: number of bins to test
%        freqrange: array containing lower and upper bounds of frequency
%        space to sample (e.g. [2,50])
%        channels: channel numbers for FFT to be performed on (e.g. 1:64)
%        conditions: cell array containing condition names (e.g.
%        [{'condition_a'},{'condition_b'}]
%        name_i: current index in names list
%
% Note this step utilizes parallel processing to speed up analysis
%
% Thanks to Mike X. Cohen for access to original code
% Patrick Cooper & Aaron Wong
% Functional Neuroimaging Laboratory, University of Newcastle 2014

%% Set up globals

CHANNELS = channels;
current_file_types = conditions;
times2test = times;
timewindow = windowsize;
egroups = num2cell(1);
bins = bins;
% frex=logspace(log10(freqrange(1)),log10(freqrange(length(freqrange))),bins);
frex = 2:1:55;
%%
% matlabpool(4);
% try
%% Begin Analysis: Loop Condition, Channel
for cond_i = 1:length(current_file_types)
    for channi = CHANNELS
        fprintf('%s Begin Processing: \tCondition: %s \tChannel: %i\n', current_file_types{cond_i},channi);
        current_file = [wpms.names{name_i},'\',current_file_types{cond_i},'\',num2str(channi),'.mat'];
        filename = [wpms.dirs.CWD,wpms.dirs.DATA_DIR,current_file];
        resultsdir  = [wpms.dirs.CWD,wpms.dirs.WAVELET_OUTPUT_DIR];
        mkdir(resultsdir);
        %% Load File
        tic;
        load(filename);
        t = toc;
        fprintf('\t%s Loadded: %s in %3.3fseconds\n',current_file,EEG.comments,t);
        %% Initialise time/frequency parameters:
        % convert times to idx
        times2testidx=zeros(size(times2test));
        %times2testidx=mat2cell(times2testidx,1,length(times2test));
        %times2test=mat2cell(times2test,1,length(times2test));
        TEMP_TIMES = EEG.times;
        for i=1:length(times2test)
            temp = (TEMP_TIMES*1000-times2test(i));
            temp = abs(temp);
            [~,times2testidx(i)]=min(temp);
            %                 [~,times2testidx{i}]=min(abs(EEG.times*1000-times2test{i}));
        end
        %times2testidx = cell2mat(times2testidx);
        %times2test=cell2mat(times2test);
        % define time and cycles for wavelets
        t=-EEG.pnts/EEG.srate/2:1/EEG.srate:EEG.pnts/EEG.srate/2-1/EEG.srate;
        timewindowidx=round(timewindow/(1000/EEG.srate)/2);
        numcycles=logspace(log10(3),log10(14),length(frex));
        mw_tf  = zeros(length(frex),length(times2test),'single');
        complex_mw_tf  = zeros(length(frex),length(times2test),'single');
        %% loop over frequencies:
        TEMP_DATA = EEG.data;
        TEMP_PNTS = EEG.pnts;
        TEMP_TRIALS = EEG.trials;
        TEMP_COMMENTS = EEG.comments;
        for fi=1:length(frex)
            % extract frequency band-specific oscillation power
            fprintf('Calculating for %3.2f Hz \n', frex(fi));
            % create wavelet
            centerfreq = frex(fi);
            wavelet=exp(2*1i*pi*centerfreq.*t).*exp(-t.^2./(2*(numcycles(fi)/(2*pi*centerfreq))^2));
            % further initialize freqdata
            freqdata = zeros(size(TEMP_DATA));
            complex_freqdata = zeros(size(TEMP_DATA));
            % loop over channels
            fprintf(' \t Calculating for Channel: %3.2f, %s', frex(fi),TEMP_COMMENTS);
            % frequency-domain convolution parameters
            Ldata  =  numel(TEMP_DATA(1,:,:));
            Lconv1 =  Ldata+TEMP_PNTS-1;
            Lconv  =  pow2(nextpow2(Lconv1));
            % FFT of data
            TEMP_SIZE = size(TEMP_DATA);
            EEGfft = fft(reshape(TEMP_DATA(1,:,:),1,TEMP_SIZE(1)*TEMP_SIZE(2)*TEMP_SIZE(3)),Lconv);
            fprintf(' \t AFTERFFT: %3.2f, %s', frex(fi),TEMP_COMMENTS);
            % convolution (in frequency domain, thanks to convolution theorem)
            m = ifft(EEGfft.*fft(wavelet,Lconv),Lconv);
            m = m(1:Lconv1);
            m = reshape(m(floor((TEMP_SIZE(2)-1)/2):end-1-ceil((TEMP_SIZE(2)-1)/2)),TEMP_SIZE(2),TEMP_SIZE(3));
            fprintf(' \t AFTER CONVOLUTION: %3.2f, %s', frex(fi),TEMP_COMMENTS);
            % store data
            freqdata(1,:,:) = abs(m).^2;
            complex_freqdata(1,:,:) = m;
            fprintf(' \t AFTER STORE: %3.2f, %s', frex(fi),TEMP_COMMENTS);
            fprintf(' \n');
            %% compute trial-averaged baseline-corrected power
            baselineperiod=[ -0.25 -0.05 ];
            [~,StartBaselineIdx]=min(abs(TEMP_TIMES-baselineperiod(1)));
            [~,EndBaselineIdx]=min(abs(TEMP_TIMES-baselineperiod(2)));
            fprintf('\n\ncompute trial-averaged baseline-corrected power\n\n');
            fprintf(' \t \t Calculating for channel %i %s\n', 1,TEMP_COMMENTS);
            mw_tf(fi,:) = 10*log10( squeeze(mean(freqdata(1,times2testidx,:),3)) ./ mean(mean(freqdata(1,StartBaselineIdx:EndBaselineIdx,:),3),2) );
            complex_mw_tf(fi,:) = squeeze(mean(complex_freqdata(1,times2testidx,:),3));
        end % end frequency loop
        subfilename = [wpms.names{name_i},'_',current_file_types{cond_i},'_',num2str(channi)];
        SAVE_filename = [resultsdir,'\',wpms.names{name_i},'\',current_file_types{cond_i},'\',subfilename,'_imagcoh_mwtf.mat'];
        mkdir([resultsdir,'\',wpms.names{name_i}]);
        mkdir([resultsdir,'\',wpms.names{name_i},'\',current_file_types{cond_i}]);
        save(SAVE_filename,'*mw_tf','-v7.3');
        %             %t = [0 200 400 600 800 1000 1200 1400 1600 1800 2000 2200 2400 2600 2800 3000 3200 3400 3600 3800 4000 4200 4400 4600 4800];
        %             t = 1:200:9801;
        %             tms = (t - 900*2-1)/2;
        %             tmscell = cell(1,length(tms));
        %             for  i =1:length(tms)
        %                 tmscell{1,i} = num2str(round(tms(1,i)));
        %             end
        %             CHIGH = 1.0;
        %             CLOW = -1.0;
        %             screen_size = get(0, 'ScreenSize');
        %             f1 = figure(1);
        %             set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
        %             n = 3*4;
        %             imagesc (reshape(mw_tf(1:bins-n,:),bins-n,length(times2test(:))),[CLOW CHIGH]);
        %             titlename = ['Condition: ',current_file];
        %             title(titlename);
        %             set(gca,'YDir','normal')
        %             set(gca,'YTick',[1 19 32 36 47 68]);
        %             set(gca,'YTickLabel',{'2.0','4.2','7.1','8.3','13.0','30.7'});
        %             set(gca,'XTick',t);
        %             set(gca,'XTickLabel',tmscell);
        %             set(get(gca,'YLabel'),'String','Frequency (Hz)');
        %             set(get(gca,'XLabel'),'String','Time (ms)');
        %             grid on;
        %             colorbar;
        %             saveas(gcf,[resultsdir,'\',wpms.names{name_i},'\',current_file_types{cond_i},'\',subfilename],'bmp');
        %             saveas(gcf,[resultsdir,'\',wpms.names{name_i},'\',current_file_types{cond_i},'\',subfilename],'fig');
        %             close all;
    end %channel loop
end %Condition Loop
% catch exception
%     matlabpool close force
%     exception
% end
% matlabpool close force
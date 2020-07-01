function fnl_wavelet_baseline_analysis(wpms,times,windowsize,bins,freqrange,channels,conditions,name_i)
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
frex=logspace(log10(freqrange(1)),log10(freqrange(length(freqrange))),bins);
%% Begin Analysis: Loop Condition, Channel
for cond_i = 1:length(current_file_types)
    fprintf('.')
    for channi = CHANNELS
        %fprintf('%s Begin Processing: \tCondition: %s \tChannel: %i\n', current_file_types{cond_i},channi);
        current_file = [wpms.names{name_i},'\',current_file_types{cond_i},'\',num2str(channi),'.mat'];
        filename = [wpms.dirs.CWD,wpms.dirs.DATA_DIR,current_file];
        resultsdir  = [wpms.dirs.CWD,wpms.dirs.WAVELET_OUTPUT_DIR];
        mkdir(resultsdir);
        %% Load File
        
        tic;
        load(filename);
        t = toc;
       % fprintf('\t%s Loadded: %s in %3.3fseconds\n',current_file,EEG.comments,t);
        
        %% Initialise time/frequency parameters:
        % convert times to idx
        
        times2testidx=zeros(size(times2test));
        for i=1:length(times2test)%dropped parfor -Patrick
            [~,times2testidx(i)]=min(abs(EEG.times*1000-times2test(i)));
        end
        
        % define time and cycles for wavelets
        t=-EEG.pnts/EEG.srate/2:1/EEG.srate:EEG.pnts/EEG.srate/2-1/EEG.srate;
        timewindowidx=round(timewindow/(1000/EEG.srate)/2);
        numcycles=logspace(log10(3),log10(14),length(frex));
        
        %baseline
        baselineperiod=[ -0.5 0 ];
        [~,StartBaselineIdx]=min(abs(EEG.times-baselineperiod(1)));
        [~,EndBaselineIdx]=min(abs(EEG.times-baselineperiod(2)));
        baseline_data  = zeros(length(frex),length(StartBaselineIdx:EndBaselineIdx),'single');
        %% loop over frequencies:
        for fi=1:length(frex)
            % extract frequency band-specific oscillation power
        %    fprintf('Calculating for %3.2f Hz \n', frex(fi));
            % create wavelet
            centerfreq = frex(fi);
            wavelet=exp(2*1i*pi*centerfreq.*t).*exp(-t.^2./(2*(numcycles(fi)/(2*pi*centerfreq))^2));
            % further initialize freqdata
            freqdata = zeros(size(EEG.data));
            % loop over channels
         %   fprintf(' \t Calculating for Channel: %3.2f, %s\n', frex(fi),EEG.comments);
            % frequency-domain convolution parameters
            Ldata  =  numel(EEG.data(1,:,:));
            Lconv1 =  Ldata+EEG.pnts-1;
            Lconv  =  pow2(nextpow2(Lconv1));
            % FFT of data
            EEGfft = fft(reshape(EEG.data(1,:,:),1,EEG.pnts*size(EEG.data,3)),Lconv);
          %  fprintf(' \t AFTER FFT: %3.2f, %s\n', frex(fi),EEG.comments);
            % convolution (in frequency domain, thanks to convolution theorem)
            m = ifft(EEGfft.*fft(wavelet,Lconv),Lconv);
            m = m(1:Lconv1);
            m = reshape(m(floor((EEG.pnts-1)/2):end-1-ceil((EEG.pnts-1)/2)),EEG.pnts,size(EEG.data,3));
           % fprintf(' \t AFTER CONVOLUTION: %3.2f, %s\n', frex(fi),EEG.comments);
            % store data
            freqdata(1,:,:) = abs(m).^2;
%             fprintf(' \t AFTER STORE: %3.2f, %s\n', frex(fi),EEG.comments);
%             fprintf(' \n');
            baseline_data(fi,:) = 10*log10(squeeze(mean(mean(freqdata(1,StartBaselineIdx:EndBaselineIdx,:),3),2)));
        end % end frequency loop
        subfilename = [wpms.names{name_i},'_',current_file_types{cond_i},'_',num2str(channi)];
        SAVE_filename = [resultsdir,'\',wpms.names{name_i},'\',current_file_types{cond_i},'\',subfilename,'_baseline_mwtf.mat'];
        mkdir([resultsdir,'\',wpms.names{name_i}]);
        mkdir([resultsdir,'\',wpms.names{name_i},'\',current_file_types{cond_i}]);
        save(SAVE_filename,'*baseline_data','-v7.3');
    end %channel loop
end %Condition Loop

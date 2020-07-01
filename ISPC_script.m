%% easily modifiable parameters
% center frequency in Hz
clc;clear all;close all;
datadir = 'E:\fieldtrip\EEGLAB_FORMAT\';
cd(datadir);
load lfchans
% names = {'DCR104' 'DCR107' 'DCR110' 'DCR111' 'DCR112' 'DCR115' 'DCR118' 'DCR119'...
%     'DCR122' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR206' 'DCR208' 'DCR209'...
%     'DCR213' 'DCR214' 'DCR217' 'DCR220' 'DCR221' 'DCR223'...
%     'DCR204' 'DCR207' 'DCR210' 'DCR211' 'DCR212'  'DCR215' 'DCR218' 'DCR219' 'DCR222'...
%     'DCR224' 'DCR225' 'DCR102' 'DCR103'  'DCR106' 'DCR108' 'DCR109' 'DCR113' 'DCR114' ...
%     'DCR117' 'DCR120' 'DCR121' 'DCR123'  ...
%     'S1' 'S6B' 'S8' 'S11B' 'S15B' 'S16B' 'S18' 'S21' 'S25B' 'S29B'...
%     'S31B' 'S36' 'S39' 'S40'...
%     'S1B' 'S6' 'S8B' 'S11' 'S15' 'S16' 'S18B' 'S21B' 'S25' 'S29' 'S31' ...
%     'S36B' 'S39B' 'S40B'...
%     'S4' 'S5B' 'S7B' 'S10' 'S12' 'S14' 'S17' 'S22B' 'S23B' 'S27' 'S28B' 'S30'...
%     'S4B' 'S5' 'S7' 'S10B' 'S12B' 'S14B' 'S17B' 'S22' 'S23' 'S27B'...
%     'S28' 'S30B'};
names = {'DCR102'	'DCR103'	'DCR204'	'DCR205'	'DCR106'	'DCR207'	'DCR108'	'DCR109'	'DCR210'	'DCR211'	'DCR212'	'DCR113'	'DCR114'	'DCR215'	'DCR116'	'DCR117'	'DCR218'	'DCR219'	'DCR120'	'DCR121'	'DCR222'	'DCR123'	'DCR224'	'DCR225'...
'S1B'	'S3'	'S5'	'S6'	'S7'	'S8B'	'S10B'	'S11'	'S12B'	'S13'	'S14B'	'S15'	'S16'	'S17B'	'S18B'	'S20B'	'S21B'	'S22'	'S23'	'S24B'	'S25'	'S27B'	'S28'	'S29'	'S30B'	'S31B'	'S33'	'S34'	'S36B'	'S37'	'S38'	'S39B'	'S40B'};
listing = dir([datadir names{1}]);
conditions = {};
for list_i = 1:length(listing)
    keepdot = ismember(listing(list_i).name,'.');
    if keepdot ==0;
        conditions = [conditions listing(list_i).name];
    end
end
% number of trials
%% initial setup and load in necessary files
% mat file containing leadfield and channel locations
%% intialize output matrices
electrodes4seeded_synch = { 'AF3';'AF4' };
% wavelet parameters
min_freq =  2;
max_freq = 30;
num_frex = 80;
wavelet_cycle_range = [ 3 14 ];
frex = logspace(log10(min_freq),log10(max_freq),num_frex);
% gaussian width and time
s = logspace(log10(wavelet_cycle_range(1)),log10(wavelet_cycle_range(2)),num_frex)./(2*pi.*frex);
srate = 512;
% time for simulation (in seconds)
time  = (-1:1/srate:2)*1000;
% time points to save from final results, and baseline for power normalization
times2save = -400:50:2000; % in ms
baselinetimerange = [ -250 0 ];
nchans = 64;
t = -2:1/srate:2;
%%
% setup time indexing
times2saveidx = dsearchn(time',times2save');
baseidx = dsearchn(time',baselinetimerange');
% fft and convolution details
% matlabpool open
% try
    for name_i = 1:length(names)
        fprintf('%s %s\n','Subject:',names{name_i});
        for cond_i = 1:length(conditions)
            fprintf('\n\t\t%s',conditions{cond_i});
            filename = [datadir names{name_i} filesep conditions{cond_i} filesep num2str(1) '.mat'];
            load(filename);
            EEGdat = zeros(nchans,size(EEG.data,2),size(EEG.data,3));
            for chani = 1:nchans
                fprintf('.');
                filename = [datadir names{name_i} filesep conditions{cond_i} filesep num2str(chani) '.mat'];
                load(filename);
                EEGdat(chani,:,:) = EEG.data;
            end
            ntime  = size(EEGdat,2);
            ntrials = size(EEGdat,3);
            Ltapr  =  length(t);
            Ldata  =  prod(ntime*ntrials);
            Lconv1 =  Ldata+Ltapr-1;
            Lconv  =  pow2(nextpow2( Lconv1 ));
            wavelets = zeros(num_frex,length(t));
            for fi=1:num_frex
                wavelets(fi,:) = exp(2*1i*pi*frex(fi).*t).*exp(-t.^2./(2*s(fi)^2));
            end
            allphasevals    = zeros(nchans,num_frex,length(times2save),ntrials);
            allphasevals_base    = zeros(nchans,num_frex,length(baseidx(1):baseidx(2)),ntrials);
            synchOverTrials = zeros(length(electrodes4seeded_synch),nchans,num_frex,length(times2saveidx));
            synchOverTrials_base = zeros(length(electrodes4seeded_synch),nchans,num_frex);
            %         tf    = zeros(nchans+2,num_frex,length(times2saveidx),2);
            %         allAS = zeros(2,num_frex,ntime,ntrials,2);
            % loop around channels
            tic;
            fprintf('\n\t\t\t');
            for chani=1:nchans
                %             fprintf('.');
                % FFT of data (channel or true dipoles)
                EEGfft = fft(reshape(EEGdat(chani,:,:),1,[]),Lconv);
                % loop over frequencies and complete convolution
                for fi=1:num_frex
                    % convolve and get analytic signal (as)
                    as = ifft(EEGfft.*fft(wavelets(fi,:),Lconv),Lconv);
                    as = as(1:Lconv1);
                    as = reshape(as(floor((Ltapr-1)/2):end-1-ceil((Ltapr-1)/2)),ntime,ntrials);
                    allphasevals(chani,fi,:,:) = as(times2saveidx,:);
                    allphasevals_base(chani,fi,:,:) = as(baseidx(1):baseidx(2),:);
%                     baselineperiod=[ -0.25 0 ];
%                     [~,StartBaselineIdx]=min(abs(TEMP_TIMES-baselineperiod(1)));
%                     [~,EndBaselineIdx]=min(abs(TEMP_TIMES-baselineperiod(2)));
%                     fprintf('\n\ncompute trial-averaged baseline-corrected power\n\n');
%                     fprintf(' \t \t Calculating for channel %i %s\n', 1,TEMP_COMMENTS);
%                     mw_tf(fi,:) = 10*log10( squeeze(mean(freqdata(1,times2testidx,:),3)) ./ mean(mean(freqdata(1,StartBaselineIdx:EndBaselineIdx,:),3),2) );
%                     complex_mw_tf(fi,:) = squeeze(mean(complex_freqdata(1,times2testidx,:),3));
                end % end frequency loop
            end % end channel loop
            proctime= toc;
            fprintf('\t%s %s',num2str(proctime),' seconds to complete');
            %%
            for chanx=1:length(electrodes4seeded_synch)
                % ISPC (average reference and laplacian)
                synchOverTrials(chanx,:,:,:) = mean(exp(1i* bsxfun(@minus,angle(allphasevals(strcmpi(electrodes4seeded_synch{chanx},{chanlocs.labels}),:,:,:)),angle(allphasevals(:,:,:,:))) ),4);
                
                synchOverTrials_base(chanx,:,:) = mean(mean(exp(1i* bsxfun(@minus,angle(allphasevals_base(strcmpi(electrodes4seeded_synch{chanx},{chanlocs.labels}),:,:,:)),angle(allphasevals_base(:,:,:,:))) ),4),3);
            end
            % Calculate percentage change:
            percent_change_sync = zeros(size(synchOverTrials));
            for time_i = 1:size(synchOverTrials,4)
                for chan_p_i = 1:size(percent_change_sync,2)
                    for freq_p_i = 1:size(percent_change_sync,3)
                        for seed_p_i = 1:size(percent_change_sync,1)
                            magnitude = sqrt(real(synchOverTrials(seed_p_i,chan_p_i,freq_p_i,time_i)).^2+imag(synchOverTrials(seed_p_i,chan_p_i,freq_p_i,time_i)).^2);
                            magnitude_base = sqrt((real(synchOverTrials_base(seed_p_i,chan_p_i,freq_p_i))).^2+(imag(synchOverTrials_base(seed_p_i,chan_p_i,freq_p_i))).^2);
                            percent_change_sync(seed_p_i,chan_p_i,freq_p_i,time_i) = 100*((magnitude-magnitude_base)/magnitude_base);
                        end
                    end
                end
            end
            % NaN's cause electrode data shifts in the eeglab topoplot function
            synchOverTrials(isnan(synchOverTrials))=0;
            savename = [datadir names{name_i} filesep conditions{cond_i} filesep names{name_i} '_ISPC.mat'];
            save(savename,'percent_change_sync','-v7.3');
        end
    end
% catch exception
%     disp(exception)
%     matlabpool close
% end
% matlabpool close

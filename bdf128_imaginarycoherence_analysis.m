function bdf128_imaginarycoherence_analysis(wpms,channels,conditions,name_i)
%% FNL_IMAGINARYCOHERENCE_ANALYSIS
% Performs imaginary coherence analysis on epoched data
%
% USEAGE:
%        fnl_imaginarycoherence_analysis(wpms,times,conditions,name_i)
%
% INPUTS:
%        wpms:  working parameters structure
%               (must include names and the current working,
%                data and wavelet_ouput directories)
%        channels: channel numbers for FFT to be performed on (e.g. 1:64)
%        conditions: cell array containing condition names (e.g.
%        {'condition_a','condition_b'})
%        name_i: current index in names list
%
% Note this step utilizes parallel processing to speed up analysis
%
% Patrick Cooper & Aaron Wong
% Functional Neuroimaging Laboratory, University of Newcastle 2014

wpms.dirs.NWD = 'E:\fieldtrip\';

% matlabpool(4);
% try
    for cond_i = 1:length(conditions)
        fprintf('.')
        for chx = 1:length(channels)
            for chy = chx+1:length(channels)
                filename1 = [wpms.dirs.CWD,wpms.dirs.WAVELET_OUTPUT_DIR,wpms.names{name_i},'\',conditions{cond_i}, ...
                    '\',wpms.names{name_i},'_',conditions{cond_i}, ...
                    '_',num2str(chx),'_imagcoh_mwtf.mat'];
                filename2 = [wpms.dirs.CWD,wpms.dirs.WAVELET_OUTPUT_DIR,wpms.names{name_i},'\',conditions{cond_i}, ...
                    '\',wpms.names{name_i},'_',conditions{cond_i}, ...
                    '_',num2str(chy),'_imagcoh_mwtf.mat'];
                [data1] = open(filename1);
                [data2] = open(filename2);
                complex_mw_tf_1 = squeeze(data1.complex_mw_tf);
                complex_mw_tf_2 = squeeze(data2.complex_mw_tf);
                CROSSSPEC = zeros(size(complex_mw_tf_1,1),size(complex_mw_tf_1,2),'single');
                parfor bin = 1:size(complex_mw_tf_1,1)
                    fft_x = complex_mw_tf_1(bin,:);
                    fft_y_conj = conj(complex_mw_tf_2(bin,:));
                    Cross = squeeze(fft_x.*fft_y_conj);
                    PSD1 = complex_mw_tf_1(bin,:).*conj(complex_mw_tf_1(bin,:));
                    PSD2 = complex_mw_tf_2(bin,:).*conj(complex_mw_tf_2(bin,:));
                    den = ((squeeze(PSD1).*squeeze(PSD2)).^(0.5));
                    Coh = Cross./den;
                    ImagCoh = squeeze(imag(Coh));
                    CROSSSPEC(bin,:) = ImagCoh;
                end
                current_file = 'IMAGCOH';
                mkdir([wpms.dirs.NWD,wpms.dirs.COHERENCE_DIR]);
                mkdir([wpms.dirs.NWD,wpms.dirs.COHERENCE_DIR,wpms.names{name_i}]);
                mkdir([wpms.dirs.NWD,wpms.dirs.COHERENCE_DIR,wpms.names{name_i},'\',conditions{cond_i}])
                savefilename = [wpms.dirs.NWD,wpms.dirs.COHERENCE_DIR,wpms.names{name_i},'\',conditions{cond_i}, ...
                    '\',current_file,'_CH',num2str(chx), ...
                    '_CH',num2str(chy),'.mat'];
                save(savefilename, 'CROSSSPEC', '-v7.3');
            end
        end
    end
% catch exception
%     exception
%     matlabpool close force;
end
% matlabpool close;
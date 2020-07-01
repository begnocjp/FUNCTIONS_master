function EEG = convert_ft2eeg(data)
    % We want: data (1,samples,trials)
    for ch_i = 1:size(data.trial,1)
        for i=1:size(data.trial,2)
            EEG.data(ch_i,:,i) = single(data.trial{ch_i,:});
            EEG.nbchan     = 1;
            EEG.trials     = size(data.trial,2);
            EEG.pnts       = size(data.trial{1},2);
            EEG.srate      = data.fsample;
            EEG.xmin       = data.time{1}(1);
            EEG.xmax       = data.time{1}(end);
            EEG.times      = data.time{1};
            EEG.ref        = []; %'common';
            EEG.comments   = ['Channel: ' ,num2str(ch_i),'(preprocessed with fieldtrip)' ];
        end
    end


end

function EEG = convert_ft2eeg_ch(data)
    % We want: data (1,samples,trials)
    
    for ch_i=1:size(data.trial{1,1},1)
        for i = 1:size(data.trial,2)
            EEG.data(1,:,i) = single(data.trial{1,i}(ch_i,:));
        end
        EEG.nbchan     = 1;
        EEG.trials     = size(data.trial,2);
        EEG.pnts       = size(data.trial{1},2);
        EEG.srate      = data.fsample;
        EEG.xmin       = data.time{1}(1);
        EEG.xmax       = data.time{1}(end);
        EEG.times      = data.time{1};
        EEG.ref        = []; %'common';
        EEG.comments   = ['Channel: ' ,num2str(ch_i),'(preprocessed with fieldtrip)' ];

        filename = [num2str(ch_i),'.mat'];
        save(filename,'EEG','-v7.3');
    end



end

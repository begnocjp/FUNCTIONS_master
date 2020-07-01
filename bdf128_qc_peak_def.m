%% bdf128_qc_peak_def
% Auditory File - setup structure

load('E:\Tourrette_EEG\aud_qc_wave.mat');

pre_trial = 0.1;
post_trial = 0.1;
trialfunction = 'qc_aud'; 
file_ext = 'bdf';
fsample = 4096;

event = zeros(1,422);
trigger = zeros(1,422);
% sample = [];
trl_length = length(aud_qc.data)/4096;

% Get events into 1 vector
for event_i = 4:length(aud_qc.events)
    event(1,event_i) = aud_qc.events(1,event_i).sample;% - magic_number;
end
% Get triggers into 1 vector
for event_i = 4:length(aud_qc.events)
    trigger(1,event_i) = str2num(aud_qc.events(1,event_i).value);%(strcmp('trigger', {aud_qc.events.type})).value;
end
trigger = trigger';

% Convert window endpoints to sample frequency
pretrig  = -round(pre_trial * fsample);
posttrig =  round(post_trial * fsample);
% 820 samples based on 0.1 seconds

% Create Epochs endpoints relative to triggers

trl = [];
for trial_i = 4:length(event)
    trlbegin = event(trial_i)+pretrig;
    trlend = event(trial_i)+posttrig;
    newtrl = [trlbegin trlend];
    trl = [trl;newtrl];
end

% Create epochs from data based on endpoints
trial_list = zeros(422,820);

for trial_i = 1:length(trl)
%     for trial_j = 1:length(trl)
        trial_list(trial_i,:) = aud_qc.data(trl(trial_i,1):trl(trial_i,2)-1);
        
%     end 
end

%% Find max/min on trial_list

max_list = zeros(422,1);
min_list = zeros(422,1);
times = -100:0.2442:100;

for trial_i = 1:length(trl)
    max_list(trial_i) = max(trial_list(trial_i,:));    
    min_list(trial_i) = min(trial_list(trial_i,:));
end

% Find where the max/min values are
max_pos = zeros(422,820);
min_pos = zeros(422,820);

for pos_i = 1:length(trl)
    for pos_j = 1:length(trial_list)
        if max_list(pos_i) == trial_list(pos_i,pos_j)
            max_pos(pos_i,pos_j) = max_list(pos_i);
        elseif min_list(pos_i) == trial_list(pos_i,pos_j)
            min_pos(pos_i,pos_j)= min_list(pos_i);
        end
    end
end

% Avg and plot
trial_avg = mean(trial_list);

plot(times,trial_avg);

%% Tactile file

load('E:\Tourrette_EEG\tact_qc_wave.mat');

pre_trial = 0.1;
post_trial = 0.1;

file_ext = 'bdf';
fsample = 4096;

event = zeros(1,498);
trigger = zeros(1,498);
% sample = [];
trl_length = length(tact_qc_wave.data)/4096;

% Get events into 1 vector
for event_i = 6:length(tact_qc_wave.event)
    event(1,event_i) = tact_qc_wave.event(1,event_i).sample;% - magic_number;
end
% Get triggers into 1 vector
for event_i = 6:length(tact_qc_wave.event)
    trigger(1,event_i) = str2num(tact_qc_wave.event(1,event_i).value);%(strcmp('trigger', {aud_qc.events.type})).value;
end
trigger = trigger';

% Convert window endpoints to sample frequency
pretrig  = -round(pre_trial * fsample);
posttrig =  round(post_trial * fsample);
% 820 samples based on 0.1 seconds

% Create Epochs endpoints relative to triggers

trl = [];
for trial_i = 6:length(event)
    trlbegin = event(trial_i)+pretrig;
    trlend = event(trial_i)+posttrig;
    newtrl = [trlbegin trlend];
    trl = [trl;newtrl];
end

% Create epochs from data based on endpoints
trial_list = zeros(498,820);

for trial_i = 1:length(trl)
%     for trial_j = 1:length(trl)
        trial_list(trial_i,:) = tact_qc_wave.data(trl(trial_i,1):trl(trial_i,2)-1);
        
%     end 
end

%% Find max/min on trial_list

max_list = zeros(422,1);
min_list = zeros(422,1);
times = -100:0.2442:100;

for trial_i = 1:length(trl)
    max_list(trial_i) = max(trial_list(trial_i,:));    
    min_list(trial_i) = min(trial_list(trial_i,:));
end

% Find where the max/min values are
max_pos = zeros(422,820);
min_pos = zeros(422,820);

for pos_i = 1:length(trl)
    for pos_j = 1:length(trial_list)
        if max_list(pos_i) == trial_list(pos_i,pos_j)
            max_pos(pos_i,pos_j) = max_list(pos_i);
        elseif min_list(pos_i) == trial_list(pos_i,pos_j)
            min_pos(pos_i,pos_j)= min_list(pos_i);
        end
    end
end

% Avg and plot
trial_avg = mean(trial_list);

plot(times,trial_avg);

%% Second Tactile file

load('E:\Tourrette_EEG\tact_qc_2.mat');

pre_trial = 0.1;
post_trial = 0.1;

file_ext = 'bdf';
fsample = 4096;

event = zeros(1,929);
trigger = zeros(1,929);
% sample = [];
trl_length = length(tac_qc2.data)/4096;

% Get events into 1 vector
for event_i = 6:length(tac_qc2.event)
    event(1,event_i) = tac_qc2.event(1,event_i).sample;% - magic_number;
end
% Get triggers into 1 vector
for event_i = 6:length(tac_qc2.event)
    trigger(1,event_i) = str2num(tac_qc2.event(1,event_i).value);%(strcmp('trigger', {aud_qc.events.type})).value;
end
trigger = trigger';

% Convert window endpoints to sample frequency
pretrig  = -round(pre_trial * fsample);
posttrig =  round(post_trial * fsample);
% 820 samples based on 0.1 seconds

% Create Epochs endpoints relative to triggers

trl = [];
for trial_i = 6:length(event)
    trlbegin = event(trial_i)+pretrig;
    trlend = event(trial_i)+posttrig;
    newtrl = [trlbegin trlend];
    trl = [trl;newtrl];
end

% Create epochs from data based on endpoints
trial_list = zeros(923,820);

for trial_i = 1:length(trl)
%     for trial_j = 1:length(trl)
        trial_list(trial_i,:) = tac_qc2.data(trl(trial_i,1):trl(trial_i,2)-1);
        
%     end 
end

%% Find max/min on trial_list

max_list = zeros(923,1);
min_list = zeros(923,1);
times = -100:0.2442:100;

for trial_i = 1:length(trl)
    max_list(trial_i) = max(trial_list(trial_i,:));    
    min_list(trial_i) = min(trial_list(trial_i,:));
end

% Find where the max/min values are
max_pos = zeros(923,820);
min_pos = zeros(923,820);

for pos_i = 1:length(trl)
    for pos_j = 1:length(trial_list)
        if max_list(pos_i) == trial_list(pos_i,pos_j)
            max_pos(pos_i,pos_j) = max_list(pos_i);
        elseif min_list(pos_i) == trial_list(pos_i,pos_j)
            min_pos(pos_i,pos_j)= min_list(pos_i);
        end
    end
end

% Avg and plot
trial_avg = mean(trial_list);

plot(times,trial_avg);


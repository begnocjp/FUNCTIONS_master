% Extraction of RT Data from Presentation Log file
% Modified to Extract RT Data for Each Experimental Block by Alexander Conley, 25/07/14

% Codes used
% 60 = Start of block, end of experiment
% Responses: 40 = Left Response; 50 = Right Response
% Cues: 1 = Non-Directional; 2 =  Directional Left;
%    3 = Directional Right
% Targets: 11 = Non-Directional Left; 12 = Non-Directional Right;
% 21 = Directional Left; 32 = Directional Right;
% Nogo Targets: 20 = Directional Left; 30 = Directional Right

clear all

CWD = ('E:\Cued_Go-Nogo2013\');

cuecond = {'nondir'; 'dirleft'; 'dirright'};
cuecode = [1 2 3];

targetcond = {'nondirleft'; 'nondirright'; 'leftnogo'; 'leftgo'; 'rightnogo'; 'rightgo'};
targetcode    = [11 12 20 21 30 32];
targetcorrect = [40 50  0 40  0 50];        % correct response codes for each target condition
    % 11, 21 -> 40
    % 12, 32 -> 50 are correct
    % 20, 30 -> no response

response = {'lefthand';'righthand'};
responsecode = [40 50];

block = 60; 
%% Create list of all subject names
% set names = {'DCR102' 'DCR103' 'DCR104'};

names = {'DCR102','DCR103','DCR104','DCR105','DCR106','DCR107','DCR108','DCR109','DCR110','DCR111','DCR112','DCR113'...
    'DCR114','DCR115','DCR116','DCR117','DCR118','DCR119','DCR120','DCR121','DCR122','DCR123','DCR124','DCR125'...
    'DCR202','DCR203','DCR204','DCR205','DCR206','DCR207','DCR208','DCR209','DCR210','DCR211','DCR212','DCR213'...
    'DCR214','DCR215','DCR216','DCR217','DCR218','DCR219','DCR220','DCR221','DCR222','DCR223','DCR224','DCR225'};
% for i=1:length(names)
%   name = ['DCR' int2str(i)];
%   filename = [CWD name '-conflict.log'];
%   
%   if exist(filename,'file')
%     names{end+1} = name;
%   end
% end

%% Process each subject
dat = [];
for name_i = 1:length(names)
    
    name = names{name_i};
    
    fprintf(1,'Participant: %s  ',name);

    %% load data from log file
    
    filename = [CWD name '-conflict.log'];
    [fileID,errmsg] = fopen(filename,'r');
    if (fileID<0)
        fprintf('\n### Unable to open file: %s  ### %s\n',filename,errmsg);
        continue;
    end
    
    formatSpec = '%*s%*s%*s%s%*s%s%*[^\n\r]';
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '\t', 'ReturnOnError', false);
    fclose(fileID);
    
    % convert text strings to numbers (Nan if not valid numbers)
    data = [];
    data(:,1) = str2double(dataArray{1});
    data(:,2) = str2double(dataArray{2});
    
    %% Split File into Each Block
% Need to split each file into the five experimental blocks
% Each block for each participant should be ordered into when it was
%   presented (1st-5th), and whether it was directional or non-directional
% New blocks in the log file are denoted by code 60

% blocks = ['1st';'2nd';'3rd';'4th';'5th'];
% type = ['DIR';'NON'];
% 
% block_i = 1:length(blocks);
% DIR = ['dirleft';'dirright'];
% NON = ['nondir'];

    block_index_start = [];
    for row_i = 1:size(data,1);
        if data(row_i,1)==60
            fprintf('Start of File Found at row %i.\n',row_i);
            block_index_start = [block_index_start,row_i]; %#ok<AGROW>
        end
    end

    data_s.block1 = data(block_index_start(4)+1:block_index_start(5)-1,:);
    data_s.block2 = data(block_index_start(5)+1:block_index_start(6)-1,:);
    data_s.block3 = data(block_index_start(6)+1:block_index_start(7)-1,:);
    data_s.block4 = data(block_index_start(7)+1:block_index_start(8)-1,:);
    data_s.block5 = data(block_index_start(8)+1:block_index_start(9)-1,:);

%clear data dataArray;


% for valid block = block_i;
%     type = 1:length(cuecond);
%     60 then 1 = NON
%     60 then 2 or 3 = DIR  
% end
    %% Cleanup the input data
    
    field_names_data = fieldnames(data_s);
    
    for block_i = 1:length(fieldnames(data_s))

        valid.(field_names_data{block_i}) = NaN(length(data_s.(field_names_data{block_i})),6);     % Code, Trial Time, Response, Response Time, Accuracy, RTValid

        CODE = 1;      % column(field) INDEX for 'valid' array
        TIME = 2;
        RESP = 3;
        RTIME = 4;
        ACC = 5;
        RTVALID = 6;

% copy recognised events from Data to Valid
        ValidEvents = [cuecode targetcode responsecode];
% Could pull in the blocks splitting here

        for Event = ValidEvents
            ind = (data_s.(field_names_data{block_i})(:,1) == Event);
            valid.(field_names_data{block_i})(ind,[CODE TIME]) = data_s.(field_names_data{block_i})(ind,[1 2]);   % CODE & TIME
        end

        % Delete practice block by finding index of first valid cue code 
        % DO NOT RUN AS WE HAVE REMOVED PRACTICE BLOCKS!
    %     start_ind = 999999;
    %     for code = cuecode
    %         start = find(valid.(field_names_data{block_i})(:,CODE)==code);
    %         start_ind = min([start',start_ind]);
    %     end
    %     valid.(field_names_data{block_i}) = valid.(field_names_data{block_i})(start_ind:length(valid),:);

        % associate Target and Response events
        % attach response code & RT to each target event
        for i = 1:(length(valid.(field_names_data{block_i}))-1)
            if any(valid.(field_names_data{block_i})(i,CODE) == targetcode) && any(valid.(field_names_data{block_i})(i+1,CODE) == responsecode)
                valid.(field_names_data{block_i})(i,RESP) = valid.(field_names_data{block_i})(i+1,CODE);
                valid.(field_names_data{block_i})(i,RTIME) = (valid.(field_names_data{block_i})(i+1,TIME)-valid.(field_names_data{block_i})(i,TIME))/10;   % convert to milliseconds
            end
        end

% eliminate all events except targets

        ind = false(length(valid.(field_names_data{block_i})(:,CODE)),1);
        for i=1:length(targetcode)
            ind = ind | (valid.(field_names_data{block_i})(:,CODE) == targetcode(i));
        end
        valid.(field_names_data{block_i}) = valid.(field_names_data{block_i})(ind,:);

%% make accuracy column
% 11, 21 -> 40
% 12, 32 -> 50 are correct
% 20, 30 -> no response

        for i = 1:length(valid.(field_names_data{block_i}))
            Response = valid.(field_names_data{block_i})(i,RESP);
            Correct = targetcorrect(find(targetcode==valid.(field_names_data{block_i})(i,CODE)));

            if Correct==0
                % NoGo Trials
                valid.(field_names_data{block_i})(i,ACC) = isnan(Response);      
                % NOTE: Accuracy just reflects whether or not a response was
                % made. It ignores whether a response would have been
                % correct on a Go trial.
            else
                % Go Trials
                if isnan(Response)
                    valid.(field_names_data{block_i})(i,ACC) = NaN;
                else 
                    valid.(field_names_data{block_i})(i,ACC) = (Response==Correct);  
                end
            end
        end

% Mark trials with response time that is too fast or too slow.
% NOTE: Use a different RT criteria based on correct responses 
% for each target code where a response is expected

        valid.(field_names_data{block_i})(:,RTVALID) = true;      % default value for NoGo trials and Trials where no response was made

        toofast = 150;
        fprintf(1,'Valid RT Range=%.1f to ( ',toofast);

        for code=targetcode
    % get correct RTs for this target code
            RT = valid.(field_names_data{block_i})( find( (valid.(field_names_data{block_i})(:,CODE) == code) & valid.(field_names_data{block_i})(:,ACC)==1 & ~isnan(valid.(field_names_data{block_i})(:,RTIME)) ) ,RTIME );

            if ~isempty(RT)
                % cutoff = mean + 3 stadard deviations
                tooslow = (nanmean(RT)+3*(nanstd(RT)));
                fprintf(1,'%.1f ',tooslow);

                % apply cutoff to ALL responses (both correct & error)
                valid.(field_names_data{block_i})( (valid.(field_names_data{block_i})(:,CODE) == code) & valid.(field_names_data{block_i})(:,RTIME)<toofast , RTVALID) = false;
                valid.(field_names_data{block_i})( (valid.(field_names_data{block_i})(:,CODE) == code) & valid.(field_names_data{block_i})(:,RTIME)>tooslow , RTVALID) = false;
            end
        end
        fprintf(1,')\n');


%% Compute Mean RT and Accuracy for each condition and in each

% Note re Accuracy:
% For Go trials, irrespective of whether RT was valid
%   ACC = 1   Correct Response
%   ACC = 0   Error Response
%   ACC = NaN No Response
% For NoGo TRials, No RT Valid checks are performed & Actual Response
% code is ignored:
%   ACC = 1   StopSuccess
%   ACC = 0   StopFailure

        for i = 1:length(targetcode)
            % For this condition, get RT and Acc for each trial 
            ind = find(valid.(field_names_data{block_i})(:,CODE)==targetcode(i));
            RT = valid.(field_names_data{block_i})(ind,RTIME);
            Acc = valid.(field_names_data{block_i})(ind,ACC);
            RTValid = valid.(field_names_data{block_i})(ind,RTVALID);

            % Compute Accuracy
            Ntrials(i)  = length(Acc);
            Ncorrect(i) = length(find(Acc==1 & RTValid));      % Correct Response and Valid RT
            Nerror(i)   = length(find(Acc==0 & RTValid));      % Error Response and Valid RT
            Ninvalid(i) = length(find(isnan(Acc) | ~RTValid)); % Either No Response OR Invalid RT

            avAcc(i) = Ncorrect(i)/Ntrials(i) * 100;

            % Compute RT (Correct)
            avRT(i) = mean(RT(Acc==1 & RTValid));

            % Compute RT (Error)
            % avRTerror(i) = mean(RT(Acc==0 & RTValid));
        end
        
        dat(name_i).(field_names_data{block_i}).Name = name; %#ok<SAGROW>
        dat(name_i).(field_names_data{block_i}).Acc = avAcc; %#ok<SAGROW>
        dat(name_i).(field_names_data{block_i}).RT = avRT;   %#ok<SAGROW>
        dat(name_i).(field_names_data{block_i}).Ntrials = Ntrials;   %#ok<SAGROW>
        dat(name_i).(field_names_data{block_i}).Ncorrect = Ncorrect; %#ok<SAGROW>
        dat(name_i).(field_names_data{block_i}).Nerror = Nerror;     %#ok<SAGROW>
        dat(name_i).(field_names_data{block_i}).Ninvalid = Ninvalid; %#ok<SAGROW>
    end
    
    %% Store results from this individual * and for each block
    

    
end
%end%name_i loop

%% save the data
savename = [CWD '\SPLIT_LOG\' 'CGNG_BlockedData.txt'];

fid = fopen(savename, 'w');

% Header
    fprintf(fid, 'Subject');
    for i=1:length(targetcond)
      fprintf(fid, '\t%s_Ntrials', targetcond{i});
      fprintf(fid, '\t%s_Ncorrect', targetcond{i});
      fprintf(fid, '\t%s_NError', targetcond{i});
      fprintf(fid, '\t%s_Ninvalid', targetcond{i});
      fprintf(fid, '\t%s_ACC', targetcond{i});
      fprintf(fid, '\t%s_RT', targetcond{i});
    end
    fprintf(fid, '\r\n');

% Subject data
for i=1:length(names)
    for block_i=1:length(fieldnames(data_s))
        fprintf(fid, '%s', names{i});
        for j=1:length(targetcond)        
            fprintf(fid, '\t%d', dat(i).(field_names_data{block_i}).Ntrials(j));
            fprintf(fid, '\t%d', dat(i).(field_names_data{block_i}).Ncorrect(j));
            fprintf(fid, '\t%d', dat(i).(field_names_data{block_i}).Nerror(j));
            fprintf(fid, '\t%d', dat(i).(field_names_data{block_i}).Ninvalid(j));
            fprintf(fid, '\t%.1f', dat(i).(field_names_data{block_i}).Acc(j));
            fprintf(fid, '\t%.0f', dat(i).(field_names_data{block_i}).RT(j));
        end
        fprintf(fid, '\r\n');
    end
    fprintf(fid, '\r\n');
end

fclose(fid);

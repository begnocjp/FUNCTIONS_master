% Extraction of RT Data from Presentation Log file
% Written by Alexander Conley, 25/06/14
% Touched by Ross Fulham, 30/06/2014

% Codes used
% 60 = Start of block, end of experiment
% Responses: 40 = Left Response; 50 = Right Response
% Cues: 1 = Non-Directional; 2 =  Directional Left;
%    3 = Directional Right
% Targets: 11 = Non-Directional Left; 12 = Non-Directional Right;
% 21 = Directional Left; 32 = Directional Right;
% Nogo Targets: 20 = Directional Left; 30 = Directional Right

clear all

CWD = ('G:\Cued_Go-Nogo2013\');

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

%% Create list of all subject names
% set names = {'DCR102' 'DCR103' 'DCR104'};

names = {'DCR128','DCR129','DCR130','DCR131','DCR132','DCR133'};
for i=1:length(names)
  name = ['DCR' int2str(i)];
  filename = [CWD name '-conflict.log'];
  
  if exist(filename,'file')
    names{end+1} = name;
  end
end

%% Process each subject

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
       
    %% Cleanup the input data
    
    valid = NaN(length(data),6);     % Code, Trial Time, Response, Response Time, Accuracy, RTValid
    
    CODE = 1;      % column(field) INDEX for 'valid' array
    TIME = 2;
    RESP = 3;
    RTIME = 4;
    ACC = 5;
    RTVALID = 6;
    
    % copy recognised events from Data to Valid
    ValidEvents = [cuecode targetcode responsecode];
    
    for Event = ValidEvents
        ind = (data(:,1) == Event);
        valid(ind,[CODE TIME]) = data(ind,[1 2]);   % CODE & TIME
    end
    
    % Delete practice block by finding index of first valid cue code
    start_ind = 999999;
    for code = cuecode
        start = find(valid(:,CODE)==code);
        start_ind = min([start',start_ind]);
    end
    valid = valid(start_ind:length(valid),:);
    
    % associate Target and Response events
    % attach response code & RT to each target event
    for i = 1:(length(valid)-1)
        if any(valid(i,CODE) == targetcode) && any(valid(i+1,CODE) == responsecode)
            valid(i,RESP) = valid(i+1,CODE);
            valid(i,RTIME) = (valid(i+1,TIME)-valid(i,TIME))/10;   % convert to milliseconds
        end
    end
      
    % eliminate all events except targets
    
    ind = false(length(valid(:,CODE)),1);
    for i=1:length(targetcode)
        ind = ind | (valid(:,CODE) == targetcode(i));
    end
    valid = valid(ind,:);
    
    %% make accuracy column
    % 11, 21 -> 40
    % 12, 32 -> 50 are correct
    % 20, 30 -> no response

    for i = 1:length(valid)
        Response = valid(i,RESP);
        Correct = targetcorrect(find(targetcode==valid(i,CODE)));
        
        if Correct==0
            % NoGo Trials
            valid(i,ACC) = isnan(Response);      
            % NOTE: Accuracy just reflects whether or not a response was
            % made. It ignores whether a response would have been
            % correct on a Go trial.
        else
            % Go Trials
            if isnan(Response)
                valid(i,ACC) = NaN;
            else 
                valid(i,ACC) = (Response==Correct);  
            end
        end
    end
    
    % Mark trials with response time that is too fast or too slow.
    % NOTE: Use a different RT criteria based on correct responses 
    % for each target code where a response is expected
    
    valid(:,RTVALID) = true;      % default value for NoGo trials and Trials where no response was made
    
    toofast = 150;
    fprintf(1,'Valid RT Range=%.1f to ( ',toofast);
    
    for code=targetcode
        % get correct RTs for this target code
        RT = valid( find( (valid(:,CODE) == code) & valid(:,ACC)==1 & ~isnan(valid(:,RTIME)) ) ,RTIME );
        
        if ~isempty(RT)
            % cutoff = mean + 3 stadard deviations
            tooslow = (nanmean(RT)+3*(nanstd(RT)));
            fprintf(1,'%.1f ',tooslow);
    
            % apply cutoff to ALL responses (both correct & error)
            valid( (valid(:,CODE) == code) & valid(:,RTIME)<toofast , RTVALID) = false;
            valid( (valid(:,CODE) == code) & valid(:,RTIME)>tooslow , RTVALID) = false;
        end
    end
    fprintf(1,')\n');
    
    %% Compute Mean RT and Accuracy for each condition
    
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
        ind = find(valid(:,CODE)==targetcode(i));
        RT = valid(ind,RTIME);
        Acc = valid(ind,ACC);
        RTValid = valid(ind,RTVALID);

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
    
    %% Store results from this individual
    
    dat(name_i).Name = name;
    dat(name_i).Acc = avAcc;
    dat(name_i).RT = avRT;
    dat(name_i).Ntrials = Ntrials;
    dat(name_i).Ncorrect = Ncorrect;
    dat(name_i).Nerror = Nerror;
    dat(name_i).Ninvalid = Ninvalid;
    
    
end%name_i loop

%% save the data
savename = [CWD,'CuedGoNoGoData.txt'];

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
    fprintf(fid, '%s', dat(i).Name);
    for j=1:length(targetcond)        
        fprintf(fid, '\t%d', dat(i).Ntrials(j));
        fprintf(fid, '\t%d', dat(i).Ncorrect(j));
        fprintf(fid, '\t%d', dat(i).Nerror(j));
        fprintf(fid, '\t%d', dat(i).Ninvalid(j));
        fprintf(fid, '\t%.1f', dat(i).Acc(j));
        fprintf(fid, '\t%.0f', dat(i).RT(j));
    end
    fprintf(fid, '\r\n');
end

fclose(fid);

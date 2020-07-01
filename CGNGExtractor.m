% Extraction of RT Data from Presentation Log file
% Written by Alexander Conley, 25/06/14

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
cuecode = 1:3;
targetcond = {'nondirleft'; 'nondirright'; 'leftnogo'; 'leftgo'; 'rightnogo'; 'rightgo'};
targetcode = [11 12 20 21 30 32];
response = {'lefthand';'righthand'};
responsecode = [40 50];
header = {'Subject','nondirleft','nondirright','leftnogo','leftgo','rightnogo','rightgo'};

names = {'DCR102'};
%% load in log file
for name_i = 1:length(names)
    fprintf('%s\t%s\n','Working on participant:',names{name_i});
    %% Initialize variables.
    filename = [CWD names{name_i} '-conflict.log'];
    delimiter = '\t';
    formatSpec = '%*s%*s%*s%s%*s%s%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
    fclose(fileID);
    %% Convert the contents of columns containing numeric strings to numbers.
    % Replace non-numeric strings with NaN.
    raw = [dataArray{:,1:end-1}];
    numericData = NaN(size(dataArray{1},1),size(dataArray,2));
    for col=[1,2]
        % Converts strings in the input cell array to numbers. Replaced non-numeric
        % strings with NaN.
        rawData = dataArray{col};
        for row=1:size(rawData, 1);
            % Create a regular expression to detect and remove non-numeric prefixes and
            % suffixes.
            regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
            try
                result = regexp(rawData{row}, regexstr, 'names');
                numbers = result.numbers;
                
                % Detected commas in non-thousand locations.
                invalidThousandsSeparator = false;
                if any(numbers==',');
                    thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                    if isempty(regexp(thousandsRegExp, ',', 'once'));
                        numbers = NaN;
                        invalidThousandsSeparator = true;
                    end
                end
                % Convert numeric strings to numbers.
                if ~invalidThousandsSeparator;
                    numbers = textscan(strrep(numbers, ',', ''), '%f');
                    numericData(row, col) = numbers{1};
                    raw{row, col} = numbers{1};
                end
            catch me
            end
        end
    end
    %% Replace non-numeric cells with NaN
    R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
    raw(R) = {NaN}; % Replace non-numeric cells
    %% Create output variable
    data = cell2mat(raw);%%change
    %% Clear temporary variables
    clearvars filename delimiter formatSpec fileID dataArray ans raw numericData col rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
    %% sort trials by codes
    valid = zeros(length(data),3);
    %search for cue codes
    for cue_i = 1:length(cuecode)
        ind = data == cuecode(cue_i);
        valid(ind,1) = data(ind);
        valid(ind,2) = data(ind,2);
    end
    clear ind
    %ignore practice block by finding index of first valid cue code
    for cue_i = 1:length(cuecode)
        start = find(valid==cuecode(cue_i));
        start_ind(cue_i) = min(start);
    end
    start_ind = min(start_ind);
    clear start
    %search for target codes
    for target_i = 1:length(targetcode)
        ind = data == targetcode(target_i);
        valid(ind,1) = data(ind);
        valid(ind,2) = data(ind,2);
    end
    clear ind
    %search for response codes
    for response_i = 1:length(responsecode)
        ind = data == responsecode(response_i);
        valid(ind,1) = data(ind);
        valid(ind,2) = data(ind,2);
    end
    %cut out practice trials
    valid = valid(start_ind:length(valid),:);
    clear start_ind
    %make RTs
    for valid_i = 1:length(valid)
        for response_i = 1:length(responsecode)
            if valid(valid_i,1) == responsecode(response_i)%find responses
                valid(valid_i,3) = ((valid(valid_i,2)-valid((valid_i-1),2))/10);
            end
        end
    end
    %get rid of too fast and too slow trials
    %first turn zeros into NaNs
    ind = valid(:,3)==0;
    valid(ind,3) = NaN;
    toofast = 200;
    tooslow = (nanmean(valid(:,3))+3*(nanstd(valid(:,3))));
    indfast = valid(:,3)>toofast;
    indslow = valid(:,3)<tooslow;
    ind = [indfast, indslow];
    for valid_i = 1:length(valid)
        if ind(valid_i,1) ~= 1 && ind(valid_i,2) ~= 1;
            valid(valid_i,3) = NaN;
        end
    end
    clear ind
    %make accuracy column
    % 11, 21 -> 40 12, 32 -> 50 are correct
    ind(:,1) = mod(valid(:,1),2);
    ind(:,2) = valid(:,1)==40;
    ind(:,3) = valid(:,1)==50;
    for valid_i = 1:length(valid)
        if ind(valid_i,2) == 1 && ind((valid_i-1),1) == 1;
            %found 11 or 21 followed by 40
            valid(valid_i,4) = 1;
        elseif ind(valid_i,3) == 1 && ind((valid_i-1),1) == 0;
            valid(valid_i,4) = 1;
        else
            valid(valid_i,4) = 0;
        end
    end
    ind = isnan(valid(:,3));
    valid(ind,4) = NaN;
    %move data into format for people not machines
    dat{name_i,1} = names{name_i};
    for condition_i = 1:length(targetcode)
        ind = find(valid(:,1)==targetcode(condition_i));
        ind = ind+1;
        avrt = mean(valid(ind,3));
        dat{name_i,condition_i} = avrt;
        ind_acc = find(valid(ind,4))~=1;
        dat{name_i,(condition_i+length(targetcode))} = ((length(find(ind_acc)))/length(ind)*100);
        clear ind avrt ind_acc
    end
end%name_i loop
dat = cell2mat(dat);%TO DO add subject list and header
savename = [CWD,'CuedGoNoGoData.txt'];
save(savename,'dat','-ascii','-tabs');
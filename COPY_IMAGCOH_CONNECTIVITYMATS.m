%% Make Directory Structure:
% -- IMAGCOH_OUTPUT:
%    -- PARTICIPANT:
%        -- CONDITION1:
%        -- CONDITION2:
%        -- CONDITION3:
%        -- CONDITION4:


names = { 'DCR102' 'DCR104' 'DCR106' 'DCR107' 'DCR108' 'DCR109' 'DCR110' 'DCR111' ... 
    'DCR112' 'DCR113' 'DCR114' 'DCR115' 'DCR117' 'DCR118' 'DCR119' 'DCR120' 'DCR121' ...
    'DCR122' 'DCR123' 'DCR124' 'DCR125' 'DCR202' 'DCR204' 'DCR206' 'DCR207' ... 
    'DCR208' 'DCR209' 'DCR210' 'DCR211' 'DCR212' 'DCR213' 'DCR214' 'DCR215' 'DCR217' ... 
    'DCR218' 'DCR219' 'DCR220' 'DCR221' 'DCR222' 'DCR223' 'DCR224' 'DCR225' 'S1' 'S1B' ... 
    'S4' 'S4B' 'S5' 'S5B' 'S6' 'S6B' 'S7' 'S7B' 'S8' 'S8B' 'S10' 'S10B' 'S11' 'S11B' 'S12' 'S12B'  ...
    'S14' 'S14B' 'S15' 'S15B' 'S16' 'S16B' 'S17' 'S17B' 'S18' 'S18B' 'S20' 'S20B' 'S21' 'S21B' ...
    'S22' 'S22B' 'S23' 'S23B' 'S24' 'S24B' 'S25' 'S25B' 'S26' 'S26B' 'S27' 'S27B' 'S28' 'S28B' 'S29' 'S29B' ...
    'S30' 'S30B' 'S31' 'S31B' 'S34' 'S34B' 'S36' 'S36B' 'S37' 'S37B' 'S38' 'S38B' ...
    'S39' 'S39B' 'S40' 'S40B'};
cond  = {'dirleft' 'dirright' 'nondirleft' 'nondirright'};

% Make Top Level Directory:
CWD = 'F:\fieldtrip\';
IMAG_DIR = 'IMAGCOH_OUTPUT\';
mkdir([CWD,IMAG_DIR]);

for name_i = 1:length(names)
    mkdir([CWD,IMAG_DIR,names{name_i}]);
    for cond_i = 1:length(cond)
        mkdir([CWD,IMAG_DIR,names{name_i},'\',cond{cond_i}]);
    end
end

%% COPY:
START_T = 0;
END_T = 400;
FROMDIR = 'F:\fieldtrip\';
for name_i = 1:length(names)
    for cond_i = 1:length(cond)
        for starttime = START_T:100:END_T;
            endtime = starttime + 200;
            tofilename = strcat(CWD,IMAG_DIR,names{1,name_i},'\',cond{1,cond_i},'\',cond{1,cond_i},num2str(starttime),'to',num2str(endtime),'_CONECTIVITY_IMAG.mat');
            fromfilename = strcat(FROMDIR,IMAG_DIR,names{1,name_i},'\',cond{1,cond_i},'\',cond{1,cond_i},num2str(starttime),'to',num2str(endtime),'_CONECTIVITY_IMAG.mat');
            copyfile(fromfilename,tofilename);
            fprintf('%s \n ',tofilename);
        end
    end
end

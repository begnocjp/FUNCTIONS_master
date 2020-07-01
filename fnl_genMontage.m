function [M] = fnl_genMontage(CWD,PREPROC_OUTPUT,names,name_i)

E = textscan([CWD,'fnl_BioSemi72.loc'],'%s'); % textread for earlier versions

lab     = cell(72,1);
theta   = zeros(72,1);
phi     = zeros(72,1);


for i = 1:length(E)
    index = mod(i,4);
    %fprintf('Mod Val: %i\n',index);
    j = floor(i/4)+1;
    switch index
        case 0 %Channel Name
            %fprintf('Found Name\n');
            lab{j-1,1} = E{i,1};
        case 1 %channel Number
            %lab{index,1} = E{i,1};
        case 2 %theta
            theta(j,1) = str2num(E{i,1});
        case 3 %phi
            phi(j,1) = str2num(E{i,1});
    end
end

M = struct('lab',{lab},'theta',theta,'phi',phi);



load([CWD,PREPROC_OUTPUT,names{name_i},'_badchannellist']);

%search for bad channels in montage
lab = cell((length(M.lab)-8)-length(badchann),1);
theta = zeros((length(M.lab)-8)-length(badchann),1);
phi = zeros((length(M.lab)-8)-length(badchann),1);
M_2 = struct('lab',{lab},'theta',theta,'phi',phi);
count = 1;
mon_i = 1;
found = 0;
while mon_i <= (length(M.lab)-8)
    %fprintf('%i, %i: Comparing %s with %s \n',mon_i,mon_bad, M.lab{mon_i,1}, badchann{1,mon_bad});
    for mon_bad = 1:length(badchann)
        if strcmpi(M.lab{mon_i,1},badchann{1,mon_bad})
            found = 1;
            %mon_i = 1;
            break;
        end
    end
    if found == 0
        M_2.lab(count,1)   = M.lab(mon_i,1);
        M_2.theta(count,1) = M.theta(mon_i,1);
        M_2.phi(count,1)   = M.phi(mon_i,1);
        count = count+1;
    end
    mon_i = mon_i+1;
end %mon_i loop
M = M_2;

end

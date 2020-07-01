function [ACTIVE_DATA,SHAM_DATA] = assignActiveSham(name_i,cond_i,time_i,ALLDATA,ACTIVE_DATA,SHAM_DATA,isActive,isSham)
actind = find(isActive);
if actind ~= 0;
    switch cond_i
        case 1
            ACTIVE_DATA.conditions.dirleft.delta(actind,time_i,:,:) = ALLDATA.conditions.dirleft.delta(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.dirleft.loweralpha(actind,time_i,:,:) = ALLDATA.conditions.dirleft.loweralpha(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.dirleft.theta(actind,time_i,:,:) = ALLDATA.conditions.dirleft.theta(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.dirleft.upperalpha(actind,time_i,:,:) = ALLDATA.conditions.dirleft.upperalpha(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.dirleft.beta(actind,time_i,:,:) = ALLDATA.conditions.dirleft.beta(name_i,time_i,:,:);
        case 2
            ACTIVE_DATA.conditions.dirright.delta(actind,time_i,:,:) = ALLDATA.conditions.dirright.delta(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.dirright.loweralpha(actind,time_i,:,:) = ALLDATA.conditions.dirright.loweralpha(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.dirright.theta(actind,time_i,:,:) = ALLDATA.conditions.dirright.theta(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.dirright.upperalpha(actind,time_i,:,:) = ALLDATA.conditions.dirright.upperalpha(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.dirright.beta(actind,time_i,:,:) = ALLDATA.conditions.dirright.beta(name_i,time_i,:,:);
        case 3
            
            ACTIVE_DATA.conditions.nondirleft.delta(actind,time_i,:,:) = ALLDATA.conditions.nondirleft.delta(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.nondirleft.loweralpha(actind,time_i,:,:) = ALLDATA.conditions.nondirleft.loweralpha(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.nondirleft.theta(actind,time_i,:,:) = ALLDATA.conditions.nondirleft.theta(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.nondirleft.upperalpha(actind,time_i,:,:) = ALLDATA.conditions.nondirleft.upperalpha(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.nondirleft.beta(actind,time_i,:,:) = ALLDATA.conditions.nondirleft.beta(name_i,time_i,:,:);
        case 4
            ACTIVE_DATA.conditions.nondirright.delta(actind,time_i,:,:) = ALLDATA.conditions.nondirright.delta(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.nondirright.loweralpha(actind,time_i,:,:) = ALLDATA.conditions.nondirright.loweralpha(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.nondirright.theta(actind,time_i,:,:) = ALLDATA.conditions.nondirright.theta(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.nondirright.upperalpha(actind,time_i,:,:) = ALLDATA.conditions.nondirright.upperalpha(name_i,time_i,:,:);
            ACTIVE_DATA.conditions.nondirright.beta(actind,time_i,:,:) = ALLDATA.conditions.nondirright.beta(name_i,time_i,:,:);
    end
end
shaind = find(isSham);
if shaind ~= 0
    switch cond_i
        case 1
            SHAM_DATA.conditions.dirleft.delta(shaind,time_i,:,:) = ALLDATA.conditions.dirleft.delta(name_i,time_i,:,:);
            SHAM_DATA.conditions.dirleft.loweralpha(shaind,time_i,:,:) = ALLDATA.conditions.dirleft.loweralpha(name_i,time_i,:,:);
            SHAM_DATA.conditions.dirleft.theta(shaind,time_i,:,:) = ALLDATA.conditions.dirleft.theta(name_i,time_i,:,:);
            SHAM_DATA.conditions.dirleft.upperalpha(shaind,time_i,:,:) = ALLDATA.conditions.dirleft.upperalpha(name_i,time_i,:,:);
            SHAM_DATA.conditions.dirleft.beta(shaind,time_i,:,:) = ALLDATA.conditions.dirleft.beta(name_i,time_i,:,:);
        case 2
            SHAM_DATA.conditions.dirright.delta(shaind,time_i,:,:) = ALLDATA.conditions.dirright.delta(name_i,time_i,:,:);
            SHAM_DATA.conditions.dirright.loweralpha(shaind,time_i,:,:) = ALLDATA.conditions.dirright.loweralpha(name_i,time_i,:,:);
            SHAM_DATA.conditions.dirright.theta(shaind,time_i,:,:) = ALLDATA.conditions.dirright.theta(name_i,time_i,:,:);
            SHAM_DATA.conditions.dirright.upperalpha(shaind,time_i,:,:) = ALLDATA.conditions.dirright.upperalpha(name_i,time_i,:,:);
            SHAM_DATA.conditions.dirright.beta(shaind,time_i,:,:) = ALLDATA.conditions.dirright.beta(name_i,time_i,:,:);
        case 3
            
            SHAM_DATA.conditions.nondirleft.delta(shaind,time_i,:,:) = ALLDATA.conditions.nondirleft.delta(name_i,time_i,:,:);
            SHAM_DATA.conditions.nondirleft.loweralpha(shaind,time_i,:,:) = ALLDATA.conditions.nondirleft.loweralpha(name_i,time_i,:,:);
            SHAM_DATA.conditions.nondirleft.theta(shaind,time_i,:,:) = ALLDATA.conditions.nondirleft.theta(name_i,time_i,:,:);
            SHAM_DATA.conditions.nondirleft.upperalpha(shaind,time_i,:,:) = ALLDATA.conditions.nondirleft.upperalpha(name_i,time_i,:,:);
            SHAM_DATA.conditions.nondirleft.beta(shaind,time_i,:,:) = ALLDATA.conditions.nondirleft.beta(name_i,time_i,:,:);
        case 4
            SHAM_DATA.conditions.nondirright.delta(shaind,time_i,:,:) = ALLDATA.conditions.nondirright.delta(name_i,time_i,:,:);
            SHAM_DATA.conditions.nondirright.loweralpha(shaind,time_i,:,:) = ALLDATA.conditions.nondirright.loweralpha(name_i,time_i,:,:);
            SHAM_DATA.conditions.nondirright.theta(shaind,time_i,:,:) = ALLDATA.conditions.nondirright.theta(name_i,time_i,:,:);
            SHAM_DATA.conditions.nondirright.upperalpha(shaind,time_i,:,:) = ALLDATA.conditions.nondirright.upperalpha(name_i,time_i,:,:);
            SHAM_DATA.conditions.nondirright.beta(shaind,time_i,:,:) = ALLDATA.conditions.nondirright.beta(name_i,time_i,:,:);
    end
end
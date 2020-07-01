function [DIFFDATA] = diffConnMats(ACTIVE_DATA,SHAM_DATA,cond_i,name_i,time_i,DIFFDATA)

switch cond_i
    case 1
        for row = 1:size(ACTIVE_DATA.conditions.dirleft.delta,3)
            for col = 1:size(ACTIVE_DATA.conditions.dirleft.delta,4)
                DIFFDATA.conditions.dirleft.delta(name_i,time_i,row,col)      = ACTIVE_DATA.conditions.dirleft.delta(name_i,time_i,row,col)- SHAM_DATA.conditions.dirleft.delta(name_i,time_i,row,col);
                DIFFDATA.conditions.dirleft.theta(name_i,time_i,row,col)      = ACTIVE_DATA.conditions.dirleft.theta(name_i,time_i,row,col)- SHAM_DATA.conditions.dirleft.theta(name_i,time_i,row,col);
                DIFFDATA.conditions.dirleft.loweralpha(name_i,time_i,row,col) = ACTIVE_DATA.conditions.dirleft.loweralpha(name_i,time_i,row,col)- SHAM_DATA.conditions.dirleft.loweralpha(name_i,time_i,row,col);
                DIFFDATA.conditions.dirleft.upperalpha(name_i,time_i,row,col) = ACTIVE_DATA.conditions.dirleft.upperalpha(name_i,time_i,row,col)- SHAM_DATA.conditions.dirleft.upperalpha(name_i,time_i,row,col);
                DIFFDATA.conditions.dirleft.beta(name_i,time_i,row,col)       = ACTIVE_DATA.conditions.dirleft.beta(name_i,time_i,row,col)- SHAM_DATA.conditions.dirleft.beta(name_i,time_i,row,col);
            end
        end
    case 2
        for row = 1:size(ACTIVE_DATA.conditions.dirright.delta,3)
            for col = 1:size(ACTIVE_DATA.conditions.dirright.delta,4)
                DIFFDATA.conditions.dirright.delta(name_i,time_i,row,col)      = ACTIVE_DATA.conditions.dirright.delta(name_i,time_i,row,col)- SHAM_DATA.conditions.dirright.delta(name_i,time_i,row,col);
                DIFFDATA.conditions.dirright.theta(name_i,time_i,row,col)      = ACTIVE_DATA.conditions.dirright.theta(name_i,time_i,row,col)- SHAM_DATA.conditions.dirright.theta(name_i,time_i,row,col);
                DIFFDATA.conditions.dirright.loweralpha(name_i,time_i,row,col) = ACTIVE_DATA.conditions.dirright.loweralpha(name_i,time_i,row,col)- SHAM_DATA.conditions.dirright.loweralpha(name_i,time_i,row,col);
                DIFFDATA.conditions.dirright.upperalpha(name_i,time_i,row,col) = ACTIVE_DATA.conditions.dirright.upperalpha(name_i,time_i,row,col)- SHAM_DATA.conditions.dirright.upperalpha(name_i,time_i,row,col);
                DIFFDATA.conditions.dirright.beta(name_i,time_i,row,col)       = ACTIVE_DATA.conditions.dirright.beta(name_i,time_i,row,col)- SHAM_DATA.conditions.dirright.beta(name_i,time_i,row,col);
            end
        end
    case 3
        for row = 1:size(ACTIVE_DATA.conditions.nondirleft.delta,3)
            for col = 1:size(ACTIVE_DATA.conditions.nondirleft.delta,4)
                DIFFDATA.conditions.nondirleft.delta(name_i,time_i,row,col)      = ACTIVE_DATA.conditions.nondirleft.delta(name_i,time_i,row,col)- SHAM_DATA.conditions.nondirleft.delta(name_i,time_i,row,col);
                DIFFDATA.conditions.nondirleft.theta(name_i,time_i,row,col)      = ACTIVE_DATA.conditions.nondirleft.theta(name_i,time_i,row,col)- SHAM_DATA.conditions.nondirleft.theta(name_i,time_i,row,col);
                DIFFDATA.conditions.nondirleft.loweralpha(name_i,time_i,row,col) = ACTIVE_DATA.conditions.nondirleft.loweralpha(name_i,time_i,row,col)- SHAM_DATA.conditions.nondirleft.loweralpha(name_i,time_i,row,col);
                DIFFDATA.conditions.nondirleft.upperalpha(name_i,time_i,row,col) = ACTIVE_DATA.conditions.nondirleft.upperalpha(name_i,time_i,row,col)- SHAM_DATA.conditions.nondirleft.upperalpha(name_i,time_i,row,col);
                DIFFDATA.conditions.nondirleft.beta(name_i,time_i,row,col)       = ACTIVE_DATA.conditions.nondirleft.beta(name_i,time_i,row,col)- SHAM_DATA.conditions.nondirleft.beta(name_i,time_i,row,col);
            end
        end
    case 4
        for row = 1:size(ACTIVE_DATA.conditions.nondirright.delta,3)
            for col = 1:size(ACTIVE_DATA.conditions.nondirright.delta,4)
                DIFFDATA.conditions.nondirright.delta(name_i,time_i,row,col)      = ACTIVE_DATA.conditions.nondirright.delta(name_i,time_i,row,col)- SHAM_DATA.conditions.nondirright.delta(name_i,time_i,row,col);
                DIFFDATA.conditions.nondirright.theta(name_i,time_i,row,col)      = ACTIVE_DATA.conditions.nondirright.theta(name_i,time_i,row,col)- SHAM_DATA.conditions.nondirright.theta(name_i,time_i,row,col);
                DIFFDATA.conditions.nondirright.loweralpha(name_i,time_i,row,col) = ACTIVE_DATA.conditions.nondirright.loweralpha(name_i,time_i,row,col)- SHAM_DATA.conditions.nondirright.loweralpha(name_i,time_i,row,col);
                DIFFDATA.conditions.nondirright.upperalpha(name_i,time_i,row,col) = ACTIVE_DATA.conditions.nondirright.upperalpha(name_i,time_i,row,col)- SHAM_DATA.conditions.nondirright.upperalpha(name_i,time_i,row,col);
                DIFFDATA.conditions.nondirright.beta(name_i,time_i,row,col)       = ACTIVE_DATA.conditions.nondirright.beta(name_i,time_i,row,col)- SHAM_DATA.conditions.nondirright.beta(name_i,time_i,row,col);
            end
        end        
end
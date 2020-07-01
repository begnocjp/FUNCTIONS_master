function [ACTIVE_AVCUEDATA,SHAM_AVCUEDATA] = averageCueConnMats(ACTIVE_DATA,SHAM_DATA,cond_i,time_i,name_i,ACTIVE_AVCUEDATA,SHAM_AVCUEDATA)
switch cond_i
    case 1
        for row = 1:size(ACTIVE_DATA.conditions.dir.delta,3)
            for col = 1:size(ACTIVE_DATA.conditions.dir.delta,4)
                ACTIVE_AVCUEDATA.conditions.dir.delta(time_i,row,col)      = mean([ACTIVE_DATA.conditions.dirleft.delta(name_i,time_i,row,col),ACTIVE_DATA.conditions.dirright.delta(name_i,time_i,row,col)]);
                ACTIVE_AVCUEDATA.conditions.dir.theta(time_i,row,col)      = mean([ACTIVE_DATA.conditions.dirleft.theta(name_i,time_i,row,col),ACTIVE_DATA.conditions.dirright.theta(name_i,time_i,row,col)]);
                ACTIVE_AVCUEDATA.conditions.dir.loweralpha(time_i,row,col) = mean([ACTIVE_DATA.conditions.dirleft.loweralpha(name_i,time_i,row,col),ACTIVE_DATA.conditions.dirright.loweralpha(name_i,time_i,row,col)]);
                ACTIVE_AVCUEDATA.conditions.dir.upperalpha(time_i,row,col) = mean([ACTIVE_DATA.conditions.dirleft.upperalpha(name_i,time_i,row,col),ACTIVE_DATA.conditions.dirright.upperalpha(name_i,time_i,row,col)]);
                ACTIVE_AVCUEDATA.conditions.dir.beta(time_i,row,col)       = mean([ACTIVE_DATA.conditions.dirleft.beta(name_i,time_i,row,col),ACTIVE_DATA.conditions.dirright.beta(name_i,time_i,row,col)]);
                SHAM_AVCUEDATA.conditions.dir.delta(time_i,row,col)      = mean([SHAM_DATA.conditions.dirleft.delta(name_i,time_i,row,col),SHAM_DATA.conditions.dirright.delta(name_i,time_i,row,col)]);
                SHAM_AVCUEDATA.conditions.dir.theta(time_i,row,col)      = mean([SHAM_DATA.conditions.dirleft.theta(name_i,time_i,row,col),SHAM_DATA.conditions.dirright.theta(name_i,time_i,row,col)]);
                SHAM_AVCUEDATA.conditions.dir.loweralpha(time_i,row,col) = mean([SHAM_DATA.conditions.dirleft.loweralpha(name_i,time_i,row,col),SHAM_DATA.conditions.dirright.loweralpha(name_i,time_i,row,col)]);
                SHAM_AVCUEDATA.conditions.dir.upperalpha(time_i,row,col) = mean([SHAM_DATA.conditions.dirleft.upperalpha(name_i,time_i,row,col),SHAM_DATA.conditions.dirright.upperalpha(name_i,time_i,row,col)]);
                SHAM_AVCUEDATA.conditions.dir.beta(time_i,row,col)       = mean([SHAM_DATA.conditions.dirleft.beta(name_i,time_i,row,col),SHAM_DATA.conditions.dirright.beta(name_i,time_i,row,col)]);
            end
        end
    case 2
        for row = 1:size(ACTIVE_DATA.conditions.nondir.delta,3)
            for col = 1:size(ACTIVE_DATA.conditions.nondir.delta,4)
                ACTIVE_AVCUEDATA.conditions.nondir.delta(time_i,row,col)      = mean([ACTIVE_DATA.conditions.nondirleft.delta(name_i,time_i,row,col),ACTIVE_DATA.conditions.nondirright.delta(name_i,time_i,row,col)]);
                ACTIVE_AVCUEDATA.conditions.nondir.theta(time_i,row,col)      = mean([ACTIVE_DATA.conditions.nondirleft.theta(name_i,time_i,row,col),ACTIVE_DATA.conditions.nondirright.theta(name_i,time_i,row,col)]);
                ACTIVE_AVCUEDATA.conditions.nondir.loweralpha(time_i,row,col) = mean([ACTIVE_DATA.conditions.nondirleft.loweralpha(name_i,time_i,row,col),ACTIVE_DATA.conditions.nondirright.loweralpha(name_i,time_i,row,col)]);
                ACTIVE_AVCUEDATA.conditions.nondir.upperalpha(time_i,row,col) = mean([ACTIVE_DATA.conditions.nondirleft.upperalpha(name_i,time_i,row,col),ACTIVE_DATA.conditions.nondirright.upperalpha(name_i,time_i,row,col)]);
                ACTIVE_AVCUEDATA.conditions.nondir.beta(time_i,row,col)       = mean([ACTIVE_DATA.conditions.nondirleft.beta(name_i,time_i,row,col),ACTIVE_DATA.conditions.nondirright.beta(name_i,time_i,row,col)]);
                SHAM_AVCUEDATA.conditions.nondir.delta(time_i,row,col)      = mean([SHAM_DATA.conditions.nondirleft.delta(name_i,time_i,row,col),SHAM_DATA.conditions.nondirright.delta(name_i,time_i,row,col)]);
                SHAM_AVCUEDATA.conditions.nondir.theta(time_i,row,col)      = mean([SHAM_DATA.conditions.nondirleft.theta(name_i,time_i,row,col),SHAM_DATA.conditions.nondirright.theta(name_i,time_i,row,col)]);
                SHAM_AVCUEDATA.conditions.nondir.loweralpha(time_i,row,col) = mean([SHAM_DATA.conditions.nondirleft.loweralpha(name_i,time_i,row,col),SHAM_DATA.conditions.nondirright.loweralpha(name_i,time_i,row,col)]);
                SHAM_AVCUEDATA.conditions.nondir.upperalpha(time_i,row,col) = mean([SHAM_DATA.conditions.nondirleft.upperalpha(name_i,time_i,row,col),SHAM_DATA.conditions.nondirright.upperalpha(name_i,time_i,row,col)]);
                SHAM_AVCUEDATA.conditions.nondir.beta(time_i,row,col)       = mean([SHAM_DATA.conditions.nondirleft.beta(name_i,time_i,row,col),SHAM_DATA.conditions.nondirright.beta(name_i,time_i,row,col)]);
            end
        end
end
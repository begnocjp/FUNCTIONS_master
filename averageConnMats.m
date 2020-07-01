function [ACTIVE_AVDATA,SHAM_AVDATA] = averageConnMats(ACTIVE_DATA,SHAM_DATA,cond_i,time_i,ACTIVE_AVDATA,SHAM_AVDATA)
switch cond_i
    case 1 %Directional Left %Assumimg that Row,Col are same:
        for row = 1:size(ACTIVE_DATA.conditions.dirleft.delta,3)
            for col = 1:size(ACTIVE_DATA.conditions.dirleft.delta,4)
                %Mean of Active Data for Directional Left:
                ACTIVE_AVDATA.conditions.dirleft.delta(time_i,row,col)      = mean(ACTIVE_DATA.conditions.dirleft.delta(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.dirleft.theta(time_i,row,col)      = mean(ACTIVE_DATA.conditions.dirleft.theta(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.dirleft.loweralpha(time_i,row,col) = mean(ACTIVE_DATA.conditions.dirleft.loweralpha(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.dirleft.upperalpha(time_i,row,col) = mean(ACTIVE_DATA.conditions.dirleft.upperalpha(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.dirleft.beta(time_i,row,col)       = mean(ACTIVE_DATA.conditions.dirleft.beta(:,time_i,row,col));
                %Mean of SHAM Data for Directional Left:
                SHAM_AVDATA.conditions.dirleft.delta(time_i,row,col)        = mean(SHAM_DATA.conditions.dirleft.delta(:,time_i,row,col));
                SHAM_AVDATA.conditions.dirleft.theta(time_i,row,col)        = mean(SHAM_DATA.conditions.dirleft.theta(:,time_i,row,col));
                SHAM_AVDATA.conditions.dirleft.loweralpha(time_i,row,col)   = mean(SHAM_DATA.conditions.dirleft.loweralpha(:,time_i,row,col));
                SHAM_AVDATA.conditions.dirleft.upperalpha(time_i,row,col)   = mean(SHAM_DATA.conditions.dirleft.upperalpha(:,time_i,row,col));
                SHAM_AVDATA.conditions.dirleft.beta(time_i,row,col)         = mean(SHAM_DATA.conditions.dirleft.beta(:,time_i,row,col));
            end
        end
    case 2 %Directional Right
        for row = 1:size(ACTIVE_DATA.conditions.dirright.delta,3)
            for col = 1:size(ACTIVE_DATA.conditions.dirright.delta,4)
                ACTIVE_AVDATA.conditions.dirright.delta(time_i,row,col)     = mean(ACTIVE_DATA.conditions.dirright.delta(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.dirright.theta(time_i,row,col)     = mean(ACTIVE_DATA.conditions.dirright.theta(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.dirright.loweralpha(time_i,row,col)= mean(ACTIVE_DATA.conditions.dirright.loweralpha(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.dirright.upperalpha(time_i,row,col)= mean(ACTIVE_DATA.conditions.dirright.upperalpha(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.dirright.beta(time_i,row,col)      = mean(ACTIVE_DATA.conditions.dirright.beta(:,time_i,row,col));
                SHAM_AVDATA.conditions.dirright.delta(time_i,row,col)       = mean(SHAM_DATA.conditions.dirright.delta(:,time_i,row,col));
                SHAM_AVDATA.conditions.dirright.theta(time_i,row,col)       = mean(SHAM_DATA.conditions.dirright.theta(:,time_i,row,col));
                SHAM_AVDATA.conditions.dirright.loweralpha(time_i,row,col)  = mean(SHAM_DATA.conditions.dirright.loweralpha(:,time_i,row,col));
                SHAM_AVDATA.conditions.dirright.upperalpha(time_i,row,col)  = mean(SHAM_DATA.conditions.dirright.upperalpha(:,time_i,row,col));
                SHAM_AVDATA.conditions.dirright.beta(time_i,row,col)        = mean(SHAM_DATA.conditions.dirright.beta(:,time_i,row,col));
            end
        end
    case 3 %Non Directional Left
        for row = 1:size(ACTIVE_DATA.conditions.nondirleft.delta,3)
            for col = 1:size(ACTIVE_DATA.conditions.nondirleft.delta,4)
                ACTIVE_AVDATA.conditions.nondirleft.delta(time_i,row,col)      = mean(ACTIVE_DATA.conditions.nondirleft.delta(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.nondirleft.theta(time_i,row,col)      = mean(ACTIVE_DATA.conditions.nondirleft.theta(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.nondirleft.loweralpha(time_i,row,col) = mean(ACTIVE_DATA.conditions.nondirleft.loweralpha(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.nondirleft.upperalpha(time_i,row,col) = mean(ACTIVE_DATA.conditions.nondirleft.upperalpha(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.nondirleft.beta(time_i,row,col)       = mean(ACTIVE_DATA.conditions.nondirleft.beta(:,time_i,row,col));
                SHAM_AVDATA.conditions.nondirleft.delta(time_i,row,col)      = mean(SHAM_DATA.conditions.nondirleft.delta(:,time_i,row,col));
                SHAM_AVDATA.conditions.nondirleft.theta(time_i,row,col)      = mean(SHAM_DATA.conditions.nondirleft.theta(:,time_i,row,col));
                SHAM_AVDATA.conditions.nondirleft.loweralpha(time_i,row,col) = mean(SHAM_DATA.conditions.nondirleft.loweralpha(:,time_i,row,col));
                SHAM_AVDATA.conditions.nondirleft.upperalpha(time_i,row,col) = mean(SHAM_DATA.conditions.nondirleft.upperalpha(:,time_i,row,col));
                SHAM_AVDATA.conditions.nondirleft.beta(time_i,row,col)       = mean(SHAM_DATA.conditions.nondirleft.beta(:,time_i,row,col));
            end
        end
    case 4 %Non Directional Right
        for row = 1:size(ACTIVE_DATA.conditions.nondirright.delta,3)
            for col = 1:size(ACTIVE_DATA.conditions.nondirright.delta,4)
                ACTIVE_AVDATA.conditions.nondirright.delta(time_i,row,col)      = mean(ACTIVE_DATA.conditions.nondirright.delta(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.nondirright.theta(time_i,row,col)      = mean(ACTIVE_DATA.conditions.nondirright.theta(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.nondirright.loweralpha(time_i,row,col) = mean(ACTIVE_DATA.conditions.nondirright.loweralpha(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.nondirright.upperalpha(time_i,row,col) = mean(ACTIVE_DATA.conditions.nondirright.upperalpha(:,time_i,row,col));
                ACTIVE_AVDATA.conditions.nondirright.beta(time_i,row,col)       = mean(ACTIVE_DATA.conditions.nondirright.beta(:,time_i,row,col));
                SHAM_AVDATA.conditions.nondirright.delta(time_i,row,col)      = mean(SHAM_DATA.conditions.nondirright.delta(:,time_i,row,col));
                SHAM_AVDATA.conditions.nondirright.theta(time_i,row,col)      = mean(SHAM_DATA.conditions.nondirright.theta(:,time_i,row,col));
                SHAM_AVDATA.conditions.nondirright.loweralpha(time_i,row,col) = mean(SHAM_DATA.conditions.nondirright.loweralpha(:,time_i,row,col));
                SHAM_AVDATA.conditions.nondirright.upperalpha(time_i,row,col) = mean(SHAM_DATA.conditions.nondirright.upperalpha(:,time_i,row,col));
                SHAM_AVDATA.conditions.nondirright.beta(time_i,row,col)       = mean(SHAM_DATA.conditions.nondirright.beta(:,time_i,row,col));
            end
        end
end
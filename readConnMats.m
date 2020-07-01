function [ALLDATA] = readConnMats(filename,name_i,cond_i,time_i,ALLDATA)
condfield = fieldnames(ALLDATA.conditions);
freqfield = fieldnames(ALLDATA.conditions.(condfield{1}));
load(filename{1,1})
ALLDATA.conditions.(condfield{cond_i}).(freqfield{1})(name_i,time_i,:,:) = ConnectivityMatrix_delta(:,:);
ALLDATA.conditions.(condfield{cond_i}).(freqfield{2})(name_i,time_i,:,:) = ConnectivityMatrix_theta(:,:);
ALLDATA.conditions.(condfield{cond_i}).(freqfield{3})(name_i,time_i,:,:) = ConnectivityMatrix_loweralpha(:,:);
ALLDATA.conditions.(condfield{cond_i}).(freqfield{4})(name_i,time_i,:,:) = ConnectivityMatrix_upperalpha(:,:);
ALLDATA.conditions.(condfield{cond_i}).(freqfield{5})(name_i,time_i,:,:) = ConnectivityMatrix_beta(:,:);

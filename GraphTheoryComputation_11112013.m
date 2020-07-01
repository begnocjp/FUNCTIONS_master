%% Graph Theory Analysis    
for cond_i = 1%:length(conditions)
    currentcond = conditions(1,cond_i);
    fprintf('%s %s\n','Computing Network Metrics for:',currentcond{1,1});
    for freq_i = 1%:length(frequencies)
        currentfreq = frequencies(1,freq_i);
        fprintf('%s %s\n','Computing Network Metrics for:',currentfreq{1,1});
        timecount = 0;
        for starttime = 0:100:1400
            timecount = timecount+1;
            endtime = starttime + 200;
            time_i = timecount;
            timeperiod = [num2str(starttime),'to',num2str(endtime)];
            fprintf('%s %s\n','Computing Network Metrics for timerange:',timeperiod);
            tic;
            clear currentnet net_norm net_thr rand_thr net_dis rand_dis
            currentnet = strcat(currentfreq{1,1},'_',currentcond{1,1},'_',timeperiod,'trim');
            eval(['currentnet = ' currentnet ';']);
            net_norm   = weight_conversion(currentnet,'normalize');
            threshcount = 0;
            for threshold = 0.1:0.1:0.5;
                threshcount = threshcount + 1;
                thresh_i = threshcount;
                repeats = 10;
                randnet = zeros(repeats,48,48);
                for randcount = 1:repeats;
                    randnet(randcount,:,:) = rand(48,48).*2.-1;
                end%randcount
                %randnet = squeeze(mean(randnettmp,1));
                fprintf('.');
                for subj_i = 1:length(names)
                    net_extr = squeeze(net_norm(subj_i,:,:));
                    net_thr  = squeeze(threshold_proportional(net_extr,threshold));
                    net_bin  = weight_conversion(net_thr,'binarize');
                    net_dis  = squeeze(distance_wei(net_bin));
                    randnet_local = randnet;
                    rand_thr = zeros(size(randnet_local));
                    rand_bin = zeros(size(randnet_local));
                    rand_dis = zeros(size(randnet_local));
                    for randCount = 1:size(randnet_local,1)
                        rand_thr(randCount,:,:) = threshold_proportional(squeeze(randnet_local(randCount,:,:)),threshold);
                        rand_bin(randCount,:,:) = weight_conversion(squeeze(rand_thr(randCount,:,:)),'binarize');
                        rand_dis(randCount,:,:) = distance_wei(squeeze(rand_bin(randCount,:,:)));
                    end;
                    clustering_observed(cond_i,freq_i,time_i,subj_i,thresh_i) ...
                        = (mean(clustering_coef_wu(net_bin)));
                    pathlength_observed(cond_i,freq_i,time_i,subj_i,thresh_i) ...
                        =  (abs(charpath(net_dis)));
                    
                    tmp_ClustRand = zeros(1,size(randnet_local,1));
                    tmp_PathLRand = zeros(1,size(randnet_local,1));
                    tmp_ClusRatio = zeros(1,size(randnet_local,1));
                    tmp_PathRatio = zeros(1,size(randnet_local,1));
                    for randCount = 1:size(randnet_local,1)
                        tmp_ClustRand(1,randCount) = mean(clustering_coef_wu(squeeze(rand_bin(randCount,:,:))));
                        tmp_PathLRand(1,randCount) = abs(mean(charpath(squeeze(rand_dis(randCount,:,:)))));
                        tmp_ClusRatio(1,randCount) = abs(clustering_observed(cond_i,freq_i,time_i,subj_i,thresh_i)./ ...
                            tmp_ClustRand(1,randCount));
                        tmp_PathRatio(1,randCount) = abs(pathlength_observed(cond_i,freq_i,time_i,subj_i,thresh_i)./ ...
                            tmp_PathLRand(1,randCount));
                    end
                    for randCount = 1:size(randnet_local,1)
                        tmp_ClustRand(1,randCount(isinf(tmp_ClustRand(1,randCount))))= 0;
                        tmp_PathLRand(1,randCount(isinf(tmp_PathLRand(1,randCount))))= 0;
                        tmp_ClusRatio(1,randCount(isinf(tmp_ClusRatio(1,randCount))))= 0;
                        tmp_PathRatio(1,randCount(isinf(tmp_PathRatio(1,randCount))))= 0;
                    end
                    clustering_random(cond_i,freq_i,time_i,subj_i,thresh_i) ...
                        = (abs(mean(tmp_ClustRand)));
                    pathlength_random(cond_i,freq_i,time_i,subj_i,thresh_i)   ...
                        =  (abs(mean(tmp_PathLRand)));
                    clustratio_observed(cond_i,freq_i,time_i,subj_i,thresh_i) ...
                        = (abs(mean(tmp_ClusRatio)));
                    pathratio_observed(cond_i,freq_i,time_i,subj_i,thresh_i) ...
                        = (abs(mean(tmp_PathRatio))); %not sure why *repeats fixed these ratio scores...
                    
                    
                end
            end%threshold loop
            toc
        end%starttimeloop
    end%freq_i loop
end%cond_i loop
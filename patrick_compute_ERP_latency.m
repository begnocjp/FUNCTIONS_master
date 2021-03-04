function patrick_compute_ERP_latency(wpms,name_i,N2_lat,P3_lat,P1_lat,front_chan,cent_chan,pari_chan,occip_chan)


%load all subjects
for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_gonogo' '.mat']);
end

%      condition = '_gonogo'
%      conditions = {'nocue','go','diff'};

for name_i = 1:length(wpms.names)

%N2
%find the latency for "mean" min/or/max amplitude using channel ROI within timewindow of interest, then adjust to convert from samples to miliseconds 
    
l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat))))
ERP.N2.gonogo_nogo_frontal_latpeak(name_i,1) =    (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat))))
ERP.N2.gonogo_nogo_central_latpeak(name_i,1) =    (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat))))
ERP.N2.gonogo_nogo_parietal_latpeak(name_i,1)=    (((N2_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat))))
ERP.N2.gonogo_go_frontal_latpeak(name_i,1) =    (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat))))
ERP.N2.gonogo_go_central_latpeak(name_i,1) =    (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat))))
ERP.N2.gonogo_go_parietal_latpeak(name_i,1)=    (((N2_lat(1) + l) - 125) * 4)

%P3  latency 280ms to 320ms

l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat))))
ERP.P3.gonogo_nogo_frontal_latpeak(name_i,1) =    (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat))))
ERP.P3.gonogo_nogo_central_latpeak(name_i,1) =    (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat))))
ERP.P3.gonogo_nogo_parietal_latpeak(name_i,1)=    (((P3_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat))))
ERP.P3.gonogo_go_frontal_latpeak(name_i,1) =    (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat))))
ERP.P3.gonogo_go_central_latpeak(name_i,1) =    (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat))))
ERP.P3.gonogo_go_parietal_latpeak(name_i,1)=    (((P3_lat(1) + l) - 125) * 4)

%P1  latency 0ms to 200ms

l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat))))
ERP.P1.gonogo_nogo_frontal_latpeak(name_i,1) =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat))))
ERP.P1.gonogo_nogo_central_latpeak(name_i,1) =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat))))
ERP.P1.gonogo_nogo_parietal_latpeak(name_i,1)=    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat))))
ERP.P1.gonogo_nogo_occip_latpeak(name_i,1)=       (((P1_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat))))
ERP.P1.gonogo_go_frontal_latpeak(name_i,1) =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat))))
ERP.P1.gonogo_go_central_latpeak(name_i,1) =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat))))
ERP.P1.gonogo_go_parietal_latpeak(name_i,1)=    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat))))
ERP.P1.gonogo_nogo_occip_latpeak(name_i,1)=        (((P1_lat(1) + l) - 125) * 4)
end

clear('load_subs')

% condition.name = '_stroop'
% condition.erp = {'congruent','incongruent','diff'}

% for name_i = 1:length(wpms.names)
%     load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_stroop' '.mat']);
% end
% 
% %N2
% 
% for name_i = 1:length(wpms.names)
% l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat))))
% ERP.N2.stroop_congruent_frontal_latpeak(name_i,1) =      (((N2_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat))))
% ERP.N2.stroop_congruent_central_latpeak(name_i,1) =      (((N2_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat))))
% ERP.N2.stroop_congruent_parietal_latpeak(name_i,1)=      (((N2_lat(1) + l) - 125) * 4)
% 
% l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat))))
% ERP.N2.stroop_incongruent_frontal_latpeak(name_i,1) =      (((N2_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat))))
% ERP.N2.stroop_incongruent_central_latpeak(name_i,1) =      (((N2_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat))))
% ERP.N2.stroop_incongruent_parietal_latpeak(name_i,1)=      (((N2_lat(1) + l) - 125) * 4)
% 
% %P3  latency 280ms to 320ms
% 
% l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat))))
% ERP.P3.stroop_congruent_frontal_latpeak(name_i,1) =      (((P3_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat))))
% ERP.P3.stroop_congruent_central_latpeak(name_i,1) =       (((P3_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat))))
% ERP.P3.stroop_congruent_parietal_latpeak(name_i,1)=       (((P3_lat(1) + l) - 125) * 4)
% 
% l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat))))
% ERP.P3.stroop_incongruent_frontal_latpeak(name_i,1) =       (((P3_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat))))
% ERP.P3.stroop_incongruent_central_latpeak(name_i,1) =       (((P3_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat))))
% ERP.P3.stroop_incongruent_parietal_latpeak(name_i,1)=       (((P3_lat(1) + l) - 125) * 4)
% 
% %P1  latency 0ms to 200ms
% 
% l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat))))
% ERP.P1.stroop_congruent_frontal_latpeak(name_i,1) =       (((P1_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat))))
% ERP.P1.stroop_congruent_central_latpeak(name_i,1) =       (((P1_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat))))
% ERP.P1.stroop_congruent_parietal_latpeak(name_i,1)=       (((P1_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat))))
% ERP.P1.stroop_congruent_occip_latpeak(name_i,1)=          (((P1_lat(1) + l) - 125) * 4)
% 
% l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat))))
% ERP.P1.stroop_incongruent_frontal_latpeak(name_i,1) =        (((P1_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat))))
% ERP.P1.stroop_incongruent_central_latpeak(name_i,1) =        (((P1_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat))))
% ERP.P1.stroop_incongruent_parietal_latpeak(name_i,1)=        (((P1_lat(1) + l) - 125) * 4)
% l = find(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)) == max(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat))))
% ERP.P1.stroop_incongruent_occip_latpeak(name_i,1)=           (((P1_lat(1) + l) - 125) * 4)
% end
% 
% clear('load_subs')
% 
% end
% 
% clear('load_subs')

save([wpms.dirs.CWD wpms.dirs.ERP 'ERP_lat'],'ERP')

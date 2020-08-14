function patrick_compute_ERP_latency(wpms,name_i,N2_lat,P3_lat,P1_lat,front_chan,cent_chan,pari_chan,occip_chan)


%load all subjects
for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_Alerting' '.mat']);
end

%      condition = '_Alerting'
%      conditions = {'nocue','double','diff'};

for name_i = 1:length(wpms.names)

%N2
    
l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat))))
ERP.N2.Alerting_nocue_frontal_latpeak(name_i,1) =    (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat))))
ERP.N2.Alerting_nocue_central_latpeak(name_i,1) =    (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat))))
ERP.N2.Alerting_nocue_parietal_latpeak(name_i,1)=    (((N2_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat))))
ERP.N2.Alerting_double_frontal_latpeak(name_i,1) =    (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat))))
ERP.N2.Alerting_double_central_latpeak(name_i,1) =    (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat))))
ERP.N2.Alerting_double_parietal_latpeak(name_i,1)=    (((N2_lat(1) + l) - 125) * 4)

%P3  latency 280ms to 320ms

l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat))))
ERP.P3.Alerting_nocue_frontal_latpeak(name_i,1) =    (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat))))
ERP.P3.Alerting_nocue_central_latpeak(name_i,1) =    (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat))))
ERP.P3.Alerting_nocue_parietal_latpeak(name_i,1)=    (((P3_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat))))
ERP.P3.Alerting_double_frontal_latpeak(name_i,1) =    (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat))))
ERP.P3.Alerting_double_central_latpeak(name_i,1) =    (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat))))
ERP.P3.Alerting_double_parietal_latpeak(name_i,1)=    (((P3_lat(1) + l) - 125) * 4)

%P1  latency 0ms to 200ms

l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat))))
ERP.P1.Alerting_nocue_frontal_latpeak(name_i,1) =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat))))
ERP.P1.Alerting_nocue_central_latpeak(name_i,1) =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat))))
ERP.P1.Alerting_nocue_parietal_latpeak(name_i,1)=    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat))))
ERP.P1.Alerting_nocue_occip_latpeak(name_i,1)=       (((P1_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat))))
ERP.P1.Alerting_double_frontal_latpeak(name_i,1) =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat))))
ERP.P1.Alerting_double_central_latpeak(name_i,1) =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat))))
ERP.P1.Alerting_double_parietal_latpeak(name_i,1)=    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat))))
ERP.P1.Alerting_nocue_occip_latpeak(name_i,1)=        (((P1_lat(1) + l) - 125) * 4)
end

clear('load_subs')

% condition.name = '_Orienting'
% condition.erp = {'center','updown','diff'}

for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_Orienting' '.mat']);
end

%N2

for name_i = 1:length(wpms.names)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat))))
ERP.N2.Orienting_center_frontal_latpeak(name_i,1) =      (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat))))
ERP.N2.Orienting_center_central_latpeak(name_i,1) =      (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat))))
ERP.N2.Orienting_center_parietal_latpeak(name_i,1)=      (((N2_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat))))
ERP.N2.Orienting_updown_frontal_latpeak(name_i,1) =      (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat))))
ERP.N2.Orienting_updown_central_latpeak(name_i,1) =      (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat))))
ERP.N2.Orienting_updown_parietal_latpeak(name_i,1)=      (((N2_lat(1) + l) - 125) * 4)

%P3  latency 280ms to 320ms

l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat))))
ERP.P3.Orienting_center_frontal_latpeak(name_i,1) =      (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat))))
ERP.P3.Orienting_center_central_latpeak(name_i,1) =       (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat))))
ERP.P3.Orienting_center_parietal_latpeak(name_i,1)=       (((P3_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat))))
ERP.P3.Orienting_updown_frontal_latpeak(name_i,1) =       (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat))))
ERP.P3.Orienting_updown_central_latpeak(name_i,1) =       (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat))))
ERP.P3.Orienting_updown_parietal_latpeak(name_i,1)=       (((P3_lat(1) + l) - 125) * 4)

%P1  latency 0ms to 200ms

l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat))))
ERP.P1.Orienting_center_frontal_latpeak(name_i,1) =       (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat))))
ERP.P1.Orienting_center_central_latpeak(name_i,1) =       (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat))))
ERP.P1.Orienting_center_parietal_latpeak(name_i,1)=       (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat))))
ERP.P1.Orienting_center_occip_latpeak(name_i,1)=          (((P1_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat))))
ERP.P1.Orienting_updown_frontal_latpeak(name_i,1) =        (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat))))
ERP.P1.Orienting_updown_central_latpeak(name_i,1) =        (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat))))
ERP.P1.Orienting_updown_parietal_latpeak(name_i,1)=        (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat))))
ERP.P1.Orienting_updown_occip_latpeak(name_i,1)=           (((P1_lat(1) + l) - 125) * 4)
end

clear('load_subs')

% condition.name = '_Executive'
% conditions.erp = {'incongruent','congruent','diff'};

for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_Executive' '.mat']);
end

%N2

for name_i = 1:length(wpms.names)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat))))
ERP.N2.Executive_incongruent_frontal_latpeak(name_i,1) =    (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat))))
ERP.N2.Executive_incongruent_central_latpeak(name_i,1) =    (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat))))
ERP.N2.Executive_incongruent_parietal_latpeak(name_i,1)=    (((N2_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat))))
ERP.N2.Executive_congruent_frontal_latpeak(name_i,1)   =      (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat))))
ERP.N2.Executive_congruent_central_latpeak(name_i,1)   =      (((N2_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat))))
ERP.N2.Executive_congruent_parietal_latpeak(name_i,1)  =      (((N2_lat(1) + l) - 125) * 4)

%P3  latency 280ms to 320ms

l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat))))
ERP.P3.Executive_incongruent_frontal_latpeak(name_i,1) =    (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat))))
ERP.P3.Executive_incongruent_central_latpeak(name_i,1) =    (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat))))
ERP.P3.Executive_incongruent_parietal_latpeak(name_i,1)=    (((P3_lat(1) + l) - 125) * 4)

l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat))))
ERP.P3.Executive_congruent_frontal_latpeak(name_i,1)   =      (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat))))
ERP.P3.Executive_congruent_central_latpeak(name_i,1)   =      (((P3_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat))))
ERP.P3.Executive_congruent_parietal_latpeak(name_i,1)  =      (((P3_lat(1) + l) - 125) * 4)

%P1  latency 0ms to 200ms

l = find(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat))))
ERP.P1.Executive_incongruent_frontal_latpeak(name_i,1) =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat))))
ERP.P1.Executive_incongruent_central_latpeak(name_i,1) =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat))))
ERP.P1.Executive_incongruent_parietal_latpeak(name_i,1)=    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat))))
ERP.P1.Executive_incongruent_occip_latpeak(name_i,1)   =       (((P1_lat(1) + l) - 125) * 4)


l = find(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat))))
ERP.P1.Executive_congruent_frontal_latpeak(name_i,1)   =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat))))
ERP.P1.Executive_congruent_central_latpeak(name_i,1)   =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat))))
ERP.P1.Executive_congruent_parietal_latpeak(name_i,1)  =    (((P1_lat(1) + l) - 125) * 4)
l = find(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)) == min(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat))))
ERP.P1.Executive_congruent_occip_latpeak(name_i,1)     =       (((P1_lat(1) + l) - 125) * 4)

end

clear('load_subs')

save([wpms.dirs.CWD wpms.dirs.ERP 'ERP_lat'],'ERP')

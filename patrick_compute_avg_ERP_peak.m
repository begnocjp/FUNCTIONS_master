function patrick_compute_avg_ERP_peak(wpms,name_i,N2_lat,P3_lat,front_chan,cent_chan,pari_chan,occip_chan)


%load all subjects
for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_Alerting' '.mat']);
end

% channels used in average
% frontal = E22,E14,E23,E15,E6,E16,E7
% central = E9,E186,E45,E132,E81,E80,E131
% parietal = E100,E129,E101,E110,E128,E119

%N2 averaege latency 180ms to 220ms (divide ms by 4 for this data collected
%at 250Hz, e.g. for 680ms into trial, 680/4 = 170, so start at sample 170)


%      condition = '_Alerting'
%      conditions = {'nocue','double','diff'};

for name_i = 1:length(wpms.names)
    
ERP.N2.Alerting_nocue_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)))
ERP.N2.Alerting_nocue_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)))
ERP.N2.Alerting_nocue_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)))

ERP.N2.Alerting_double_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)))
ERP.N2.Alerting_double_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)))
ERP.N2.Alerting_double_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)))

%P3  latency 280ms to 320ms

ERP.P3.Alerting_nocue_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)))
ERP.P3.Alerting_nocue_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)))
ERP.P3.Alerting_nocue_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)))

ERP.P3.Alerting_double_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)))
ERP.P3.Alerting_double_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)))
ERP.P3.Alerting_double_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)))

%P1  latency 0ms to 200ms

ERP.P1.Alerting_nocue_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)))
ERP.P1.Alerting_nocue_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)))
ERP.P1.Alerting_nocue_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)))
ERP.P1.Alerting_nocue_occip(name_i,1)     = mean(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)))

ERP.P1.Alerting_double_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)))
ERP.P1.Alerting_double_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)))
ERP.P1.Alerting_double_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)))
ERP.P1.Alerting_double_occip(name_i,1)    = mean(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)))

end

clear('load_subs')

% condition.name = '_Orienting'
% condition.erp = {'center','updown','diff'}

for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_Orienting' '.mat']);
end


for name_i = 1:length(wpms.names)

ERP.N2.Orienting_center_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)))
ERP.N2.Orienting_center_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)))
ERP.N2.Orienting_center_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)))

ERP.N2.Orienting_updown_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)))
ERP.N2.Orienting_updown_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)))
ERP.N2.Orienting_updown_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)))

%P3 averaege latency 280ms to 320ms

ERP.P3.Orienting_center_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)))
ERP.P3.Orienting_center_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)))
ERP.P3.Orienting_center_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)))

ERP.P3.Orienting_updown_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)))
ERP.P3.Orienting_updown_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)))
ERP.P3.Orienting_updown_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)))

%P1 averaege latency 0ms to 200ms

ERP.P1.Orienting_center_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)))
ERP.P1.Orienting_center_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)))
ERP.P1.Orienting_center_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)))
ERP.P1.Orienting_center_occip(name_i,1)     = mean(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)))

ERP.P1.Orienting_updown_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)))
ERP.P1.Orienting_updown_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)))
ERP.P1.Orienting_updown_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)))
ERP.P1.Orienting_updown_occip(name_i,1)    = mean(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)))

end

clear('load_subs')

% condition.name = '_Executive'
% conditions.erp = {'incongruent','congruent','diff'};

for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_Executive' '.mat']);
end


for name_i = 1:length(wpms.names)

ERP.N2.Executive_incongruent_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)))
ERP.N2.Executive_incongruent_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)))
ERP.N2.Executive_incongruent_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)))

ERP.N2.Executive_congruent_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)))
ERP.N2.Executive_congruent_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)))
ERP.N2.Executive_congruent_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)))

%P3 averaege latency 280ms to 320ms

ERP.P3.Executive_incongruente_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)))
ERP.P3.Executive_incongruent_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)))
ERP.P3.Executive_incongruent_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)))

ERP.P3.Executive_congruent_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)))
ERP.P3.Executive_congruent_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)))
ERP.P3.Executive_congruent_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)))

%P1 averaege latency 0ms to 200ms

ERP.P1.Executive_incongruente_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)))
ERP.P1.Executive_incongruent_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)))
ERP.P1.Executive_incongruent_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)))
ERP.P1.Executive_incongruent_occip(name_i,1)     = mean(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)))

ERP.P1.Executive_congruent_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)))
ERP.P1.Executive_congruent_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)))
ERP.P1.Executive_congruent_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)))
ERP.P1.Executive_congruent_occip(name_i,1)    = mean(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)))

end

clear('load_subs')



%     condition = '_Orienting'
%     conditions = {'center','updown','diff'};

%     condition = '_Executive'
%     conditions = {'incongruent','congruent','diff'};

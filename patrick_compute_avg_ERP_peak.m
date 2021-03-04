function patrick_compute_avg_ERP_peak(wpms,name_i,N2_lat,P3_lat,front_chan,cent_chan,pari_chan,occip_chan)


%load all subjects
for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_gonogo' '.mat']);
end

% channels used in average
% frontal = E22,E14,E23,E15,E6,E16,E7
% central = E9,E186,E45,E132,E81,E80,E131
% parietal = E100,E129,E101,E110,E128,E119

%N2 averaege latency 180ms to 220ms (divide ms by 4 for this data collected
%at 250Hz, e.g. for 680ms into trial, 680/4 = 170, so start at sample 170)


%      condition = '_gonogo'
%      conditions = {'nogo','go','diff'};

for name_i = 1:length(wpms.names)
    
ERP.N2.gonogo_nogo_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)))
ERP.N2.gonogo_nogo_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)))
ERP.N2.gonogo_nogo_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)))

ERP.N2.gonogo_go_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)))
ERP.N2.gonogo_go_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)))
ERP.N2.gonogo_go_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)))

%P3  latency 280ms to 320ms

ERP.P3.gonogo_nogo_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)))
ERP.P3.gonogo_nogo_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)))
ERP.P3.gonogo_nogo_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)))

ERP.P3.gonogo_go_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)))
ERP.P3.gonogo_go_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)))
ERP.P3.gonogo_go_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)))

%P1  latency 0ms to 200ms
% 
% ERP.P1.gonogo_nogo_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)))
% ERP.P1.gonogo_nogo_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)))
% ERP.P1.gonogo_nogo_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)))
% ERP.P1.gonogo_nogo_occip(name_i,1)     = mean(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)))
% 
% ERP.P1.gonogo_go_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)))
% ERP.P1.gonogo_go_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)))
% ERP.P1.gonogo_go_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)))
% ERP.P1.gonogo_go_occip(name_i,1)    = mean(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)))

end

clear('load_subs')

% condition.name = '_stroop'
% condition.erp = {'congruent','incongruent','diff'}

% for name_i = 1:length(wpms.names)
%     load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_stroop' '.mat']);
% end

% 
% for name_i = 1:length(wpms.names)
% 
% ERP.N2.stroop_congruent_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)))
% ERP.N2.stroop_congruent_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)))
% ERP.N2.stroop_congruent_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)))
% 
% ERP.N2.stroop_incongruent_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)))
% ERP.N2.stroop_incongruent_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)))
% ERP.N2.stroop_incongruent_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)))
% 
% %P3 averaege latency 280ms to 320ms
% 
% ERP.P3.stroop_congruent_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)))
% ERP.P3.stroop_congruent_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)))
% ERP.P3.stroop_congruent_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)))
% 
% ERP.P3.stroop_incongruent_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)))
% ERP.P3.stroop_incongruent_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)))
% ERP.P3.stroop_incongruent_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)))
% 
% %P1 averaege latency 0ms to 200ms
% 
% ERP.P1.stroop_congruent_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)))
% ERP.P1.stroop_congruent_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)))
% ERP.P1.stroop_congruent_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)))
% ERP.P1.stroop_congruent_occip(name_i,1)     = mean(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)))
% 
% ERP.P1.stroop_incongruent_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)))
% ERP.P1.stroop_incongruent_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)))
% ERP.P1.stroop_incongruent_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)))
% ERP.P1.stroop_incongruent_occip(name_i,1)    = mean(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)))
% 
% end
% 
% clear('load_subs')


 save([wpms.dirs.CWD wpms.dirs.ERP 'ERP_avg'], 'ERP');
 
 
%     condition = '_stroop'
%     conditions = {'congruent','incongruent','diff'};

%     condition = '_Executive'
%     conditions = {'incongruent','congruent','diff'};

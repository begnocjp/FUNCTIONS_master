function patrick_compute_avg_ERP_peak(wpms,name_i,N2_lat,P3_lat,front_chan,cent_chan,pari_chan,occip_chan)
% 
% %load all subjects
% for name_i = 1:length(wpms.names)
%     load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_gonogo' '.mat']);
% end
% 
% % channels used in average
% % frontal = E22,E14,E23,E15,E6,E16,E7
% % central = E9,E186,E45,E132,E81,E80,E131
% % parietal = E100,E129,E101,E110,E128,E119 
% 
% %N2 averaege latency 180ms to 220ms (divide ms by 4 for this data collected
% %at 250Hz, e.g. for 680ms into trial, 680/4 = 170, so start at sample 170)
% 
%     time = 'pre'
%   time = 'post'
     condition = '_gonogo'
     conditions = {'nogo','go','diff'};
     
     for name_i = 1:length(wpms.names)
         load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_gonogo' '.mat']);
     end

for name_i = 1:length(wpms.names)
    
ERP.names(name_i) = erase(wpms.names(name_i),'_002')
ERP.num_nogo_trials(name_i)=length(load_subs{name_i}.timelock(1).cfg.previous.trials)
ERP.num_go_trials(name_i)=length(load_subs{name_i}.timelock(2).cfg.previous.trials)
   
ERP.N2.gonogo_nogo_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)))
ERP.N2.gonogo_nogo_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)))
ERP.N2.gonogo_nogo_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)))

ERP.N2.gonogo_go_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)))
ERP.N2.gonogo_go_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)))
ERP.N2.gonogo_go_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)))

% P3  latency 280ms to 320ms

ERP.P3.gonogo_nogo_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)))
ERP.P3.gonogo_nogo_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)))
ERP.P3.gonogo_nogo_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)))

ERP.P3.gonogo_go_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)))
ERP.P3.gonogo_go_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)))
ERP.P3.gonogo_go_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)))

% P1  latency 0ms to 200ms

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

ERP.names = string(transpose(ERP.names))
ERP.num_nogo_trials=string(transpose(ERP.num_nogo_trials))
ERP.num_go_trials=string(transpose(ERP.num_go_trials))

clear('load_subs')
% 
%      time = 'pre'
% %     time = 'post'
% condition = '_stroop'
% conditions = {'congruent','incongruent','diff'}
% 
% for name_i = 1:length(wpms.names)
%     load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_stroop' '.mat']);
% end
%  
% 
% for name_i = 1:length(wpms.names)
%     
% ERP.names(name_i) = erase(wpms.names(name_i),'_002')
% ERP.num_congruent_trials(name_i)=length(load_subs{name_i}.timelock(1).cfg.previous.trials)
% ERP.num_incongruent_trials(name_i)=length(load_subs{name_i}.timelock(2).cfg.previous.trials)
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
% % % % P1 averaege latency 0ms to 200ms
% % % 
% % % ERP.P1.stroop_congruent_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)))
% % % ERP.P1.stroop_congruent_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)))
% % % ERP.P1.stroop_congruent_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)))
% % % ERP.P1.stroop_congruent_occip(name_i,1)     = mean(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)))
% % % 
% % % ERP.P1.stroop_incongruent_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)))
% % % ERP.P1.stroop_incongruent_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)))
% % % ERP.P1.stroop_incongruent_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)))
% % % ERP.P1.stroop_incongruent_occip(name_i,1)    = mean(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)))
% 
% end
% 
% ERP.names = string(transpose(ERP.names)) 
% ERP.num_congruent_trials=string(transpose(ERP.num_congruent_trials))
% ERP.num_incongruent_trials=string(transpose(ERP.num_incongruent_trials))
% 
% clear('load_subs')
% 
%   time = 'pre'
%      time = 'post'
% condition = '_incidental'
% conditions = {'sing','rept','diff'}
% 
% 
% for name_i = 1:length(wpms.names)
%     load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_incidental' '.mat']);
% end
% 
% 
% for name_i = 1:length(wpms.names)
% 
% ERP.names(name_i) = erase(wpms.names(name_i),'_002')
% 
% ERP.num_sing_trials(name_i)=length(load_subs{name_i}.timelock(1).cfg.previous.trials)
% ERP.num_rept_trials(name_i)=length(load_subs{name_i}.timelock(2).cfg.previous.trials)
% 
% ERP.N2.incidental_sing_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat)))
% ERP.N2.incidental_sing_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat)))
% ERP.N2.incidental_sing_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat)))
% 
% ERP.N2.incidental_rept_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat)))
% ERP.N2.incidental_rept_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat)))
% ERP.N2.incidental_rept_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat)))
% 
% %P3 averaege latency 280ms to 320ms
% 
% ERP.P3.incidental_sing_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat)))
% ERP.P3.incidental_sing_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat)))
% ERP.P3.incidental_sing_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat)))
% 
% ERP.P3.incidental_rept_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat)))
% ERP.P3.incidental_rept_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat)))
% ERP.P3.incidental_rept_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat)))
% 
% % %P1 averaege latency 0ms to 200ms
% % 
% % ERP.P1.incidental_sing_frontal(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat)))
% % ERP.P1.incidental_sing_central(name_i,1)   = mean(mean(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat)))
% % ERP.P1.incidental_sing_parietal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat)))
% % ERP.P1.incidental_sing_occip(name_i,1)     = mean(mean(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat)))
% % 
% % ERP.P1.incidental_rept_frontal(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat)))
% % ERP.P1.incidental_rept_central(name_i,1)  = mean(mean(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat)))
% % ERP.P1.incidental_rept_parietal(name_i,1) = mean(mean(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat)))
% % ERP.P1.incidental_rept_occip(name_i,1)    = mean(mean(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat)))
% 
% end
% 
% ERP.names = string(transpose(ERP.names))
% ERP.num_sing_trials=string(transpose(ERP.num_sing_trials))
% ERP.num_rept_trials=string(transpose(ERP.num_rept_trials))
% 
% 
% 
% clear('load_subs')
% % 
% % % 
% 

 save([wpms.dirs.CWD wpms.dirs.ERP [time condition '_ERP_avg']], 'ERP');
 


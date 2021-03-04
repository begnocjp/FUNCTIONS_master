function patrick_compute_ERP_latency_peak(wpms,name_i,N2_lat,P3_lat,P1_lat,front_chan,cent_chan,pari_chan,occip_chan)


%load all subjects
for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_Alerting' '.mat']);
end


%find minimum peak over N2 latency 150ms to 300ms (divide ms by 4 for this data collected
%at 250Hz, e.g. for 680ms into trial, 680/4 = 170, so start at sample 170)


%      condition = '_Alerting'
%      conditions = {'nocue','double','diff'};


for name_i = 1:length(wpms.names)

[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat),[],'all'))
ERP.N2.Alerting_nocue_frontal_latpeak(name_i,1) =    ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat),[],'all'))
ERP.N2.Alerting_nocue_central_latpeak(name_i,1) =    ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat),[],'all'))
ERP.N2.Alerting_nocue_parietal_latpeak(name_i,1)=    ((l - 125) * 4)

[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat),[],'all'))
ERP.N2.Alerting_double_frontal_latpeak(name_i,1)  =  ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat),[],'all'))
ERP.N2.Alerting_double_central_latpeak(name_i,1)  =  ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat),[],'all'))
ERP.N2.Alerting_double_parietal_latpeakl(name_i,1) = ((l - 125) * 4)

%P3  latency 280ms to 320ms

[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat),[],'all'))
ERP.P3.Alerting_nocue_frontal_latpeak(name_i,1) =    ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat),[],'all'))
ERP.P3.Alerting_nocue_central_latpeak(name_i,1) =    ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat),[],'all'))
ERP.P3.Alerting_nocue_parietal_latpeak(name_i,1)=    ((l - 125) * 4)

[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat),[],'all'))
ERP.P3.Alerting_double_frontal_latpeak(name_i,1)  =  ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat),[],'all'))
ERP.P3.Alerting_double_central_latpeak(name_i,1)  =  ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat),[],'all'))
ERP.P3.Alerting_double_parietal_latpeakl(name_i,1) = ((l - 125) * 4)

%P1  latency 0ms to 200ms

[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat),[],'all'))
ERP.P1.Alerting_nocue_frontal_latpeak(name_i,1) =    ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat),[],'all'))
ERP.P1.Alerting_nocue_central_latpeak(name_i,1) =    ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat),[],'all'))
ERP.P1.Alerting_nocue_parietal_latpeak(name_i,1)=    ((l - 125) * 4)

[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat),[],'all'))
ERP.P1.Alerting_double_frontal_latpeak(name_i,1)  =  ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat),[],'all'))
ERP.P1.Alerting_double_central_latpeak(name_i,1)  =  ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat),[],'all'))
ERP.P1.Alerting_double_parietal_latpeakl(name_i,1) = ((l - 125) * 4)

end

clear('load_subs')

% condition.name = '_Orienting'
% condition.erp = {'center','updown','diff'}

for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_Orienting' '.mat']);
end


for name_i = 1:length(wpms.names)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat),[],'all'))
ERP.N2.Orienting_center_frontal_latpeak(name_i,1)  = ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat),[],'all'))
ERP.N2.Orienting_center_central_latpeak(name_i,1)  = ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat),[],'all'))
ERP.N2.Orienting_center_parietal_latpeak(name_i,1) = ((l - 125) * 4)

[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat),[],'all'))
ERP.N2.Orienting_updown_frontal_latpeak(name_i,1)  = ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat),[],'all'))
ERP.N2.Orienting_updown_central_latpeak(name_i,1)  = ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat),[],'all'))
ERP.N2.Orienting_updown_parietal_latpeak(name_i,1) = ((l - 125) * 4)


%P3 averaege latency 280ms to 320ms

[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat),[],'all'))
ERP.N2.Orienting_center_frontal_latpeak(name_i,1)  = ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat),[],'all'))
ERP.N2.Orienting_center_central_latpeak(name_i,1)  = ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(1).avg == min(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat),[],'all'))
ERP.N2.Orienting_center_parietal_latpeak(name_i,1) = ((l - 125) * 4)

[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat),[],'all'))
ERP.N2.Orienting_updown_frontal_latpeak(name_i,1)  = ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat),[],'all'))
ERP.N2.Orienting_updown_central_latpeak(name_i,1)  = ((l - 125) * 4)
[z, l] = find(load_subs{1,name_i}.timelock(2).avg == min(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat),[],'all'))
ERP.N2.Orienting_updown_parietal_latpeak(name_i,1) = ((l - 125) * 4)

%P1 averaege latency 0ms to 200ms

ERP.P1.Orienting_center_frontal_latpeak(name_i,1)   = max(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat),[],'all')
ERP.P1.Orienting_center_central_latpeak(name_i,1)   = max(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat),[],'all')
ERP.P1.Orienting_center_parietal_latpeak(name_i,1)  = max(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat),[],'all')
ERP.P1.Orienting_center_occip_latpeak(name_i,1)     = max(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat),[],'all')

ERP.P1.Orienting_updown_frontal_latpeak(name_i,1)  = max(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat),[],'all')
ERP.P1.Orienting_updown_central_latpeak(name_i,1)  = max(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat),[],'all')
ERP.P1.Orienting_updown_parietal_latpeak(name_i,1) = max(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat),[],'all')
ERP.P1.Orienting_updown_occip_latpeak(name_i,1)    = max(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat),[],'all')

end

clear('load_subs')

% condition.name = '_Executive'
% conditions.erp = {'incongruent','congruent','diff'};

for name_i = 1:length(wpms.names)
    load_subs{name_i} = load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK' '_Executive' '.mat']);
end


for name_i = 1:length(wpms.names)

ERP.N2.Executive_incongruent_frontal_latpeak(name_i,1)   = min(load_subs{1,name_i}.timelock(1).avg(front_chan,N2_lat),[],'all')
ERP.N2.Executive_incongruent_central_latpeak(name_i,1)   = min(load_subs{1,name_i}.timelock(1).avg(cent_chan,N2_lat),[],'all')
ERP.N2.Executive_incongruent_parietal_latpeak(name_i,1)  = min(load_subs{1,name_i}.timelock(1).avg(pari_chan,N2_lat),[],'all')

ERP.N2.Executive_congruent_frontal_latpeak(name_i,1)  = min(load_subs{1,name_i}.timelock(2).avg(front_chan,N2_lat),[],'all')
ERP.N2.Executive_congruent_central_latpeak(name_i,1)  = min(load_subs{1,name_i}.timelock(2).avg(cent_chan,N2_lat),[],'all')
ERP.N2.Executive_congruent_parietal_latpeak(name_i,1) = min(load_subs{1,name_i}.timelock(2).avg(pari_chan,N2_lat),[],'all')

%P3 averaege latency 280ms to 320ms

ERP.P3.Executive_incongruente_frontal_latpeak(name_i,1)   = max(load_subs{1,name_i}.timelock(1).avg(front_chan,P3_lat),[],'all')
ERP.P3.Executive_incongruent_central_latpeak(name_i,1)   = max(load_subs{1,name_i}.timelock(1).avg(cent_chan,P3_lat),[],'all')
ERP.P3.Executive_incongruent_parietal_latpeak(name_i,1)  = max(load_subs{1,name_i}.timelock(1).avg(pari_chan,P3_lat),[],'all')

ERP.P3.Executive_congruent_frontal_latpeak(name_i,1)  = max(load_subs{1,name_i}.timelock(2).avg(front_chan,P3_lat),[],'all')
ERP.P3.Executive_congruent_central_latpeak(name_i,1)  = max(load_subs{1,name_i}.timelock(2).avg(cent_chan,P3_lat),[],'all')
ERP.P3.Executive_congruent_parietal_latpeak(name_i,1) = max(load_subs{1,name_i}.timelock(2).avg(pari_chan,P3_lat),[],'all')

%P1 averaege latency 0ms to 200ms

ERP.P1.Executive_incongruente_frontal_latpeak(name_i,1)   = max(load_subs{1,name_i}.timelock(1).avg(front_chan,P1_lat),[],'all')
ERP.P1.Executive_incongruent_central_latpeak(name_i,1)   = max(load_subs{1,name_i}.timelock(1).avg(cent_chan,P1_lat),[],'all')
ERP.P1.Executive_incongruent_parietal_latpeak(name_i,1)  = max(load_subs{1,name_i}.timelock(1).avg(pari_chan,P1_lat),[],'all')
ERP.P1.Executive_incongruent_occip_latpeak(name_i,1)     = max(load_subs{1,name_i}.timelock(1).avg(occip_chan,P1_lat),[],'all')

ERP.P1.Executive_congruent_frontal_latpeak(name_i,1)  = max(load_subs{1,name_i}.timelock(2).avg(front_chan,P1_lat),[],'all')
ERP.P1.Executive_congruent_central_latpeak(name_i,1)  = max(load_subs{1,name_i}.timelock(2).avg(cent_chan,P1_lat),[],'all')
ERP.P1.Executive_congruent_parietal_latpeak(name_i,1) = max(load_subs{1,name_i}.timelock(2).avg(pari_chan,P1_lat),[],'all')
ERP.P1.Executive_congruent_occip_latpeak(name_i,1)    = max(load_subs{1,name_i}.timelock(2).avg(occip_chan,P1_lat),[],'all')

end

clear('load_subs')

save([wpms.dirs.CWD wpms.dirs.ERP 'ERP_latpeak'],'ERP')

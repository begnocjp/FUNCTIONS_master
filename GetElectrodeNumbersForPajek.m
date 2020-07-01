labels = {'AF3','F1','F3','F5','AF4','Afz','Fz','F2','F4', ...
    'F6','FC5','FC3','FC1','FC6','FC4','FC2','FCz','C1', ...
    'C3','C5','Cz','C2','C4','C6','CP5','CP3','CP1', ...
    'CP6','CP4','CP2','CPz','P1','P3','P5','P7','Pz', ...
    'P2','P4','P6','P8','PO7','PO3','O1','Oz','POz', ...
    'PO8','PO4','O2'};
freq = 'theta';
cond = 'noninf';
time = '1200to1400';
load([freq '_' cond '_' time '_TMAP_reordered']);
filename = [freq '_' cond '_' time '_TMAP_reordered']
electrodepairs_labels = {};
electrodepairs_number = [];
count = 0;
for row = 1:length(theta_noninf_1200to1400_TMAP_reordered)
    for col = 1:length(theta_noninf_1200to1400_TMAP_reordered)
        if theta_noninf_1200to1400_TMAP_reordered(row,col) ~= 0;
            count = count + 1;
            electrodepairs_labels(count,1) = labels(row);
            electrodepairs_labels(count,2) = labels(col);
            electrodepairs_number(count,1) = row;
            electrodepairs_number(count,2) = col;
        end%ifloop
    end%col loop
end%row loop


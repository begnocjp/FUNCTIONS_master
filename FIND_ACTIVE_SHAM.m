SHAM = [];
ACTIVE = [];


% DCR Subjects:
for name_i = 1:46/2
    if strcmp(LIST_ACTIVE_SHAM{name_i,2}, 'SHAM')
        SHAM = [SHAM,LIST_ACTIVE_SHAM(name_i,1)];
        ACTIVE = [ACTIVE,LIST_ACTIVE_SHAM(name_i+46/2,1)];
    else
        ACTIVE = [ACTIVE,LIST_ACTIVE_SHAM(name_i,1)];
        SHAM = [SHAM,LIST_ACTIVE_SHAM(name_i+46/2,1)];
    end
end


% S Subjects:

for name_i = 47:2:length(names)
    if strcmp(LIST_ACTIVE_SHAM{name_i,2}, 'SHAM')
        SHAM = [SHAM,LIST_ACTIVE_SHAM(name_i,1)];
        ACTIVE = [ACTIVE,LIST_ACTIVE_SHAM(name_i+1,1)];
    else
        ACTIVE = [ACTIVE,LIST_ACTIVE_SHAM(name_i,1)];
        SHAM = [SHAM,LIST_ACTIVE_SHAM(name_i+1,1)];
    end
end


save('LIST_ACTIVE_SHAM.mat','SHAM','ACTIVE');
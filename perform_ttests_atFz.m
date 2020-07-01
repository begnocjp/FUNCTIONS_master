%% run ttests between cue and targets for delta and theta
%first load data
clearvars -except wpms
clc;
power = zeros(length(wpms.names),length(wpms.conditions),length(wpms.responsetype),80,9001);
frex = logspace(log10(2),log10(30),80);
filename = [wpms.dirs.PREPROC wpms.conditions{1} filesep wpms.names{1} ...
                        '_' wpms.conditionshort{1} '-' wpms.responsetype{1} ...
                        '-C-f.set'];
EEG = pop_loadset(filename);
channel_labels = {EEG.chanlocs(:).labels};
channel = find(strcmpi(channel_labels,'FCz'));
times = -1000:0.5:3500;
time = [find(times==300):find(times==700)]; %wanted extraction time
clear EEG

for cond_i=1:length(wpms.conditions);
    fprintf('\n%s\t%s\t','Working on condition:',wpms.conditions{cond_i});
    tic;
    for response_i=1:length(wpms.responsetype);
        for name_i = 1:length(wpms.names)
            fprintf('.');
            filename = [wpms.dirs.WAVELET_OUTPUT_DIR wpms.names{name_i} filesep wpms.conditions{cond_i} filesep wpms.conditions{cond_i} wpms.responsetype{response_i} '_' num2str(channel) '_imagcoh_mwtf.mat'];
            load(filename,'mw_tf');
            power(name_i,cond_i,response_i,:,:) = mw_tf;
            clear mw_tf;
        end
    end
    t=toc;
    fprintf('\t%3.2f %s',t,'s');
end
freq = {(1:20),(21:38),(42:57),(58:80)};%delta,theta,alpha,beta
delta = freq{1};
theta = freq{2};
alpha = freq{3};
beta = freq{4};
%% now run ttests
% for test_i = 1:length(test_pairs)
%     fprintf('\n%s\n','Delta');
%     if test_pairs{test_i}(1) == 10;
%         x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,delta,time),3),4),5));
%         y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,delta,time),3),4),5));
%         [~,p,~,stat]=ttest(x,y);
%         xcond = wpms.conditions{test_pairs{test_i}(1)};
%         ycond = wpms.conditions{test_pairs{test_i}(2)};
%         fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
%         fprintf('\n%s\n','Theta');
%         x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,theta,time),3),4),5));
%         y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,theta,time),3),4),5));
%         [~,p,~,stat]=ttest(x,y);
%         xcond = wpms.conditions{test_pairs{test_i}(1)};
%         ycond = wpms.conditions{test_pairs{test_i}(2)};
%         fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
%     elseif test_pairs{test_i}(1) == 11;
%         x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,delta,time),3),4),5));
%         y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,delta,time),3),4),5));
%         [~,p,~,stat]=ttest(x,y);
%         xcond = wpms.conditions{test_pairs{test_i}(1)};
%         ycond = wpms.conditions{test_pairs{test_i}(2)};
%         fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
%         fprintf('\n%s\n','Theta');
%         x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,theta,time),3),4),5));
%         y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,theta,time),3),4),5));
%         [~,p,~,stat]=ttest(x,y);
%         xcond = wpms.conditions{test_pairs{test_i}(1)};
%         ycond = wpms.conditions{test_pairs{test_i}(2)};
%         fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
%     elseif test_pairs{test_i}(1) == 9;
%         x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,delta,time),3),4),5));
%         y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,delta,time),3),4),5));
%         [~,p,~,stat]=ttest(x,y);
%         xcond = wpms.conditions{test_pairs{test_i}(1)};
%         ycond = wpms.conditions{test_pairs{test_i}(2)};
%         fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
%         fprintf('\n%s\n','Theta');
%         x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,theta,time),3),4),5));
%         y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,theta,time),3),4),5));
%         [~,p,~,stat]=ttest(x,y);
%         xcond = wpms.conditions{test_pairs{test_i}(1)};
%         ycond = wpms.conditions{test_pairs{test_i}(2)};
%         fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
%     else
%         x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),:,delta,time),3),4),5));
%         y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,delta,time),3),4),5));
%         [~,p,~,stat]=ttest(x,y);
%         xcond = wpms.conditions{test_pairs{test_i}(1)};
%         ycond = wpms.conditions{test_pairs{test_i}(2)};
%         fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
%         fprintf('\n%s\n','Theta');
%         x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),:,theta,time),3),4),5));
%         y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,theta,time),3),4),5));
%         [~,p,~,stat]=ttest(x,y);
%         xcond = wpms.conditions{test_pairs{test_i}(1)};
%         ycond = wpms.conditions{test_pairs{test_i}(2)};
%         fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
%     end
% end
%% switch tests
% test_pairs = {[6 7];[6 8];[6 4];[6 5];[7 8];[7 4];[7 5];[8 4];[8 5]};%oddball
% test_pairs = {[1 2];[1 3];[2 3]};%go nogo
test_pairs = {[1 6];[2 7];[3 8]};%go nogo vs oddball

time = [find(times==300):find(times==700)]; %wanted extraction time

clc;
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Delta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),:,delta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,delta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Theta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),:,theta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,theta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
time = [find(times==700):find(times==1200)]; %wanted extraction time
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Alpha');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),:,alpha,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,alpha,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Beta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),:,beta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,beta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
%% switch
test_pairs = {[9 9];[10 10];[11 11]};%switch
clc;
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Delta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,delta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),2,delta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Theta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,theta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),2,theta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
time = [find(times==700):find(times==1200)]; %wanted extraction time
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Alpha');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,alpha,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),2,alpha,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Beta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,beta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),2,beta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
%%
test_pairs = {[9 1];[9 6]};%switch
clc;
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Delta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,delta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,delta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Theta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,theta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,theta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
time = [find(times==700):find(times==1200)]; %wanted extraction time
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Alpha');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,alpha,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,alpha,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Beta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,beta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,beta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
%%
test_pairs = {[9 1];[9 6]};%switch
clc;
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Delta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,delta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,delta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Theta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,theta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,theta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
time = [find(times==700):find(times==1200)]; %wanted extraction time
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Alpha');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,alpha,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,alpha,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Beta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,beta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,beta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
%%
test_pairs = {[9 10];[9 11]};%switch
clc;
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Delta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,delta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),1,delta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Theta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,theta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),1,theta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
time = [find(times==700):find(times==1200)]; %wanted extraction time
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Alpha');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,alpha,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),1,alpha,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Beta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,beta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),1,beta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
%%
test_pairs = {[9 10];[9 11]};%switch
clc;
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Delta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,delta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),2,delta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Theta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,theta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),2,theta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
time = [find(times==700):find(times==1200)]; %wanted extraction time
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Alpha');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,alpha,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),2,alpha,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Beta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,beta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),2,beta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
%% repeat targets vs. other targets
test_pairs = {[10 2];[11 3];[10 7];[11 8]};%repeat
clc;
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Delta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,delta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,delta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Theta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,theta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,theta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
time = [find(times==700):find(times==1200)]; %wanted extraction time
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Alpha');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,alpha,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,alpha,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Beta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),1,beta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,beta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
%%
%% repeat targets vs. other targets
test_pairs = {[10 2];[11 3];[10 7];[11 8]};%repeat
clc;
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Delta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,delta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,delta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Theta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,theta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,theta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
time = [find(times==700):find(times==1200)]; %wanted extraction time
for test_i = 1:length(test_pairs)
    fprintf('\n%s\n','Alpha');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,alpha,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,alpha,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
    fprintf('\n%s\n','Beta');
    x = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(1),2,beta,time),3),4),5));
    y = squeeze(mean(mean(mean(power(:,test_pairs{test_i}(2),:,beta,time),3),4),5));
    [~,p,~,stat]=ttest(x,y);
    xcond = wpms.conditions{test_pairs{test_i}(1)};
    ycond = wpms.conditions{test_pairs{test_i}(2)};
    fprintf('%s %s %s: %s %2.2f %s %1.4f\n',xcond,'vs', ycond,'t:',stat.tstat,'p:',p);
end
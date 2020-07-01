%Fz = 38
clear all
close all
load ('E:\fieldtrip\FUNCTIONS\LIST_ACTIVE_SHAM');
names = struct('pnum',{ 'DCR102' 'DCR103' 'DCR104' 'DCR106' 'DCR107' 'DCR108' 'DCR109' 'DCR110' 'DCR111' ... 
    'DCR112' 'DCR113' 'DCR114' 'DCR115' 'DCR117' 'DCR118' 'DCR119' 'DCR120' 'DCR121' ...
    'DCR122' 'DCR123' 'DCR124' 'DCR125' 'DCR202' 'DCR203' 'DCR204' 'DCR206' 'DCR207' ... 
    'DCR208' 'DCR209' 'DCR210' 'DCR211' 'DCR212' 'DCR213' 'DCR214' 'DCR215' 'DCR217' ... 
    'DCR218' 'DCR219' 'DCR220' 'DCR221' 'DCR222' 'DCR223' 'DCR224' 'DCR225'});
conditions = {'dirleft' 'dirright' 'nondirleft' 'nondirright'};
channels = 1:64;
SHAM = [SHAM(1:13) SHAM(15:23)];
ACTIVE = [ACTIVE(1:13) ACTIVE(15:23)];


beta = 48:68;
scale = 48:68;
times  = [1000:200:1200, 2500:200:2700];% = 200ms pre cue
timeticks = times-800;
timeticks = mat2cell(timeticks,1,4);
timeticks{2} = '';timeticks{4}= '';timeticks{6}= '';timeticks{8}= '';timeticks{10}= '';
power = [];
power.dirleft =  zeros(length(names),length(channels),length(scale),length(times));
power.dirright =  zeros(length(names),length(channels),length(scale),length(times));
power.nondirleft =  zeros(length(names),length(channels),length(scale),length(times));
power.nondirright =  zeros(length(names),length(channels),length(scale),length(times));
CWD = 'E:\fieldtrip\WAVELET_OUTPUT\';
addpath('E:\fieldtrip\FUNCTIONS');

%Delta
%ticks = [[2,2.08317348339461,2.16980588095922,2.26004103766396,2.35402878052260,2.45192516736622,2.55389274596260,2.66010082391156,2.77072574976436,2.88595120583388,3.00596851318192,3.13097694928985,3.26118407894019,3.39680609885843,3.53806819668749,3.68520492489058,3.83846059020364,3.99808965928373];
%Theta
%ticks = [[4.16435718122703,4.33753922765803,4.51792335112057,4.70580906253185,4.90150832849220,5.10534608927639,5.31766079836647,5.53880498442202,5.76914583662093,6.00906581434257,6.25896328220573,6.51925317151574,6.79036766921890]];
%Lower Alpha
%ticks = [[7.99236046183574,8.32473669191385,8.67093536641855,9.03153131577582,9.40712327573611,9.79833488151886]];
%Upper Alpha
%ticks = [[10.2058157033003,10.6302423247637,11.0723194665034,11.5327811561470,12.0123919471392,12.5119481882116,13.0322793456449]];
%Beta
ticks = [[13.5742493805193,14.1387581832418,14.7267430677289,15.3391803277291,15.9770868578668,16.6415218421003,17.3335885123978,18.0544359805502,18.8052611461639,19.5873106839998,20.4018831139602,21.2503309571590,22.1340629816566,23.0545465415867,24.0133100135601,25.0119453343914,26.0521106443598,27.1355330403964,28.2640114437661,29.4394195870076,30.6637091250911;]];

ticks = sort(ticks,'descend');
%ticks = mat2cell(ticks,1,21);
h = waitbar(0,'Loading . . .');

%% FOR SHAM
for chan_i = 1:length(channels);
for name_i = 1:length(SHAM)
    waitbar(name_i/length(SHAM),h)
    for cond_i = 1:length(conditions)
        load([CWD names{name_i} '\' conditions{cond_i} '\' names{name_i} '_' conditions{cond_i} '_' num2str(chan_i) '_SHAM_imagcoh_mwtf.mat'])
        power.(conditions{cond_i})(name_i,:,:,:) = mw_tf(scale,times);
        clear mw_tf
    end
end
end
close(h);
for cond_i = 1:length(conditions)
    for x = 1:size(power.(conditions{cond_i}),2);
        if x == 1
            power2.(conditions{cond_i})(:,x,:) = power.(conditions{cond_i})(:,end,:);
        elseif x == size(power.(conditions{cond_i}),2)
            power2.(conditions{cond_i})(:,x,:) = power.(conditions{cond_i})(:,end-x+1,:);
        else
            power2.(conditions{cond_i})(:,x,:) = power.(conditions{cond_i})(:,end-x,:);
        end
    end
end
figure();
set(gcf,'Color',[1 1 1]);
hold on;
for cond_i = 1:length(conditions)
    subplot(2,2,cond_i); imagesc(squeeze(mean(power2.(conditions{cond_i}),1)));
    title(conditions{cond_i});
    set(gca,'YTick',1:2.1667:13,'XTick',1:400:2001,'XTickLabel',timeticks{1,1},'YTickLabel',ticks{1,1});
    caxis([-1 0.5]);
end
saveas(gcf,'F:\WAVELET_OUTPUT\Beta_FFT_Plots.pdf','pdf');
%% FOR ACTIVE
for chan_i = 1:length(channels);
for name_i = 1:length(names)
    waitbar(name_i/length(names),h)
    for cond_i = 1:length(conditions)
        load([CWD names{name_i} '\' conditions{cond_i} '\' names{name_i} '_' conditions{cond_i} '_' num2str(chan_i) '_ACTIVE_imagcoh_mwtf.mat'])
        power.(conditions{cond_i})(name_i,:,:,:) = mw_tf(scale,times);
        clear mw_tf
    end
end
end
close(h);
for cond_i = 1:length(conditions)
    for x = 1:size(power.(conditions{cond_i}),2);
        if x == 1
            power2.(conditions{cond_i})(:,x,:) = power.(conditions{cond_i})(:,end,:);
        elseif x == size(power.(conditions{cond_i}),2)
            power2.(conditions{cond_i})(:,x,:) = power.(conditions{cond_i})(:,end-x+1,:);
        else
            power2.(conditions{cond_i})(:,x,:) = power.(conditions{cond_i})(:,end-x,:);
        end
    end
end
figure();
set(gcf,'Color',[1 1 1]);
hold on;
for cond_i = 1:length(conditions)
    subplot(2,2,cond_i); imagesc(squeeze(mean(power2.(conditions{cond_i}),1)));
    title(conditions{cond_i});
    set(gca,'YTick',1:2.1667:13,'XTick',1:400:2001,'XTickLabel',timeticks{1,1},'YTickLabel',ticks{1,1});
    caxis([-1 0.5]);
end
saveas(gcf,'F:\WAVELET_OUTPUT\Beta_FFT_Plots.pdf','pdf');

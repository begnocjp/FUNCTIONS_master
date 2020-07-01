%% Determine phase of theta waves during task switching
% Patrick Cooper, 2014 
% Functional Neuroimaging Laboratory, University of Newcastle
%% Set up globals
CWD = 'F:\FNL_EEG_TOOLBOX\';
WAVELET_OUTPUT = 'WAVELET_OUTPUT_DIR';
cd([CWD WAVELET_OUTPUT]);
names = {'AGE059'  'AGE067'  'AGE077'  'AGE086'  'AGE094'  'AGE102'  'AGE109' ...
        'AGE119'  'AGE128'  'AGE136'  'AGE150'  'AGE158'  'AGE166'  'AGE175'  ...
        'AGE182'  'AGE061'  'AGE068'  'AGE079'  'AGE088'  'AGE095'  'AGE103'  ...
        'AGE114'  'AGE120'  'AGE129'  'AGE138'  'AGE151'  'AGE159'  'AGE167'  ...
        'AGE176'  'AGE184'  'AGE005'  'AGE062'  'AGE069'  'AGE081'  'AGE089'  ...
        'AGE096'  'AGE104'  'AGE115'  'AGE121'  'AGE130'  'AGE146'  'AGE152'  ...
        'AGE161'  'AGE168'  'AGE177'  'AGE185'  'AGE007'  'AGE063'  'AGE070'  ...
        'AGE083'  'AGE090'  'AGE097'  'AGE106'  'AGE116'  'AGE122'  'AGE131'  ...
        'AGE147'  'AGE153'  'AGE162'  'AGE169'  'AGE178'  'AGE186'  'AGE020'  ...
        'AGE064'  'AGE072'  'AGE084'  'AGE092'  'AGE098'  'AGE107'  'AGE117'  ...
        'AGE123'  'AGE133'  'AGE148'  'AGE155'  'AGE164'  'AGE170'  'AGE180'  ...
        'AGE187'  'AGE053'  'AGE066'  'AGE075'  'AGE085'  'AGE093'  'AGE100'  ...
        'AGE108'  'AGE118'  'AGE124'  'AGE134'  'AGE149'  'AGE156'  'AGE165'  ...
        'AGE172'  'AGE181'  'AGE195'};
conditions = {'mixrepeat','switchto','switchaway','noninf'};
channels = 1:64;
channelofinterest = 30;%Poz
%% Main Loop
mr = zeros(length(names),80,5201);
st = zeros(length(names),80,5201);
sa = zeros(length(names),80,5201);
ni = zeros(length(names),80,5201);
for name_i = 1:length(names)
    fprintf('.');
    for cond_i =1:length(conditions)
        load([CWD WAVELET_OUTPUT '\' names{name_i} '\' conditions{cond_i} '\' names{name_i} '_' conditions{cond_i} '_' num2str(channelofinterest) '_imagcoh_mwtf.mat']);
        switch cond_i
            case 1
                mr(name_i,:,:) = complex_mw_tf;
            case 2
                st(name_i,:,:) = complex_mw_tf;
            case 3
                sa(name_i,:,:) = complex_mw_tf;
            case 4
                ni(name_i,:,:) = complex_mw_tf;
        end
    end
end
%plot theta waves
times =800:2800;
figure();
for freq = 4:7;
    hold on;
    plot(imag(squeeze(mean((st(freq,times)),1))),'-b');
    plot(imag(squeeze(mean((mr(freq,times)),1))),'-r');
    plot(imag(squeeze(mean((sa(freq,times)),1))),'-g');
    plot(imag(squeeze(mean((ni(freq,times)),1))),'-k');
end
%plot angle in degrees
figure();
for freq = 4:7;
    hold on;
    plot(squeeze(mean(angle(st(freq,times)).*(180/pi),1)),'-b');
    plot(squeeze(mean(angle(mr(freq,times)).*(180/pi),1)),'-r');
    plot(squeeze(mean(angle(sa(freq,times)).*(180/pi),1)),'-g');
    plot(squeeze(mean(angle(ni(freq,times)).*(180/pi),1)),'-k');
end
rt = [694.308	21.645;
817.346	32.303;
927.264	31.025;
858.733	23.373];

means = [rt(1,1); rt(2,1); rt(3,1); rt(4,1)];
stes = [rt(1,2); rt(2,2); rt(3,2); rt(4,2)];

bar(means,'-r','g')
hold on;
errorbar(means(1,1),stes(1,1),'r');
hold on;
errorbar(means(1,2),stes(1,2),'g');
set(h,'none')



x = [1,3,5,7,9]; % place bars at these points along x-axis
series1 = [10,25,90,35,16];
series2 = [21.645,31,50,41];
figure
width1 = 0.5;
bar(x,series1,width1,'FaceColor',[0.2,0.2,0.5],....
                     'EdgeColor','none');
                 
x = [1,3,5,7]; % place bars at these points along x-axis
MixRepeat = [694.308,0,0,0];
SwitchTo = [0,817.346,0,0];
SwitchAway = [0,0,927.264,0];
NonInf = [0,0,0,858.733];
MixRepeat_sted = [21.645,0,0,0];
SwitchTo_sted = [0,32.303,0,0];
SwitchAway_sted = [0,0,31.025,0];
NonInf_sted = [0,0,0,23.373];
figure();
width1 = 0.5;
bar(x,MixRepeat,width1,'r');
hold on
bar(x,SwitchTo,width1,'b');
hold on
bar(x,SwitchAway,width1,'g');
hold on
bar(x,NonInf,width1,'black');
ylim([500 1000]);
legend('Mix Repeat','Switch To','Switch Away', 'Non Informative') % add legend
hold on
errorbar(x,MixRepeat,MixRepeat_sted,'.r');
hold on
errorbar(x,SwitchTo,SwitchTo_sted,'.b');
hold on
errorbar(x,SwitchAway,SwitchAway_sted,'.g');
hold on
errorbar(x,NonInf,NonInf_sted,'.black');
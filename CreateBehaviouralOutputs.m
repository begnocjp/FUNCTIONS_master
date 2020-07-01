%% Behavioural Results
% set up globals
CWD         = 'F:\fieldtrip';
BEHAV       = 'ANALYSES\Behavioural';
mkdir([CWD,'\',BEHAV]);
cd([CWD,'\',BEHAV]);
%% Accuracy Data
% from SPSS Repeated Measures ANOVA
% 4(TrialType) * 3(Task)
% for anova values - first column = trialtype, second = task, third = 
% interaction
Fstat = [7.362409;2.966837;1.386364];
pval  = [0.000194;0.059609;0.222792];
df    = [3,84;2,56;6,168];
trialmeans = [0.985900,0.964975,0.966444,0.968413;   % MR,ST,SA,NI means
                0.003029,0.008096,0.008849,0.005887];% MR,ST,SA,NI sterr
taskmeans  = [0.976757,0.966243,0.971299;
                0.006606,0.006519,0.006651];
            
%create tmp structures for plotting
savename = [CWD '\' BEHAV '\Accuracy'];
legendtxt  = {'Mix Repeat','Switch To','Switch Away', 'Non Informative'};
colourlist = {'r','b','g','black';'.r','.b','.g','.black'};

barwitherrors(trialmeans,'Trial Type',[0.9 1], legendtxt, colourlist);
cd([CWD,'\',BEHAV])
saveas(gca,savename,'bmp');

accuracy_filename = 'Accuracy_ANOVA_Results.txt';
fid = fopen(accuracy_filename,'w');
fprintf(fid,'ACCURACY 4(TRIALTYPE)*3(TASK) REPEAT MEASURES ANOVA\n');
fprintf(fid,'%s%1.0f,%1.0f%s %1.3f %s %1.4f\n', 'Main Effect of TrialType: F(',df(1,1),df(1,2),') = ',Fstat(1,1),', p =',pval(1,1));
fprintf(fid,'%s%1.0f,%1.0f%s %1.3f %s %1.4f\n', 'Main Effect of TaskType: F(',df(2,1),df(2,2),') = ',Fstat(2,1),', p =',pval(2,1));
fprintf(fid,'%s%1.0f,%1.0f%s %1.3f %s %1.4f\n', 'No Significant Interaction: F(',df(3,1),df(3,2),') = ',Fstat(3,1),', p =',pval(3,1));
fclose('all');

%% RT Data
% from SPSS Repeated Measures ANOVA
% 4(TrialType) * 3(Task)
% for anova values - first column = trialtype, second = task, third = 
% interaction
Fstat = [120.005454;24.454396;1.676090];
pval  = [0.000000;0.000000;0.129697];
df    = [3,84;2,56;6,168];
trialmeans = [694.308116,817.345876,927.264125,858.733022;   % MR,ST,SA,NI means
                21.645314,32.303329,31.025125,23.372904];% MR,ST,SA,NI sterr
taskmeans  = [843.797449,866.736251,762.704654;
                29.084913,28.222010,26.229690];
            
%create tmp structures for plotting
savename = [CWD '\' BEHAV '\RT'];
legendtxt  = {'Mix Repeat','Switch To','Switch Away', 'Non Informative'};
colourlist = {'r','b','g','black';'.r','.b','.g','.black'};

cd([CWD,'\FUNCTIONS']);
barwitherrors(trialmeans,'Trial Type',[500 1000], legendtxt, colourlist);
cd([CWD,'\',BEHAV])
saveas(gca,savename,'bmp');

accuracy_filename = 'ReactionTime_ANOVA_Results.txt';
fid = fopen(accuracy_filename,'w');
fprintf(fid,'RT 4(TRIALTYPE)*3(TASK) REPEAT MEASURES ANOVA\n');
fprintf(fid,'%s%1.0f,%1.0f%s %1.3f %s %1.4f\n', 'Main Effect of TrialType: F(',df(1,1),df(1,2),') = ',Fstat(1,1),', p =',pval(1,1));
fprintf(fid,'%s%1.0f,%1.0f%s %1.3f %s %1.4f\n', 'Main Effect of TaskType: F(',df(2,1),df(2,2),') = ',Fstat(2,1),', p =',pval(2,1));
fprintf(fid,'%s%1.0f,%1.0f%s %1.3f %s %1.4f\n', 'No Significant Interaction: F(',df(3,1),df(3,2),') = ',Fstat(3,1),', p =',pval(3,1));
fclose('all');

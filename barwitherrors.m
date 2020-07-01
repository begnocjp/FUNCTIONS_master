function barwitherrors(trials, xtitle, ylimit, legendtxt, colourlist)
% BARWITHERRORS             creates bar plot with standard error bars
%
% USEAGE:           barwitherrors(trials,xtitle,ylimit,legendtxt,colourlist)
%                   trials = 2xN matrix containing values to plot
%                            trials(1,..) = observed values
%                            trials(2,..) = standard errors
%                   xtitle = {'string'} Title for x Axis
%                   ylimit = [MIN MAX] values corresponding to yaxis scale
%                   legendtxt = {'string1','string2',...}
%                               labels for legend
%                   colourlist = {'string1','string2',...;
%                                  '.string1','.string2' ....}
%                               colours for bargraph
%                               need to be in appropriate format for
%                               plotting functions 'e.g. red = 'r'
%                               can include additional line specs
%                               e.g. '-r'
%
%
% Patrick Cooper, 2013 University of Newcastle
%

% Move values from trials structure to tmp variables for plotting
for trial_i = 1:size(trials,2)
    eval(['tmpmean' num2str(trial_i) ' = zeros(1,' num2str(size(trials,2)) ');']); % fill with zeroes
    eval(['tmpster' num2str(trial_i) ' = zeros(1,' num2str(size(trials,2)) ');']); % fill with zeroes
    eval(['tmpmean' num2str(trial_i) '(1,' num2str(trial_i) ') = trials(1,' num2str(trial_i) ');']); % insert values
    eval(['tmpster' num2str(trial_i) '(1,' num2str(trial_i) ') = trials(2,' num2str(trial_i) ');']); % insert values
end%trial_i loop

% Create locations for x axis ticks
xval = -1;
x = [];
for var_count = 1:size(trials,2)
    xval = xval + 2;
    x = [x,xval];
end%var_count
clear xval
% Remove xaxis ticks
for trial_i = 1:size(trials,2)
    blankxlabels{trial_i} = {' '};
end%trial_i
% Create barplot with errorbars
figure
for trial_i = 1:size(trials,2)
    width = 0.5;
    currentmeancolour = colourlist{1,trial_i};
    currentstedcolour = colourlist{2,trial_i};
    currentblanklabel = blankxlabels{1,trial_i};
    legend(legendtxt,'Location','NorthEast') % add legend
    eval(['bar(x,tmpmean' num2str(trial_i) ',' 'width' ',''' currentmeancolour ''');']);
    hold on
    eval(['errorbar(x,tmpmean' num2str(trial_i), ',tmpster' num2str(trial_i) ',''' currentstedcolour ''');']);
    set(gca,'XTickLabel',currentblanklabel);
    xlabel(xtitle);
    set(gcf,'Color','white')
    ylim(ylimit);
    hold on
end%trial_i loop
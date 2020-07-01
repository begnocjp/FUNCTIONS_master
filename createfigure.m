function createfigure(X1, Y1, Z1, S1, C1, XMatrix1, YMatrix1, ZMatrix1, XMatrix2, YMatrix2, ZMatrix2, XMatrix3, YMatrix3, ZMatrix3, XMatrix4, YMatrix4, ZMatrix4, XMatrix5, YMatrix5, ZMatrix5, XMatrix6, YMatrix6, ZMatrix6, XMatrix7, YMatrix7, ZMatrix7, XMatrix8, YMatrix8, ZMatrix8, XMatrix9, YMatrix9, ZMatrix9, XMatrix10, YMatrix10, ZMatrix10, XMatrix11, YMatrix11, ZMatrix11, XMatrix12, YMatrix12, ZMatrix12, XMatrix13, YMatrix13, ZMatrix13, XMatrix14, YMatrix14, ZMatrix14, XMatrix15, YMatrix15, ZMatrix15, XMatrix16, YMatrix16, ZMatrix16, XMatrix17, YMatrix17, ZMatrix17, XMatrix18, YMatrix18, ZMatrix18, XMatrix19, YMatrix19, ZMatrix19, XMatrix20, YMatrix20, ZMatrix20, XMatrix21, YMatrix21, ZMatrix21, XMatrix22, YMatrix22, ZMatrix22, XMatrix23, YMatrix23, ZMatrix23, XMatrix24, YMatrix24, ZMatrix24, XMatrix25, YMatrix25, ZMatrix25, XMatrix26, YMatrix26, ZMatrix26, XMatrix27, YMatrix27, ZMatrix27, XMatrix28, YMatrix28, ZMatrix28, XMatrix29, YMatrix29, ZMatrix29, XMatrix30, YMatrix30, ZMatrix30, XMatrix31, YMatrix31, ZMatrix31, XMatrix32, YMatrix32, ZMatrix32, XMatrix33, YMatrix33, ZMatrix33, XMatrix34, YMatrix34, ZMatrix34, XMatrix35, YMatrix35, ZMatrix35, XMatrix36, YMatrix36, ZMatrix36, XMatrix37, YMatrix37, ZMatrix37, XMatrix38, YMatrix38, ZMatrix38, XMatrix39, YMatrix39, ZMatrix39, XMatrix40, YMatrix40, ZMatrix40, XMatrix41, YMatrix41, ZMatrix41, S2, C2)
%CREATEFIGURE(X1,Y1,Z1,S1,C1,XMATRIX1,YMATRIX1,ZMATRIX1,XMATRIX2,YMATRIX2,ZMATRIX2,XMATRIX3,YMATRIX3,ZMATRIX3,XMATRIX4,YMATRIX4,ZMATRIX4,XMATRIX5,YMATRIX5,ZMATRIX5,XMATRIX6,YMATRIX6,ZMATRIX6,XMATRIX7,YMATRIX7,ZMATRIX7,XMATRIX8,YMATRIX8,ZMATRIX8,XMATRIX9,YMATRIX9,ZMATRIX9,XMATRIX10,YMATRIX10,ZMATRIX10,XMATRIX11,YMATRIX11,ZMATRIX11,XMATRIX12,YMATRIX12,ZMATRIX12,XMATRIX13,YMATRIX13,ZMATRIX13,XMATRIX14,YMATRIX14,ZMATRIX14,XMATRIX15,YMATRIX15,ZMATRIX15,XMATRIX16,YMATRIX16,ZMATRIX16,XMATRIX17,YMATRIX17,ZMATRIX17,XMATRIX18,YMATRIX18,ZMATRIX18,XMATRIX19,YMATRIX19,ZMATRIX19,XMATRIX20,YMATRIX20,ZMATRIX20,XMATRIX21,YMATRIX21,ZMATRIX21,XMATRIX22,YMATRIX22,ZMATRIX22,XMATRIX23,YMATRIX23,ZMATRIX23,XMATRIX24,YMATRIX24,ZMATRIX24,XMATRIX25,YMATRIX25,ZMATRIX25,XMATRIX26,YMATRIX26,ZMATRIX26,XMATRIX27,YMATRIX27,ZMATRIX27,XMATRIX28,YMATRIX28,ZMATRIX28,XMATRIX29,YMATRIX29,ZMATRIX29,XMATRIX30,YMATRIX30,ZMATRIX30,XMATRIX31,YMATRIX31,ZMATRIX31,XMATRIX32,YMATRIX32,ZMATRIX32,XMATRIX33,YMATRIX33,ZMATRIX33,XMATRIX34,YMATRIX34,ZMATRIX34,XMATRIX35,YMATRIX35,ZMATRIX35,XMATRIX36,YMATRIX36,ZMATRIX36,XMATRIX37,YMATRIX37,ZMATRIX37,XMATRIX38,YMATRIX38,ZMATRIX38,XMATRIX39,YMATRIX39,ZMATRIX39,XMATRIX40,YMATRIX40,ZMATRIX40,XMATRIX41,YMATRIX41,ZMATRIX41,S2,C2)
%  X1:  scatter3 x
%  Y1:  scatter3 y
%  Z1:  scatter3 z
%  S1:  scatter3 s
%  C1:  scatter3 c
%  XMATRIX1:  matrix of x data
%  YMATRIX1:  matrix of y data
%  ZMATRIX1:  matrix of z data
%  XMATRIX2:  matrix of x data
%  YMATRIX2:  matrix of y data
%  ZMATRIX2:  matrix of z data
%  XMATRIX3:  matrix of x data
%  YMATRIX3:  matrix of y data
%  ZMATRIX3:  matrix of z data
%  XMATRIX4:  matrix of x data
%  YMATRIX4:  matrix of y data
%  ZMATRIX4:  matrix of z data
%  XMATRIX5:  matrix of x data
%  YMATRIX5:  matrix of y data
%  ZMATRIX5:  matrix of z data
%  XMATRIX6:  matrix of x data
%  YMATRIX6:  matrix of y data
%  ZMATRIX6:  matrix of z data
%  XMATRIX7:  matrix of x data
%  YMATRIX7:  matrix of y data
%  ZMATRIX7:  matrix of z data
%  XMATRIX8:  matrix of x data
%  YMATRIX8:  matrix of y data
%  ZMATRIX8:  matrix of z data
%  XMATRIX9:  matrix of x data
%  YMATRIX9:  matrix of y data
%  ZMATRIX9:  matrix of z data
%  XMATRIX10:  matrix of x data
%  YMATRIX10:  matrix of y data
%  ZMATRIX10:  matrix of z data
%  XMATRIX11:  matrix of x data
%  YMATRIX11:  matrix of y data
%  ZMATRIX11:  matrix of z data
%  XMATRIX12:  matrix of x data
%  YMATRIX12:  matrix of y data
%  ZMATRIX12:  matrix of z data
%  XMATRIX13:  matrix of x data
%  YMATRIX13:  matrix of y data
%  ZMATRIX13:  matrix of z data
%  XMATRIX14:  matrix of x data
%  YMATRIX14:  matrix of y data
%  ZMATRIX14:  matrix of z data
%  XMATRIX15:  matrix of x data
%  YMATRIX15:  matrix of y data
%  ZMATRIX15:  matrix of z data
%  XMATRIX16:  matrix of x data
%  YMATRIX16:  matrix of y data
%  ZMATRIX16:  matrix of z data
%  XMATRIX17:  matrix of x data
%  YMATRIX17:  matrix of y data
%  ZMATRIX17:  matrix of z data
%  XMATRIX18:  matrix of x data
%  YMATRIX18:  matrix of y data
%  ZMATRIX18:  matrix of z data
%  XMATRIX19:  matrix of x data
%  YMATRIX19:  matrix of y data
%  ZMATRIX19:  matrix of z data
%  XMATRIX20:  matrix of x data
%  YMATRIX20:  matrix of y data
%  ZMATRIX20:  matrix of z data
%  XMATRIX21:  matrix of x data
%  YMATRIX21:  matrix of y data
%  ZMATRIX21:  matrix of z data
%  XMATRIX22:  matrix of x data
%  YMATRIX22:  matrix of y data
%  ZMATRIX22:  matrix of z data
%  XMATRIX23:  matrix of x data
%  YMATRIX23:  matrix of y data
%  ZMATRIX23:  matrix of z data
%  XMATRIX24:  matrix of x data
%  YMATRIX24:  matrix of y data
%  ZMATRIX24:  matrix of z data
%  XMATRIX25:  matrix of x data
%  YMATRIX25:  matrix of y data
%  ZMATRIX25:  matrix of z data
%  XMATRIX26:  matrix of x data
%  YMATRIX26:  matrix of y data
%  ZMATRIX26:  matrix of z data
%  XMATRIX27:  matrix of x data
%  YMATRIX27:  matrix of y data
%  ZMATRIX27:  matrix of z data
%  XMATRIX28:  matrix of x data
%  YMATRIX28:  matrix of y data
%  ZMATRIX28:  matrix of z data
%  XMATRIX29:  matrix of x data
%  YMATRIX29:  matrix of y data
%  ZMATRIX29:  matrix of z data
%  XMATRIX30:  matrix of x data
%  YMATRIX30:  matrix of y data
%  ZMATRIX30:  matrix of z data
%  XMATRIX31:  matrix of x data
%  YMATRIX31:  matrix of y data
%  ZMATRIX31:  matrix of z data
%  XMATRIX32:  matrix of x data
%  YMATRIX32:  matrix of y data
%  ZMATRIX32:  matrix of z data
%  XMATRIX33:  matrix of x data
%  YMATRIX33:  matrix of y data
%  ZMATRIX33:  matrix of z data
%  XMATRIX34:  matrix of x data
%  YMATRIX34:  matrix of y data
%  ZMATRIX34:  matrix of z data
%  XMATRIX35:  matrix of x data
%  YMATRIX35:  matrix of y data
%  ZMATRIX35:  matrix of z data
%  XMATRIX36:  matrix of x data
%  YMATRIX36:  matrix of y data
%  ZMATRIX36:  matrix of z data
%  XMATRIX37:  matrix of x data
%  YMATRIX37:  matrix of y data
%  ZMATRIX37:  matrix of z data
%  XMATRIX38:  matrix of x data
%  YMATRIX38:  matrix of y data
%  ZMATRIX38:  matrix of z data
%  XMATRIX39:  matrix of x data
%  YMATRIX39:  matrix of y data
%  ZMATRIX39:  matrix of z data
%  XMATRIX40:  matrix of x data
%  YMATRIX40:  matrix of y data
%  ZMATRIX40:  matrix of z data
%  XMATRIX41:  matrix of x data
%  YMATRIX41:  matrix of y data
%  ZMATRIX41:  matrix of z data
%  S2:  scatter3 s
%  C2:  scatter3 c

%  Auto-generated by MATLAB on 28-May-2014 10:55:27

% Create figure
figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Visible','off','Parent',figure1,'DataAspectRatio',[1 1 1]);
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[-0.999779218981721 0.929712221872254]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[-0.950959388812057 0.950959388812057]);
%% Uncomment the following line to preserve the Z-limits of the axes
% zlim(axes1,[-0.088111980706191 1]);
view(axes1,[-90.5 90]);
hold(axes1,'all');

% Create scatter3
scatter3(X1,Y1,Z1,S1,C1,'MarkerFaceColor','flat','MarkerEdgeColor','none');

% Create multiple lines using matrix input to plot3
plot3(XMatrix1,YMatrix1,ZMatrix1,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix2,YMatrix2,ZMatrix2,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix3,YMatrix3,ZMatrix3,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix4,YMatrix4,ZMatrix4,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix5,YMatrix5,ZMatrix5,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix6,YMatrix6,ZMatrix6,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix7,YMatrix7,ZMatrix7,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix8,YMatrix8,ZMatrix8,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix9,YMatrix9,ZMatrix9,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix10,YMatrix10,ZMatrix10,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix11,YMatrix11,ZMatrix11,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix12,YMatrix12,ZMatrix12,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix13,YMatrix13,ZMatrix13,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix14,YMatrix14,ZMatrix14,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix15,YMatrix15,ZMatrix15,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix16,YMatrix16,ZMatrix16,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix17,YMatrix17,ZMatrix17,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix18,YMatrix18,ZMatrix18,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix19,YMatrix19,ZMatrix19,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix20,YMatrix20,ZMatrix20,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix21,YMatrix21,ZMatrix21,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix22,YMatrix22,ZMatrix22,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix23,YMatrix23,ZMatrix23,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix24,YMatrix24,ZMatrix24,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix25,YMatrix25,ZMatrix25,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix26,YMatrix26,ZMatrix26,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix27,YMatrix27,ZMatrix27,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix28,YMatrix28,ZMatrix28,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix29,YMatrix29,ZMatrix29,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix30,YMatrix30,ZMatrix30,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix31,YMatrix31,ZMatrix31,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix32,YMatrix32,ZMatrix32,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix33,YMatrix33,ZMatrix33,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix34,YMatrix34,ZMatrix34,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix35,YMatrix35,ZMatrix35,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix36,YMatrix36,ZMatrix36,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix37,YMatrix37,ZMatrix37,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix38,YMatrix38,ZMatrix38,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix39,YMatrix39,ZMatrix39,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix40,YMatrix40,ZMatrix40,'Parent',axes1,'Color',[0.5 0.5 0.5]);

% Create multiple lines using matrix input to plot3
plot3(XMatrix41,YMatrix41,ZMatrix41,'Color',[0.5 0.5 0.5]);

% Create scatter3
scatter3(X1,Y1,Z1,S2,C2,'MarkerFaceColor','flat','MarkerEdgeColor','none');

% Create text
text('Parent',axes1,'String',' AF3',...
    'Position',[0.895914903158642 0.370385844688008 0.245256625502742]);

% Create text
text('Parent',axes1,'String',' F1',...
    'Position',[0.704855649939034 0.306377569293828 0.639774411634779]);

% Create text
text('Parent',axes1,'String',' F3',...
    'Position',[0.677071334036459 0.567063850794575 0.469055431423747]);

% Create text
text('Parent',axes1,'String',' F5',...
    'Position',[0.635739860155896 0.741861433700567 0.213252065398443]);

% Create text
text('Parent',axes1,'String',' FC5',...
    'Position',[0.338386158063031 0.897027817764154 0.28431655278689]);

% Create text
text('Parent',axes1,'String',' FC3',...
    'Position',[0.364179822978724 0.697352684424579 0.617310529685845]);

% Create text
text('Parent',axes1,'String',' FC1',...
    'Position',[0.381602163514583 0.380604436837979 0.842330132109872]);

% Create text
text('Parent',axes1,'String',' C1',...
    'Position',[2.48800497406205e-17 0.406322047433479 0.913729934810864]);

% Create text
text('Parent',axes1,'String',' C3',...
    'Position',[4.55073568957136e-17 0.743191537795185 0.669078723432175]);

% Create text
text('Parent',axes1,'String',' C5',...
    'Position',[5.82294685813904e-17 0.950959388812057 0.309315762337129]);

% Create text
text('Parent',axes1,'String',' CP5',...
    'Position',[-0.338417470034671 0.897016005312454 0.28431655278689]);

% Create text
text('Parent',axes1,'String',' CP3',...
    'Position',[-0.364118966090153 0.697384462454118 0.617310529685845]);

% Create text
text('Parent',axes1,'String',' CP1',...
    'Position',[-0.381568948058739 0.380637736459633 0.842330132109872]);

% Create text
text('Parent',axes1,'String',' P1',...
    'Position',[-0.704871690864841 0.306340662718341 0.639774411634779]);

% Create text
text('Parent',axes1,'String',' P3',...
    'Position',[-0.677041641714562 0.567099301389389 0.469055431423747]);

% Create text
text('Parent',axes1,'String',' P5',...
    'Position',[-0.635804597358154 0.741805952107109 0.213252065398443]);

% Create text
text('Parent',axes1,'String',' P7',...
    'Position',[-0.586764241388238 0.804949690281397 -0.088111980706191]);

% Create text
text('Parent',axes1,'String',' PO7',...
    'Position',[-0.808150723478523 0.584788629573007 -0.0701046850307777]);

% Create text
text('Parent',axes1,'String',' PO3',...
    'Position',[-0.895921367474678 0.370370207966719 0.245256625502742]);

% Create text
text('Parent',axes1,'String',' O1',...
    'Position',[-0.950378695807622 0.307513577982048 -0.047071582846585]);

% Create text
text('Parent',axes1,'String',' Oz',...
    'Position',[-0.999779218981721 -1.22437642038e-16 -0.0210122176911628]);

% Create text
text('Parent',axes1,'String',' POz',...
    'Position',[-0.929712221872254 -1.13856909664403e-16 0.36828682368686]);

% Create text
text('Parent',axes1,'String',' Pz',...
    'Position',[-0.714570364099559 -8.75096309160084e-17 0.69956357448814]);

% Create text
text('Parent',axes1,'String',' CPz',...
    'Position',[-0.387386866297129 -4.74412085842503e-17 0.921917249985317]);

% Create text
text('Parent',axes1,'String',' AF4',...
    'Position',[0.895914903158642 -0.370385844688008 0.245256625502742]);

% Create text
text('Parent',axes1,'String',' Afz',...
    'Position',[0.929712221872254 0 0.36828682368686]);

% Create text
text('Parent',axes1,'String',' Fz',...
    'Position',[0.714570364099559 0 0.69956357448814]);

% Create text
text('Parent',axes1,'String',' F2',...
    'Position',[0.704404856070726 -0.306181624025266 0.640364436749285]);

% Create text
text('Parent',axes1,'String',' F4',...
    'Position',[0.677459130668359 -0.566383487864145 0.469317452210033]);

% Create text
text('Parent',axes1,'String',' F6',...
    'Position',[0.635603929959277 -0.741702813206766 0.214206865206255]);

% Create text
text('Parent',axes1,'String',' FC6',...
    'Position',[0.338386158063031 -0.897027817764154 0.28431655278689]);

% Create text
text('Parent',axes1,'String',' FC4',...
    'Position',[0.364179822978724 -0.697352684424579 0.617310529685845]);

% Create text
text('Parent',axes1,'String',' FC2',...
    'Position',[0.381602163514583 -0.380604436837979 0.842330132109872]);

% Create text
text('Parent',axes1,'String',' FCz',...
    'Position',[0.387386866297129 0 0.921917249985317]);

% Create text
text('Parent',axes1,'String',' Cz','Position',[6.12323399573677e-17 0 1]);

% Create text
text('Parent',axes1,'String',' C2',...
    'Position',[2.49317940449975e-17 -0.407167096053426 0.913353686088484]);

% Create text
text('Parent',axes1,'String',' C4',...
    'Position',[4.55044965911905e-17 -0.743144825477394 0.669130606358858]);

% Create text
text('Parent',axes1,'String',' C6',...
    'Position',[5.82294685813904e-17 -0.950959388812057 0.309315762337129]);

% Create text
text('Parent',axes1,'String',' CP6',...
    'Position',[-0.338417470034671 -0.897016005312454 0.28431655278689]);

% Create text
text('Parent',axes1,'String',' CP4',...
    'Position',[-0.364118966090153 -0.697384462454118 0.617310529685845]);

% Create text
text('Parent',axes1,'String',' CP2',...
    'Position',[-0.381568948058739 -0.380637736459633 0.842330132109872]);

% Create text
text('Parent',axes1,'String',' P2',...
    'Position',[-0.704420886737481 -0.30614474105356 0.640364436749285]);

% Create text
text('Parent',axes1,'String',' P4',...
    'Position',[-0.67742947396965 -0.566418958764877 0.469317452210033]);

% Create text
text('Parent',axes1,'String',' P6',...
    'Position',[-0.635668653319804 -0.74164734347606 0.214206865206255]);

% Create text
text('Parent',axes1,'String',' P8',...
    'Position',[-0.587328778670941 -0.804543580596477 -0.0880598243576574]);

% Create text
text('Parent',axes1,'String',' PO8',...
    'Position',[-0.808460771858146 -0.584368268350296 -0.070035043455453]);

% Create text
text('Parent',axes1,'String',' PO4',...
    'Position',[-0.895921367474678 -0.370370207966719 0.245256625502742]);

% Create text
text('Parent',axes1,'String',' O2',...
    'Position',[-0.950378695807622 -0.307513577982048 -0.047071582846585]);


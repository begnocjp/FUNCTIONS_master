function fnl_GrandAverageERPs(wmps,conditions)
%% Grand Average Evoked Response Potentials (ERP)
%
% Plots GrandAverage ERPs for all participants in WMPS, saves
% 
% USAGE:
%        fnl_GrandAverageERPs(wmps,conditions)
% INPUTS:
%        wpms: working parameters stucture
%        conditions: cell array of conditions (e.g.
%        {'condition_a','condtion_b','condition_c'}
%        
% Patrick Cooper & Aaron Wong
% Functional Neuroimaging Laboratory, University of Newcastle 2014

	fprintf('Begin Grand Average ERPs for all names in WPMS:\n');
	for name_i = 1:length(wmps.names)
		fprintf('\t%i: Name: %s\n',name_i,wmps.names{name_i});
	end

	%TOINCLUDE_IN_GRANDAVERAGE = struct('pnum',{'FB01','FB02','FB03','FB04','FB05','FB06','FB07','FB08','FB09','FB10','FB11','FB12','FB13','FB14','FB15','FB16','FB17','FB18','FB19','FB20','FB21','FB22','FB23','FB24','FB25','FB26'});

	% Begin Reading the grand average of by loading the TimeLockAnalysis Data
	% for each individual participant. Insert them into one single
	% data structure.

	%DATA = zeros(1,length(TOINCLUDE_IN_GRANDAVERAGE));
	for name_i = 1:length(wmps.names)
		DATA(1,name_i) =load([wpms.dirs.CWD wpms.dirs.preproc wpms.names{name_i} '_TIMELOCK.mat']);
	end

	cfg = [];
	cfg.channel        = 'all';
	cfg.latency        = 'all';
	cfg.keepindividual = 'no';
	cfg.normalizevar   = 'N-1';
	cfg.method         = 'across';
	cfg.parameter      = 'avg';

	%Define Classes and generate and perform the Grandaverage calulation for each class.
	%data_class = struct('pnum',{ '150','160','170','180','190','200'}); is now an input into the function
	for condition_i = 1:length(conditions)
		fprintf('\tCalculating Grand Average ERP: %s',conditions{condition_i});
		tic;
		evalStr1 = ['[Class_',conditions{condition_i},'] = ft_timelockgrandaverage(cfg'];
		for name_i = 1:length(wmps.names))
			evalStr1 = [evalStr1,',DATA(1,',num2str(name_i),').timelock_',conditions{condition_i}]; 
		end
		evalStr1 = [evalStr1,');'];	
		eval(evalStr1);
		t = toc;
		fprintf('\t\t %5.2f Seconds \n', t);
	end

	save([wpms.dirs.CWD wpms.dirs.preproc 'GRANDAVERAGE_ERP.mat'],'Class*','conditions');
	clear Class* conditions
	%Plot for Channel 62: PO8 (This is the site shown to be strongest response,
	%and also other papers have used this site to look at the response)
	%Plot for Channel 25: PO7 
	% data.fsample = 512;
	% sample = 513:(513+512/2);
	% %sample = 257:513;%data.fsample:(data.fsample*1.5);
	% time = ((sample./data.fsample)-1)*1000;
	% figure('Position',[50 50 1200 800]);
	% hold on; 
	% ch_to_plot = 62;
	% plot(time,Class_150.avg(ch_to_plot,sample),'-b');
	% plot(time,Class_160.avg(ch_to_plot,sample),'-g');
	% plot(time,Class_170.avg(ch_to_plot,sample),'-r');
	% plot(time,Class_180.avg(ch_to_plot,sample),'-c');
	% plot(time,Class_190.avg(ch_to_plot,sample),'-m');
	% plot(time,Class_200.avg(ch_to_plot,sample),'-k');
	% xlabel('Time (ms)');
	% ylabel('uV')
	% legend('150: ekman ','160: peter cropped','170: faceDrawings ','180: facebuilidings','190: subliminal faces','200: buildings without faces', 'Location','SouthEast');
	% string_title = 'Grand Average of ';
	% for name_i = 1:length(TOINCLUDE_IN_GRANDAVERAGE)
		% string_title=[string_title,' ',TOINCLUDE_IN_GRANDAVERAGE(1,name_i).pnum];
		% %if mod(name_i,3) == 0
		% %   string_title = [string_title,'\n'];
		% %end   
	% end
	% string_title=[string_title, ' TIMELOCK ERP'];
	% title(string_title);
	% saveas(gcf,[OUTPUTDIR,string_title],'bmp');
	% saveas(gcf,[OUTPUTDIR,string_title,'.eps'],'psc2');


	%% GRandAverage Topoplots:

	% close all;    
	% cfg = [];
	% cfg.parameter   = 'avg';
	% cfg.zlim  = [-5 5];
	% cfg.comment = 'no';
	% for i = 0:0.01:0.01;
		% cfg.xlim = [ i i+0.025]; %150-200ms %[513 513+256];
	 %%   cfg.highlight = 'labels';
		% cfg.layout      = 'biosemi64.lay';

		% figure('Position',[50 50 1600 900]);
	%%    title(names(1,name_i).pnum);
		% subplot(2,3,1)
		% ft_topoplotER(cfg,Class_150) ;
		% title('150: Ekman');

		% subplot(2,3,2)
		% ft_topoplotER(cfg, Class_160)
		% title('160: Peter Cropped');

		% subplot(2,3,3)
		% ft_topoplotER(cfg, Class_170)
		% title('170: FaceDrawings');

		% subplot(2,3,4)
		% ft_topoplotER(cfg, Class_180)
		% title('180: FaceBuildings');

		% subplot(2,3,5)
		% ft_topoplotER(cfg, Class_190)
		% title('190: SubliminalFaces');

		% subplot(2,3,6)
		% ft_topoplotER(cfg, Class_200)
		% title('200: BuildingsWithoutFace');

		% text(-3.25,1.20,['GRANDAVERAGE TOPOLOGY [',num2str(cfg.xlim(1)*1000),'-',num2str(cfg.xlim(2)*1000), ']ms'],'FontSize',18);

		% saveas(gcf,[OUTPUTDIR,'GRANDAVERAGE_TOPOPLOT_ER_',num2str(cfg.xlim(1)*1000)],'png');
		% saveas(gcf,[OUTPUTDIR,'GRANDAVERAGE_TOPOPLOT_ER',num2str(cfg.xlim(1)*1000),'.eps',],'psc2');
		% close all;
	% end

end
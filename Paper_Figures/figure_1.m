function figure_1()


	load('IMP_100000_SS/imp_100000_ss_100000000.mat','H1');
	DEM0=H1;
	DEM0.Z(:,1)=NaN; DEM0.Z(:,end)=NaN; DEM0.Z(1,:)=NaN; DEM0.Z(end,:)=NaN;
	F0=FLOWobj(DEM0,'preprocess','carve');
	S0=STREAMobj(F0,'minarea',5e5,'unit','mapunits');
	S0L=klargestconncomps(S0,6);

	load('IMP_100000_TR/imp_100000_tr_1000000.mat','H1');
	DEM1=H1;
	DEM1.Z(:,1)=NaN; DEM1.Z(:,end)=NaN; DEM1.Z(1,:)=NaN; DEM1.Z(end,:)=NaN;
	F1=FLOWobj(DEM1,'preprocess','carve');
	S1=STREAMobj(F1,'minarea',5e5,'unit','mapunits');
	S1L=klargestconncomps(S1,6);

	load('IMP_100000_TR/imp_100000_tr_50000000.mat','H1');
	DEM2=H1;
	DEM2.Z(:,1)=NaN; DEM2.Z(:,end)=NaN; DEM2.Z(1,:)=NaN; DEM2.Z(end,:)=NaN;
	F2=FLOWobj(DEM2,'preprocess','carve');
	S2=STREAMobj(F2,'minarea',5e5,'unit','mapunits');
	S2L=klargestconncomps(S2,6);

	f1=figure(1);
	clf
	set(f1,'unit','normalized','position',[0.1 0.1 0.8 0.6]);

	subplot(2,6,1:2)
	hold on 
	imageschs(DEM0,DEM0,'caxis',[0 800],'colormap',ttscm('batlow'));
	plot(S0L,'-w','linewidth',2);
	xticks([0 5000 10000 15000 20000])
	yticks([0 5000 10000 15000 20000])
	xticklabels([0 5 10 15 20])
	yticklabels([0 5 10 15 20])	
	xlabel('[km]')
	ylabel('[km]')
	title('T = 0 Myrs')
	hold off	

	subplot(2,6,3:4)
	hold on 
	imageschs(DEM1,DEM1,'caxis',[0 800],'colormap',ttscm('batlow'));
	plot(S1L,'-w','linewidth',2);
	xticks([0 5000 10000 15000 20000])
	yticks([0 5000 10000 15000 20000])
	xticklabels([0 5 10 15 20])
	yticklabels([0 5 10 15 20])	
	xlabel('[km]')
	ylabel('[km]')
	xlabel('[km]')
	ylabel('[km]')
	title('T = 1 Myrs')
	hold off

	subplot(2,6,5:6)
	hold on 
	imageschs(DEM2,DEM2,'caxis',[0 800],'colorbarylabel','Elevation [m]','colormap',ttscm('batlow'));
	plot(S2L,'-w','linewidth',2);
	xticks([0 5000 10000 15000 20000])
	yticks([0 5000 10000 15000 20000])
	xticklabels([0 5 10 15 20])
	yticklabels([0 5 10 15 20])	
	xlabel('[km]')
	ylabel('[km]')
	xlabel('[km]')
	ylabel('[km]')
	title('T = 50 Myrs')
	hold off		

	S2_1=modify(S2L,'rmnodes',S1L);
	S1_0=modify(S1L,'rmnodes',S0L);


	subplot(2,6,8:9)
	hold on 
	plot(S1L,'-k')
	plot(S1_0,'-r','linewidth',2);
	axis equal
	xlim([0 20000])
	ylim([0 20000])
	xticks([0 5000 10000 15000 20000])
	yticks([0 5000 10000 15000 20000])
	xticklabels([0 5 10 15 20])
	yticklabels([0 5 10 15 20])	
	xlabel('[km]')
	ylabel('[km]')
	xlabel('[km]')
	ylabel('[km]')
	title('Stream Network Change 1 to 0 Myrs')
	hold off

	subplot(2,6,10:11)
	hold on 
	plot(S2L,'-k');
	plot(S2_1,'-r','linewidth',2);
	axis equal
	xlim([0 20000])
	ylim([0 20000])
	xticks([0 5000 10000 15000 20000])
	yticks([0 5000 10000 15000 20000])
	xticklabels([0 5 10 15 20])
	yticklabels([0 5 10 15 20])	
	xlabel('[km]')
	ylabel('[km]')
	xlabel('[km]')
	ylabel('[km]')
	title('Stream Network Change 50 to 1 Myrs')
	hold off

	set(findall(gcf,'-property','FontSize'),'FontSize',14)

function [T]=plot_time_to_steady_state_v3()
	
	LL_T=readtable('transient_summary_landlab.csv');
	LL_T=removevars(LL_T,'Var1');
	TT_T=readtable('transient_summary_ttlem.csv');

	T=vertcat(LL_T,TT_T);

	T.grid=categorical(T.grid);
	T.algorithm=categorical(T.algorithm);
	T.program=categorical(T.program);

	% Tu=response_time(1)/1e6;

	grids={'raster','voronoi','hex'};
	algo={'fastscape','TVD','explicit'};
	prog={'landlab','ttlem'};
	dt=[100000,25000,2500,250];

	x_max=35;

	% Columns steady state metrics (3)
	% Rows are grid types and/or algorithms (5)
	% Colors are time steps (4)

	% col=ttscm('hawaii',5);
	% col=magmacolor(5);
	col=flipud(ttscm('lajolla',5));

	f1=figure(1);
	clf
	set(f1,'unit','normalized','position',[0.1 0.1 0.8 0.7]);

	% First row is raster fastscape
	% First colum is max elevation
	% Second column is mean elevation
	% Third colum is local max
	subplot(3,4,1)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		p1(ii)=plot(TT.time(TT.dt==dt(ii))/1e6,TT.max_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','-.');
	end

	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.max_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1);
	end
	set(gca,'YScale','log');
	xlim([0 x_max])
	ylim([1e-14 1e3])
	legend(p1,{'TTLEM; Raster; dt = 100ka','TTLEM; Raster; dt = 25ka','TTLEM; Raster; dt = 2.5ka','TTLEM; Raster; dt = 0.25ka'},'location','best');
	ylabel('\Delta [m]')
	title('\Delta Max Elevation');
	hold off

	subplot(3,4,2)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.mean_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','-.');
	end

	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		p2(ii)=plot(TT.time(TT.dt==dt(ii))/1e6,TT.mean_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1);
	end
	set(gca,'YScale','log');
	xlim([0 x_max])
	ylim([1e-14 1e3])
	title('\Delta Mean Elevation');
	legend(p2,{'Landlab; Raster; dt = 100ka','Landlab; Raster; dt = 25ka','Landlab; Raster; dt = 2.5ka','Landlab; Raster; dt = 0.25ka'},'location','best');
	hold off

	subplot(3,4,3)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.local_elev__max_change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','-.');
	end

	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.local_elev__max_change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1);
	end
	set(gca,'YScale','log');
	xlim([0 x_max])
	ylim([1e-14 1e3])
	title('\Delta Max Local Elevation');
	% text(37,10^-4,'Fastscape','FontWeight','Bold')
	% text(37,10^-5,'Raster','FontWeight','Bold')
	hold off

	subplot(3,4,4)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,abs(TT.net_flux(TT.dt==dt(ii))),'color',col(ii,:),'LineWidth',1,'LineStyle','-.');
	end

	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,abs(TT.net_flux(TT.dt==dt(ii))),'color',col(ii,:),'LineWidth',1);
	end
	set(gca,'YScale','log');
	xlim([0 x_max])
	ylim([1e-23 1e0])
	ylabel('\Delta [m/yr]')
	title('\Delta Flux');
	hold off

	%% SECOND ROW TTLEM TVD & EXplicit
	subplot(3,4,5)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='tvd' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=3:4
		p11(ii-2)=plot(TT.time(TT.dt==dt(ii))/1e6,TT.max_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','-');
	end

	idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.max_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','--');
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	ylim([1e-14 1e3])
	legend(p11,{'TVD; dt = 2.5ka','TVD; dt = 0.25ka'},'location','best');
	ylabel('\Delta [m]')
	hold off

	subplot(3,4,6)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='tvd' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.mean_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','-');
	end

	idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=3:4
		p22(ii-2)=plot(TT.time(TT.dt==dt(ii))/1e6,TT.mean_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','--');
	end

	set(gca,'YScale','log');
	legend(p22,{'Explicit; dt = 2.5ka','Explicit; dt = 0.25ka'},'location','best');
	xlim([0 x_max])
	ylim([1e-14 1e3])
	hold off

	subplot(3,4,7)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='tvd' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.local_elev__max_change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','-');
	end

		% Indexing
	idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.local_elev__max_change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','--');
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	ylim([1e-14 1e3])
	hold off


	subplot(3,4,8)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='tvd' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,abs(TT.net_flux(TT.dt==dt(ii))),'color',col(ii,:),'LineWidth',1,'LineStyle','-');
	end

	idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,abs(TT.net_flux(TT.dt==dt(ii))),'color',col(ii,:),'LineWidth',1,'LineStyle','--');
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	ylim([1e-23 1e0])
	ylabel('\Delta [m/yr]')
	hold off	


	%% Third ROW Landlab Voronoi & Hex
	subplot(3,4,9)
	hold on 
	% Indexing
	idx=T.grid=='voronoi' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		p1(ii)=plot(TT.time(TT.dt==dt(ii))/1e6,TT.max_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1);

	end

	idx=T.grid=='hex' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.max_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','--');
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	ylim([1e-14 1e3])
	legend(p1,{'Voronoi; dt = 100ka','Voronoi; dt = 25ka','Voronoi; dt = 2.5ka','Voronoi; dt = 0.25ka'},'location','best');
	ylabel('\Delta [m]')
	xlabel('Model Time [Myrs]')
	hold off

	subplot(3,4,10)
	hold on 
	% Indexing
	idx=T.grid=='voronoi' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.mean_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1);
	end

	% Indexing
	idx=T.grid=='hex' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		p2(ii)=plot(TT.time(TT.dt==dt(ii))/1e6,TT.mean_elev__change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','--');
	end	

	set(gca,'YScale','log');
	xlim([0 x_max])
	ylim([1e-14 1e3])
	legend(p2,{'Hex; dt = 100ka','Hex; dt = 25ka','Hex; dt = 2.5ka','Hex; dt = 0.25ka'},'location','best');
	xlabel('Model Time [Myrs]')
	hold off

	subplot(3,4,11)
	hold on 
	% Indexing
	idx=T.grid=='voronoi' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.local_elev__max_change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1);
	end

	% Indexing
	idx=T.grid=='hex' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,TT.local_elev__max_change(TT.dt==dt(ii)),'color',col(ii,:),'LineWidth',1,'LineStyle','--');
	end	

	set(gca,'YScale','log');
	xlim([0 x_max])
	ylim([1e-14 1e3])
	xlabel('Model Time [Myrs]')
	hold off

	subplot(3,4,12)
	hold on 
	% Indexing
	idx=T.grid=='voronoi' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,abs(TT.net_flux(TT.dt==dt(ii))),'color',col(ii,:),'LineWidth',1);
	end

		% Indexing
	idx=T.grid=='hex' & T.algorithm=='fastscape' & T.program=='landlab';
	TT=T(idx,:);
	for ii=1:4
		plot(TT.time(TT.dt==dt(ii))/1e6,abs(TT.net_flux(TT.dt==dt(ii))),'color',col(ii,:),'LineWidth',1,'LineStyle','--');
	end

	set(gca,'YScale','log');

	xlim([0 x_max])
	ylim([1e-23 1e0])
	ylabel('\Delta [m/yr]')
	xlabel('Model Time [Myrs]')

	set(findall(gcf,'-property','FontSize'),'FontSize',12)


	%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% col2=ttscm('batlowK',6);

	% f2=figure(2);
	% clf
	% set(f2,'unit','normalized','position',[0.1 0.1 0.9 0.4]);

	% subplot(1,4,1)
	% hold on 
	% idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.max_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');

	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(1,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.max_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(2,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='tvd' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.max_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(3,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.max_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(4,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='voronoi' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.max_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(5,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='hex' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.max_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(6,:),'LineWidth',2);
	% clear tss;	

	% set(gca,'XScale','log');
	% ylim([5 35])
	% xlim([250 100000])
	% xlabel('Timestep [yrs]');
	% ylabel('Time to Steady State [Myrs]')
	% legend('TTLEM - Fastscape - Raster','Landlab - Fastscape - Raster','TTLEM - TVD - Raster','TTLEM - Explicit - Raster','Landlab - Fastscape - Voronoi','Landlab - Fastscape - Hex','location','best');
	% title('\Delta Max Elevation');
	% hold off

	% subplot(1,4,2)
	% hold on 
	% idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.mean_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');

	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(1,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.mean_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(2,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='TVD' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.max_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(3,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.mean_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(4,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='voronoi' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.mean_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(5,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='hex' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.mean_elev__change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(6,:),'LineWidth',2);
	% clear tss;	

	% set(gca,'XScale','log');
	% ylim([5 35])
	% xlim([250 100000])
	% xlabel('Timestep [yrs]');
	% ylabel('Time to Steady State [Myrs]')
	% title('\Delta Mean Elevation');
	% hold off

	% subplot(1,4,3)
	% hold on 
	% idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.local_elev__max_change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');

	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(1,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.local_elev__max_change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(2,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='TVD' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.local_elev__max_change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(3,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.local_elev__max_change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(4,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='voronoi' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.local_elev__max_change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(5,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='hex' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=TT.local_elev__max_change(TT.dt==dt(ii));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(6,:),'LineWidth',2);
	% clear tss;	

	% set(gca,'XScale','log');
	% ylim([5 35])
	% xlim([250 100000])
	% xlabel('Timestep [yrs]');
	% ylabel('Time to Steady State [Myrs]')
	% title('Max \Delta Local Elevation Change');
	% hold off	

	% subplot(1,4,4)
	% hold on 
	% idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=abs(TT.net_flux(TT.dt==dt(ii)));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');

	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(1,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=abs(TT.net_flux(TT.dt==dt(ii)));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(2,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='TVD' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=abs(TT.net_flux(TT.dt==dt(ii)));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(3,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=abs(TT.net_flux(TT.dt==dt(ii)));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(4,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='voronoi' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=abs(TT.net_flux(TT.dt==dt(ii)));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(5,:),'LineWidth',2);
	% clear tss;

	% idx=T.grid=='hex' & T.algorithm=='fastscape' & T.program=='landlab';
	% TT=T(idx,:);
	% for ii=1:4
	% 	tt=TT.time(TT.dt==dt(ii))/1e6;
	% 	v=abs(TT.net_flux(TT.dt==dt(ii)));

	% 	tt=flipud(tt);
	% 	v=flipud(v);
	% 	ix=find(v>0,1,'first');
	% 	if isempty(ix)
	% 		tss(ii)=nan;
	% 	else
	% 		tss(ii)=tt(ix);
	% 	end
	% end
	% plot(dt,tss,'color',col2(6,:),'LineWidth',2);
	% clear tss;	

	% set(gca,'XScale','log');
	% ylim([5 35])
	% xlim([250 100000])
	% xlabel('Timestep [yrs]');
	% ylabel('Time to Steady State [Myrs]')
	% title('\Delta Net Flux');
	% hold off	


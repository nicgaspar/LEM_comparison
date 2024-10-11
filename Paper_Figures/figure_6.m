function figure_6()
	
	% Read TTLEM
	load('TTLEM_transient_table_FIX.mat','TF');
	T=TF;


	% Tu=response_time(1)/1e6;

	grids={'raster','voronoi','hex'};
	algo={'fastscape','TVD','explicit'};
	prog={'landlab','ttlem','child'};
	dt=[100000,25000,2500,250];
	cols={'#1B9E77','#7570B3','#E7298A','#E6AB02'};

	x_max=10;
	xcval=0;

	el_cut=1e-5;
	fl_cut=1e-6;

	% Columns steady state metrics (3)
	% Rows are grid types and/or algorithms (5)
	% Colors are time steps (4)

	f1=figure(1);
	clf
	set(f1,'unit','normalized','position',[0.1 0.1 0.8 0.6]);

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
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
		Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

		metric=TT.max_elev__change(TT.dt==dt(ii));

		t=TT.time(TT.dt==dt(ii))/1e6;
		p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

		[~,ix_max]=min(abs(t-Tu_lmax));
		[~,ix_mn]=min(abs(t-Tu_lmn));

		scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
		scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	legend(p1,{'dt = 100ka','dt = 25ka','dt = 2.5ka','dt = 0.25ka'},'Position',[0.01 0.825 0.075 0.1]);

	ylabel('\Delta [m]')
	title('\Delta Max Elevation');
	hold off

	subplot(3,4,2)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
		Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

		metric=TT.mean_elev__change(TT.dt==dt(ii));

		t=TT.time(TT.dt==dt(ii))/1e6;
		p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

		[~,ix_max]=min(abs(t-Tu_lmax));
		[~,ix_mn]=min(abs(t-Tu_lmn));

		scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
		scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
		
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	title('\Delta Mean Elevation');
	hold off

	subplot(3,4,3)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
		Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

		metric=TT.local_elev__max_change(TT.dt==dt(ii));

		t=TT.time(TT.dt==dt(ii))/1e6;
		p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

		[~,ix_max]=min(abs(t-Tu_lmax));
		[~,ix_mn]=min(abs(t-Tu_lmn));

		scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
		scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);			
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	title('\Delta Max Local Elevation');
	hold off

	subplot(3,4,4)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
		Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

		metric=TT.net_flux(TT.dt==dt(ii));

		t=TT.time(TT.dt==dt(ii))/1e6;
		p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

		[~,ix_max]=min(abs(t-Tu_lmax));
		[~,ix_mn]=min(abs(t-Tu_lmn));

		scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
		scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	ylabel('\Delta [m/yr]')
	title('\Delta Flux');	

	yyaxis right
	ylabel('TRI');
	ax=gca;
	ax.YTick=[];
	ax.YTickLabel=[];
	ax.YColor='k';
	hold off


	%%%% THIRD ROW TTLEM EXPLICIT

	subplot(3,4,5)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4	
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		if ~isempty(h)
			Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
			Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

			metric=TT.max_elev__change(TT.dt==dt(ii));

			t=TT.time(TT.dt==dt(ii))/1e6;
			p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

			[~,ix_max]=min(abs(t-Tu_lmax));
			[~,ix_mn]=min(abs(t-Tu_lmn));

			scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
			scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
		end
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	ylabel('\Delta [m]')
	% title('\Delta Max Elevation');
	hold off

	subplot(3,4,6)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		if ~isempty(h)
			Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
			Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

			metric=TT.mean_elev__change(TT.dt==dt(ii));

			t=TT.time(TT.dt==dt(ii))/1e6;
			p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

			[~,ix_max]=min(abs(t-Tu_lmax));
			[~,ix_mn]=min(abs(t-Tu_lmn));

			scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
			scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
		end		
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	% title('\Delta Mean Elevation');
	hold off

	subplot(3,4,7)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		if ~isempty(h)
			Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
			Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

			metric=TT.local_elev__max_change(TT.dt==dt(ii));

			t=TT.time(TT.dt==dt(ii))/1e6;
			p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

			[~,ix_max]=min(abs(t-Tu_lmax));
			[~,ix_mn]=min(abs(t-Tu_lmn));

			scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
			scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
		end		
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	% title('\Delta Max Local Elevation');
	hold off

	subplot(3,4,8)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='explicit' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		if ~isempty(h)
			Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
			Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

			metric=TT.net_flux(TT.dt==dt(ii));

			t=TT.time(TT.dt==dt(ii))/1e6;
			p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

			[~,ix_max]=min(abs(t-Tu_lmax));
			[~,ix_mn]=min(abs(t-Tu_lmn));

			scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
			scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
		end				
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	ylabel('\Delta [m/yr]')
	% title('\Delta Flux');

	yyaxis right
	ylabel('TRE');
	ax=gca;
	ax.YTick=[];
	ax.YTickLabel=[];
	ax.YColor='k';
	hold off

	%%%% FOURTH ROW TTLEM TVD

	subplot(3,4,9)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='tvd' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4	
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		if ~isempty(h)
			Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
			Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

			metric=TT.max_elev__change(TT.dt==dt(ii));

			t=TT.time(TT.dt==dt(ii))/1e6;
			p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

			[~,ix_max]=min(abs(t-Tu_lmax));
			[~,ix_mn]=min(abs(t-Tu_lmn));

			scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
			scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
		end		
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	ylabel('\Delta [m]')
	xlabel('Time [Myrs]')
	% title('\Delta Max Elevation');
	hold off

	subplot(3,4,10)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='tvd' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		if ~isempty(h)
			Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
			Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

			metric=TT.mean_elev__change(TT.dt==dt(ii));

			t=TT.time(TT.dt==dt(ii))/1e6;
			p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

			[~,ix_max]=min(abs(t-Tu_lmax));
			[~,ix_mn]=min(abs(t-Tu_lmn));

			scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
			scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
		end		
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	xlabel('Time [Myrs]')
	% title('\Delta Mean Elevation');
	hold off

	subplot(3,4,11)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='tvd' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		if ~isempty(h)
			Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
			Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

			metric=TT.local_elev__max_change(TT.dt==dt(ii));

			t=TT.time(TT.dt==dt(ii))/1e6;
			p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

			[~,ix_max]=min(abs(t-Tu_lmax));
			[~,ix_mn]=min(abs(t-Tu_lmn));

			scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
			scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
		end		
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	xlabel('Time [Myrs]')
	% title('\Delta Max Local Elevation');
	hold off

	subplot(3,4,12)
	hold on 
	% Indexing
	idx=T.grid=='raster' & T.algorithm=='tvd' & T.program=='ttlem';
	TT=T(idx,:);
	for ii=1:4
		% Extract vectors	
		l_mn=TT.mean_length(TT.dt==dt(ii));
		l_mx=TT.max_length(TT.dt==dt(ii));
		h=TT.hack_h(TT.dt==dt(ii));
		ka=TT.hack_ka(TT.dt==dt(ii));
		% Calculate response times
		if ~isempty(h)
			Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
			Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

			metric=TT.net_flux(TT.dt==dt(ii));

			t=TT.time(TT.dt==dt(ii))/1e6;
			p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

			[~,ix_max]=min(abs(t-Tu_lmax));
			[~,ix_mn]=min(abs(t-Tu_lmn));

			scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
			scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
		end				
	end

	set(gca,'YScale','log');
	xlim([0 x_max])
	xticks([0 2 4 6 8 10])
	ylim([1e-10 1e3])
	ylabel('\Delta [m/yr]')
	xlabel('Time [Myrs]')
	% title('\Delta Flux');

	yyaxis right
	ylabel('TRT');
	ax=gca;
	ax.YTick=[];
	ax.YTickLabel=[];
	ax.YColor='k';
	hold off
	set(findall(gcf,'-property','FontSize'),'FontSize',14)	

end 


function [Tu]=resp_time(h,ka,l,xc)
	% Calculate beta
	m=0.5;
	n=1;
	hmn=(h*m)/n;
	bta=(ka^(-m/n))*((1-hmn)^(-1)) * (l^(1-hmn) - xc^(1-hmn));

	% Calculate fu
	ui=1e-4;
	uf=5e-4;
	fu=uf/ui;

	K=5e-6;

	if n==1
		Tu=bta*(K^(-1/n));
	else
		Tu=bta*(K^(-1/n))*(ui^(1/(n-1))) * ((fu^(1/n))-1) * (fu-1)^(-1);
	end
end



	




	


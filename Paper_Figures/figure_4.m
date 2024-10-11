function figure_4()

	% Read TTLEM
	load('TTLEM_transient_table_v2.mat','T');
	load('TTLEM_transient_table_ALT.mat','TA');
	TA.grid(:)='raster_alt';

	% Read Landlab
	TL=readtable('transient_summary_landlab_v2.csv');
	TL.grid=categorical(TL.grid);
	TL.algorithm=categorical(TL.algorithm);
	TL.program=categorical(TL.program);
	TL=removevars(TL,'Var1');
	TL=removevars(TL,'Unnamed');
	TL=removevars(TL,'hackO_c');
	TL=removevars(TL,'hackO_h');

	% Read CHILD
	TC=readtable('child_transient_v0.csv');
	TC.grid=categorical(TC.grid);
	TC.algorithm=categorical(TC.algorithm);
	TC.program=categorical(TC.program);

	% Concatenate
	T=vertcat(T,TL,TC,TA);

	grids={'raster','voronoi','hex'};
	algo={'fastscape','TVD','explicit'};
	prog={'landlab','ttlem','child'};
	dt=[100000,25000,10000,2500,1000,250];
	cols={'#1B9E77','#7570B3','#2E6FFF','#E7298A','#8B3800','#E6AB02'};


	grid_prog={'raster','raster','raster','raster','hex','voronoi','voronoi'};
	algo_prog={'fastscape','explicit','tvd','fastscape','fastscape','fastscape','explicit'};
	prog_prog={'ttlem','ttlem','ttlem','landlab','landlab','landlab','child'};
	abbrev={'TRI','TRE','TRT','LRI','LHI','LVI','CVE'};

	metric_name={'max_elev__change','mean_elev__change','local_elev__max_change','net_flux'};
	title_name={'\Delta Max Elevation','\Delta Mean Elevation','\Delta Max Local Elevation','\Delta Flux',};

	x_max=50;
	xcval=0;

	% Columns steady state metrics (3)
	% Rows are grid types and/or algorithms (5)
	% Colors are time steps (4)

	f1=figure(1);
	clf
	set(f1,'unit','normalized','position',[0.1 0.1 0.8 0.9]);

	% Max Elev Change
	metric_name='max_elev__change';
	title_text='\Delta Max Elevation';
	pos=1:4:28;

	for jj=1:7
		subplot(7,4,pos(jj))
		hold on 
		% Indexing
		idx=T.grid==grid_prog{jj} & T.algorithm==algo_prog{jj} & T.program==prog_prog{jj};
		TT=T(idx,:);
		for ii=1:6	
			% Extract vectors	
			l_mn=TT.mean_length(TT.dt==dt(ii));
			l_mx=TT.max_length(TT.dt==dt(ii));
			h=TT.hack_h(TT.dt==dt(ii));
			ka=TT.hack_ka(TT.dt==dt(ii));
			if ~isempty(h)
				% Calculate response times
				Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
				Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

				t=TT.time(TT.dt==dt(ii))/1e6;
				metric=TT.(metric_name)(TT.dt==dt(ii));

				p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

				[~,ix_max]=min(abs(t-Tu_lmax));
				[~,ix_mn]=min(abs(t-Tu_lmn));

				scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
				scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
			end
		end
		set(gca,'YScale','log')
		ylabel('\Delta [m]')
		if jj==1
			title(title_text)
		end
		xlim([0 x_max])
		ylim([1e-14 1e3])
		yticks(logspace(-14,2,3))
		if jj==1
			legend(p1,{'dt = 100ka','dt = 25ka','dt = 10ka','dt = 2.5ka','dt = 1ka','dt = 0.25ka'},'Position',[0.01 0.825 0.075 0.1]);
		end

		if jj==7
			xlabel('Time [Myrs]')
		end
		hold off

	end

	% Max Elev Change
	metric_name='mean_elev__change';
	title_text='\Delta Mean Elevation';
	pos=2:4:28;

	for jj=1:7
		subplot(7,4,pos(jj))
		hold on 
		% Indexing
		idx=T.grid==grid_prog{jj} & T.algorithm==algo_prog{jj} & T.program==prog_prog{jj};
		TT=T(idx,:);
		for ii=1:6	
			% Extract vectors	
			l_mn=TT.mean_length(TT.dt==dt(ii));
			l_mx=TT.max_length(TT.dt==dt(ii));
			h=TT.hack_h(TT.dt==dt(ii));
			ka=TT.hack_ka(TT.dt==dt(ii));
			if ~isempty(h)
				% Calculate response times
				Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
				Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

				t=TT.time(TT.dt==dt(ii))/1e6;
				metric=TT.(metric_name)(TT.dt==dt(ii));

				p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

				[~,ix_max]=min(abs(t-Tu_lmax));
				[~,ix_mn]=min(abs(t-Tu_lmn));

				scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
				scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
			end
		end
		set(gca,'YScale','log')
		ylabel('\Delta [m]')
		if jj==1
			title(title_text)
		end
		xlim([0 x_max])
		ylim([1e-14 1e3])
		yticks(logspace(-14,2,3))

		if jj==7
			xlabel('Time [Myrs]')
		end
		hold off
	end

	% Max Local Elev Change
	metric_name='local_elev__max_change';
	title_text='\Delta Local Max Elevation';
	pos=3:4:28;

	for jj=1:7
		subplot(7,4,pos(jj))
		hold on 
		% Indexing
		idx=T.grid==grid_prog{jj} & T.algorithm==algo_prog{jj} & T.program==prog_prog{jj};
		TT=T(idx,:);
		for ii=1:6	
			% Extract vectors	
			l_mn=TT.mean_length(TT.dt==dt(ii));
			l_mx=TT.max_length(TT.dt==dt(ii));
			h=TT.hack_h(TT.dt==dt(ii));
			ka=TT.hack_ka(TT.dt==dt(ii));
			if ~isempty(h)
				% Calculate response times
				Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
				Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

				t=TT.time(TT.dt==dt(ii))/1e6;
				metric=TT.(metric_name)(TT.dt==dt(ii));

				p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

				[~,ix_max]=min(abs(t-Tu_lmax));
				[~,ix_mn]=min(abs(t-Tu_lmn));

				scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
				scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
			end
		end
		set(gca,'YScale','log')
		ylabel('\Delta [m]')
		if jj==1
			title(title_text)
		end
		xlim([0 x_max])
		ylim([1e-14 1e3])
		yticks(logspace(-14,2,3))

		if jj==7
			xlabel('Time [Myrs]')
		end
		hold off

	end

	% Max Local Elev Change
	metric_name='net_flux';
	title_text='\Delta Flux';
	pos=4:4:28;

	for jj=1:7
		subplot(7,4,pos(jj))
		hold on 
		% Indexing
		idx=T.grid==grid_prog{jj} & T.algorithm==algo_prog{jj} & T.program==prog_prog{jj};
		TT=T(idx,:);
		for ii=1:6	
			% Extract vectors	
			l_mn=TT.mean_length(TT.dt==dt(ii));
			l_mx=TT.max_length(TT.dt==dt(ii));
			h=TT.hack_h(TT.dt==dt(ii));
			ka=TT.hack_ka(TT.dt==dt(ii));
			if ~isempty(h)
				% Calculate response times
				Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
				Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

				t=TT.time(TT.dt==dt(ii))/1e6;
				metric=TT.(metric_name)(TT.dt==dt(ii));

				p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

				[~,ix_max]=min(abs(t-Tu_lmax));
				[~,ix_mn]=min(abs(t-Tu_lmn));

				scatter(t(ix_max),metric(ix_max),30,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
				scatter(t(ix_mn),metric(ix_mn),30,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
			end
		end
		set(gca,'YScale','log')
		ylabel('\Delta [m]')
		if jj==1
			title(title_text)
		end
		xlim([0 x_max])
		ylim([1e-14 1e3])
		yticks(logspace(-14,2,3))

		if jj==7
			xlabel('Time [Myrs]')
		end

		yyaxis right
		ylabel(abbrev{jj});
		ax=gca;
		ax.YTick=[];
		ax.YTickLabel=[];
		ax.YColor='k';
		hold off

	end

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

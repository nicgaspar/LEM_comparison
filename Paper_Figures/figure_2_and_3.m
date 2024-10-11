function figure_2_and_3()

	% Read TTLEM
	load('TTLEM_transient_table_v2.mat','T');

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
	T=vertcat(T,TL,TC);

	cols={'#1B9E77','#7570B3','#2E6FFF','#E7298A','#8B3800','#E6AB02'};
	dt=[100000,25000,10000,2500,1000,250];
	x_max=50;
	x_max_zoom=4;
	xcval=0;

	f1=figure(1);
	clf
	set(f1,'unit','normalized','position',[0.1 0.1 0.8 0.9]);

	metric_name={'max_elev__change','max_elev__change','mean_elev__change','mean_elev__change',...
	'local_elev__max_change','local_elev__max_change','net_flux','net_flux'};
	title_name={'\Delta Max Elevation','\Delta Max Elevation','\Delta Mean Elevation','\Delta Mean Elevation',...
	'\Delta Max Local Elevation','\Delta Max Local Elevation','\Delta Flux','\Delta Flux'};
	y_lim={[1e-2 1e2],[1e-14 1e3],[1e-4 1e2],[1e-14 1e3],[1e1 1e2],[1e-14 1e3],[1e-5 1e1],[1e-14 1e3]};
	y_ticks={logspace(-2,2,3),logspace(-14,2,3),logspace(-4,2,3),logspace(-14,2,3),logspace(1,2,2),logspace(-14,2,3),logspace(-4,0,3),logspace(-14,2,3)};

	for jj=1:8

		subplot(4,2,jj)
		hold on 
		% Indexing
		idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='ttlem';
		TT=T(idx,:);
		for ii=1:6	
			% Extract vectors	
			l_mn=TT.mean_length(TT.dt==dt(ii));
			l_mx=TT.max_length(TT.dt==dt(ii));
			h=TT.hack_h(TT.dt==dt(ii));
			ka=TT.hack_ka(TT.dt==dt(ii));
			% Calculate response times
			Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
			Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

			t=TT.time(TT.dt==dt(ii))/1e6;
			metric=TT.(metric_name{jj})(TT.dt==dt(ii));

			p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

			[~,ix_max]=min(abs(t-Tu_lmax));
			[~,ix_mn]=min(abs(t-Tu_lmn));

			scatter(t(ix_max),metric(ix_max),50,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
			scatter(t(ix_mn),metric(ix_mn),50,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);

		end

		set(gca,'YScale','log');
		if mod(jj,2)==1
			xlim([0 x_max_zoom])
		else
			xlim([0 x_max])
		end
		ylim(y_lim{jj})
		legend(p1,{'dt = 100ka','dt = 25ka','dt = 10ka','dt = 2.5ka','dt = 1ka','dt = 0.25ka'},'Position',[0.01 0.825 0.075 0.1]);
		
		if jj<7
			ylabel('\Delta [m]')
			yticks(y_ticks{jj})
		else
			ylabel('\Delta [m/yr]')
			yticks(y_ticks{jj})
			xlabel('Model Time [Myr]')
		end
		title(title_name{jj});
		hold off

	end
	set(findall(gcf,'-property','FontSize'),'FontSize',14)

	x_max=40;
	x_max_zoom=7.2;

	f2=figure(2);
	clf
	set(f2,'unit','normalized','position',[0.1 0.1 0.8 0.9]);

	metric_name={'max_elev__change','max_elev__change','mean_elev__change','mean_elev__change',...
	'local_elev__max_change','local_elev__max_change','net_flux','net_flux'};
	title_name={'\Delta Max Elevation','\Delta Max Elevation','\Delta Mean Elevation','\Delta Mean Elevation',...
	'\Delta Max Local Elevation','\Delta Max Local Elevation','\Delta Flux','\Delta Flux'};
	y_lim={[1e-3 1e2],[1e-14 1e3],[1e-4 1e2],[1e-14 1e3],[1e1 1e3],[1e-14 1e3],[1e-5 1e1],[1e-14 1e3]};
	y_ticks={logspace(-2,2,3),logspace(-14,2,3),logspace(-4,2,3),logspace(-14,2,3),logspace(1,3,3),logspace(-14,2,3),logspace(-4,0,3),logspace(-14,2,3)};

	pix=zeros(6,1);
	for jj=1:8

		subplot(4,2,jj)
		hold on 
		% Indexing
		idx=T.grid=='raster' & T.algorithm=='fastscape' & T.program=='landlab';
		TT=T(idx,:);
		for ii=1:6	
			% Extract vectors	
			l_mn=TT.mean_length(TT.dt==dt(ii));
			l_mx=TT.max_length(TT.dt==dt(ii));
			h=TT.hack_h(TT.dt==dt(ii));
			ka=TT.hack_ka(TT.dt==dt(ii));
			% Calculate response times
			if ~isempty(h)
				Tu_lmax=resp_time(h(end),ka(end),l_mx(end),xcval)/1e6;
				Tu_lmn=resp_time(h(end),ka(end),l_mn(end),xcval)/1e6;

				t=TT.time(TT.dt==dt(ii))/1e6;
				metric=TT.(metric_name{jj})(TT.dt==dt(ii));

				p1(ii)=plot(t,metric,'color',cols{ii},'LineWidth',1,'LineStyle','-');

				[~,ix_max]=min(abs(t-Tu_lmax));
				[~,ix_mn]=min(abs(t-Tu_lmn));

				scatter(t(ix_max),metric(ix_max),50,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
				scatter(t(ix_mn),metric(ix_mn),50,'MarkerFaceColor','w','MarkerEdgeColor',cols{ii},'Marker','o','LineWidth',2);
				pix(ii)=1;
			else
				pix(ii)=0;
			end
		end

		p1=p1(logical(pix));

		set(gca,'YScale','log');
		if mod(jj,2)==1
			xlim([0 x_max_zoom])
		else
			xlim([0 x_max])
		end
		ylim(y_lim{jj})
		legend(p1,{'dt = 100ka','dt = 25ka','dt = 2.5ka','dt = 0.25ka'},'Position',[0.01 0.825 0.075 0.1]);
		
		if jj<7
			ylabel('\Delta [m]')
			yticks(y_ticks{jj})
		else
			ylabel('\Delta [m/yr]')
			yticks(y_ticks{jj})
			xlabel('Model Time [Myr]')
		end
		title(title_name{jj});
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

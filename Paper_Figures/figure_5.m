function figure_5()

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
	xcval=0;

	f1=figure(1);
	clf
	set(f1,'unit','normalized','position',[0.1 0.1 0.8 0.9]);

	metric_name={'max_elev__change','mean_elev__change','local_elev__max_change','net_flux'};
	title_name={'\Delta Max Elevation','\Delta Mean Elevation','\Delta Max Local Elevation','\Delta Flux',};
	m=logspace(-10,3,14);

	for jj=1:4

		subplot(2,2,jj)
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

			yline(Tu_lmax,'color',cols{ii},'LineStyle','-','LineWidth',1);
			yline(Tu_lmn,'color',cols{ii},'LineStyle',':','LineWidth',1);

			t=TT.time(TT.dt==dt(ii))/1e6;
			metric=TT.(metric_name{jj})(TT.dt==dt(ii));

			tv1=zeros(size(m));
			tv2=zeros(size(m));
			for kk=1:numel(m)
				ix1=find(metric<m(kk),1,'first');
				ix2=find(metric>m(kk),1,'last');
				if isempty(ix1)
					tv1(kk)=NaN;
				else
					tv1(kk)=t(ix1);
				end

				if isempty(ix2)
					tv2(kk)=NaN;
				else
					tv2(kk)=t(ix2);
				end

			end
			p1(ii)=scatter(m,tv1,50,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
			% scatter(m,tv2,50,'MarkerEdgeColor',cols{ii},'MarkerFaceColor','w','Marker','o','LineWidth',2);

		end
		set(gca,'XScale','log')
		set(gca,'YScale','log')
		xlabel('Threshold Value')
		ylabel('Time [Myr]')
		legend(p1,{'dt = 100ka','dt = 25ka','dt = 10ka','dt = 2.5ka','dt = 1ka','dt = 0.25ka'},'Position',[0.01 0.825 0.075 0.1]);
		title(title_name{jj});
		hold off

	end
	set(findall(gcf,'-property','FontSize'),'FontSize',14)

	f2=figure(2);
	clf
	set(f2,'unit','normalized','position',[0.1 0.1 0.8 0.9]);

	metric_name={'max_elev__change','mean_elev__change','local_elev__max_change','net_flux'};
	title_name={'\Delta Max Elevation','\Delta Mean Elevation','\Delta Max Local Elevation','\Delta Flux',};
	m=logspace(-10,3,14);
	pix=zeros(6,1);

	for jj=1:4

		subplot(2,2,jj)
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

				yline(Tu_lmax,'color',cols{ii},'LineStyle','-','LineWidth',1);
				yline(Tu_lmn,'color',cols{ii},'LineStyle',':','LineWidth',1);

				t=TT.time(TT.dt==dt(ii))/1e6;
				metric=TT.(metric_name{jj})(TT.dt==dt(ii));

				tv1=zeros(size(m));
				tv2=zeros(size(m));
				for kk=1:numel(m)
					ix1=find(metric<m(kk),1,'first');
					ix2=find(metric>m(kk),1,'last');
					if isempty(ix1)
						tv1(kk)=NaN;
					else
						tv1(kk)=t(ix1);
					end

					if isempty(ix2)
						tv2(kk)=NaN;
					else
						tv2(kk)=t(ix2);
					end

				end
				p2(ii)=scatter(m,tv1,50,'MarkerFaceColor',cols{ii},'MarkerEdgeColor','k','Marker','s');
				% scatter(m,tv2,50,'MarkerEdgeColor',cols{ii},'MarkerFaceColor','w','Marker','o','LineWidth',2);
				pix(ii)=1;

			else
				pix(ii)=0;
			end
		end

		p2=p2(logical(pix));


		set(gca,'XScale','log')
		set(gca,'YScale','log')
		xlabel('Threshold Value')
		ylabel('Time [Myr]')
		legend(p2,{'dt = 100ka','dt = 25ka','dt = 2.5ka','dt = 0.25ka'},'Position',[0.01 0.825 0.075 0.1]);
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

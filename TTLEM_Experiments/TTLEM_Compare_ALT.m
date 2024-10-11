function TTLEM_Compare()
	% Runs for TTLEM experiments using alternate noise grid (NoiseGrid_ALT)
	
	%% Define parameters constant between all models
	ui=1e-4;
	uf=5e-4;

	%% Implict, ts=100000;
	ts=100000;
	numerical_method='implicit_FDM';
	prefix='imp';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed implicit, ts = ' num2str(ts)])

	%% Implict, ts=25000;
	ts=25000;
	numerical_method='implicit_FDM';
	prefix='imp';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed implicit, ts = ' num2str(ts)])

	%% Implict, ts1000;
	ts=10000;
	numerical_method='implicit_FDM';
	prefix='imp';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed implicit, ts = ' num2str(ts)])

	%% Implict, ts=2500;
	ts=2500;
	numerical_method='implicit_FDM';
	prefix='imp';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed implicit, ts = ' num2str(ts)])

	%% Implict, ts1000;
	ts=1000;
	numerical_method='implicit_FDM';
	prefix='imp';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed implicit, ts = ' num2str(ts)])

	%% Implict, ts=250;
	ts=250;
	numerical_method='implicit_FDM';
	prefix='imp';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed implicit, ts = ' num2str(ts)])

	%% Explicit, ts=2500;
	ts=2500;
	numerical_method='explicit_FDM';
	prefix='exp';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed explicit, ts = ' num2str(ts)])

	%% Explicit, ts=1000;
	ts=1000;
	numerical_method='explicit_FDM';
	prefix='exp';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed explicit, ts = ' num2str(ts)])

	%% Explicit, ts=250;
	ts=250;
	numerical_method='explicit_FDM';
	prefix='exp';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed explicit, ts = ' num2str(ts)])

	%% TVD_FVM, ts=2500;
	ts=2500;
	numerical_method='TVD_FVM';
	prefix='tvd';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed TVD_FVM, ts = ' num2str(ts)])

	%% TVD_FVM, ts=1000;
	ts=1000;
	numerical_method='TVD_FVM';
	prefix='tvd';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed TVD_FVM, ts = ' num2str(ts)])	

	%% TVD_FVM, ts=250;
	ts=250;
	numerical_method='TVD_FVM';
	prefix='tvd';
	run_exp(ui,uf,ts,numerical_method,prefix);
	disp(['Completed TVD_FVM, ts = ' num2str(ts)])
end 


function run_exp(ui,uf,ts,nm,prefix);

	%%% INITIAL STEADY STATE

	% Load Noise Grid
	load('NoiseGrid_ALT.mat','DEM');

	%%% Uplift %%%
	Ui = GRIDobj(DEM);
	Ui.Z(2:end-1,2:end-1)=ones(198,198)*ui;

	%%% Set erosional parameters %%%
	p.D = 0;
	p.Kw = 5e-6;
	p.m = 0.5;
	p.n = 1;
	p.diffScheme = 'imp_lin';

	%%% Set rho_rs so that ksn equals predicted ksn %%%
	p.rho_rs=1;

	%%% Set total time and plot / save options %%%
	t_total=100e6;
	p.TimeSpan=t_total;
	num_to_save=10;
	num_to_plot=500;

	p.BC_Type='Dirichlet';

	%%% Model Specifics 

	p.resultsdir=[upper(prefix) '_' num2str(ts) '_SS_ALT'];
	p.fileprefix=[prefix '_' num2str(ts) '_ss_'];
	p.riverInc = nm;

	if strcmp(nm,'TVD_FVM')
		p.cfls = 0.9;
	elseif strcmp(nm,'explicit_FDM')
		p.cfls = 0.9;
	end

	%%% Define Output
	p.TimeStep=ts;
	num_ts=t_total/ts;
	p.ploteach=num_ts/num_to_plot;
	p.saveeach=num_ts/num_to_save;

	%%% Initialize parameters
	p   = ttlemset(p);

	%%% Run model
	ttlem_out = ttlem(DEM,Ui,p);
	fig=gcf;
	close(fig);

	%%% TRANSIENT 
	load([upper(prefix) '_' num2str(ts) '_SS_ALT' filesep prefix '_' num2str(ts) '_ss_100000000.mat'],'H1');

	%%% Uplift %%%
	Uf = GRIDobj(H1);
	Uf.Z(2:end-1,2:end-1)=ones(198,198)*uf;

	%%% Set erosional parameters %%%
	p.D = 0;
	p.Kw = 5e-6;
	p.m = 0.5;
	p.n = 1;
	p.diffScheme = 'imp_lin';

	%%% Set rho_rs so that ksn equals predicted ksn %%%
	p.rho_rs=1;

	%%% Set total time and plot / save options %%%
	t_total=50e6;
	p.TimeSpan=t_total;
	% num_to_save=100;
	num_to_plot=500;
	save_every=100000;

	p.BC_Type='Dirichlet';

	% Model Specifics 
	p.resultsdir=[upper(prefix) '_' num2str(ts) '_TR_ALT'];
	p.fileprefix=[prefix '_' num2str(ts) '_tr_'];
	p.riverInc = nm;

	if strcmp(nm,'TVD_FVM')
		p.cfls = 0.9;
	elseif strcmp(nm,'explicit_FDM')
		p.cfls = 0.9;
	end

	% Define Output
	p.TimeStep=ts;
	num_ts=t_total/ts;
	p.ploteach=num_ts/num_to_plot;
	p.saveeach=save_every/ts;

	% Initialize parameters
	p   = ttlemset(p);

	% Run model
	ttlem_out = ttlem(H1,Uf,p);
	fig=gcf;
	close(fig);
end


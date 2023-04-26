function SteadyStateExpTTLEM()

% Load Noise Grid
load('NoiseGrid.mat','DEM');

%%% Uplift %%%
U = GRIDobj(DEM);
upl_rate=1e-4; %Aboslute vertical uplift rate in m/yr
U.Z(2:end-1,2:end-1)=ones(198,198)*upl_rate;

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
num_to_save=500;
num_to_plot=500;

p.BC_Type='Dirichlet';

%%%%%%%%%%%%%%%%%%%%%%%%
%%% FS - TS: 100000 %%%

% Model Specifics 
ts=100000;
p.resultsdir='FS100000';
p.fileprefix='fs100000_ss_';
p.riverInc = 'implicit_FDM';

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%%%
%%% FS - TS: 25000 %%%

% Model Specifics 
ts=25000;
p.resultsdir='FS25000';
p.fileprefix='fs25000_ss_';
p.riverInc = 'implicit_FDM';

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%%
%%% FS - TS: 2500 %%%

% Model Specifics 
ts=2500;
p.resultsdir='FS2500';
p.fileprefix='fs2500_ss_';
p.riverInc = 'implicit_FDM';

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%%% FS - TS: 250 %%%

% Model Specifics 
ts=250;
p.resultsdir='FS250';
p.fileprefix='fs250_ss_';
p.riverInc = 'implicit_FDM';

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%%
%% EDGE - TS: 100000 %%%

% Model Specifics 
ts=100000;
p.resultsdir='EDGE100000';
p.fileprefix='edge100000_ss_';
p.riverInc = 'TVD_FVM';

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDGE - TS: 25000 %%%

% Model Specifics 
ts=25000;
p.resultsdir='EDGE25000';
p.fileprefix='edge25000_ss_';
p.riverInc = 'TVD_FVM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%% EDGE - TS: 2500 %%%

% Model Specifics 
ts=2500;
p.resultsdir='EDGE2500';
p.fileprefix='edge2500_ss_';
p.riverInc = 'TVD_FVM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%% Explicit - TS: 100000 %%%
%% Not running because the stability check will fail and change dt

% Model Specifics 
ts=100000;
p.resultsdir='EXP100000';
p.fileprefix='exp100000_ss_';
p.riverInc = 'explicit_FDM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%%% Explicit - TS: 25000 %%%


% Model Specifics 
ts=25000;
p.resultsdir='EXP25000';
p.fileprefix='exp25000_ss_';
p.riverInc = 'explicit_FDM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%%% EDGE - TS: 250 %%%

% Model Specifics 
ts=250;
p.resultsdir='EDGE250';
p.fileprefix='edge250_ss_';
p.riverInc = 'TVD_FVM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%%
%%% Explicit - TS: 2500 %%%

% Model Specifics 
ts=2500;
p.resultsdir='EXP2500';
p.fileprefix='exp2500_ss_';
p.riverInc = 'explicit_FDM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%%% Explicit - TS: 250 %%%

% Model Specifics 
ts=250;
p.resultsdir='EXP250';
p.fileprefix='exp250_ss_';
p.riverInc = 'explicit_FDM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=num_ts/num_to_save;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);


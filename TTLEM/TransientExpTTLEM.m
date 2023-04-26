function TransientExpTTLEM()

% Load the steady state landscape from Landlab
load('Landlab_SS.mat','DEM');

Tu=response_time(1);

%%% Uplift %%%
U = GRIDobj(DEM);
upl_rate=5e-4; %Aboslute vertical uplift rate in m/yr
U.Z(2:end-1,2:end-1)=ones(198,198)*upl_rate;

%%% Set erosional parameters %%%
p.D = 0;
p.Kw = 5e-6;
p.m = 0.5;
p.n = 1;
p.diffScheme = 'imp_lin';

%%% Set rho_rs so that ksn equals predicted ksn %%%
p.rho_rs=1;

%%% Set steady state
p.steadyState=false;
p.SS_Value=1e-4;

%%% Set total time and plot / save options %%%
t_total=50e6;
p.TimeSpan=t_total;
% num_to_save=100;
num_to_plot=500;
save_every=100000;

p.BC_Type='Dirichlet';

%%%%%%%%%%%%%%%%%%%%%%%
%% FS - TS: 100000 %%%

% Model Specifics 
ts=100000;
p.resultsdir='FS100000t';
p.fileprefix='fs100000_t_';
p.riverInc = 'implicit_FDM';

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%%%
%%% FS - TS: 25000 %%%

% Model Specifics 
ts=25000;
p.resultsdir='FS25000t';
p.fileprefix='fs25000_t_';
p.riverInc = 'implicit_FDM';

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%%
%%% FS - TS: 2500 %%%

% Model Specifics 
ts=2500;
p.resultsdir='FS2500t';
p.fileprefix='fs2500_t_';
p.riverInc = 'implicit_FDM';

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%%% FS - TS: 250 %%%

% Model Specifics 
ts=250;
p.resultsdir='FS250t';
p.fileprefix='fs250_t_';
p.riverInc = 'implicit_FDM';

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);


%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDGE - TS: 100000 %%%


% Model Specifics 
ts=100000;
p.resultsdir='EDGE100000t';
p.fileprefix='edge100000_t_';
p.riverInc = 'TVD_FVM';
p.cfls = 0.9;

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%%
%% EDGE - TS: 25000 %%%


% Model Specifics 
ts=25000;
p.resultsdir='EDGE25000t';
p.fileprefix='edge25000_t_';
p.riverInc = 'TVD_FVM';
p.cfls = 0.9;

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%% EDGE - TS: 2500 %%%

% Model Specifics 
ts=2500;
p.resultsdir='EDGE2500t';
p.fileprefix='edge2500_t_';
p.riverInc = 'TVD_FVM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%%% EDGE - TS: 250 %%%

% Model Specifics 
ts=250;
p.resultsdir='EDGE250t';
p.fileprefix='edge250_t_';
p.riverInc = 'TVD_FVM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);


%%%%%%%%%%%%%%%%%%%%%%%
%%% Explicit - TS: 100000 %%%


% Model Specifics 
ts=100000;
p.resultsdir='EXP100000t';
p.fileprefix='exp100000_t_';
p.riverInc = 'explicit_FDM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%
%% Explicit - TS: 25000 %%%


% Model Specifics 
ts=25000;
p.resultsdir='EXP25000t';
p.fileprefix='exp25000_t_';
p.riverInc = 'explicit_FDM';
p.cfls = 0.9;

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%% Explicit - TS: 2500 %%%

% Model Specifics 
ts=2500;
p.resultsdir='EXP2500t';
p.fileprefix='exp2500_t_';
p.riverInc = 'explicit_FDM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);

%%%%%%%%%%%%%%%%%%%%%%
%%% Explicit - TS: 250 %%%

% Model Specifics 
ts=250;
p.resultsdir='EXP250t';
p.fileprefix='exp250_t_';
p.riverInc = 'explicit_FDM';
p.cfls = 0.9

% Define Output
p.TimeStep=ts;
num_ts=t_total/ts;
p.ploteach=num_ts/num_to_plot;
p.saveeach=save_every/ts;

% Initialize parameters
p   = ttlemset(p);

% Run model
ttlem_out = ttlem(DEM,U,p);


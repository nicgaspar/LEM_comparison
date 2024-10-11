function [DEM]=NoiseGrid()

	% Generate random initial surface of 0m ± 1m
	dx=100;%m
	Lx=200*dx; %m
	Ly=200*dx;
	x=dx:dx:Lx;
	y=dx:dx:Ly;
	% Set the seed
	rng(10,'twister');

	Z=rand(numel(y),numel(x))*1; %Randomized initial condition
	DEM=GRIDobj(x,y,Z);

	DEM.Z(:,1)=0;
	DEM.Z(:,end)=0;
	DEM.Z(1,:)=0;
	DEM.Z(end,:)=0;

	save('NoiseGrid_ALT.mat','DEM');
	% GRIDobj2ascii(DEM,'NoiseGrid_ALT.txt');

end
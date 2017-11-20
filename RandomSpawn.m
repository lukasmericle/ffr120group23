function [pos, vel] = RandomSpawn(nAgents, fieldSize, center)
% spawns a population of agents randomly according to multivariate Gaussian
% distribution for position and uniform distribution for velocity

sigma = fieldSize/2;

xPos = sigma/2*randn(nAgents,1) + center(1)*fieldSize;
yPos = sigma*randn(nAgents,1) + center(2)*fieldSize;
pos = [xPos  yPos];   % position in Cartesian coordinates

vel = 2*pi*rand(1,nAgents);
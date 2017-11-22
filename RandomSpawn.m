function [pos, vel] = RandomSpawn(nAgents, fieldSize, center)
% spawns a population of agents randomly according to multivariate Gaussian
% distribution for position and uniform distribution for velocity

sigma = (fieldSize/2)/3;

xPos = max(0, min(sigma/2*randn(nAgents,1) + center(1)*fieldSize, fieldSize));
yPos = max(0, min(sigma*randn(nAgents,1) + center(2)*fieldSize, fieldSize));
pos = [xPos  yPos];   % position in Cartesian coordinates

vel = 2*pi*rand(nAgents, 1);
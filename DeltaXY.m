function [dx, dy] = DeltaXY(vel, stepLength)
% updates position of agent

dx = stepLength*cos(vel);
dy = stepLength*sin(vel);
function [polarization, angularMomentum] = GetFlockStats(pos, vel, nAgents)
% see doi:10.1006/yjtbi.3065, eqns. 4-6

xVel = cos(vel)';
yVel = sin(vel)';
polarization = norm([sum(xVel) sum(yVel)])/nAgents;

deviation = [(pos(:,1)-mean(pos(:,1))) (pos(:,2)-mean(pos(:,2))) zeros(nAgents, 1)];
threeDVel = [xVel yVel zeros(nAgents, 1)];
allCrossProduct = sum(cross(deviation, threeDVel, 2), 1);
angularMomentum = norm(allCrossProduct)/nAgents;
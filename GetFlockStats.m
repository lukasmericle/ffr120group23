function [polarization, angularMomentum] = GetFlockStats(pos, vel, nAgents)
% see doi:10.1006/yjtbi.3065, eqns. 4-6
% calculate measures that describe aggregate motion of a flock

xVel = cos(vel);
yVel = sin(vel);
polarization = norm([sum(xVel) sum(yVel)])/nAgents;

threeDDeviation = [(pos(:,1)-mean(pos(:,1))) (pos(:,2)-mean(pos(:,2))) zeros(nAgents, 1)]; %3d vector describing distance of each agent from the flock's centroid
threeDVel = [xVel yVel zeros(nAgents, 1)];
allCrossProduct = sum(cross(threeDDeviation, threeDVel, 2), 1);
angularMomentum = abs(allCrossProduct(3))/nAgents;
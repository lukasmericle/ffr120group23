function [polarization, angularMomentum] = GetFlockStats(pos, vel)
% see doi:10.1006/yjtbi.3065, eqns. 4-6
nAgents = length(vel);

polarization = norm([sum(cos(vel)) sum(sin(vel))])/nAgents;

deviation = [(pos(:,1)-mean(pos(:,1))) (pos(:,2)-mean(pos(:,2))) zeros(nAgents, 1)];
threeDVel = [xVel' yVel' zeros(nAgents, 1)];
allCrossProduct = sum(cross(deviation, threeDVel, 2), 1);
angularMomentum = norm(allCrossProduct)/nAgents;
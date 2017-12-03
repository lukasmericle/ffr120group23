function angularMomentum = CalcAngularMomentum(displacementVec, displacementNorm, vel, speed)
% calculate the angular momentum of a flock

nAgents = length(vel);
[~, centralAgent] = min(sum(displacementNorm)); % get index of most central agent (minimizing distances to all other agents)
displacements = displacementVec(centralAgent, :, :); % displacements relative to central agent
centroid = mean(displacements, 2); % the location of the center of mass of the flock
centeredDisplacements = reshape(displacements-centroid, nAgents, []); % determine the displacements relative to the centroid of the flock
rVec = [centeredDisplacements zeros(nAgents, 1)]; % displacement relative to centroid (in 3D)
velVec = speed*[cos(vel) sin(vel) zeros(nAgents, 1)]; % velocity in Cartesian coords (in 3D)
allCrossProduct = mean(cross(rVec, velVec, 2), 1);
angularMomentum = abs(allCrossProduct(3));
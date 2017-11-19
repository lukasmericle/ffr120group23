function [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPredatorNeighbors)
% get parameters for agents based on the information provided from the enemy
% agents

twopi = 2*pi;
nPrey = length(preyVel);
nPredators = length(predatorVel);

distMatrix = pdist2(preyPos, predatorPos);

[preyPredatorNeighbors, preyPredatorSortIndex] = sort(distMatrix, 2);
preyPredatorParameters = zeros(nPrey, 3*nPredators);
for i = 1:nPrey
    for j = 1:nPredators
        neighborIndex = preyPredatorSortIndex(i, j);
        displacement = predatorPos(neighborIndex,:) - preyPos(i,:);
        rho = preyPredatorNeighbors(i,j);
        theta = mod(atan2(displacement(2), displacement(1)) - preyVel(i), twopi);
        phi = mod(predatorVel(neighborIndex) - preyVel(i), twopi);
        preyPredatorParameters(i, 3*j:3*j+2) = [rho theta phi];
    end
end

[predatorPreyNeighbors, predatorPreySortIndex] = sort(distMatrix);
predatorPreyNeighbors = predatorPreyNeighbors(1:nPredatorNeighbors,:)';
predatorPreySortIndex = predatorPreySortIndex(1:nPredatorNeighbors,:)';
predatorPreyParameters = zeros(nPredators, 3*nPredatorNeighbors);
for i = 1:nPredators
    for j = 1:nPredatorNeighbors
        neighborIndex = predatorPreySortIndex(i,j);
        displacement = preyPos(neighborIndex,:) - predatorPos(i,:);
        rho = predatorPreyNeighbors(i,j);
        theta = mod(atan2(displacement(2), displacement(1)) - predatorVel(i), twopi);
        phi = mod(preyVel(neighborIndex) - predatorVel(i), twopi);
        predatorPreyParameters(i, 3*j:3*j+2) = [rho theta phi];
    end
end
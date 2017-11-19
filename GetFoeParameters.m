function [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPreyAgents, nPredatorAgents, nPredatorNeighbors)
% get parameters for agents based on the information provided from the enemy
% agents

twopi = 2*pi;

distMatrix = pdist2(preyPos, predatorPos);

[preyPredatorNeighbors, preyPredatorSortIndex] = sort(distMatrix, 2);
preyPredatorParameters = zeros(nPreyAgents, 3*nPredatorAgents);
for i = 1:nPreyAgents
    myParameters = zeros(3, nPredatorAgents);
    for j = 1:nPredatorAgents
        neighborIndex = preyPredatorSortIndex(i, j);
        displacement = predatorPos(neighborIndex,:) - preyPos(i,:);
        rho = preyPredatorNeighbors(i,j);
        theta = mod(atan2(displacement(2), displacement(1)) - preyVel(i), twopi);
        phi = mod(predatorVel(neighborIndex) - preyVel(i), twopi);
        myParameters(:, j) = [rho ; theta ; phi];
    end
    preyPredatorParameters(i,:) = reshape(myParameters, 1, []);
end

[predatorPreyNeighbors, predatorPreySortIndex] = sort(distMatrix);
predatorPreyNeighbors = predatorPreyNeighbors(1:nPredatorNeighbors,:)';
predatorPreySortIndex = predatorPreySortIndex(1:nPredatorNeighbors,:)';
predatorPreyParameters = zeros(nPredatorAgents, 3*nPredatorNeighbors);
for i = 1:nPredatorAgents
    myParameters = zeros(3, nPredatorNeighbors);
    for j = 1:nPredatorNeighbors
        neighborIndex = predatorPreySortIndex(i,j);
        displacement = preyPos(neighborIndex,:) - predatorPos(i,:);
        rho = predatorPreyNeighbors(i,j);
        theta = mod(atan2(displacement(2), displacement(1)) - predatorVel(i), twopi);
        phi = mod(preyVel(neighborIndex) - predatorVel(i), twopi);
        myParameters(:, j) = [rho ; theta ; phi];
    end
    predatorPreyParameters = reshape(myParameters, 1, []);
end
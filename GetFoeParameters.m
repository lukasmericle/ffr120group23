function [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPreyAgents, nPredatorAgents, nPredatorNeighbors)
% get parameters for agents based on the information provided from the enemy
% agents

twopi = 2*pi;

distMatrix = pdist2(preyPos, predatorPos);

[preyPredatorNeighbors, preyPredatorSortIndex] = sort(distMatrix, 2);
preyPredatorParameters = zeros(nPreyAgents, 3*nPredatorAgents);
for i = 1:nPreyAgents
    displacement = predatorPos(preyPredatorSortIndex(i,:),:) - repmat(preyPos(i,:), nPredatorAgents, 1);
    rho = preyPredatorNeighbors(i,:);
    theta = mod(atan2(displacement(:,2), displacement(:,1)) - repmat(preyVel(i), nPredatorAgents, 1), twopi);
    phi = mod(predatorVel(preyPredatorSortIndex(i,:)) - preyVel(i), twopi);
    preyPredatorParameters(i,:) = reshape([rho ; theta' ; phi], 1, []);
end

[predatorPreyNeighbors, predatorPreySortIndex] = sort(distMatrix);
predatorPreyNeighbors = predatorPreyNeighbors(1:nPredatorNeighbors,:)';
predatorPreySortIndex = predatorPreySortIndex(1:nPredatorNeighbors,:)';
predatorPreyParameters = zeros(nPredatorAgents, 3*nPredatorNeighbors);
for i = 1:nPredatorAgents
    rho = predatorPreyNeighbors(i,:);
    displacement = preyPos(predatorPreySortIndex(i,:),:) - repmat(predatorPos(i,:), nPredatorNeighbors, 1);
    theta = mod(atan2(displacement(:,2), displacement(:,1)) - repmat(predatorVel(i), nPredatorNeighbors, 1), twopi);
    phi = mod(preyVel(predatorPreySortIndex(i,:)) - predatorVel(i), twopi);
    predatorPreyParameters(i,:) = reshape([rho ; theta' ; phi], 1, []);
end
function [preyPredatorParameters, predatorPreyParameters, captured] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPreyAgents, nPredatorAgents, nPredatorNeighbors, captureDistance)
% get parameters for agents based on the information provided from the enemy
% agents

twopi = 2*pi;
preyPredatorParameters = zeros(nPreyAgents, 3*nPredatorAgents);
predatorPreyParameters = zeros(nPredatorAgents, 3*nPredatorNeighbors);

distMatrix = pdist2(preyPos, predatorPos);

captured = any(distMatrix(:) <= captureDistance);
if captured
    return;
end

[preyPredatorNeighbors, preyPredatorSortIndex] = sort(distMatrix, 2);
for i = 1:nPreyAgents
    displacement = bsxfun(@minus, predatorPos(preyPredatorSortIndex(i,:),:), preyPos(i,:));
    rho = preyPredatorNeighbors(i,:);
    theta = atan2(displacement(:,2), displacement(:,1)) - preyVel(i);
    theta = theta + twopi*(theta < 0);
    phi = predatorVel(preyPredatorSortIndex(i,:)) - preyVel(i);
    phi = phi + twopi*(phi < 0);
    preyPredatorParameters(i,:) = reshape([rho ; theta' ; phi'], 1, []);
end

[predatorPreyNeighbors, predatorPreySortIndex] = sort(distMatrix);
predatorPreyNeighbors = predatorPreyNeighbors(1:nPredatorNeighbors,:)';
predatorPreySortIndex = predatorPreySortIndex(1:nPredatorNeighbors,:)';
for i = 1:nPredatorAgents
    rho = predatorPreyNeighbors(i,:);
    displacement = bsxfun(@minus, preyPos(predatorPreySortIndex(i,:),:), predatorPos(i,:));
    theta = atan2(displacement(:,2), displacement(:,1)) - predatorVel(i);
    theta = theta + twopi*(theta < 0);
    phi = preyVel(predatorPreySortIndex(i,:)) - predatorVel(i);
    phi = phi + twopi*(phi < 0);
    predatorPreyParameters(i,:) = reshape([rho ; theta' ; phi'], 1, []);
end
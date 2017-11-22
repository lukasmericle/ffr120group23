function parameters = GetFriendParameters(pos, vel, nAgents, nNeighbors)
% get parameters for agents based on the information provided from the friendly
% agents

twopi = 2*pi;

distMatrix = squareform(pdist(pos));

[allDists, allSortIndex] = sort(distMatrix, 2);
neighborDists = allDists(:, 2:(2+nNeighbors-1)); % exclude first one, as it is always self
neighborSortIndex = allSortIndex(:, 2:(2+nNeighbors-1));

parameters = zeros(nAgents, 3*nNeighbors);
for i = 1:nAgents
    displacement = bsxfun(@minus, pos(neighborSortIndex(i,:),:), pos(i,:));
    rho = neighborDists(i,:);
    theta = atan2(displacement(:,2), displacement(:,1)) - vel(i);
    theta = theta + twopi*(theta < 0);
    phi = vel(neighborSortIndex(i,:)) - vel(i);
    phi = phi + twopi*(phi < 0);
    parameters(i,:) = reshape([rho ; theta' ; phi'], 1, []);
end
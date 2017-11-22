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
    displacement = pos(neighborSortIndex(i,:),:) - pos(i,:);
    rho = neighborDists(i,:);
    theta = mod(atan2(displacement(:,2), displacement(:,1)) - vel(i), twopi);
    phi = mod(vel(neighborSortIndex(i,:)) - vel(i), twopi);
    parameters(i,:) = reshape([rho ; theta' ; phi'], 1, []);
end
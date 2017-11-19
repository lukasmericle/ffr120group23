function parameters = GetFriendParameters(pos, vel, nAgents, nNeighbors)
% get parameters for agents based on the information provided from the friendly
% agents

twopi = 2*pi;

distMatrix = squareform(pdist(pos));

[neighborDists, neighborSortIndex] = sort(distMatrix, 2);
neighborDists = neighborDists(:,2:2+nNeighbors-1); % exclude first one, as it is always self
neighborSortIndex = neighborSortIndex(:,2:2+nNeighbors-1);

parameters = zeros(nAgents, 3*nNeighbors);
for i = 1:nAgents
    myParameters = zeros(3, nNeighbors);
    for j = 1:nNeighbors
        thisNeighborIndex = neighborSortIndex(i,j);
        displacement = pos(thisNeighborIndex,:) - pos(i,:);
        rho = neighborDists(i,j);
        theta = mod(atan2(displacement(2), displacement(1)) - vel(i), twopi);
        phi = mod(vel(thisNeighborIndex) - vel(i), twopi);
        myParameters(:, j) = [rho ; theta ; phi];
    end
    parameters(i,:) = reshape(myParameters, 1, []);
end
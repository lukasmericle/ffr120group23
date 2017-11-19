function parameters = GetFriendParameters(pos, vel, nNeighbors)
% get parameters for agents based on the information provided from the friendly
% agents

twopi = 2*pi;
nAgents = length(vel);
distMatrix = zeros(nAgents);

for i = 1:nAgents-1
    for j = i+1:nAgents
        displacement = norm(pos(i,:) - pos(j,:));
        distMatrix(i,j) = displacement;
        distMatrix(j,i) = displacement;
    end
end

[neighborDists, neighborSortIndex] = sort(distMatrix, 2);
neighborDists = neighborDists(:,2:2+nNeighbors); % exclude first one, as it is always self
neighborSortIndex = neighborSortIndex(:,2:2+nNeighbors);

parameters = zeros(nAgents, 3*nNeighbors);
for i = 1:nAgents
    for j = 1:nNeighbors
        thisNeighborIndex = neighborSortIndex(i,j);
        displacement = pos(thisNeighborIndex,:) - pos(i,:);
        rho = neighborDists(i,j);
        theta = mod(atan2(displacement(2), displacement(1)) - vel(i), twopi);
        phi = mod(vel(thisNeighborIndex) - vel(i), twopi);
        parameters(i, 3*j:3*j+2) = [rho theta phi];
    end
end
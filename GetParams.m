function params = GetParams(displacementVec, displacementNorm, vel1, vel2, nNeighbors, fieldSize)
% for each neighbor of agent in flock 1, get the descriptive tuples of all
% agents in flock 2 (1 and 2 can be same flock)

[n1,n2,~] = size(displacementVec);
neighborIndices = GetNeighbors(displacementNorm, nNeighbors);

dispVec2 = reshape(permute(displacementVec, [2 1 3]), [], 2);
neighborIndices2 = neighborIndices + n2*(0:(n1-1));
neighborDisps = permute(reshape(dispVec2(neighborIndices2,:), nNeighbors, [], 2), [2 1 3]);

r = sqrt(neighborDisps(:,:,1).^2 + neighborDisps(:,:,2).^2);
theta = atan2(neighborDisps(:,:,2), neighborDisps(:,:,1)) - vel1;
phi = vel2(neighborIndices') - vel1;

stackParams = zeros(n1, nNeighbors, 5);
% all normalized to reasonable ranges
stackParams(:,:,1) = r/(fieldSize/2); % in [0,1]
stackParams(:,:,2) = cos(theta); % in [-1,1]
stackParams(:,:,3) = sin(theta); % in [-1,1]
stackParams(:,:,4) = cos(phi); % in [-1,1]
stackParams(:,:,5) = sin(phi); % in [-1,1]

params = reshape(permute(stackParams, [3 2 1]), [], n1);

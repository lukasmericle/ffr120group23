function rtpParams = GetRTP(pos1, vel1, pos2, vel2, nNeighbors)
% for each neighbor of agent in flock 1, get the (rho,theta,phi) tuples of all
% agents in flock 2 (1 and 2 can be same flock)

% vectorization magic galore... I'll be honest I barely understand how this
% works. --Lukas

n1 = size(pos1,1);
n2 = size(pos2,1);
ppos1 = reshape(pos1, [], 1, 2);
ppos2 = reshape(pos2, 1, [], 2);
displacementVec = ppos2 - ppos1;
displacementNorm = sqrt(displacementVec(:,:,1).^2 + displacementVec(:,:,2).^2);
[distNeighbors, sortNeighbors] = sort(displacementNorm, 2);
rho = distNeighbors(:, 1:nNeighbors);
neighborIndices = sortNeighbors(:, 1:nNeighbors);
neighborIndices2 = neighborIndices+n2*(0:(n1-1))';
displacementVec2 = reshape(displacementVec, [], 2);
displacementNeighbors = -reshape(displacementVec2(neighborIndices2,:), n1, nNeighbors, 2);
theta = mod(atan2(displacementNeighbors(:,:,2), displacementNeighbors(:,:,1)) - vel1, 2*pi);
phi = mod(vel2(neighborIndices) - vel1, 2*pi);

params = zeros(size(rho, 1), nNeighbors, 3);
params(:,:,1) = rho;
params(:,:,2) = theta;
params(:,:,3) = phi;

rtpParams = reshape(permute(params, [3,2,1]), [], 3*nNeighbors)';
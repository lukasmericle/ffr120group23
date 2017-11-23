function rtpParams = GetRTP(pos1, vel1, pos2, vel2, nNeighbors)

ppos1 = reshape(pos1, [], 1, 2);
ppos2 = reshape(pos2, 1, [], 2);
displacementVec = ppos2 - ppos1;
displacementNorm = sqrt(displacementVec(:,:,1).^2 + displacementVec(:,:,2).^2);
[distNeighbors, sortNeighbors] = sort(displacementNorm, 2);
neighborIndices = sortNeighbors(:, 1:nNeighbors);
rho = distNeighbors(:, 1:nNeighbors);
theta = mod(atan2(displacementVec(:,1:nNeighbors,2), displacementVec(:,1:nNeighbors,1)) - vel1, 2*pi);
phi = mod(vel2(neighborIndices) - vel1, 2*pi);

params = zeros(size(rho, 1), nNeighbors, 3);
params(:,:,1) = rho;
params(:,:,2) = theta;
params(:,:,3) = phi;

rtpParams = reshape(permute(params, [3,2,1]), [], 3*nNeighbors)';
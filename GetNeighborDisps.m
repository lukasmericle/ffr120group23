function [neighborDisps, neighborIndices] = GetNeighborDisps(dispVecs, dispNorms, nNeighbors)

[n1,n2,~] = size(dispVecs);
neighborIndices = GetNeighbors(dispNorms, nNeighbors);

dispVec2 = reshape(permute(dispVecs, [2 1 3]), [], 2);
neighborIndices2 = neighborIndices + n2*(0:(n1-1));
neighborDisps = permute(reshape(dispVec2(neighborIndices2,:), nNeighbors, [], 2), [2 1 3]);
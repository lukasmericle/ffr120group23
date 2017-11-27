function neighborIndices = GetNeighbors(dispNorm, nNeighbors)

[~, sortNeighbors] = sort(dispNorm, 2);
neighborIndices = sortNeighbors(:, 1:nNeighbors);
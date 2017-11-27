function neighborIndices = GetNeighbors(dispNorm, nNeighbors)

[~, sortNeighbors] = sort(dispNorm');
neighborIndices = sortNeighbors(1:nNeighbors,:);
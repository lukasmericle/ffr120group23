function neighborIndices = GetNeighbors(dispNorm, nNeighbors)

[~, sortNeighbors] = sort(dispNorm'); % this takes a long time for a large population, can we select only the minimum nNeighbors values faster?
neighborIndices = sortNeighbors(1:nNeighbors,:);

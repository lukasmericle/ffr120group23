function [parameters, displacementVec] = GetFriendParameters(pos, vel, nNeighbors,fieldSize)
% get parameters for agents based on the information provided from the friendly
% agents

[displacementVec, displacementNorm] = GetDisplacements(pos, pos, fieldSize);

params = GetParams(displacementVec, displacementNorm, vel, vel, nNeighbors+1);
parameters = params(5:end,:);
function [parameters, displacementVec, displacementNorm] = GetFriendParameters(pos, vel, nNeighbors,fieldSize)
% get parameters for agents based on the information provided from the friendly
% agents

[displacementVec, displacementNorm] = GetDisplacements(pos, pos, fieldSize);

params = GetParams(displacementVec, displacementNorm, vel, vel, nNeighbors+1, fieldSize); %'nNeighbors+1' because each agent will get parameters for self, so we look at one more agent and drop the self-parameters afterward
parameters = params(6:end,:); % exclude the parameters corresponding to self

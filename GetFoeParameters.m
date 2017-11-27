function [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPredatorAgents, nPredatorNeighbors,fieldSize)
% get parameters for agents based on the information provided from the enemy
% agents

[preyDisplacementVec, preyDisplacementNorm] = GetDisplacements(preyPos, predatorPos, fieldSize);
preyPredatorParameters = GetParams(preyDisplacementVec, preyDisplacementNorm, preyVel, predatorVel, nPredatorAgents);

predatorDisplacementVec = permute(preyDisplacementVec, [2 1 3]);
predatorDisplacementNorm = preyDisplacementNorm';
predatorPreyParameters = GetParams(predatorDisplacementVec, predatorDisplacementNorm, predatorVel, preyVel, nPredatorNeighbors);
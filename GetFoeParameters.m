function [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPreyEnemies, nPredatorEnemies, fieldSize)
% get parameters for agents based on the information provided from the enemy
% agents

[preyDisplacementVec, preyDisplacementNorm] = GetDisplacements(preyPos, predatorPos, fieldSize);
preyPredatorParameters = GetParams(preyDisplacementVec, preyDisplacementNorm, preyVel, predatorVel, nPreyEnemies, fieldSize);

predatorDisplacementVec = permute(preyDisplacementVec, [2 1 3]);
predatorDisplacementNorm = preyDisplacementNorm';

predatorPreyParameters = GetParams(predatorDisplacementVec, predatorDisplacementNorm, predatorVel, preyVel, nPredatorEnemies, fieldSize);

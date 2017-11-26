function [preyPredatorParameters, predatorPreyParameters, captured] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPredatorAgents, nPredatorNeighbors,fieldSize)
% get parameters for agents based on the information provided from the enemy
% agents

preyPredatorParameters = GetRTP(preyPos, preyVel, predatorPos, predatorVel, nPredatorAgents,fieldSize);
predatorPreyParameters = GetRTP(predatorPos, predatorVel, preyPos, preyVel, nPredatorNeighbors,fieldSize);
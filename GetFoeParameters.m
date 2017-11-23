function [preyPredatorParameters, predatorPreyParameters, captured] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPredatorAgents, nPredatorNeighbors)
% get parameters for agents based on the information provided from the enemy
% agents

preyPredatorParameters = GetRTP(preyPos, preyVel, predatorPos, predatorVel, nPredatorAgents);
predatorPreyParameters = GetRTP(predatorPos, predatorVel, preyPos, preyVel, nPredatorNeighbors);
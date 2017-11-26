function [nPreyAgents, nPreyNeighbors, preyTurningRadius, nPredatorAgents, ...
    predatorSpeed, nCompetitions, deltaT, maxTime, captureDistance, ...
    populationSize, selectionParameter, mutationFrequency, mutationDistance] = ...
    TunableParameters

% simulation parameters
nPreyAgents = 300;
nPreyNeighbors = 6; % https://doi.org/10.1016/j.anbehav.2008.02.004
preyTurningRadius = 1;

nPredatorAgents = 3;
predatorSpeed = 1.1;

nCompetitions = 2;
deltaT = 0.5;
maxTime = 120;
captureDistance = 1;

% genetic algorithm parameters
populationSize = 8;
selectionParameter = 0.75;
mutationFrequency = 2; % per chromosome
mutationDistance = 1;
clear all;
clc;

% simulation parameters
preySimParams = struct(...
    'nAgents', 100, ...
    'nNeighbors', 6, ...  % https://doi.org/10.1016/j.anbehav.2008.02.004
    'maxTurningAngle', pi/5,...
    'speed', 1);

predatorSimParams = struct(...
    'nAgents', 1, ...
    'nNeighbors', preySimParams.nNeighbors*2, ...
    'maxTurningAngle', pi/10,...
    'speed', 1.5);

envSimParams = struct(...
    'deltaT', 0.5, ...
    'maxTime', 1000, ...
    'fieldSize', 100, ...
    'captureDistance', 1, ...
    'nCompetitions', 5);

% neural network parameters
preyNNParams = struct(...
    'nInputs', 3*(preySimParams.nNeighbors + predatorSimParams.nAgents), ...
    'nOutputs', 1);
preyNNParams.nHidden = sqrt(preyNNParams.nInputs * preyNNParams.nOutputs);

predatorNNParams = struct(...
    'nInputs', 3*(predatorSimParams.nNeighbors + predatorSimParams.nAgents - 1), ...
    'nOutputs', 1);
predatorNNParams.nHidden = sqrt(predatorNNParams.nInputs * predatorNNParams.nOutputs);

% genetic algorithm parameters
GAParams = struct(...
    'populationSize', 25, ...
    'selectionParameter', 0.618, ...
    'mutationFrequency', 1, ... % per chromosome
    'mutationDistance', 5);

%------------------------------------------------------------------------------

preyPopulation = InitializePopulation(GAParams, preyNNParams);
predatorPopulation = InitializePopulation(GAParams, predatorNNParams);

fitnessMatrix = zeros(GAParams.populationSize);
[fitnessMatrix, preyFitnesses, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, preyPopulation, predatorPopulation, preySimParams, predatorSimParams, envSimParams);

gen = 0;

while true
    
    gen = gen + 1;
    
    [fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = SortPopulation(fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses);
    
    preyPopulation = SteadyStateGAUpdate(preyPopulation, preyFitnesses, GAParams);
    predatorPopulation = SteadyStateGAUpdate(predatorPopulation, predatorFitnesses, GAParams);
    
    fitnessMatrix(populationSize-1:populationSize, :) = 0;
    fitnessMatrix(:, populationSize-1:populationSize) = 0;
    [fitnessMatrix, preyFitnesses, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, preyPopulation, predatorPopulation, preySimParams, predatorSimParams, envSimParams);

end
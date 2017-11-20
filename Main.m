clear all;
clc;

% simulation parameters
nPreyAgents = 333;
nPreyNeighbors = 6; % https://doi.org/10.1016/j.anbehav.2008.02.004
maxPreyTurningAngle = pi/5;

nPredatorAgents = 3;
nPredatorNeighbors = 12;
maxPredatorTurningAngle = pi/10;
predatorSpeed = 1.5;

deltaT = 0.5;
maxTime = 100;
fieldSize = 100;
captureDistance = 5;
nCompetitions = 3;

% neural network parameters
nPreyNNInputs = 3*(nPreyNeighbors + nPredatorAgents);
nPreyNNOutputs = 1;
nPreyNNHidden = floor(sqrt(nPreyNNInputs * nPreyNNOutputs));

nPredatorNNInputs = 3*(nPredatorNeighbors + nPredatorAgents - 1);
nPredatorNNOutputs = 1;
nPredatorNNHidden = floor(sqrt(nPredatorNNInputs * nPredatorNNOutputs));

% genetic algorithm parameters
populationSize = 5;
selectionParameter = (sqrt(5)-1)/2;
mutationFrequency = 1; % per chromosome
mutationDistance = 1;

%------------------------------------------------------------------------------

preyChromosomeLength = nPreyNNOutputs + nPreyNNOutputs*nPreyNNHidden + nPreyNNHidden + nPreyNNHidden*nPreyNNInputs;
preyMutationProbability = mutationFrequency/preyChromosomeLength;
predatorChromosomeLength = nPredatorNNOutputs + nPredatorNNOutputs*nPredatorNNHidden + nPredatorNNHidden + nPredatorNNHidden*nPredatorNNInputs;
predatorMutationProbability = mutationFrequency/predatorChromosomeLength;

preyPopulation = InitializePopulation(populationSize, nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, mutationDistance);
predatorPopulation = InitializePopulation(populationSize, nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, mutationDistance);

fitnessMatrix = zeros(populationSize);
[fitnessMatrix, preyFitnesses, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorSpeed, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              deltaT, maxTime, fieldSize, captureDistance, nCompetitions);

gen = 0;

while true
    
    gen = gen + 1;
    
    [fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = SortPopulation(fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses);
    
    preyPopulation = SteadyStateGAUpdate(preyPopulation, preyFitnesses, populationSize, selectionParameter, preyMutationProbability, mutationDistance);
    predatorPopulation = SteadyStateGAUpdate(predatorPopulation, predatorFitnesses, populationSize, selectionParameter, preyMutationProbability, mutationDistance);
    
    fitnessMatrix(populationSize-1:populationSize, :) = 0;
    fitnessMatrix(:, populationSize-1:populationSize) = 0;
    [fitnessMatrix, preyFitnesses, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorSpeed, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              deltaT, maxTime, fieldSize, captureDistance, nCompetitions);

end
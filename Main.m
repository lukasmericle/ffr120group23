% simulation parameters
nPreyAgents = 100;
nPreyNeighbors = 6; % https://doi.org/10.1016/j.anbehav.2008.02.004
maxPreyTurningAngle = pi/5;

nPredatorAgents = 2;
nPredatorNeighbors = nPreyNeighbors * 2;
predatorSpeed = 1.5;
maxPredatorTurningAngle = maxPreyTurningAngle / predatorSpeed;

fieldSize = 100;
captureDistance = fieldSize / 100;
nCompetitions = 2;
deltaT = captureDistance / predatorSpeed;
maxTime = 120;

% neural network parameters
nPreyNNInputs = 3*(nPreyNeighbors + nPredatorAgents) + 4
nPreyNNOutputs = 1;
nPreyNNHidden = ceil(3*sqrt(nPreyNNInputs + nPreyNNOutputs))

nPredatorNNInputs = 3*(nPredatorNeighbors + nPredatorAgents - 1) + 4
nPredatorNNOutputs = 1;
nPredatorNNHidden = ceil(3*sqrt(nPredatorNNInputs + nPredatorNNOutputs))

% genetic algorithm parameters
populationSize = 10;
selectionParameter = (sqrt(5)-1)/2;
mutationFrequency = 1; % per chromosome
mutationDistance = 1;

%------------------------------------------------------------------------------

maxPreyTurningAngle = maxPreyTurningAngle  * deltaT;
maxPredatorTurningAngle = maxPredatorTurningAngle  * deltaT;
preyStepLength = deltaT;
predatorStepLength = predatorSpeed * deltaT;

preyChromosomeLength = nPreyNNOutputs + nPreyNNOutputs*nPreyNNHidden + nPreyNNHidden + nPreyNNHidden*nPreyNNInputs;
preyMutationProbability = mutationFrequency/preyChromosomeLength;
predatorChromosomeLength = nPredatorNNOutputs + nPredatorNNOutputs*nPredatorNNHidden + nPredatorNNHidden + nPredatorNNHidden*nPredatorNNInputs;
predatorMutationProbability = mutationFrequency/predatorChromosomeLength;

preyPopulation = InitializePopulation(populationSize, preyChromosomeLength, mutationDistance);
predatorPopulation = InitializePopulation(populationSize, predatorChromosomeLength, mutationDistance);

gen = 0;

fitnessMatrix = zeros(populationSize);
[fitnessMatrix, preyFitnesses, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              deltaT, maxTime, fieldSize, captureDistance, nCompetitions, gen);

figure(1);
clf

while true
    
    gen = gen + 1;
    
    [fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = SortPopulation(fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses);
    
    preyPopulation = SteadyStateGAUpdate(preyPopulation, preyFitnesses, populationSize, selectionParameter, preyMutationProbability, mutationDistance);
    predatorPopulation = SteadyStateGAUpdate(predatorPopulation, predatorFitnesses, populationSize, selectionParameter, preyMutationProbability, mutationDistance);
    
    fitnessMatrix(populationSize-1:populationSize, :) = 0;
    fitnessMatrix(:, populationSize-1:populationSize) = 0;
    [fitnessMatrix, preyFitnesses, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              deltaT, maxTime, fieldSize, captureDistance, nCompetitions, gen);

end
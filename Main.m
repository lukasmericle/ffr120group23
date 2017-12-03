[nPreyAgents, nPreyNeighbors, preyTurningRadius, nPredatorAgents, ...
    predatorSpeed, nCompetitions, deltaT, maxTime, captureDistance, ...
    populationSize, selectionParameter, mutationFrequency, mutationDistance] = ...
    TunableParameters;

%------------------------------------------------------------------------------

tupleSize = 5;
nPreyPreyNeighbors = min(nPreyNeighbors, nPreyAgents-1);
nPreyPredatorNeighbors = ceil(nPreyNeighbors/2);
nPredatorPreyNeighbors = nPreyNeighbors*2;
nPredatorPredatorNeighbors = min(nPreyNeighbors, nPredatorAgents-1);
nAgentNeighbors = [nPreyPreyNeighbors, nPreyPredatorNeighbors, nPredatorPreyNeighbors, nPredatorPredatorNeighbors];
predatorTurningRadius = preyTurningRadius * predatorSpeed;
maxPreyTurningAngle = acos(1 - deltaT^2 / (2*preyTurningRadius^2));
maxPredatorTurningAngle = acos(1 - predatorSpeed * deltaT^2 / (2*predatorTurningRadius^2));
preyStepLength = deltaT;
predatorStepLength = predatorSpeed * deltaT;
fieldArea = 10 * (pi*(nPreyAgents*preyTurningRadius^2 + nPredatorAgents*predatorTurningRadius^2));
fieldSize = sqrt(fieldArea);

% neural network parameters
goldenratio = 0.5*(sqrt(5)-1);
nPreyNNInputs = tupleSize*(nPreyPreyNeighbors + nPreyPredatorNeighbors);
nPreyNNOutputs = 1;
nPreyNNHidden = ceil(goldenratio*log(nPreyNNInputs)*nPreyNNInputs^goldenratio);

nPredatorNNInputs = tupleSize*(nPredatorPreyNeighbors + nPredatorPredatorNeighbors);
nPredatorNNOutputs = 1;
nPredatorNNHidden = ceil(goldenratio*log(nPredatorNNInputs)*nPredatorNNInputs^goldenratio);

preyChromosomeLength = nPreyNNOutputs + nPreyNNOutputs*nPreyNNHidden + nPreyNNHidden + nPreyNNHidden*nPreyNNInputs;
preyMutationProbability = mutationFrequency/preyChromosomeLength;
predatorChromosomeLength = nPredatorNNOutputs + nPredatorNNOutputs*nPredatorNNHidden + nPredatorNNHidden + nPredatorNNHidden*nPredatorNNInputs;
predatorMutationProbability = mutationFrequency/predatorChromosomeLength;

fprintf(['Begin simulation...\n\n',...
    'Number of prey agents: %d\n',...
    'Number of predator agents: %d\n',...
    'Predator/prey speeds ratio: %.1f\n',...
    'Number of competitions: %d\n',...
    'Genetic algorithm population size: %d\n',...
    'Prey NN: %d-%d-%d\n',...
    'Predator NN: %d-%d-%d\n',...
    '\n'], ...
    nPreyAgents, nPredatorAgents,...
    predatorSpeed, nCompetitions, populationSize,...
    nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs,...
    nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs);

preyPopulation = InitializePopulation(populationSize, preyChromosomeLength, mutationDistance);
predatorPopulation = InitializePopulation(populationSize, predatorChromosomeLength, mutationDistance);

gen = 0;

fitnessMatrix = zeros(populationSize);
[fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              nAgentNeighbors, deltaT, maxTime, fieldSize, captureDistance, nCompetitions, gen);

for i = 1:10000
    
    gen = gen + 1;
    
    preyPopulation = SteadyStateGAUpdate(preyPopulation, preyFitnesses, populationSize, selectionParameter, preyMutationProbability, mutationDistance);
    predatorPopulation = SteadyStateGAUpdate(predatorPopulation, predatorFitnesses, populationSize, selectionParameter, preyMutationProbability, mutationDistance);
    
    fitnessMatrix(populationSize-1:populationSize, :) = 0;
    fitnessMatrix(:, populationSize-1:populationSize) = 0;
    [fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              nAgentNeighbors, deltaT, maxTime, fieldSize, captureDistance, nCompetitions, gen);
end

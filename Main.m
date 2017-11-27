[nPreyAgents, nPreyNeighbors, preyTurningRadius, nPredatorAgents, ...
    predatorSpeed, nCompetitions, deltaT, maxTime, captureDistance, ...
    populationSize, selectionParameter, mutationFrequency, mutationDistance] = ...
    TunableParameters;

%------------------------------------------------------------------------------

nPredatorNeighbors = nPreyNeighbors * 2;
nPreyNeighbors = min(nPreyNeighbors, nPreyAgents-1);
nPredatorNeighbors = min(nPredatorNeighbors, nPreyAgents);
predatorTurningRadius = preyTurningRadius * predatorSpeed;
maxPreyTurningAngle = acos(1 - deltaT^2 / (2*preyTurningRadius^2));
maxPredatorTurningAngle = acos(1 - predatorSpeed * deltaT^2 / (2*predatorTurningRadius^2));
preyStepLength = deltaT;
predatorStepLength = predatorSpeed * deltaT;
fieldArea = 10 * (pi*(nPreyAgents*preyTurningRadius^2 + nPredatorAgents*predatorTurningRadius^2));
fieldSize = sqrt(fieldArea);


% neural network parameters
goldenratio = 0.5*(sqrt(5)-1);
nPreyNNInputs = 4*(nPreyNeighbors + nPredatorAgents);
nPreyNNOutputs = 1;
nPreyNNHidden = ceil(goldenratio*log(nPreyNNInputs)*nPreyNNInputs^goldenratio);

nPredatorNNInputs = 4*(nPredatorNeighbors + nPredatorAgents - 1);
nPredatorNNOutputs = 1;
nPredatorNNHidden = ceil(goldenratio*log(nPredatorNNInputs)*nPredatorNNInputs^goldenratio);

preyChromosomeLength = nPreyNNOutputs + nPreyNNOutputs*nPreyNNHidden + nPreyNNHidden + nPreyNNHidden*nPreyNNInputs;
preyMutationProbability = mutationFrequency/preyChromosomeLength;
predatorChromosomeLength = nPredatorNNOutputs + nPredatorNNOutputs*nPredatorNNHidden + nPredatorNNHidden + nPredatorNNHidden*nPredatorNNInputs;
predatorMutationProbability = mutationFrequency/predatorChromosomeLength;

preyPopulation = InitializePopulation(populationSize, preyChromosomeLength, mutationDistance);
predatorPopulation = InitializePopulation(populationSize, predatorChromosomeLength, mutationDistance);

gen = 0;

fitnessMatrix = zeros(populationSize);
[fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              deltaT, maxTime, fieldSize, captureDistance, nCompetitions, gen);

while true
    
    gen = gen + 1;
    
    preyPopulation = SteadyStateGAUpdate(preyPopulation, preyFitnesses, populationSize, selectionParameter, preyMutationProbability, mutationDistance);
    predatorPopulation = SteadyStateGAUpdate(predatorPopulation, predatorFitnesses, populationSize, selectionParameter, preyMutationProbability, mutationDistance);
    
    fitnessMatrix(populationSize-1:populationSize, :) = 0;
    fitnessMatrix(:, populationSize-1:populationSize) = 0;
    [fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              deltaT, maxTime, fieldSize, captureDistance, nCompetitions, gen);

end
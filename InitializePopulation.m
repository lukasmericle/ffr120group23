function population = InitializePopulation(populationSize, chromosomeLength, mutationDistance)
% create a random population with Gaussian distribution for weights and
% thresholds

population = mutationDistance * randn(populationSize, chromosomeLength);
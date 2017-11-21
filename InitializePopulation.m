function population = InitializePopulation(populationSize, chromosomeLength, mutationDistance)
% create a random population

randSpread = rand(populationSize, chromosomeLength);
population = mutationDistance * (2 * randSpread - 1);
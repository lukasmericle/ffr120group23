function population = InitializePopulation(populationSize, chromosomeLength, mutationDistance)
% create a random population

%population = mutationDistance * randn(populationSize, chromosomeLength);
population = mutationDistance * (2*rand(populationSize, chromosomeLength)-1);

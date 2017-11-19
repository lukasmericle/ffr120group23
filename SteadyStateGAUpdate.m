function population = SteadyStateGAUpdate(population, fitnesses, GAParams)
% accepts population and fitnesses, sorted by descending fitness
% drops worst two individuals and generates two more from remaining population

populationSize = size(population, 1);

population = population(1:populationSize-2, :);
fitnesses = fitnesses(1:populationSize-2, :);

individual1 = TournamentSelect(fitnesses, GAParams.selectionParameter, 2);
individual2 = TournamentSelect(fitnesses, GAParams.selectionParameter, 2);

% cross with 100% probability
chromosome1 = population(individual1, :);
chromosome2 = population(individual2, :);
[chromosome1, chromosome2] = Cross(chromosome1, chromosome2);

chromosomeLength = length(chromosome1);
mutationProbability = GAParams.mutationFrequency/chromosomeLength;
chromosome1 = Mutate(chromosome1, mutationProbability, GAParams.mutationDistance);
chromosome2 = Mutate(chromosome2, mutationProbability, GAParams.mutationDistance);

population = [population ; chromosome1 ; chromosome2];
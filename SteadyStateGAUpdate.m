function population = SteadyStateGAUpdate(population, fitnesses, populationSize, selectionParameter, mutationProbability, mutationDistance)
% accepts population and fitnesses, sorted by descending fitness
% drops worst two individuals and generates two more from remaining population

population = population(1:populationSize-2, :);
fitnesses = fitnesses(:, 1:populationSize-2);

individual1 = TournamentSelect(fitnesses, selectionParameter, 2);
individual2 = TournamentSelect(fitnesses, selectionParameter, 2);

% cross with 100% probability
chromosome1 = population(individual1, :);
chromosome2 = population(individual2, :);
[chromosome1, chromosome2] = Cross(chromosome1, chromosome2);

chromosome1 = Mutate(chromosome1, mutationProbability, mutationDistance);
chromosome2 = Mutate(chromosome2, mutationProbability, mutationDistance);

population = [population ; chromosome1 ; chromosome2];
function population = InitializePopulation(populationSize, nInputs, nHidden, nOutputs, mutationDistance)
% create a random population

chromosomeSize = nOutputs + nOutputs*nHidden + nHidden + nHidden*nInputs;
randSpread = rand(populationSize, chromosomeSize);
population = mutationDistance * (2 * randSpread - 1);
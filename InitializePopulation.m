function population = InitializePopulation(GAParams, nnParams)
% create a random population

nInputs = nnParams.nInputs;
nHidden = nnParams.nHidden;
nOutputs = nnParams.nOutputs;
chromosomeSize = nOutputs + nOutputs*nHidden + nHidden + nHidden*nInputs;
randSpread = rand(GAParams.populationSize, chromosomeSize);
population = GAParams.mutationDistance * (2 * randSpread - 1);
function mutatedChromosome = Mutate(chromosome, mutationProbability, mutationDistance)
% mutates each gene in a chromosome via creep mutation

rmp = rand(1,length(chromosome)) < mutationProbability;
%rcm = randn(1,length(chromosome)) * mutationDistance;
rcm = (2*rand(1, length(chromosome))-1) * mutationDistance;

mutatedChromosome = chromosome + rmp.*rcm;

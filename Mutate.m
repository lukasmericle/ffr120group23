function chromosome = Mutate(chromosome, mutationProbability, mutationDistance)
% mutates each gene in a chromosome via creep mutation with Gaussian
% distribution

for i = 1:length(chromosome)
    r = rand();
    if r < mutationProbability
        chromosome(i) = chromosome(i) + randn() * mutationDistance;
    end
end
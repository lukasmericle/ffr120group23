function [newChromosome1, newChromosome2] = Cross(chromosome1, chromosome2)
% performs crossover for two chromosomes

chromosomeSize = length(chromosome1);

r = randi([1 chromosomeSize-1]);

chunk11 = chromosome1(1:r);
chunk12 = chromosome1(r+1:chromosomeSize);

chunk21 = chromosome2(1:r);
chunk22 = chromosome2(r+1:chromosomeSize);

newChromosome1 = [chunk11 chunk22];
newChromosome2 = [chunk21 chunk12];

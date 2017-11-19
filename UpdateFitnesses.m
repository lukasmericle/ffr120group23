function [fitnessMatrix, preyFitnesses, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, preyPopulation, predatorPopulation, preySimParams, predatorSimParams, envSimParams)
% run a number of simulations to fill in the missing fitnesses in our
% fitnessMatrix

[rows, cols] = find(~fitnessMatrix); % selects all (i,j) where fitnessMatrix(i,j)==0
for i = 1:length(rows)
    row = rows(i);
    col = cols(i);
    fitness = 0;
    for n = 1:envSimParams.nCompetitions
        thisFitness = Compete(preyPopulation(row,:), predatorPopulation(col,:), preySimParams, predatorSimParams, envSimParams);
        fitness = fitness + thisFitness;
    end
    fitnessMatrix(row,col) = fitness/envSimParams.nCompetitions;
end

preyFitnesses = sum(fitnessMatrix, 2)';
predatorFitnesses = -sum(fitnessMatrix, 1);
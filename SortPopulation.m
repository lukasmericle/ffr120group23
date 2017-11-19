function [fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = SortPopulation(fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses)
% note: this sort *preserves* information about competitions between prey i and
% predator j

toSort = [preyFitnesses' fitnessMatrix];
[sortedMatrix, preySortIndex] = sortrows(toSort, 'descend');
preyFitnesses = sortedMatrix(:, 1)';
preyPopulation = preyPopulation(preySortIndex,:);
fitnessMatrix = sortedMatrix(:, 2:size(sortedMatrix, 1));

toSort = [predatorFitnesses' fitnessMatrix'];
[sortedMatrix, predatorSortIndex] = sortrows(toSort, 'descend');
predatorFitnesses = sortedMatrix(:, 1)';
predatorPopulation = predatorPopulation(predatorSortIndex,:);
fitnessMatrix = sortedMatrix(:, 2:size(sortedMatrix, 1))';
function winner = TournamentSelect(fitnessValues, selectionParameter, tournamentSize)
% select an individual from the population using tournament selection

if tournamentSize > length(fitnessValues)
    disp("Tournament size is greater than population size.");
    return;
elseif tournamentSize < 2
    disp("Tournament must have at least two participants.");
    return;
end

[selectedFitnesses, selectedIndividuals] = datasample(fitnessValues, tournamentSize);
[~, sortIndices] = sort(selectedFitnesses, 'descend');
sortedIndividuals = selectedIndividuals(sortIndices);

winnerFound = false;

while ~winnerFound
    r = rand();
    if (length(sortedIndividuals) == 1) || (r < selectionParameter)
        winnerFound = true;
        winner = sortedIndividuals(1);
    else
        sortedIndividuals(1) = [];
    end
end

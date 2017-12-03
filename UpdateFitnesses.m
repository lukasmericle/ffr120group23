function [fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              nAgentNeighbors, deltaT, maxTime, fieldSize, captureDistance, nCompetitions, gen)
% run a number of simulations to fill in the missing fitnesses in our
% fitnessMatrix, then record a competition between 

fprintf("\nGeneration %d\n----\n", gen);

[rows, cols] = find(~fitnessMatrix); % selects all (i,j) where fitnessMatrix(i,j)==0
preyPopulationParfor = preyPopulation(rows,:);
predatorPopulationParfor = predatorPopulation(cols,:);
fitnessParfor = zeros(1, length(rows));

parfor i = 1:length(rows)
    fprintf("Evaluating prey %2d vs predator %2d ...\n", rows(i), cols(i));
    fitness = 0;
    for n = 1:nCompetitions
        thisFitness = Compete(preyPopulationParfor(i,:), ...
                              nPreyAgents, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulationParfor(i,:), ...
                              nPredatorAgents, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              nAgentNeighbors, deltaT, maxTime, fieldSize, captureDistance, gen, false);
        fitness = fitness + thisFitness;
    end
    fitnessParfor(i) = fitness/nCompetitions;
end

for i = 1:length(rows)
    row = rows(i);
    col = cols(i);
    fitnessMatrix(row,col) = fitnessParfor(i);
end

preyFitnesses = mean(fitnessMatrix, 2)';
predatorFitnesses = -mean(fitnessMatrix, 1);

[fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = SortPopulation(fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses);

% this run competes the best prey v best predator and records the competition
[timeElapsed, simStats, preyStats, predatorStats]= Compete(preyPopulation(1,:), ...
                      nPreyAgents, maxPreyTurningAngle, preyStepLength, ...
                      nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                      predatorPopulation(1,:), ...
                      nPredatorAgents, maxPredatorTurningAngle, predatorStepLength, ...
                      nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                      nAgentNeighbors, deltaT, maxTime, fieldSize, captureDistance, gen, true);

grandparentFolderName = 'Simulation Data';
parentFolderName = sprintf('%04d-%03d-%02d-%.2f--%.2f-%d', ...
                    preyStats.nAgents, predatorStats.nAgents, ...
                    preyStats.nFriendlyNeighbors, predatorStats.speed, ...
                    simStats.deltaT, simStats.maxTime);
folderName = sprintf('Generation %d', simStats.generation);
if ispc
    filePath = [pwd, '\', grandparentFolderName, '\', parentFolderName, '\', folderName, '\'];
elseif isunix
    filePath = [pwd, '/', grandparentFolderName, '/', parentFolderName, '/', folderName, '/'];
end
mkdir(filePath);
preyPassiveStats = SimulatePassiveBM(simStats, preyStats);
predatorPassiveStats = SimulatePassiveBM(simStats, predatorStats);
preyActiveStats = SimulateActiveBM(simStats, preyStats);
predatorActiveStats = SimulateActiveBM(simStats, predatorStats);
[preyBoidStats, predatorBoidStats] = SimulateBoids(simStats, preyStats, predatorStats, fieldSize);

tic;
PlotSimulation(filePath, simStats, preyStats, predatorStats, preyBoidStats, predatorBoidStats, fieldSize);
PlotDiffusion(filePath, 'Prey', simStats, preyPassiveStats, preyActiveStats, preyBoidStats, preyStats);
PlotDiffusion(filePath, 'Predator', simStats, predatorPassiveStats, predatorActiveStats, predatorBoidStats, predatorStats);
PlotMSD(filePath, 'Prey', simStats, preyPassiveStats, preyActiveStats, preyBoidStats, preyStats);
PlotMSD(filePath, 'Predator', simStats, predatorPassiveStats, predatorActiveStats, predatorBoidStats, predatorStats);
toc
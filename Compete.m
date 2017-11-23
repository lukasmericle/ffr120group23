function timeElapsed = Compete(preyNN, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                               nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                               predatorNN, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                               nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                               deltaT, maxTime, fieldSize, captureDistance, thisGeneration)
% runs one full simulation based on prey and predator chromosomes and
% simulation parameters, returning the time elapsed before one of the stop
% conditions was met

%TODO replace pos/vel awareness with vector to nearest wall (in own ref. frame)

[preyT1, preyW12, preyT2, preyW23] = DecodeChromosome(preyNN, nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs);
[predatorT1, predatorW12, predatorT2, predatorW23] = DecodeChromosome(predatorNN, nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs);

[preyPos, preyVel] = RandomSpawn(nPreyAgents, fieldSize, [(3/4) (1/2)]);
[predatorPos, predatorVel] = RandomSpawn(nPredatorAgents, fieldSize, [1/4 1/2]);


clf;
preyObj = plot(preyPos(:,1), preyPos(:,2), 'b.');
hold on;
xlim manual;
ylim manual;
predatorObj = plot(predatorPos(:,1), predatorPos(:,2), 'r*');
myTitle = ['Gen=', num2str(thisGeneration), ', t=0.0'];
title(myTitle);
xlim([0 fieldSize]);
ylim([0 fieldSize]);
drawnow;

timeElapsed = 0;
captured = false;
while (timeElapsed < maxTime) && ~captured
    
    preyWallVectors = GetWallVectors(preyPos, preyVel, fieldSize);
    predatorWallVectors = GetWallVectors(predatorPos, predatorVel, fieldSize);
    
    preyPreyParameters = GetFriendParameters(preyPos, preyVel, nPreyNeighbors);
    [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPredatorAgents, nPredatorNeighbors);
    predatorPredatorParameters = GetFriendParameters(predatorPos, predatorVel, nPredatorAgents-1);
    
    preyInputVectors = [preyWallVectors ; preyPreyParameters ; preyPredatorParameters];
    predatorInputVectors = [predatorWallVectors ; predatorPreyParameters ; predatorPredatorParameters];
    
    [preyPos, preyVel] = UpdateAgentState(preyPos, preyVel, preyInputVectors, preyT1, preyW12, preyT2, preyW23, maxPreyTurningAngle, preyStepLength, deltaT, fieldSize);
    [preyPolarization, preyAngularMomentum] = GetFlockStats(preyPos, preyVel, nPreyAgents);
    
    [predatorPos, predatorVel] = UpdateAgentState(predatorPos, predatorVel, predatorInputVectors, predatorT1, predatorW12, predatorT2, predatorW23, maxPredatorTurningAngle, predatorStepLength, deltaT, fieldSize);
    [predatorPolarization, predatorAngularMomentum] = GetFlockStats(predatorPos, predatorVel, nPredatorAgents);
    
    captured = CheckCaptured(preyPos, predatorPos, captureDistance);
    timeElapsed = timeElapsed + deltaT;
    myTitle = ['Gen=', num2str(thisGeneration), ', t=', num2str(round(timeElapsed, 1))];
    %PlotAgentStates(preyObj, preyPos, predatorObj, predatorPos, myTitle, fieldSize);
end
clf;
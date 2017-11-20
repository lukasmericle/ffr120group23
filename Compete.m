function timeElapsed = Compete(preyNN, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, ...
                               nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                               predatorNN, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorSpeed, ...
                               nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                               deltaT, maxTime, fieldSize, captureDistance)
% runs one full simulation based on prey and predator chromosomes and
% simulation parameters, returning the time elapsed before one of the stop
% conditions was met

[preyT1, preyW12, preyT2, preyW23] = DecodeChromosome(preyNN, nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs);
[predatorT1, predatorW12, predatorT2, predatorW23] = DecodeChromosome(predatorNN, nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs);

[preyPos, preyVel] = RandomSpawn(nPreyAgents, fieldSize, [(3/4) (1/2)]);
[predatorPos, predatorVel] = RandomSpawn(nPredatorAgents, fieldSize, [1/4 1/2]);

clf;
figure(1);
ax = gca;

preyObj = plot(preyPos(:,1), preyPos(:,2),'g.');
hold on;
predatorObj = plot(predatorPos(:,1), predatorPos(:,2),'r*');
title('t=0');
xlim([0 fieldSize]);
ylim([0 fieldSize]);
drawnow;

timeElapsed = 0;
captured = false;
while (timeElapsed < maxTime)
    [preyPredatorParameters, predatorPreyParameters, captured] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPreyAgents, nPredatorAgents, nPredatorNeighbors, captureDistance);
    if captured
        break
    end
    preyPreyParameters = GetFriendParameters(preyPos, preyVel, nPreyAgents, nPreyNeighbors);
    preyInputVectors = [preyPreyParameters preyPredatorParameters];
    if nPredatorAgents > 1
        predatorPredatorParameters = GetFriendParameters(predatorPos, predatorVel, nPredatorAgents, nPredatorAgents-1);
        predatorInputVectors = [predatorPreyParameters predatorPredatorParameters];
    else
        predatorInputVectors = predatorPreyParameters;
    end
    
    [preyPos, preyVel] = UpdateAgentState(preyPos, preyVel, preyInputVectors, preyT1, preyW12, preyT2, preyW23, maxPreyTurningAngle, 1, deltaT, fieldSize);
    [preyPolarization, preyAngularMomentum] = GetFlockStats(preyPos, preyVel, nPreyAgents);
    
    [predatorPos, predatorVel] = UpdateAgentState(predatorPos, predatorVel, predatorInputVectors, predatorT1, predatorW12, predatorT2, predatorW23, maxPredatorTurningAngle, predatorSpeed, deltaT, fieldSize);
    [predatorPolarization, predatorAngularMomentum] = GetFlockStats(predatorPos, predatorVel, nPredatorAgents);
    
    timeElapsed = timeElapsed + deltaT;
    myTitle = ['t=', num2str(timeElapsed)];
    PlotAgentStates(preyObj, preyPos, preyVel, predatorObj, predatorPos, predatorVel, myTitle, fieldSize);
end
clf;
function timeElapsed = Compete(preyNN, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                               nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                               predatorNN, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                               nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                               deltaT, maxTime, fieldSize, captureDistance, thisGeneration, film)
% runs one full simulation based on prey and predator chromosomes and
% simulation parameters, returning the time elapsed before one of the stop
% conditions was met

[preyT1, preyW12, preyT2, preyW23] = DecodeChromosome(preyNN, nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs);
[predatorT1, predatorW12, predatorT2, predatorW23] = DecodeChromosome(predatorNN, nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs);

[preyPos, preyVel] = RandomSpawn(nPreyAgents, fieldSize, [(3/4) (1/2)]);
[predatorPos, predatorVel] = RandomSpawn(nPredatorAgents, fieldSize, [1/4 1/2]);

if film
    clf;
    [preyObj, predatorObj] = InitializePlot(preyPos, predatorPos, fieldSize, thisGeneration);
    % initialize storage vectors for FlockStats
    % initialize videowriter
end

timeElapsed = 0;
captured = false;
while (timeElapsed < maxTime) && ~captured
    
    preyPreyParameters = GetFriendParameters(preyPos, preyVel, nPreyNeighbors,fieldSize);
    [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPredatorAgents, nPredatorNeighbors,fieldSize);
    predatorPredatorParameters = GetFriendParameters(predatorPos, predatorVel, nPredatorAgents-1,fieldSize);
    preyInputVectors = [preyPreyParameters ; preyPredatorParameters];
    predatorInputVectors = [predatorPreyParameters ; predatorPredatorParameters];
    
    [preyPos, preyVel] = UpdateAgentState(preyPos, preyVel, preyInputVectors, preyT1, preyW12, preyT2, preyW23, maxPreyTurningAngle, preyStepLength, deltaT, fieldSize);
    [predatorPos, predatorVel] = UpdateAgentState(predatorPos, predatorVel, predatorInputVectors, predatorT1, predatorW12, predatorT2, predatorW23, maxPredatorTurningAngle, predatorStepLength, deltaT, fieldSize);
    
    captured = CheckCaptured(preyPos, predatorPos, captureDistance);
    timeElapsed = timeElapsed + deltaT;
    
    if film
        [preyPolarization, preyAngularMomentum] = GetFlockStats(preyPos, preyVel, nPreyAgents);
        [predatorPolarization, predatorAngularMomentum] = GetFlockStats(predatorPos, predatorVel, nPredatorAgents);
        myTitle = sprintf('Gen = %d, t = %5.2f',thisGeneration, round(timeElapsed,2));
        PlotAgentStates(preyObj, preyPos, predatorObj, predatorPos, myTitle);
        % write to video and storage vectors
    end
    
end
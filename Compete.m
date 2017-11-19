function timeElapsed = Compete(preyNN, predatorNN, preySimParams, predatorSimParams, envSimParams)
% runs one full simulation based on prey and predator chromosomes and
% simulation parameters, returning the time elapsed before one of the stop
% conditions was met

[preyT1, preyW12, preyT2, preyW23] = DecodeChromosome(preyNN, preySimParams);
[predatorT1, predatorW12, predatorT2, predatorW23] = DecodeChromosome(predatorNN, predatorSimParams);

[preyPos, preyVel] = RandomSpawn(preySimParams.nAgents, envSimParams.fieldSize, [3/4 1/2]);
[predatorPos, predatorVel] = RandomSpawn(predatorSimParams.nAgents, envSimParams.fieldSize, [1/4 1/2]);

timeElapsed = 0;
captured = false;
while (timeElapsed <= envSimParams.maxTime) && ~captured
    preyPreyParameters = GetFriendParameters(preyPos, preyVel, preySimParams.nAgents, preySimParams.nNeighbors);
    predatorPredatorParameters = GetFriendParameters(predatorPos, predatorVel, predatorSimParams.nAgents, predatorSimParams.nAgents-1);
    [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, predatorSimParams.nNeighbors);
    
    preyInputVectors = [preyPreyParameters preyPredatorParameters];
    [preyPos, preyVel] = UpdateAgentState(preyPos, preyVel, preyInputVectors, preyT1, preyW12, preyT2, preyW23, preySimParams, envSimParams);
    preyPolarization, preyAngularMomentum = GetFlockStats(preyPos, preyVel);
    
    predatorInputVectors = [predatorPreyParameters predatorPredatorParameters];
    [predatorPos, predatorVel] = UpdateAgentState(predatorPos, predatorVel, predatorInputVectors, predatorT1, predatorW12, predatorT2, predatorW23, predatorSimParams, envSimParams);
    predatorPolarization, predatorAngularMomentum = GetFlockStats(predatorPos, predatorVel);
    
    captured = CheckCaptured(preyPos, predatorPos, envSimParams.captureDistance);
    timeElapsed = timeElapsed + envSimParams.deltaT;
end
function [timeElapsed, simStats, preyStats, predatorStats] = Compete(preyNN, nPreyAgents, maxPreyTurningAngle, preyStepLength, ...
                               nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                               predatorNN, nPredatorAgents, maxPredatorTurningAngle, predatorStepLength, ...
                               nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                               nAgentNeighbors, deltaT, maxTime, fieldSize, captureDistance, thisGeneration, collectstats)
% runs one full simulation based on prey and predator chromosomes and
% simulation parameters, returning the time elapsed before one of the stop
% conditions was met

[preyT1, preyW12, preyT2, preyW23] = DecodeChromosome(preyNN, nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs);
[predatorT1, predatorW12, predatorT2, predatorW23] = DecodeChromosome(predatorNN, nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs);

[preyPos, preyVel] = RandomSpawn(nPreyAgents, fieldSize, [1/2 1/2]);
[predatorPos, predatorVel] = RandomSpawn(nPredatorAgents, fieldSize, [0 1/2]);

simStats = struct;
preyStats = struct;
predatorStats = struct;

if collectstats
    
    simStats.maxTime = maxTime;
    simStats.deltaT = deltaT;
    simStats.generation = thisGeneration;
    simStats.t = 0:deltaT:maxTime;
    timeSteps = length(simStats.t);
    
    preyStats.x = zeros(nPreyAgents, timeSteps);
    preyStats.x(:,1) = preyPos(:,1);
    preyStats.y = zeros(nPreyAgents, timeSteps);
    preyStats.y(:,1) = preyPos(:,2);
    preyStats.v = zeros(nPreyAgents, timeSteps);
    preyStats.v(:,1) = preyVel;
    preyStats.dx = zeros(nPreyAgents, timeSteps);
    preyStats.dy = zeros(nPreyAgents, timeSteps);
    preyStats.dv = zeros(nPreyAgents, timeSteps);
    preyStats.pol = zeros(1, timeSteps);
    preyStats.ang = zeros(1, timeSteps);
    preyStats.NN = preyNN;
    preyStats.nAgents = nPreyAgents;
    preyStats.nFriendlyNeighbors = nAgentNeighbors(1);
    preyStats.nEnemyNeighbors = nAgentNeighbors(2);
    preyStats.speed = 1;
    preyStats.maxdv = maxPreyTurningAngle;
    
    predatorStats.x = zeros(nPredatorAgents, timeSteps);
    predatorStats.x(:,1) = predatorPos(:,1);
    predatorStats.y = zeros(nPredatorAgents, timeSteps);
    predatorStats.y(:,1) = predatorPos(:,2);
    predatorStats.v = zeros(nPredatorAgents, timeSteps);
    predatorStats.v(:,1) = predatorVel;
    predatorStats.dx = zeros(nPredatorAgents, timeSteps);
    predatorStats.dy = zeros(nPredatorAgents, timeSteps);
    predatorStats.dv = zeros(nPredatorAgents, timeSteps);
    predatorStats.pol = zeros(1, timeSteps);
    predatorStats.ang = zeros(1, timeSteps);
    predatorStats.NN = predatorNN;
    predatorStats.nAgents = nPredatorAgents;
    predatorStats.nFriendlyNeighbors = nAgentNeighbors(4);
    predatorStats.nEnemyNeighbors = nAgentNeighbors(3);
    predatorStats.speed = predatorStepLength/deltaT;
    predatorStats.maxdv = maxPredatorTurningAngle;

end

timeElapsed = 0;
captured = false;
stepCount = 1;
while (timeElapsed < maxTime) && ~captured
    
    timeElapsed = timeElapsed + deltaT;
    stepCount = stepCount + 1;
    
    [preyPreyParameters, preyDispVec, preyDispNorm] = GetFriendParameters(preyPos, preyVel, nAgentNeighbors(1), fieldSize);
    [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nAgentNeighbors(2), nAgentNeighbors(3), fieldSize);
    [predatorPredatorParameters, predatorDispVec, predatorDispNorm] = GetFriendParameters(predatorPos, predatorVel, nAgentNeighbors(4), fieldSize);
    preyInputVectors = [preyPreyParameters ; preyPredatorParameters];
    predatorInputVectors = [predatorPreyParameters ; predatorPredatorParameters];
    
    preydv = DeltaPhi(preyInputVectors, preyT1, preyW12, preyT2, preyW23, maxPreyTurningAngle);
    preyVel = mod(preyVel + preydv, 2*pi);
    [preydx, preydy] = DeltaXY(preyVel, preyStepLength);
    preyPos(:,1) = mod(preyPos(:,1) + preydx, fieldSize);
    preyPos(:,2) = mod(preyPos(:,2) + preydy, fieldSize);
    
    predatordv = DeltaPhi(predatorInputVectors, predatorT1, predatorW12, predatorT2, predatorW23, maxPredatorTurningAngle);
    predatorVel = mod(predatorVel + predatordv, 2*pi);
    [predatordx, predatordy] = DeltaXY(predatorVel, predatorStepLength);
    predatorPos(:,1) = mod(predatorPos(:,1) + predatordx, fieldSize);
    predatorPos(:,2) = mod(predatorPos(:,2) + predatordy, fieldSize);
    
    if collectstats
        
        preyStats.x(:,stepCount) = preyPos(:,1);
        preyStats.y(:,stepCount) = preyPos(:,2);
        preyStats.v(:,stepCount) = preyVel;
        preyStats.dx(:,stepCount) = preydx;
        preyStats.dy(:,stepCount) = preydy;
        preyStats.dv(:,stepCount) = preydv;
        preyStats.pol(stepCount) = CalcPolarization(preyVel);
        preyStats.ang(stepCount) = CalcAngularMomentum(preyDispVec, preyDispNorm, preyVel, 1);
        
        predatorStats.x(:,stepCount) = predatorPos(:,1);
        predatorStats.y(:,stepCount) = predatorPos(:,2);
        predatorStats.v(:,stepCount) = predatorVel;
        predatorStats.dx(:,stepCount) = predatordx;
        predatorStats.dy(:,stepCount) = predatordy;
        predatorStats.dv(:,stepCount) = predatordv;
        predatorStats.pol(stepCount) = CalcPolarization(predatorVel);
        predatorStats.ang(stepCount) = CalcAngularMomentum(predatorDispVec, predatorDispNorm, predatorVel, predatorStepLength/deltaT);

    end
    
    captured = CheckCaptured(preyPos, predatorPos, captureDistance);
    
end

if collectstats
    
    simStats.t = simStats.t(1:stepCount);
    simStats.stepCount = stepCount;
    simStats.timeElapsed = timeElapsed;
    
    preyStats.x = preyStats.x(:,1:stepCount);
    preyStats.y = preyStats.y(:,1:stepCount);
    preyStats.v = preyStats.v(:,1:stepCount);
    preyStats.dx = preyStats.dx(:,1:stepCount);
    preyStats.dy = preyStats.dy(:,1:stepCount);
    preyStats.dv = preyStats.dv(:,1:stepCount);
    preyStats.pol = preyStats.pol(1:stepCount);
    preyStats.ang = preyStats.ang(1:stepCount);
    netDisplacementX = sum(preyStats.dx, 2);
    netDisplacementY = sum(preyStats.dy, 2);
    preyStats.netphi = atan2(sum(netDisplacementY), sum(netDisplacementX));
    
    predatorStats.x = predatorStats.x(:,1:stepCount);
    predatorStats.y = predatorStats.y(:,1:stepCount);
    predatorStats.v = predatorStats.v(:,1:stepCount);
    predatorStats.dx = predatorStats.dx(:,1:stepCount);
    predatorStats.dy = predatorStats.dy(:,1:stepCount);
    predatorStats.dv = predatorStats.dv(:,1:stepCount);
    predatorStats.pol = predatorStats.pol(1:stepCount);
    predatorStats.ang = predatorStats.ang(1:stepCount);
    netDisplacementX = sum(predatorStats.dx, 2);
    netDisplacementY = sum(predatorStats.dy, 2);
    predatorStats.netphi = atan2(sum(netDisplacementY), sum(netDisplacementX));
    
    preyStats = GetDiffusionStats(simStats, preyStats);
    predatorStats = GetDiffusionStats(simStats, predatorStats);
    
end
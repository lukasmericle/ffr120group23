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
    [ax1, ax2, ax3, preyObj, predatorObj, preyPolObj, preyAngObj, ...
     predatorPolObj, predatorAngObj] = InitializePlot(preyPos, predatorPos, ...
                                                    fieldSize, thisGeneration);
    flockTArr = 0:deltaT:maxTime;
    timeSteps = length(flockTArr);
    preyPolArr = zeros(1, timeSteps);
    preyAngArr = zeros(1, timeSteps);
    predatorPolArr = zeros(1, timeSteps);
    predatorAngArr = zeros(1, timeSteps);
    % initialize storage vectors for FlockStats
    % initialize videowriter
end

timeElapsed = 0;
captured = false;
stepCount = 0;
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
    stepCount = stepCount + 1;
    
    if film
        
        [preyPolarization, preyAngularMomentum] = GetFlockStats(preyPos, preyVel, nPreyAgents);
        [predatorPolarization, predatorAngularMomentum] = GetFlockStats(predatorPos, predatorVel, nPredatorAgents);
        preyPolArr(stepCount) = preyPolarization;
        preyAngArr(stepCount) = preyAngularMomentum;
        predatorPolArr(stepCount) = predatorPolarization;
        predatorAngArr(stepCount) = predatorAngularMomentum;
        
        PlotAgentStates(ax1, preyObj, preyPos, predatorObj, predatorPos);
        PlotFlockStats(ax2, preyPolObj, preyAngObj, flockTArr(1:stepCount), preyPolArr(1:stepCount), preyAngArr(1:stepCount), timeElapsed);
        PlotFlockStats(ax3, predatorPolObj, predatorAngObj, flockTArr(1:stepCount), predatorPolArr(1:stepCount), predatorAngArr(1:stepCount), timeElapsed);
        drawnow;
        
        % write to video and storage vectors
    end
    
end
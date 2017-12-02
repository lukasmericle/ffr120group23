function [timeElapsed,frames] = Compete(preyNN, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                               nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                               predatorNN, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                               nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                               deltaT, maxTime, fieldSize, captureDistance, thisGeneration, film,frames)
% runs one full simulation based on prey and predator chromosomes and
% simulation parameters, returning the time elapsed before one of the stop
% conditions was met

[preyT1, preyW12, preyT2, preyW23] = DecodeChromosome(preyNN, nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs);
[predatorT1, predatorW12, predatorT2, predatorW23] = DecodeChromosome(predatorNN, nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs);

[preyPos, preyVel] = RandomSpawn(nPreyAgents, fieldSize, [1/2 1/2]);
[predatorPos, predatorVel] = RandomSpawn(nPredatorAgents, fieldSize, [0 1/2]);

if film


    [~, ax2, ax3, preyObj, predatorObj, preyPolObj, preyAngObj, ...
     predatorPolObj, predatorAngObj,h,frames] = InitializePlot(preyPos, predatorPos, ...
                                                    fieldSize, thisGeneration,frames);
    flockTArr = 0:deltaT:maxTime;
    timeSteps = length(flockTArr);
    preyPolArr = zeros(1, timeSteps);
    preyAngArr = zeros(1, timeSteps);
    predatorPolArr = zeros(1, timeSteps);
    predatorAngArr = zeros(1, timeSteps);
    
    %******************* Store NNData*******************
    parentFolderName = 'Simulation Data\';
    folderName = sprintf('Simulation Data Generation%d',thisGeneration);
    mkdir(parentFolderName,folderName)
    fileNamePrey = sprintf('NNWeightsGeneration %d', thisGeneration);
    fileNamePredator = sprintf('NNWeightsGeneration %d',thisGeneration);
    save(strcat('C:\Users\sandr\Documents\Skola\Simulation of complex systems\Project\ffr120group23\',parentFolderName,folderName,'\',fileNamePrey),'preyT1', 'preyW12', 'preyT2', 'preyW23')
    save(strcat('C:\Users\sandr\Documents\Skola\Simulation of complex systems\Project\ffr120group23\',parentFolderName,folderName,'\',fileNamePredator),'predatorT1', 'predatorW12', 'predatorT2', 'predatorW23')
end

timeElapsed = 0;
captured = false;
stepCount = 0;
while (timeElapsed < maxTime) && ~captured
    
    [preyPreyParameters, preyDispVec, preyDispNorm] = GetFriendParameters(preyPos, preyVel, nPreyNeighbors,fieldSize);
    [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPredatorAgents, nPredatorNeighbors,fieldSize);
    [predatorPredatorParameters, predatorDispVec, predatorDispNorm] = GetFriendParameters(predatorPos, predatorVel, nPredatorAgents-1,fieldSize);
    preyInputVectors = [preyPreyParameters ; preyPredatorParameters];
    predatorInputVectors = [predatorPreyParameters ; predatorPredatorParameters];
    
    timeElapsed = timeElapsed + deltaT;
    stepCount = stepCount + 1;
    
    if film
        
        preyPolArr(stepCount) = CalcPolarization(preyVel);
        preyAngArr(stepCount) = CalcAngularMomentum(preyDispVec, preyDispNorm, preyVel, 1);
        predatorPolArr(stepCount) = CalcPolarization(predatorVel);
        predatorAngArr(stepCount) = CalcAngularMomentum(predatorDispVec, predatorDispNorm, predatorVel, predatorStepLength/deltaT);
        
        PlotAgentStates(preyObj, preyPos, predatorObj, predatorPos);
        PlotFlockStats(ax2, preyPolObj, preyAngObj, flockTArr(1:stepCount), preyPolArr(1:stepCount), preyAngArr(1:stepCount), timeElapsed);
        PlotFlockStats(ax3, predatorPolObj, predatorAngObj, flockTArr(1:stepCount), predatorPolArr(1:stepCount), predatorAngArr(1:stepCount), timeElapsed);
%         drawnow nocallbacks
        frames(1+timeElapsed/deltaT)=getframe(h);
        
        % write to video
    end
    
    [preyPos, preyVel] = UpdateAgentState(preyPos, preyVel, preyInputVectors, preyT1, preyW12, preyT2, preyW23, maxPreyTurningAngle, preyStepLength, deltaT, fieldSize);
    [predatorPos, predatorVel] = UpdateAgentState(predatorPos, predatorVel, predatorInputVectors, predatorT1, predatorW12, predatorT2, predatorW23, maxPredatorTurningAngle, predatorStepLength, deltaT, fieldSize);
    captured = CheckCaptured(preyPos, predatorPos, captureDistance);
    
end


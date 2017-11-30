function captured = CheckCaptured(preyPos, predatorPos, captureDistance)
% check if (any of) the predator(s) are close enough to prey to capture them

distMatrix = pdist2(preyPos, predatorPos);
captured = any(distMatrix(:) <= captureDistance);

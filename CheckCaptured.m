function captured = CheckCaptured(preyPos, predatorPos, captureDistance)

distMatrix = pdist2(preyPos, predatorPos);
captured = any(distMatrix(:) <= captureDistance);
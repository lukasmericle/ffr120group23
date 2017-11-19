function captured = CheckCaptured(preyPos, predatorPos, captureDistance)
% checks if any prey is close enough to a predator to be considered "captured"

distMatrix = pdist2(preyPos, predatorPos);

if any(distMatrix <= captureDistance)
    captured = true;
else
    captured = false;
end
function captured = CheckCaptured(preyPos, predatorPos, captureDistance)
% checks if any prey is close enough to a predator to be considered "captured"

distMatrix = zeros(size(preyPos, 1), size(predatorPos, 1));
for i = 1:size(preyPos, 1)
    for j = 1:size(predatorPos, 1)
        displacement = norm(preyPos(i,:) - predatorPos(j,:));
        distMatrix(i,j) = displacement;
    end
end

if any(distMatrix <= captureDistance)
    captured = true;
else
    captured = false;
end
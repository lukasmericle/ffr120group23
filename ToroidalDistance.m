function toroidalDisplacementVec = ToroidalDistance(displacementVec, fieldSize)
% Assumed square field

distTooHigh = abs(displacementVec) > 0.5*fieldSize;
toroidalDisplacementVec = displacementVec - fieldSize * sign(displacementVec) .* distTooHigh;
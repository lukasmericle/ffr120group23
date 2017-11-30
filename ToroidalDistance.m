function toroidalDisplacementVec = ToroidalDistance(displacementVec, fieldSize)
% Assuming a square field, produce the displacement vectors taking into account
% the periodic boundary conditions

distTooHigh = abs(displacementVec) > 0.5*fieldSize;
toroidalDisplacementVec = displacementVec - fieldSize * sign(displacementVec) .* distTooHigh;

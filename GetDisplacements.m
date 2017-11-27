function [displacementVec, displacementNorm] = GetDisplacements(pos1, pos2, fieldSize)

ppos1 = reshape(pos1, [], 1, 2);
ppos2 = reshape(pos2, 1, [], 2);
displacementVec = ToroidalDistance(ppos2 - ppos1, fieldSize);
displacementNorm = sqrt(displacementVec(:,:,1).^2 + displacementVec(:,:,2).^2);
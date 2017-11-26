function displacementVec = ToroidalDistance(displacementVec, fieldSize)
% Assumed square Range

displacementX = displacementVec(:,:,1);
tempLogicX = abs(displacementX) > 0.5*fieldSize;
displacementVec(:,:,1) = displacementX - fieldSize * sign(displacementX) .* tempLogicX;

displacementY = displacementVec(:,:,2);
tempLogicY = abs(displacementY) > 0.5*fieldSize; 
displacementVec(:,:,2) = displacementY - fieldSize * sign(displacementY) .* tempLogicY;
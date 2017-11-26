function displacementVec = ToroidalDistance (displacementVec, range)

% Assumed square Range


 
temp = displacementVec(:,:,1);
tempLogic = temp > (0.5*range); 
displacementVec(:,:,1) = range * tempLogic - temp;   

temp = displacementVec(:,:,2);
tempLogic = temp > (0.5*range); 
displacementVec(:,:,2) = range * tempLogic - temp; 
end
    
    
function params = GetParams(displacementVec, displacementNorm, vel1, vel2, nNeighbors)
% for each neighbor of agent in flock 1, get the descriptive tuples of all
% agents in flock 2 (1 and 2 can be same flock)

n1 = size(displacementVec, 1);
neighborIndices = GetNeighbors(displacementNorm, nNeighbors);

myVelX = cos(-vel1);
myVelY = sin(-vel1);

dispX = zeros(n1, nNeighbors);
dispY = zeros(n1, nNeighbors);
for i = 1:n1 % rotate displacement vectors clockwise
    neighborDisps = displacementVec(i,neighborIndices(i,:),:);
    dispX(i,:) = myVelX(i)*neighborDisps(:,:,1) - myVelY(i)*neighborDisps(:,:,2);
    dispY(i,:) = myVelY(i)*neighborDisps(:,:,1) + myVelX(i)*neighborDisps(:,:,2);
end

phi = vel2(neighborIndices) - vel1;

stackParams = cat(3, dispX, dispY, cos(phi), sin(phi));

params = reshape(permute(stackParams, [3 2 1]), [], n1);
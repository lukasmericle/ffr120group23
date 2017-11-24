function wallVecs = GetWallVectors(pos, vel, fieldSize)
% get vector to two nearest walls (x/y) relative to own reference frame

closestWall = fieldSize*(pos > fieldSize/2);
r = abs(pos - closestWall);
dirWallX = pi*(closestWall(:,1)==0);
dirWallY = 0.5*pi + pi*(closestWall(:,2)==0);
tX = mod(dirWallX - vel, 2*pi);
tY = mod(dirWallY - vel, 2*pi);
theta = [tX tY];
params = [r ; theta];
wallVecs = reshape(params, [], 4)';
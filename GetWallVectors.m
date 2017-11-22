function wallVecs = GetWallVectors(pos, vel, fieldSize)
closestWall = fieldSize*(pos > fieldSize/2);
r = abs(pos - closestWall);
dirWallX = pi*(closestWall(:,1)==0);
dirWallY = pi/2 + pi*(closestWall(:,2)==0);
tX = mod(vel - dirWallX, 2*pi);
tY = mod(vel - dirWallY, 2*pi);
theta = [tX tY];
params = [r ; theta];
wallVecs = reshape(params, [], 4);
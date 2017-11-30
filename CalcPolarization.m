function polarization = CalcPolarization(vel)
% calculate the polarization of a flock

xVel = cos(vel);
yVel = sin(vel);
polarization = norm([mean(xVel) mean(yVel)]);

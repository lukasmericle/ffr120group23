function polarization = CalcPolarization(vel)

xVel = cos(vel);
yVel = sin(vel);
polarization = norm([mean(xVel) mean(yVel)]);
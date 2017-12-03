function cohesionVecs = BoidsCohesion(neighborDisps, deltaT)

CoMs = mean(neighborDisps, 2);
cohesionVecs = reshape(CoMs, [], 2)/deltaT^2;
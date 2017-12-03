function separationVecs = BoidsSeparation(neighborDisps, deltaT)

scale = neighborDisps(:,:,1).^2 + neighborDisps(:,:,2).^2;
separationVecs = -reshape(sum(neighborDisps./scale, 2), [], 2)/deltaT^2;
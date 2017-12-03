function alignmentVecs = BoidsAlignment(vel1, vel2, neighborIndices, deltaT)

velDiffs = vel2(neighborIndices') - vel1;
cosvel = cos(velDiffs);
sinvel = sin(velDiffs);
alignmentVecs = [mean(cosvel, 2) mean(sinvel, 2)]/deltaT;
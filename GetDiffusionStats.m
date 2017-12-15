function stats = GetDiffusionStats(simStats, stats)

rotdx = cos(-stats.netphi)*stats.dx - sin(-stats.netphi)*stats.dy;
rotdy = sin(-stats.netphi)*stats.dx + cos(-stats.netphi)*stats.dy;
rotv = mod(stats.v - stats.netphi, 2*pi);
stats.cumdx = zeros(stats.nAgents, simStats.stepCount);
stats.cumdy = zeros(stats.nAgents, simStats.stepCount);
stats.cumcentroid = zeros(2, simStats.stepCount);
netdx = zeros(stats.nAgents, 1);
netdy = zeros(stats.nAgents, 1);
for i = 1:simStats.stepCount
    netdx = netdx + rotdx(:,i);
    netdy = netdy + rotdy(:,i);
    stats.cumdx(:,i) = netdx;
    stats.cumdy(:,i) = netdy;
end
stats.cumcentroid(1,:) = mean(stats.cumdx);
stats.cumcentroid(2,:) = mean(stats.cumdy);

squaredDisplacement = stats.cumdx.^2+stats.cumdy.^2;
absDisplacement = sqrt(squaredDisplacement);
stats.firstmoment = mean(absDisplacement);
stats.secondmoment = mean(squaredDisplacement);
stats.thirdmoment = mean(absDisplacement.^3);
stats.fourthmoment = mean(absDisplacement.^4);

stats.Omega = atan2(mean2(sin(stats.dv)), mean2(cos(stats.dv)))/simStats.deltaT;
stats.DReff = simStats.deltaT/2*(-2*log(abs(mean(exp(1i*(stats.dv/simStats.deltaT - stats.Omega)))))); % https://en.wikipedia.org/wiki/Directional_statistics#Measures_of_location_and_spread

stats.DTeff = zeros(1, simStats.stepCount);
stats.DTeff(1) = 1;
stats.DTeff(2:end) = simStats.deltaT/4*(var(stats.dx(:,2:end)/simStats.deltaT - stats.speed*cos(stats.v(:,1:end-1))) + ...
    var(stats.dy(:,2:end)/simStats.deltaT - stats.speed*sin(stats.v(:,1:end-1))));

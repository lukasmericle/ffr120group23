function activeStats = SimulateActiveBM(simStats, stats)
activeStats.nAgents = stats.nAgents;
activeStats.speed = stats.speed;
activeStats.netphi = stats.netphi;
activeStats.v = zeros(stats.nAgents, simStats.stepCount);
activeStats.v(:,1) = stats.v(:,1);
activeStats.dx = zeros(stats.nAgents, simStats.stepCount);
activeStats.dy = zeros(stats.nAgents, simStats.stepCount);
activeStats.dv = zeros(stats.nAgents, simStats.stepCount);

DR = mean(stats.DReff);
DT = mean(stats.DTeff);

for i = 2:simStats.stepCount
    activeStats.dx(:,i) = stats.speed*cos(activeStats.v(:,i-1))*simStats.deltaT + sqrt(2*DT*simStats.deltaT)*randn(stats.nAgents,1);
    activeStats.dy(:,i) = stats.speed*sin(activeStats.v(:,i-1))*simStats.deltaT + sqrt(2*DT*simStats.deltaT)*randn(stats.nAgents,1);
    activeStats.dv(:,i) = stats.Omega*simStats.deltaT + sqrt(2*DR*simStats.deltaT)*randn(stats.nAgents,1);
    activeStats.v(:,i) = mod(activeStats.v(:,i-1) + activeStats.dv(:,i), 2*pi);
end

activeStats = GetDiffusionStats(simStats, activeStats);
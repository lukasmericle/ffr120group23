function passiveStats = SimulatePassiveBM(simStats, stats)
passiveStats.nAgents = stats.nAgents;
passiveStats.speed = 0;
passiveStats.netphi = stats.netphi;
passiveStats.x = zeros(stats.nAgents, simStats.stepCount);
passiveStats.y = zeros(stats.nAgents, simStats.stepCount);
passiveStats.v = zeros(stats.nAgents, simStats.stepCount);
passiveStats.v(:,1) = stats.v(:,1);
passiveStats.dx = zeros(stats.nAgents, simStats.stepCount);
passiveStats.dy = zeros(stats.nAgents, simStats.stepCount);
passiveStats.dv = zeros(stats.nAgents, simStats.stepCount);

for i = 2:simStats.stepCount
    passiveStats.dx(:,i) = sqrt(2*stats.DTeff(i)*simStats.deltaT)*randn(stats.nAgents,1);
    passiveStats.dy(:,i) = sqrt(2*stats.DTeff(i)*simStats.deltaT)*randn(stats.nAgents,1);
    passiveStats.v(:,i) = atan2(passiveStats.dy(:,i), passiveStats.dx(:,i));
    passiveStats.dv(:,i) = mod(passiveStats.v(:,i) - passiveStats.v(:,i-1), 2*pi);
    passiveStats.x(:,i) = passiveStats.x(:,i-1) + passiveStats.dx(:,i);
    passiveStats.y(:,i) = passiveStats.y(:,i-1) + passiveStats.dy(:,i);
end

passiveStats = GetDiffusionStats(simStats, passiveStats);
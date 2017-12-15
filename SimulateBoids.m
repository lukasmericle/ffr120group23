function [preyBoidStats, predatorBoidStats] = SimulateBoids(simStats, preyStats, predatorStats, fieldSize)
c1 = 1;
c2 = 1/5;
c3 = 1/2;
c4 = 5;
preyBoidStats.nAgents = preyStats.nAgents;
preyBoidStats.nFriendlyNeighbors = preyStats.nFriendlyNeighbors;
preyBoidStats.nEnemyNeighbors = preyStats.nEnemyNeighbors;
preyBoidStats.speed = preyStats.speed;
preyBoidStats.netphi = preyStats.netphi;
preyBoidStats.x = zeros(preyStats.nAgents, simStats.stepCount);
preyBoidStats.x(:,1) = preyStats.x(:,1);
preyBoidStats.y = zeros(preyStats.nAgents, simStats.stepCount);
preyBoidStats.y(:,1) = preyStats.y(:,1);
preyBoidStats.v = zeros(preyStats.nAgents, simStats.stepCount);
preyBoidStats.v(:,1) = preyStats.v(:,1);
preyBoidStats.dx = zeros(preyStats.nAgents, simStats.stepCount);
preyBoidStats.dy = zeros(preyStats.nAgents, simStats.stepCount);
preyBoidStats.dv = zeros(preyStats.nAgents, simStats.stepCount);
preyBoidStats.pol = zeros(1, simStats.stepCount);
preyBoidStats.ang = zeros(1, simStats.stepCount);

predatorBoidStats.nAgents = predatorStats.nAgents;
predatorBoidStats.nFriendlyNeighbors = predatorStats.nFriendlyNeighbors;
predatorBoidStats.nEnemyNeighbors = predatorStats.nEnemyNeighbors;
predatorBoidStats.speed = predatorStats.speed;
predatorBoidStats.netphi = predatorStats.netphi;
predatorBoidStats.x = zeros(predatorStats.nAgents, simStats.stepCount);
predatorBoidStats.x(:,1) = predatorStats.x(:,1);
predatorBoidStats.y = zeros(predatorStats.nAgents, simStats.stepCount);
predatorBoidStats.y(:,1) = predatorStats.y(:,1);
predatorBoidStats.v = zeros(predatorStats.nAgents, simStats.stepCount);
predatorBoidStats.v(:,1) = predatorStats.v(:,1);
predatorBoidStats.dx = zeros(predatorStats.nAgents, simStats.stepCount);
predatorBoidStats.dy = zeros(predatorStats.nAgents, simStats.stepCount);
predatorBoidStats.dv = zeros(predatorStats.nAgents, simStats.stepCount);
predatorBoidStats.pol = zeros(1, simStats.stepCount);
predatorBoidStats.ang = zeros(1, simStats.stepCount);

preyPos = [preyBoidStats.x(:,1) preyBoidStats.y(:,1)];
preyVel = preyBoidStats.v(:,1);
predatorPos = [predatorBoidStats.x(:,1) predatorBoidStats.y(:,1)];
predatorVel = predatorBoidStats.v(:,1);

for i = 2:simStats.stepCount
    
    [preyDispVec, preyDispNorm] = GetDisplacements(preyPos, preyPos, fieldSize);
    [preyNeighborDisps, preyNeighborIndices] = GetNeighborDisps(preyDispVec, preyDispNorm, preyBoidStats.nFriendlyNeighbors+1);
    preyNeighborDisps = preyNeighborDisps(:,2:end,:);
    preyCohesion = BoidsCohesion(preyNeighborDisps, simStats.deltaT);
    preyAlignment = BoidsAlignment(preyVel, preyVel, preyNeighborIndices, simStats.deltaT);
    preySeparation = BoidsSeparation(preyNeighborDisps, simStats.deltaT);
    
    [preyPredatorDispVec, preyPredatorDispNorm] = GetDisplacements(preyPos, predatorPos, fieldSize);
    [preyPredatorNeighborDisps, ~] = GetNeighborDisps(preyPredatorDispVec, preyPredatorDispNorm, preyBoidStats.nEnemyNeighbors);
    preyEvasion = BoidsSeparation(preyPredatorNeighborDisps, simStats.deltaT);
    
    [predatorDispVec, predatorDispNorm] = GetDisplacements(predatorPos, predatorPos, fieldSize);
    [predatorNeighborDisps, predatorNeighborIndices] = GetNeighborDisps(predatorDispVec, predatorDispNorm, predatorBoidStats.nFriendlyNeighbors+1);
    predatorNeighborDisps = predatorNeighborDisps(:,2:end,:);
    predatorCohesion = BoidsCohesion(predatorNeighborDisps, simStats.deltaT);
    predatorAlignment = BoidsAlignment(predatorVel, predatorVel, predatorNeighborIndices, simStats.deltaT);
    predatorSeparation = BoidsSeparation(predatorNeighborDisps, simStats.deltaT);
    
    [predatorPreyDispVec, predatorPreyDispNorm] = GetDisplacements(predatorPos, preyPos, fieldSize);
    [predatorPreyNeighborDisps, ~] = GetNeighborDisps(predatorPreyDispVec, predatorPreyDispNorm, predatorBoidStats.nEnemyNeighbors);
    predatorPursuit = BoidsCohesion(predatorPreyNeighborDisps, simStats.deltaT);
    
    preyAccel = (c1*preyCohesion + c2*preyAlignment + c3*preySeparation + c4*preyEvasion)/(c1+c2+c3+c4);
    preyBoidStats.v(:,i) = atan2(sin(preyBoidStats.v(:,i-1)) + simStats.deltaT*preyAccel(:,2), cos(preyBoidStats.v(:,i-1)) + simStats.deltaT*preyAccel(:,1));
    preyBoidStats.dv(:,i) = preyBoidStats.v(:,i) - preyBoidStats.v(:,i-1);
    preyBoidStats.dx(:,i) = simStats.deltaT*preyBoidStats.speed*cos(preyBoidStats.v(:,i));
    preyBoidStats.dy(:,i) = simStats.deltaT*preyBoidStats.speed*sin(preyBoidStats.v(:,i));
    preyBoidStats.x(:,i) = mod(preyBoidStats.x(:,i-1) + preyBoidStats.dx(:,i), fieldSize);
    preyBoidStats.y(:,i) = mod(preyBoidStats.y(:,i-1) + preyBoidStats.dy(:,i), fieldSize);
    preyPos = [preyBoidStats.x(:,i) preyBoidStats.y(:,i)];
    preyVel = preyBoidStats.v(:,i);
    preyBoidStats.pol(i) = CalcPolarization(preyVel);
    preyBoidStats.ang(i) = CalcAngularMomentum(preyDispVec, preyDispNorm, preyVel, preyStats.speed);
    
    predatorAccel = (c1*predatorCohesion + c2*predatorAlignment + c3*predatorSeparation + c4*predatorPursuit)/(c1+c2+c3+c4);
    predatorBoidStats.v(:,i) = atan2(sin(predatorBoidStats.v(:,i-1)) + simStats.deltaT*predatorAccel(:,2), cos(predatorBoidStats.v(:,i-1)) + simStats.deltaT*predatorAccel(:,1));
    predatorBoidStats.dv(:,i) = predatorBoidStats.v(:,i) - predatorBoidStats.v(:,i-1);
    predatorBoidStats.dx(:,i) = simStats.deltaT*predatorBoidStats.speed*cos(predatorBoidStats.v(:,i));
    predatorBoidStats.dy(:,i) = simStats.deltaT*predatorBoidStats.speed*sin(predatorBoidStats.v(:,i));
    predatorBoidStats.x(:,i) = mod(predatorBoidStats.x(:,i-1) + predatorBoidStats.dx(:,i), fieldSize);
    predatorBoidStats.y(:,i) = mod(predatorBoidStats.y(:,i-1) + predatorBoidStats.dy(:,i), fieldSize);
    predatorPos = [predatorBoidStats.x(:,i) predatorBoidStats.y(:,i)];
    predatorVel = predatorBoidStats.v(:,i);
    predatorBoidStats.pol(i) = CalcPolarization(predatorVel);
    predatorBoidStats.ang(i) = CalcAngularMomentum(predatorDispVec, predatorDispNorm, predatorVel, predatorStats.speed);
    
end

preyBoidStats = GetDiffusionStats(simStats, preyBoidStats);
predatorBoidStats = GetDiffusionStats(simStats, predatorBoidStats);

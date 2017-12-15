function PlotSimulation(filePath, simStats, preyStats, predatorStats, preyBoidStats, predatorBoidStats, fieldSize)
fprintf('Plotting Simulation\n');

width = 600;
height = 500;
padleft = 40;
padding = 20;

splith = (width-padleft-padding)/2+padleft;
splitv1 = height-splith;
splitv2 = splitv1/2;


fileName = sprintf('SimulationVideoGeneration%d', simStats.generation);

v = VideoWriter(strcat(filePath, fileName));
v.FrameRate = ceil(4/simStats.deltaT);
v.Quality = 100;
open(v);

h = figure('visible', 'off');
clf;
set(h, 'Color', 'w', 'Units', 'Pixels', 'Position', [0, 0, width, height]);


ax1 = axes('Units', 'Pixels', 'Position', [padleft, splitv1+padding, splith-padding-padleft, height-splitv1-padding-padding]);
box on; hold on;
xlim manual; ylim manual;
xlim([0 fieldSize]);
ylim([0 fieldSize]);
title(sprintf('Intelligent Model, Generation %d', simStats.generation));
preyIntelPos = plot(preyStats.x(:, 1), preyStats.y(:, 1), 'g.');
predatorIntelPos = plot(predatorStats.x(:, 1), predatorStats.y(:, 1), 'r*');
set(ax1, 'XTick', [], 'YTick', []);


ax2 = axes('Units', 'Pixels', 'Position', [padleft, splitv2+padding, splith-padding-padleft, splitv1-splitv2-padding-padding]);
box on; hold on;
xlim manual; ylim manual;
xlim([0 simStats.timeElapsed]);
ylim([0 1]);
title("Prey Flock Behavior");
plot(simStats.t, preyStats.pol, 'm', 'LineWidth', 2);
plot(simStats.t, preyStats.ang/max(preyStats.ang), 'b', 'LineWidth', 2);
preyIntelTrack = plot([0 0], [0 1]);


ax3 = axes('Units', 'Pixels', 'Position', [padleft, padding, splith-padding-padleft, splitv2-padding-padding]);
box on; hold on;
xlim manual; ylim manual;
xlim([0 simStats.timeElapsed]);
ylim([0 1]);
title("Predator Flock Behavior");
xlabel('$t$', 'Interpreter', 'Latex');
plot(simStats.t, predatorStats.pol, 'm', 'LineWidth', 2);
plot(simStats.t, predatorStats.ang/max(predatorStats.ang), 'b', 'LineWidth', 2);
predatorIntelTrack = plot([0 0], [0 1]);


ax4 = axes('Units', 'Pixels', 'Position', [splith+padding, splitv1+padding, width-splith-padding-padding, height-splitv1-padding-padding]);
box on; hold on;
xlim manual; ylim manual;
xlim([0 fieldSize]);
ylim([0 fieldSize]);
title('Boids Model');
preyBoidPos = plot(preyBoidStats.x(:, 1), preyBoidStats.y(:, 1), 'g.');
predatorBoidPos = plot(predatorBoidStats.x(:, 1), predatorBoidStats.y(:, 1), 'r*');
set(ax4, 'XTick', [], 'YTick', []);


ax5 = axes('Units', 'Pixels', 'Position', [splith+padding, splitv2+padding, width-splith-padding-padding, splitv1-splitv2-padding-padding]);
box on; hold on;
xlim manual; ylim manual;
xlim([0 simStats.timeElapsed]);
ylim([0 1]);
title("Prey Flock Behavior");
plot(simStats.t, preyBoidStats.pol, 'm', 'LineWidth', 2);
plot(simStats.t, preyBoidStats.ang/max(preyBoidStats.ang), 'b', 'LineWidth', 2);
preyBoidTrack = plot([0 0], [0 1]);

ax6 = axes('Units', 'Pixels', 'Position', [splith+padding, padding, width-splith-padding-padding, splitv2-padding-padding]);
box on; hold on;
xlim manual; ylim manual;
xlim([0 simStats.timeElapsed]);
ylim([0 1]);
title("Predator Flock Behavior");
xlabel('$t$', 'Interpreter', 'Latex');
plot(simStats.t, predatorBoidStats.pol, 'm', 'LineWidth', 2);
plot(simStats.t, predatorBoidStats.ang/max(predatorBoidStats.ang), 'b', 'LineWidth', 2);
predatorBoidTrack = plot([0 0], [0 1]);

H = getframe(h);
writeVideo(v, H);

for i = 2:simStats.stepCount
    set(preyIntelPos, 'XData', preyStats.x(:, i), 'YData', preyStats.y(:, i));
    set(predatorIntelPos, 'XData', predatorStats.x(:, i), 'YData', predatorStats.y(:, i));
    set(preyIntelTrack, 'XData', [simStats.t(i) simStats.t(i)]);
    set(predatorIntelTrack, 'XData', [simStats.t(i) simStats.t(i)]);
    set(preyBoidPos, 'XData', preyBoidStats.x(:, i), 'YData', preyBoidStats.y(:, i));
    set(predatorBoidPos, 'XData', predatorBoidStats.x(:, i), 'YData', predatorBoidStats.y(:, i));
    set(preyBoidTrack, 'XData', [simStats.t(i) simStats.t(i)]);
    set(predatorBoidTrack, 'XData', [simStats.t(i) simStats.t(i)]);
    
    H = getframe(h);
    writeVideo(v, H);
end

close(v);
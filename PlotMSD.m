function PlotMSD(filePath, flock, simStats, activeStats, boidsStats, intelStats)

activeNormTime = activeStats.speed.*simStats.t; % normalize quantity to make the resulting measurement dimensionless
intelNormTime = intelStats.speed.*simStats.t;
boidsNormTime = boidsStats.speed.*simStats.t;

h = figure('visible', 'off');
clf;
set(h, 'Color', 'w', 'Units', 'Pixels', 'Position', [0,0,600,500], 'visible', 'off');
fprintf(['Plotting ', flock, ' MSD\n']);

ax = axes('GridAlpha', 0.33, 'MinorGridAlpha', 0, 'GridLineStyle', '--');
grid on; box on; hold on;
title([flock, sprintf(', Generation %d', simStats.generation)], 'Interpreter', 'Latex', 'FontSize', 16);
xlim([simStats.t(2) simStats.t(end)]);
xlabel('$t$', 'Interpreter', 'Latex', 'FontSize', 14);
ylabel('$MSD/(vt)^2$', 'Interpreter', 'Latex', 'FontSize', 14);
ax.YScale = 'log';
plot(simStats.t, activeStats.secondmoment./(activeNormTime.^2), 'LineWidth', 3);
plot(simStats.t, intelStats.secondmoment./(intelNormTime.^2), 'LineWidth', 3);
plot(simStats.t, boidsStats.secondmoment./(boidsNormTime.^2), 'LineWidth', 3);

legend({'Active Brownian Motion', 'Intelligent Model', 'Boids Model'});
legend('Location', 'northeast');

saveas(h, [filePath, flock, sprintf('NormMSDGeneration%d.png', simStats.generation)]);
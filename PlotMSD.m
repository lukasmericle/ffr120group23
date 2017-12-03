function PlotMSD(filePath, flock, simStats, passiveStats, activeStats, boidsStats, intelStats)

fileName = [flock, sprintf('MSDGeneration%d.png', simStats.generation)];

h = figure('visible', 'off');
clf;
set(h,'Color','w','Units','Pixels','Position',[0 0 500 500]);

ax = axes('GridAlpha', 0.5, 'MinorGridAlpha', 0);
grid on; box on; hold on;
title(sprintf('Mean-Square Displacement, Generation %d', simStats.generation));
xlim([simStats.t(2) simStats.t(end)]);
xlabel('$t$', 'Interpreter', 'Latex');
ylabel('$MSD$', 'Interpreter', 'Latex');
ax.XScale = 'log';
ax.YScale = 'log';
plot(simStats.t, passiveStats.MSD, 'LineStyle','--');
plot(simStats.t, activeStats.MSD, 'LineWidth', 2);
plot(simStats.t, boidsStats.MSD, 'LineWidth', 2);
plot(simStats.t, intelStats.MSD, 'LineWidth', 2);
legend({'Passive Brownian Motion', 'Active Brownian Motion', 'Boids Model', 'Intelligent Model'});
legend('boxoff');
legend('Location', 'southoutside');

saveas(h, [filePath, fileName], 'png');

function PlotMoments(filePath, flock, simStats, passiveStats, activeStats, boidsStats, intelStats)
width = 1;
height = 0.925;
padleft = 0.05;
padbetween = 0.025;
splitv = 0.51;
splith = 0.5;

passiveNormTime = passiveStats.speed.*simStats.t; % normalize quantity to make the resulting measurement dimensionless
activeNormTime = activeStats.speed.*simStats.t;
boidsNormTime = boidsStats.speed.*simStats.t;
intelNormTime = intelStats.speed.*simStats.t;

h = figure('visible', 'off');
%clf;
set(h, 'Color', 'w', 'Units', 'Pixels', 'Position', [0,0,800,1000], 'visible', 'off');
fprintf(['Plotting ', flock, ' Moments\n']);

textax = axes('Position', [padleft, height+padbetween, width-padleft-padbetween, 1-height-padbetween], 'visible', 'off');
text(0.5, 0.2, [flock, sprintf(' Moments, Generation %d', simStats.generation)], 'HorizontalAlignment', 'center', 'FontSize', 16);

ax1 = subplot(2,2,1, 'Position', [padleft, splitv+padbetween, splith-padleft-padbetween, height-splitv-padbetween-padbetween]);
set(ax1, 'GridAlpha', 0.33, 'MinorGridAlpha', 0, 'GridLineStyle', '--');
grid on; box on; hold on;
title('$m_1/(vt)$', 'Interpreter', 'Latex', 'FontSize', 14);
xlim([simStats.t(2) simStats.t(end)]);
%xlabel('$t$', 'Interpreter', 'Latex');
ax1.XScale = 'log';
ax1.YScale = 'log';
plot(simStats.t, passiveStats.firstmoment./passiveNormTime, 'LineStyle', '-.', 'LineWidth', 2, 'YLimInclude', 'off');
plot(simStats.t, activeStats.firstmoment./activeNormTime, 'LineWidth', 2);
plot(simStats.t, boidsStats.firstmoment./boidsNormTime, 'LineWidth', 2);
plot(simStats.t, intelStats.firstmoment./intelNormTime, 'LineWidth', 2);

set(h, 'visible', 'off');

ax2 = subplot(2,2,2, 'Position', [splith+padbetween, splitv+padbetween, width-splith-padbetween-padbetween, height-splitv-padbetween-padbetween]);
set(ax2, 'GridAlpha', 0.33, 'MinorGridAlpha', 0, 'GridLineStyle', '--');
grid on; box on; hold on;
title('$m_2/(vt)^2$', 'Interpreter', 'Latex', 'FontSize', 14);
xlim([simStats.t(2) simStats.t(end)]);
%xlabel('$t$', 'Interpreter', 'Latex');
ax2.XScale = 'log';
ax2.YScale = 'log';
plot(simStats.t, passiveStats.secondmoment./(passiveNormTime.^2), 'LineStyle', '-.', 'LineWidth', 2, 'YLimInclude', 'off');
plot(simStats.t, activeStats.secondmoment./(activeNormTime.^2), 'LineWidth', 2);
plot(simStats.t, boidsStats.secondmoment./(boidsNormTime.^2), 'LineWidth', 2);
plot(simStats.t, intelStats.secondmoment./(intelNormTime.^2), 'LineWidth', 2);

set(h, 'visible', 'off');

ax3 = subplot(2,2,3, 'Position', [padleft, padbetween, splith-padleft-padbetween, splitv-padbetween-padbetween]);
set(ax3, 'GridAlpha', 0.33, 'MinorGridAlpha', 0, 'GridLineStyle', '--');
grid on; box on; hold on;
title('$m_3/(vt)^3$', 'Interpreter', 'Latex', 'FontSize', 14);
xlim([simStats.t(2) simStats.t(end)]);
xlabel('$t$', 'Interpreter', 'Latex');
ax3.XScale = 'log';
ax3.YScale = 'log';
l1 = plot(simStats.t, passiveStats.thirdmoment./(passiveNormTime.^3), 'LineStyle', '-.', 'LineWidth', 2, 'YLimInclude', 'off');
l2 = plot(simStats.t, activeStats.thirdmoment./(activeNormTime.^3), 'LineWidth', 2);
plot(simStats.t, boidsStats.thirdmoment./(boidsNormTime.^3), 'LineWidth', 2);
plot(simStats.t, intelStats.thirdmoment./(intelNormTime.^3), 'LineWidth', 2);

legend([l1 l2],{'Passive Brownian Motion', 'Active Brownian Motion'});
legend('boxoff');
legend('Location', 'southoutside');

set(h, 'visible', 'off');

ax4 = subplot(2,2,4, 'Position', [splith+padbetween, padbetween, width-splith-padbetween-padbetween, splitv-padbetween-padbetween]);
set(ax4, 'GridAlpha', 0.33, 'MinorGridAlpha', 0, 'GridLineStyle', '--');
grid on; box on; hold on;
title('$m_4/(vt)^4$', 'Interpreter', 'Latex', 'FontSize', 14);
xlim([simStats.t(2) simStats.t(end)]);
xlabel('$t$', 'Interpreter', 'Latex');
ax4.XScale = 'log';
ax4.YScale = 'log';
plot(simStats.t, passiveStats.fourthmoment./(passiveNormTime.^4), 'LineStyle', '-.', 'LineWidth', 2, 'YLimInclude', 'off');
plot(simStats.t, activeStats.fourthmoment./(activeNormTime.^4), 'LineWidth', 2);
l3 = plot(simStats.t, boidsStats.fourthmoment./(boidsNormTime.^4), 'LineWidth', 2);
l4 = plot(simStats.t, intelStats.fourthmoment./(intelNormTime.^4), 'LineWidth', 2);

legend([l3 l4],{'Boids Model', 'Intelligent Model'});
legend('boxoff');
legend('Location', 'southoutside');

set(h, 'visible', 'off');

saveas(h, [filePath, flock, sprintf('MomentsGeneration%d.png', simStats.generation)]);
function [ax1, ax2, ax3, preyObj, predatorObj, preyPolObj, preyAngObj, ...
          predatorPolObj, predatorAngObj] = InitializePlot(preyPos, ...
                                        predatorPos, fieldSize, thisGeneration)

clf;
h = figure(1);
set(h,'Color','w','Units','Pixels','Position',[0 0 1000 500]);

ax1 = axes('Units','Pixels','Position',[50 50 400 400]);
box on; hold on;
xlim manual; ylim manual;
xlim([0 fieldSize]);
ylim([0 fieldSize]);
title(['Generation ',num2str(thisGeneration)]);
xlabel('$x$','FontSize',12,'Interpreter','Latex');
ylabel('$y$','FontSize',12,'Interpreter','Latex');
preyObj = plot(preyPos(:,1), preyPos(:,2), 'b.', 'DisplayName', 'Prey Agents');
predatorObj = plot(predatorPos(:,1), predatorPos(:,2), 'r*', 'DisplayName', 'Predator Agents');
legend('boxoff');
legend('Orientation', 'horizontal');
legend('Location', 'southoutside');

ax2 = axes('Units','Pixels','Position',[550 320 400 130]);
box on; hold on;
ylim manual;
ylim([0 1]);
title("Prey Flock Behavior");
preyPolObj = plot([0], [0], 'r-', 'LineWidth', 1.5);
preyAngObj = plot([0], [0], 'b-', 'LineWidth', 1.5);

ax3 = axes('Units','Pixels','Position',[550  50 400 220]);
box on; hold on;
ylim manual;
ylim([0 1]);
title("Predator Flock Behavior");
xlabel('$t$','FontSize',12,'Interpreter','Latex');
predatorPolObj = plot([0], [0], 'r-', 'LineWidth', 1.5, 'DisplayName', 'Polarization');
predatorAngObj = plot([0], [0], 'b-', 'LineWidth', 1.5, 'DisplayName', 'Angular Momentum');
legend('boxoff');
legend('Orientation', 'horizontal');
legend('Location', 'southoutside');
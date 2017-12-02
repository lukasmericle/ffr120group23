function [ax1, ax2, ax3, preyObj, predatorObj, preyPolObj, preyAngObj, ...
          predatorPolObj, predatorAngObj,h,frames] = InitializePlot(preyPos, ...
                                        predatorPos, fieldSize, thisGeneration,frames)

clf;
h = figure(1);
set(h,'Color','w','Units','Pixels','Position',[0 0 1000 500]);

ax1 = axes('Units','Pixels','Position',[50 25 400 450]);
box on; hold on;
xlim manual; ylim manual;
xlim([0 fieldSize]);
ylim([0 fieldSize]);
title(['Generation ',num2str(thisGeneration)]);
%xlabel('$x$','FontSize',12,'Interpreter','Latex');
%ylabel('$y$','FontSize',12,'Interpreter','Latex');
preyObj = plot(preyPos(:,1), preyPos(:,2), 'b.');
predatorObj = plot(predatorPos(:,1), predatorPos(:,2), 'r*');
legend({'Prey', 'Predator'});
legend('boxoff');
legend('Orientation', 'horizontal');
legend('Location', 'southoutside');
set(ax1, 'XTick',[]);
set(ax1, 'YTick',[]);

ax2 = axes('Units','Pixels','Position',[525 313 450 137]);
box on; hold on;
ylim manual;
ylim([0 1]);
title("Prey Flock Behavior");
preyPolObj = plot([0], [0], 'r-', 'LineWidth', 1.5);
preyAngObj = plot([0], [0], 'b-', 'LineWidth', 1.5);

ax3 = axes('Units','Pixels','Position',[525  50 450 213]);
box on; hold on;
ylim manual;
ylim([0 1]);
title("Predator Flock Behavior");
xlabel('$t$','FontSize',12,'Interpreter','Latex');
predatorPolObj = plot([0], [0], 'r-', 'LineWidth', 1.5);
predatorAngObj = plot([0], [0], 'b-', 'LineWidth', 1.5);
legend({'Polarization', 'Angular Momentum'});
legend('boxoff');
legend('Orientation', 'horizontal');
legend('Location', 'southoutside');
 
frames(1)=getframe(h);

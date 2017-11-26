function [preyObj,predatorObj] = InitializePlot(preyPos, predatorPos, fieldSize, thisGeneration)

clf;
preyObj = plot(preyPos(:,1), preyPos(:,2), 'b.');
hold on;
xlim manual;
ylim manual;
predatorObj = plot(predatorPos(:,1), predatorPos(:,2), 'r*');
myTitle = ['Gen = %4d, t = %5.2f',thisGeneration, 0.0];
title(myTitle);
xlim([0 fieldSize]);
ylim([0 fieldSize]);
drawnow;
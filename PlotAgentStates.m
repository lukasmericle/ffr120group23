function PlotAgentStates(preyObj, preyPos, preyVel, predatorObj, predatorPos, predatorVel, myTitle, fieldSize)
set(preyObj, 'XData', preyPos(:,1), 'YData', preyPos(:,2));
set(predatorObj, 'XData', predatorPos(:,1), 'YData', predatorPos(:,2));
title(myTitle);
xlim([0 fieldSize]);
ylim([0 fieldSize]);
drawnow;
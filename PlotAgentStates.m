function PlotAgentStates(preyObj, preyPos, predatorObj, predatorPos, myTitle, fieldSize)
set(preyObj, 'XData', preyPos(:,1), 'YData', preyPos(:,2));
set(predatorObj, 'XData', predatorPos(:,1), 'YData', predatorPos(:,2));
title(myTitle);
drawnow;
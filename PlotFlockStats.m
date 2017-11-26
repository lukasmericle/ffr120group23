function PlotFlockStats(ax, polObj, angObj, x, polArr, angArr, timeElapsed)

angArr = angArr / max([1 max(angArr)]);
set(polObj, 'XData', x, 'YData', polArr);
set(angObj, 'XData', x, 'YData', angArr);
xlim(ax, [0 timeElapsed]);
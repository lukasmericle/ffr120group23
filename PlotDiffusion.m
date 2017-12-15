function PlotDiffusion(filePath, flock, simStats, passiveStats, activeStats, boidStats, intelStats)
fprintf(['Plotting ', flock, ' Diffusion Visualization\n']);

fileName = [flock, sprintf('DiffusionVideoGeneration%d', simStats.generation)];
v = VideoWriter([filePath, fileName]);
v.FrameRate = 4/simStats.deltaT;
v.Quality = 100;
open(v);

maxExtent = max([max(abs(passiveStats.cumdx)), max(abs(passiveStats.cumdy)) ...
     max(abs(activeStats.cumdx)), max(abs(activeStats.cumdy)) ...
     max(abs(boidStats.cumdx)), max(abs(boidStats.cumdy)) ...
     max(abs(intelStats.cumdx)), max(abs(intelStats.cumdy))])*1.05;
patchX = [-maxExtent, -maxExtent, maxExtent, maxExtent];
patchY = [-maxExtent, maxExtent, maxExtent, -maxExtent];
patchOpacity = 0.618;

h = figure('visible', 'off');

for i = 1:simStats.stepCount
    
    clf;
    set(h,'Color','w','Units','Pixels','Position',[0 0 1000 1000]);

    ax1 = axes('Units','Pixels','Position',[ 25 525 450 450]); % top left
    box on; hold on;
    xlim manual; ylim manual;
    xlim([-maxExtent maxExtent]);
    ylim([-maxExtent maxExtent]);
    title('Passive Brownian Motion');
    passiveX = passiveStats.cumdx(:,1:i)';
    passiveY = passiveStats.cumdy(:,1:i)';
    passiveObj = plot(passiveX, passiveY, 'LineWidth', 1.5);
    patch(patchX, patchY, 'white', 'FaceAlpha', patchOpacity);
    plot(passiveStats.cumcentroid(1,1:i), passiveStats.cumcentroid(2,1:i), 'LineWidth', 3, 'Color', 'red');
    plot(passiveStats.cumcentroid(1,i), passiveStats.cumcentroid(2,i), 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'black', 'MarkerSize', 7);

    ax2 = axes('Units','Pixels','Position',[525 525 450 450]); % top right
    box on; hold on;
    xlim manual; ylim manual;
    xlim([-maxExtent maxExtent]);
    ylim([-maxExtent maxExtent]);
    title('Active Brownian Motion');
    activeX = activeStats.cumdx(:,1:i)';
    activeY = activeStats.cumdy(:,1:i)';
    activeObj = plot(activeX, activeY, 'LineWidth', 1.5);
    patch(patchX, patchY, 'white', 'FaceAlpha', patchOpacity);
    plot(activeStats.cumcentroid(1,1:i), activeStats.cumcentroid(2,1:i), 'LineWidth', 3, 'Color', 'red');
    plot(activeStats.cumcentroid(1,i), activeStats.cumcentroid(2,i), 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'black', 'MarkerSize', 7);

    ax3 = axes('Units','Pixels','Position',[ 25  25 450 450]); % bottom left
    box on; hold on;
    xlim manual; ylim manual;
    xlim([-maxExtent maxExtent]);
    ylim([-maxExtent maxExtent]);
    title('Boids Model');
    boidsX = boidStats.cumdx(:,1:i)';
    boidsY = boidStats.cumdy(:,1:i)';
    boidsObj = plot(boidsX, boidsY, 'LineWidth', 1.5);
    patch(patchX, patchY, 'white', 'FaceAlpha', patchOpacity);
    plot(boidStats.cumcentroid(1,1:i), boidStats.cumcentroid(2,1:i), 'LineWidth', 3, 'Color', 'red');
    plot(boidStats.cumcentroid(1,i), boidStats.cumcentroid(2,i), 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'black', 'MarkerSize', 7);

    ax4 = axes('Units','Pixels','Position',[525  25 450 450]); % bottom right
    box on; hold on;
    xlim manual; ylim manual;
    xlim([-maxExtent maxExtent]);
    ylim([-maxExtent maxExtent]);
    title('Intelligent Model');
    intelX = intelStats.cumdx(:,1:i)';
    intelY = intelStats.cumdy(:,1:i)';
    intelObj = plot(intelX, intelY, 'LineWidth', 1.5);
    patch(patchX, patchY, 'white', 'FaceAlpha', patchOpacity);
    plot(intelStats.cumcentroid(1,1:i), intelStats.cumcentroid(2,1:i), 'LineWidth', 3, 'Color', 'red');
    plot(intelStats.cumcentroid(1,i), intelStats.cumcentroid(2,i), 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'black', 'MarkerSize', 7);

    H = getframe(h);
    writeVideo(v,H);

end

close(v);
%% drawTrajectory
% offset defines the speed with which draw the trajectory.
function drawTrajectory(Ic2, x_8c, y_8c, offset)

if ~exist('offset', 'var')
   offset = 50; 
end

figure('units','normalized','outerposition',[0 0 1 1])
imagesc(Ic2), colormap(gray), drawnow
hold on

a = 1;
for kk = 1 : offset : length(x_8c) - offset
    b = a + offset;
    plot(x_8c(a:b), y_8c(a:b), 'r.'); 
    drawnow
    a = b;
end
b = length(x_8c);
plot(x_8c(a:b), y_8c(a:b), 'r.'); 
drawnow;


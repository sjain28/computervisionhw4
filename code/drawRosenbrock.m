function drawRosenbrock(allx, fig)

figure(fig)
clf

% Rosenbrock-specifc part: plot contours and minimum
xx = -1.5:.04:1.5;
yy = -0.5:.04:1.5;
[x,y] = meshgrid(xx,yy);
meshd = 100.*(y-x.*x).^2 + (1-x).^2; 
hold off;
contour(xx,yy,meshd,3.^(1:6),':')
hold on;
plot(1,1,'*');
axis equal

% Plot the optimization path
plot(allx(1,1),allx(2,1),'o');
plot(allx(1,:),allx(2,:),'.-');

drawnow
figure(gcf)
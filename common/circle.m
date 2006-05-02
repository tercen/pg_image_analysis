function [x,y] = circle(mp, r, nPoints)
% function [x,y] = circle(mp, r, nPoints);
% x and y coordinates of a circle with midpoint mp and radius r
% using nPoints.

dt = 2*pi/nPoints;
t = [0:dt:2*pi -dt]';
x = mp(1) + r*sin(t); y = mp(2) + r*cos(t);
% EOF

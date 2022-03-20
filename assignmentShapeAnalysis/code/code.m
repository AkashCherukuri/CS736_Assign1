clear;
clc;
% Import the data...
A = importdata('../data/ellipses2D.mat');
nps=A.numOfPointSets;
np=A.numOfPoints;
points=A.pointSets;
plotter(nps,points);
shape_mean= code11(nps,np,points);
figure;
hold on;
plot(shape_mean(1,:),shape_mean(2,:) ,'*r'); 
shape_mean= code22(nps,np,points);
figure;
hold on;
plot(shape_mean(1,:),shape_mean(2,:) ,'*r'); 

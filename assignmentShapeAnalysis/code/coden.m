clear;
clc;
% Import the data...
points = importdata('../data/hands2D.mat');
[~,np,nps]=size(points);
plotter(nps,points);
shape_mean= code11(nps,np,points);
figure;
plot(shape_mean(1,:),shape_mean(2,:) ,'-*r'); 
modes(nps,np,points,shape_mean);
shape_mean= code22(nps,np,points);
figure;
plot(shape_mean(1,:),shape_mean(2,:) ,'-*r'); 

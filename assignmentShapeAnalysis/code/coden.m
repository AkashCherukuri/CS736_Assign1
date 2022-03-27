close all;
clear;
clc;
% Import the data...
points = importdata('../data/hands2D.mat');
[~,np,nps]=size(points);
plotter(nps,points);
sgtitle('initial poinset');
shape_mean1= code11(nps,np,points);
modes(nps,np,points,shape_mean1);
shape_mean2= code22(nps,np,points); 
modes(nps,np,points,shape_mean2);

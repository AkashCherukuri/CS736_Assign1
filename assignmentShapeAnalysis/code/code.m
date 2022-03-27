close all;
clear;
clc;
% Import the data...
A = importdata('../data/ellipses2D.mat');
nps=A.numOfPointSets;
np=A.numOfPoints;
points=A.pointSets;
plotter(nps,points);
sgtitle('initial poinset');
shape_mean1= code11(nps,np,points);
modes(nps,np,points,shape_mean1);
shape_mean2= code22(nps,np,points); 
modes(nps,np,points,shape_mean2);

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
[aligned_points1,shape_mean1]= code11(nps,np,points);
modes(nps,np,aligned_points1,shape_mean1);
[aligned_points2,shape_mean2]= code22(nps,np,points); 
modes(nps,np,aligned_points2,shape_mean2);

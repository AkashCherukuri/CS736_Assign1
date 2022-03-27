close all;
clear;
clc;
% Import the data...
points = importdata('../data/hands2D.mat');
[~,np,nps]=size(points);
plotter(nps,points);
sgtitle('initial poinset');
[aligned_points1,shape_mean1]= code11(nps,np,points);
modes(nps,np,aligned_points1,shape_mean1);
[aligned_points2,shape_mean2]= code22(nps,np,points); 
modes(nps,np,aligned_points2,shape_mean2);

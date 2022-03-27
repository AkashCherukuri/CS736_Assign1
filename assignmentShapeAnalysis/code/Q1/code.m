close all;
clear;
clc;
% Import the data...
A = importdata('../../data/ellipses2D.mat');
nps=A.numOfPointSets;
np=A.numOfPoints;
points=A.pointSets;
plotter(nps,points);
sgtitle('initial poinset');
[aligned_points1,shape_mean1]= code11(nps,np,points);
modes(nps,np,aligned_points1,shape_mean1);
[aligned_points2,shape_mean2]= code22(nps,np,points); 
modes(nps,np,aligned_points2,shape_mean2);

plotter(nps,aligned_points1);
sgtitle('Aligned pointset1');
figure;
plot(shape_mean1(1,:),shape_mean1(2,:) ,'-*r'); 
sgtitle('Shape mean1');
plotter(nps,aligned_points2);
sgtitle('Aligned pointset2');
figure;
plot(shape_mean2(1,:),shape_mean2(2,:) ,'-*r');  
sgtitle('Shape mean2');
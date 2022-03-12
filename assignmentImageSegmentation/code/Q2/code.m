clear;
clc;

% Import the data...
A = importdata('../../data/assignmentSegmentBrainGmmEmMrf.mat');

%...and get the different fields in the struct
imgData = A.imageData;
imgMask = A.imageMask;

% Given that the number of classes is 3
K = 3;



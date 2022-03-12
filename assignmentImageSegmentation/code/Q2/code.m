clear;
clc;

% Import the data...
A = importdata('../../data/assignmentSegmentBrainGmmEmMrf.mat');

%...and get the different fields in the struct
imgData = A.imageData;
imgMask = A.imageMask;
y = single(imgData.*imgMask);
[~,n] = size(y);

% Given that the number of classes is 3
K = 3;
n_iters = 2;
beta = 10;

%% Step1: Initialize Parameters \theta
%  KMeans algorithm is used to initialize the parameters for the gaussian
%  distributions

% Means initialised via KMeans
[X_map, mu] = imsegkmeans(y,K+1);
[~,idx] = min(mu);
mu(idx) = [];

% Kmeans always gives the black bg as class 1
class2 = [];
class3 = [];
class4 = [];

for i=1:n
    for j=1:n
        if (X_map(i,j)==2)
            class2(end+1) = y(i,j);
        elseif (X_map(i,j)==3)
            class3(end+1) = y(i,j);
        elseif(X_map(i,j)==4)
            class4(end+1) = y(i,j);
        end
    end
end

% Initialise the standard deviations
sigm = zeros(3);
sigm(1) = std(class2);
sigm(2) = std(class3);
sigm(3) = std(class4);

u = zeros(n,n,K);
for i=1:n
    for j=1:n
        [~,idx]=min(abs(mu-y(i,j)));
        u(i,j,idx)=1;
    end
end
u = u.*imgMask;

figure;
subplot(1,3,1); imshow(u(:,:,1));
subplot(1,3,2); imshow(u(:,:,2));
subplot(1,3,3); imshow(u(:,:,3));
sgtitle('Initalized memberships','FontSize', 15);

for i=1:n_iters
    %% E Step: Compute the MAP Estimate
    %  ICM has been used for this, as requested in the problem statement

    % This is mostly wrong, but is just acting as a placeholder
    % Put X_map as the max membership
    X_map = zeros(n,n);
    for xi=1:n
        for yi=1:n
            if(u(xi,yi,1)+u(xi,yi,2)+u(xi,yi,3)==0)
                X_map(xi,yi) = -1;
            else
                [~,max_idx] = max(u(xi,yi));
                X_map(xi,yi) = max_idx;
            end
        end
    end
    % Compute the potential function
    pot = potential(X_map, beta);

    % Compute the memberships
    u = zeros(n,n,3);
    for xi=1:n
        for yi=1:n
            den = 0;
            for k=1:K
                u(xi,yi,k) = (normpdf(y(xi,yi),mu(k),sigm(k)) * pot(xi,yi,k));
                den = den + u(xi,yi,k);
            end
            u(xi,yi,:) = u(xi, yi,:)/den;
        end
    end
    u(isnan(u))=0;
    %% M Step: Update the parameters
    %  Use the computed MAP estimate in the E Step to update both the means and
    %  the variances of the underlying GMM

    mu  = gauss_mean(u,y);
    sigm= gauss_std(u,y,mu);
end
    
figure;
subplot(1,3,1); imshow(u(:,:,1));
subplot(1,3,2); imshow(u(:,:,2));
subplot(1,3,3); imshow(u(:,:,3));
sgtitle('EM Optimization','FontSize', 15);

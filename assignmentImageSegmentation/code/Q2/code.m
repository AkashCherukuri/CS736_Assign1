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
n_iters = 100;
beta = 50;

%% Step1: Initialize Parameters \theta
%  KMeans algorithm is used to initialize the parameters for the gaussian
%  distributions

% Means initialised via KMeans
[X_map, mu] = imsegkmeans(y,K+1);
[~,idx] = min(mu);
mu(idx) = [];

mu
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

sigm
u = zeros(n,n,K);
for i=1:n
    for j=1:n
        [~,idx]=min(abs(mu-y(i,j)));
        u(i,j,idx)=1;
    end
end
u = u.*imgMask;

figure;
subplot(1,1,1); imshow(y);
sgtitle('Given image','FontSize', 15);


figure;
X_map = getLabelImg(u);
for i=1:n
    for j=1:n
        if(X_map(i,j)==-1)
            X_map(i,j)=0;
        end
    end
end
RGB = label2rgb(X_map, @jet, 'k');
subplot(1,1,1); imshow(RGB);
sgtitle('Initial Label image','FontSize', 15);

before_ICM = zeros(n_iters,1);
after_ICM  = zeros(n_iters,1);

for i=1:n_iters
    %% E Step: Compute the MAP Estimate
    %  ICM has been used for this, as requested in the problem statement
    
    % Get the MAP estimate
    t_max = getLabelImg(u);
    before_ICM(i) = getLogPosterior(t_max,y,beta,mu,sigm);
    X_map = performICM(t_max,y,beta,mu,sigm);
    after_ICM(i)  = getLogPosterior(X_map,y,beta,mu,sigm);

    % Compute the memberships
    u = zeros(n,n,3);
    for xi=1:n
        for yi=1:n
            if(t_max(xi,yi) ~= -1)
                den = zeros(3,1);
                for k=1:3
                    val = 0;
                    if(t_max(xi,yi+1)~=k && t_max(xi,yi+1)~=-1)
                        val = val + beta;
                    end
                    if(t_max(xi,yi-1)~=k && t_max(xi,yi-1)~=-1)
                        val = val + beta;
                    end
                    if(t_max(xi+1,yi)~=k && t_max(xi+1,yi)~=-1)
                        val = val + beta;
                    end
                    if(t_max(xi-1,yi)~=k && t_max(xi-1,yi)~=-1)
                        val = val + beta;
                    end
                    pot = exp(-val);
                    den(k) = pot * normpdf(y(xi,yi),mu(k), sigm(k));
                end
                den(isnan(den))=0;
                for k=1:3
                    u(xi,yi,k) = den(k)/sum(den,"all");
                end
            end
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
sgtitle('Optimal Class Image Estimates with \beta = 0','FontSize', 15);

figure;
for i=1:n
    for j=1:n
        if(X_map(i,j)==-1)
            X_map(i,j)=0;
        end
    end
end
RGB = label2rgb(X_map, @jet, 'k');
subplot(1,1,1); imshow(RGB);
sgtitle('Optimal Label Image with \beta=0','FontSize', 15);

figure;
xgraph = 1:n_iters;
plot(xgraph, before_ICM);
hold on;
plot(xgraph, after_ICM);
legend({'Before ICM','After ICM'});
title('Plot showing difference in Log-Posterior before and after ICM');
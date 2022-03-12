clear;
clc;

% Import the data...
A = importdata('../../data/assignmentSegmentBrain.mat');

%...and extract the features given by the data
img=A.imageData;
mask=A.imageMask;

y=img.*mask;            % Get the image inside the brain
b=ones(size(y)).*mask;  % Initialize the bias field inside the brain
k=3;                    % Given that the number of classes = 3

n_iters=19;             % Specify the number of iterations
q=1.6;                  % parameter to control the fuzziness
std = 10;                % Std dev of the gaussian controlling weights

w=fspecial('gaussian',20);   % Create a predefined 2D filter

u=zeros(256,256,k);   

% Perform KMeans to initialize the cluster means
[labels,c] = imsegkmeans(y,k+1); 
[~,idx]=min(c);
c(idx)=[];
[n,m]=size(y);
for i=1:n
    for j=1:m
        [~,idx]=min(abs(c-y(i,j)));
        u(i,j,idx)=1;
    end
end
u=u.*mask;

% Plot the initialized class means for the sake of comparision
figure;
subplot(1,3,1), imshow(u(:,:,1));
title('class 1', 'FontSize', 15);
subplot(1,3,2), imshow(u(:,:,2));
title('class 2', 'FontSize', 15);
subplot(1,3,3), imshow(u(:,:,3));
title('class 3', 'FontSize', 15);
sgtitle('Initial estimate for membership values','FontSize', 15);
c
obj_val = zeros(n_iters,1);

% Being iterating over the image
for i=1:n_iters
    u=memberships(y,c,b,w,q).*mask; % Find optimal value of memberships at every iteration (b)
    b=bias(w,y,u,c,q).*mask;        % Find optimal value of bias        at every iteration (c)
    c=class_means(u,b,w,q,y);       % Find optimal value of class means at every iteration (a)
    % Append the objective function value after the i'th iteration
    obj_val(i) = ObjFunc(u,q,w,y,c,b);  
end

bias_removed_image=zeros(256,256);
for i=1:k
    bias_removed_image=bias_removed_image+u(:,:,i).*c(i);
end
residual_image=y-bias_removed_image;

figure;
imshow(w);
title('Neibourhood mask','FontSize', 15);

obj_val
% Plot the objective function with number of iterations
figure;
plot(1:n_iters, obj_val);
sgtitle('Objective Function Plot', 'FontSize', 15);

figure;
imshow(y);
title('Corrupted Image','FontSize', 15);

% Plot the obtained classes 
figure;
subplot(1,3,1), imshow(u(:,:,1));
title('class 1', 'FontSize', 15);
subplot(1,3,2), imshow(u(:,:,2));
title('class 2', 'FontSize', 15);
subplot(1,3,3), imshow(u(:,:,3));
title('class 3', 'FontSize', 15);
sgtitle('Optimal class-membership image estimates','FontSize', 15);

figure;
imshow(b);
title('Optimal bias-field image estimate','FontSize', 15);

figure;
imshow(bias_removed_image);
title('Bias-removed image','FontSize', 15);

figure;
imshow(residual_image);
title('Residual image','FontSize', 15);

c
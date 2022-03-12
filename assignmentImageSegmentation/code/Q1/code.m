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

n_iters=40;             % Specify the number of iterations
q=1.7;                  % parameter to control the fuzziness
std = 0.5;                % Std dev of the gaussian controlling weights

w=fspecial('gaussian',5);   % Create a predefined 2D filter

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
sgtitle('Kmeans initialization','FontSize', 15);

obj_val = zeros(n_iters);

% Being iterating over the image
for i=1:n_iters
    u=memberships(y,c,b,w,q).*mask; % Find optimal value of memberships at every iteration (b)
    b=bias(w,y,u,c,q).*mask;        % Find optimal value of bias        at every iteration (c)
    c=class_means(u,b,w,q,y);       % Find optimal value of class means at every iteration (a)
    % Append the objective function value after the i'th iteration
    obj_val(i) = ObjFunc(u,q,w,y,c,b);   
end

% Plot the obtained classes 
figure;
subplot(1,3,1), imshow(u(:,:,1));
title('class 1', 'FontSize', 15);
subplot(1,3,2), imshow(u(:,:,2));
title('class 2', 'FontSize', 15);
subplot(1,3,3), imshow(u(:,:,3));
title('class 3', 'FontSize', 15);
sgtitle('Modified FCM','FontSize', 15);

% Plot the objective function with number of iterations
figure;
plot(1:n_iters, obj_val);
sgtitle('Objective Function Plot', 'FontSize', 15);

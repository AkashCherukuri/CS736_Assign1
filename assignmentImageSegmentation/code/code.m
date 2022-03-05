clear;
clc;
A = importdata('../data/assignmentSegmentBrain.mat');
img=A.imageData;
mask=A.imageMask;
y=img.*mask;
k=3;
b=ones(size(y)).*mask;
n_iters=5;
q=1.7;
w=fspecial('gaussian',5);
u=zeros(256,256,k);
[labels,c] = imsegkmeans(y,k+1);
[~,idx]=min(c);
c(idx)=[];
[n,m]=size(y);
for i=1:n
    for j=1:m
        if(mask(i,j))>0
            [~,idx]=min(abs(c-y(i,j)));
            u(i,j,idx)=1;
        end
    end
end
figure;
subplot(1,3,1), imshow(u(:,:,1));
title('class 1', 'FontSize', 15);
subplot(1,3,2), imshow(u(:,:,2));
title('class 2', 'FontSize', 15);
subplot(1,3,3), imshow(u(:,:,3));
title('class 3', 'FontSize', 15);
sgtitle('Kmeans initialization','FontSize', 15);
for i=1:n_iters
    u=memberships(y,c,b,w,q).*mask;
    b=bias(w,y,u,c,q).*mask;
    c=class_means(u,b,w,q,y);
end
figure;
subplot(1,3,1), imshow(u(:,:,1));
title('class 1', 'FontSize', 15);
subplot(1,3,2), imshow(u(:,:,2));
title('class 2', 'FontSize', 15);
subplot(1,3,3), imshow(u(:,:,3));
title('class 3', 'FontSize', 15);
sgtitle('Modified FCM','FontSize', 15);

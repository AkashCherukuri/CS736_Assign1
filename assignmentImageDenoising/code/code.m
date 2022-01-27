%{
   TO BE DONE!!!
   1. Rician Noise 
   2. Step of gradient descent must not be constant

%}

% 1 - Quadratic Prior
% 2 - Huber Prior
% 3 - The other prior
prior = 2;

% 1 - Gaussian Noise
% 2 - Rician Noise
noise = 1;

% Weighting term between noise and likelihood
alpha = 0.9999;

A = importdata('../data/assignmentImageDenoisingPhantom.mat');
clean = A.imageNoiseless;
y = A.imageNoisy;
n = size(clean);
m = n(1);
n = n(2);

x_new = y;
x_old = y;

while 1      
    diff = zeros(4,m,n);
    diff(1,:,:) = x_new-circshift(x_new,[0 -1]);
    diff(2,:,:) = x_new-circshift(x_new,[ 0 1]);
    diff(3,:,:) = x_new-circshift(x_new,[ 1 0]);
    diff(4,:,:) = x_new-circshift(x_new,[-1 0]);

    % pre-compute regularity terms 
    reg_d = zeros(m,n);
    thr = 0;
    step = 0;
    for idx = 1:4
        if prior == 1
            % Quadratic MRF Prior
            reg_d = reg_d + squeeze(2*diff(idx,:,:));
            thr = 0.2e-2;
            step = 0.01;
        elseif prior == 2
            % Huber MRF Prior
            reg_d = reg_d + squeeze(huber_der(squeeze(diff(idx,:,:)), 0.18));
            thr = 1.2e-4;
            step = 0.001;
        elseif prior == 3
            % The custom function's prior
            reg_d = reg_d + squeeze(disc_adap_der(squeeze(diff(idx,:,:)), 0.1));
            thr = 1e-4;
            step = 0.001;
        end
    end
    % Using gaussian noise
    fid = 2*(x_new-y);
    
    der = fid*(1-alpha) + reg_d*alpha;
    x_old = x_new;
    x_new = x_new - step*der;
    
    sqrt(sum(mean((x_new-x_old).^2),'all'))/sqrt(sum(mean((x_old).^2),'all'))
    if sqrt(sum(mean((x_new-x_old).^2),'all'))/sqrt(sum(mean((x_old).^2),'all')) < thr
        break
    end
    
end

subplot(1,3,1), imshow(x_new);
subplot(1,3,2), imshow(y);
subplot(1,3,3), imshow(clean);

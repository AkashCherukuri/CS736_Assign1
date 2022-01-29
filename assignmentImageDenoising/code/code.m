%{
   TO BE DONE!!!
   1.  ~~ Rician Noise ~~ 
   2.  ~~ Step of gradient descent must not be constant ~~
        implemented gradient descent with momentum
   3.  Code to plot the objective function values as gradient descent does
   its thing
%}

% 1 - Quadratic Prior
% 2 - Huber Prior
% 3 - The other prior
prior = 1;

% 1 - Gaussian Noise
% 2 - Rician Noise
noise = 2;

% Weighting term between noise and likelihood
alpha = 0.00001;

A = importdata('../data/assignmentImageDenoisingPhantom.mat');
clean = A.imageNoiseless;
y = A.imageNoisy;
n = size(clean);

imshow(y*256,jet);
m = n(1);
n = n(2);

x_new = y;
x_old = y;
prev_delta = 0;

itc = 0;
obj = [];

while 0      
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
            thr = 2e-4;
            step = 0.01;
            beta = 0.5;
        elseif prior == 2
            % Huber MRF Prior
            reg_d = reg_d + squeeze(huber_der(squeeze(diff(idx,:,:)), 0.005));
            thr = 1e-5;
            step = 0.001;
            beta = 0.5;     % Gradient Descent with momentum
        elseif prior == 3
            % The custom function's prior
            reg_d = reg_d + squeeze(disc_adap_der(squeeze(diff(idx,:,:)), 0.1));
            thr = 1e-4;
            step = 0.001;
        end
    end
    
    fid = 0;
    itc = itc + 1;
    if noise == 1
        % Using gaussian noise
        fid = 2*(x_new-y)*(alpha);        
    elseif noise == 2
        % Using Rician Noise
        arg = (x_new.*y)*(alpha);
        fid = (alpha)*(x_new - (besseli(1,arg)./besseli(0,arg)).*(y));
        
    end
        
    
    der = fid + reg_d*(1-alpha);
    x_old = x_new;
    x_new = x_new - (step*der + beta*prev_delta);
    prev_delta = (step*der + beta*prev_delta);
    
    
    rrmse(x_new, x_old)
    if rrmse(x_new, x_old) < thr
        break
    end
    
end

%subplot(1,3,1), imshow(x_new);
%subplot(1,3,2), imshow(y);
%subplot(1,3,3), imshow(clean);


post_diff = rrmse(x_new, clean);
init_diff = rrmse(y, clean);
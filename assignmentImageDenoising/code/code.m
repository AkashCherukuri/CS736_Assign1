clear;
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
alpha = 0.001*1.2;

%A = importdata('../data/assignmentImageDenoisingPhantom.mat');
A = importdata('../data/brainMRIslice.mat');
%clean = A.imageNoiseless;
%y = A.imageNoisy;
clean = A.brainMRIsliceOrig;
y = A.brainMRIsliceNoisy;
n = size(clean);

m = n(1);
n = n(2);

x_new = y;
x_old = y;
prev_delta = 0;

itc = 0;
objective_func_value = [];
iter_num = 0;

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
    gamma=0;
    for idx = 1:4
        if prior == 1
            % Quadratic MRF Prior
            reg_d = reg_d + squeeze(2*diff(idx,:,:));
            thr = 2.27e-3;
            step = 0.001;
            beta = 0.1;
        elseif prior == 2
            % Huber MRF Prior
            gamma = 0.002*0.8;
            reg_d = reg_d + squeeze(huber_der(squeeze(diff(idx,:,:)), gamma));
            thr =1e-4;
            % 1.2: 0.113747482273460
            step = 0.009;
            beta = 0.5;     % Gradient Descent with momentum
        elseif prior == 3
            % The custom function's prior
            gamma = 0.004;
            reg_d = reg_d + squeeze(disc_adap_der(squeeze(diff(idx,:,:)), gamma));
            thr = 2.5e-5;
            step = 0.006;
            beta = 0.4;
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
    
    objective_func_value(itc)=objective_function(x_new,y,diff,1-alpha,gamma,prior,noise);
    iter_num =iter_num + 1 ;
    rrmse(x_new, x_old);
    if rrmse(x_new, x_old) < thr && iter_num > 50
        break
    end
    
end

figure;
 imshow(x_new*255, jet);

iterations= linspace(1,itc,itc);
figure;
plot(iterations,objective_func_value);
xlabel('iteration');
ylabel('objective function value');
title('objective function value vs iteration for Quadratic Prior');

rrmse(clean, x_new)
rrmse(clean, y)
A = importdata('data/assignmentImageDenoisingPhantom.mat');
clean = A.imageNoiseless;
y = A.imageNoisy;
n = size(clean);
m = n(1);
n = n(2);

x_new = y;
x_old = y;

while 1      
    diff = zeros(4,m,n);
    diff(1,:,:) = abs(x_new-circshift(x_new,[0 -1]));
    diff(2,:,:) = abs(x_new-circshift(x_new,[ 0 1]));
    diff(3,:,:) = abs(x_new-circshift(x_new,[ 1 0]));
    diff(4,:,:) = abs(x_new-circshift(x_new,[-1 0]));

    % pre-compute regularity terms 
    reg_d = zeros(m,n);
    for idx = 1:4
        % Quadratic MRF Prior
        reg_d = reg_d + squeeze(2*diff(idx,:,:));
    end
    step = 0.1;
    % Using gaussian noise
    der = reg_d + 2*(x_new-y);
    x_old = x_new;
    x_new = x_new - step*der;
    sqrt(sum(mean((x_new-x_old).^2),'all'))/sqrt(sum(mean((x_old).^2),'all'))
    if sqrt(sum(mean((x_new-x_old).^2),'all'))/sqrt(sum(mean((x_old).^2),'all')) < 0.25
        break
    end
end

imshow(x_new)
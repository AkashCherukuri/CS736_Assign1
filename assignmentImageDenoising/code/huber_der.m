function [der] = huber_der(x, gamma)
% Computes the derivative of the huber's function  
% to be used in the gradient descent algorithm
sz = size(x);
m = sz(1);
n = sz(2);
der = zeros(m,n);
for i = 1:m
    for j = 1:n
        if x(i,j) > gamma 
            der(i,j) = gamma;
        elseif x(i,j) < -gamma
            der(i,j) = -gamma;
        else
            der(i,j) = x(i,j);
        end
    end
end
end


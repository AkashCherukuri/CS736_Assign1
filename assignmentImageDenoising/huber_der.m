function [der] = huber_der(x, gamma)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
sz = size(x);
m = sz(1);
n = sz(2);
der = zeros(m,n);
for i = 1:m
    for j = 1:n
        if x(i,j) > gamma
            der(i,j) = gamma;
        else
            der(i,j) = x(i,j);
        end
    end
end
end


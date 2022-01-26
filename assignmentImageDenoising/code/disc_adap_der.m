function [der] = disc_adap_der(x,gamma)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
sz = size(x);
m = sz(1);
n = sz(2);
der = zeros(m,n);
for i=1:m
    for j=1:n
        if x(i,j) > 0
            der(i,j) = (1.0*gamma*x(i,j))/(gamma+x(i,j));
        elseif x(i,j) < 0
            der(i,j) = (1.0*gamma*x(i,j))/(gamma-x(i,j));
        end
    end
end
end


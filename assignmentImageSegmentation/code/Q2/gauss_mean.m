% Code to find optimal values of class means
function [mu] = gauss_mean(m,y)
    [~,~,K] = size(m);
    mu = zeros(K);
    for k=1:K
        num = sum(m(:,:,k).*y(:,:));
        den = sum(m(:,:,k));
        mu(k) = num/den;
    end
end
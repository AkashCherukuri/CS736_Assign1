% Code to find optimal values of class deviations
function [std] = gauss_std(m,y,mu)
    K = size(mu);
    std = zeros(K);
    for k=1:K
        num = sum(m(:,:,k).*(y(:,:)-mu(k)).^2);
        den = sum(m(:,:,k));
        std(k) = num/den;
    end
end
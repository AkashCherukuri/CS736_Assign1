% Code to find optimal values of class deviations
function [std] = gauss_std(m,y,mu)
    K = 3;
    std = zeros(K,1);
    for k=1:K
        num = sum(m(:,:,k).*(y(:,:)-mu(k)).^2);
        den = sum(m(:,:,k));
        std(k) = sqrt(num/den);
    end
end
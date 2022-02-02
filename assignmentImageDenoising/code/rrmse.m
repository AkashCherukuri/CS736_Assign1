function [out] = rrmse(x1,x2)
% outputs the relative mean squared error wrt x2
out = sqrt(sum(mean((abs(x1)-abs(x2)).^2),'all'))/sqrt(sum(mean((x1).^2),'all'));
end

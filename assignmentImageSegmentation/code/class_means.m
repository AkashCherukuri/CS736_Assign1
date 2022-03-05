function [c] = class_means(u,b,w,q,y)
[~,~,K]=size(u);
p=conv2(b,w,'same');
t=conv2(b.^2,w,'same');
p(~isnan(p))=0;
p(isnan(p))=1;
l=sum(sum(p));
c=zeros(K,1);
uq=u.^q;
for k=1:K
    num=sum(sum(uq(:,:,k).*(y.*p)));
    dem=sum(sum(uq(:,:,k).*t));
    c(k)=num/dem;
end
end
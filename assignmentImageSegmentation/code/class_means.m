function [c] = class_means(u,b,w,q,y)
[~,~,K]=size(u);
p=conv2(b,w,'same');
t=conv2(b.^2,w,'same');
c=zeros(K,1);
uq=u.^q;
for k=1:K
    num=sum(uq(:,:,k).*(y.*p),[1 2]);
    dem=sum(uq(:,:,k).*t,[1 2]);
    c(k)=num/dem;
end
end
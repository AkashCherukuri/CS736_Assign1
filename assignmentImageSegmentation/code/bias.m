function [b] = bias(w,y,u,c,q)
[N,M,K]=size(u);
uq=u.^q;
p=zeros(N,M,K);
t=zeros(N,M,K);
for k=1:K
    p(:,:,k)=uq(:,:,k).*c(k);
    t(:,:,k)=uq(:,:,k).*((c(k)^2));
end
num = conv2(y.*sum(p,3),w,'same');
den= conv2(sum(t,3),w,'same');
b = num./den;
b(isnan(b))=0;
end
function [u] = memberships(y,c,b,w,q)
[K,~] = size(c);
p=conv2(b,w,'same');
t=conv2(b.^2,w,'same');
[n,m]=size(y);
d=zeros(n,m,K);
h=ones(n,m,K);
u=zeros(n,m,K);
for k=1:K
    d(:,:,k)=abs((y.^2)-(2*c(k).*y.*p)+((c(k)^2).*t));
end
h=(h./d).^(1/(q-1));
h(isnan(h))=0;
h_sum=sum(h,3);
for k=1:K
    u(:,:,k)=h(:,:,k)./h_sum;
end
u(isnan(u))=0;
end
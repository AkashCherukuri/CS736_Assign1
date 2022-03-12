function [val] = ObjFunc(u,q,w,y,c,b)
    % Returns the value of the objective function
    [K,~] = size(c);
    p=conv2(b,w,'same');
    t=conv2(b.^2,w,'same');
    [n,m]=size(y);
    d=zeros(n,m,K);
    uq=u.^q;
    for k=1:K
        d(:,:,k)=(y.^2)-(2*c(k).*y.*p)+((c(k)^2).*t);
    end
    val = sum(uq.*d,"all");
end
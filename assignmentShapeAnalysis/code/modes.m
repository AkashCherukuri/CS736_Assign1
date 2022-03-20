function [] = modes(nps,np,points,shape_mean)
S=zeros(2*np,2*np);
for i=1:nps
    dX=reshape(points(:,:,i),1,2*np)-reshape(shape_mean,1,2*np);
    S=S+dX*dX.';
end
S=S./nps;
[V,D] = eig(S);
for i=1:3
    pma=shape_mean-3*sqrt(D(i))*reshape(V(:,i),2,np);
    pmb=shape_mean+3*sqrt(D(i))*reshape(V(:,i),2,np);
    figure;
    plot(shape_mean(1,:),shape_mean(2,:) ,'-*r'); 
    hold on;
    plot(pma(1,:),pma(2,:) ,'-*r');
    hold on;
    plot(pmb(1,:),pmb(2,:) ,'-*r');
end
end
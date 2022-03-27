function [] = modes(nps,np,points,shape_mean)
dX=zeros(2*np,nps);
S=zeros(2*np,2*np);
for i=1:nps
    dX(:,i)=reshape(points(:,:,i),1,2*np)-reshape(shape_mean,1,2*np);
end
S=(dX*dX.')./nps;
[V,D] = eig(S);
[~, idx] = sort(diag(D));
D=D(idx,idx);
V = V(:, idx);
for k=1:3
    i=2*np-k+1;
    pma=shape_mean-3*sqrt(D(i,i))*reshape(V(:,i),2,np);
    pmb=shape_mean+3*sqrt(D(i,i))*reshape(V(:,i),2,np); 
    figure;
    plot(shape_mean(1,:),shape_mean(2,:) ,'-*r'); 
    hold on;
    plot(pma(1,:),pma(2,:) ,'-*b');
    hold on;
    plot(pmb(1,:),pmb(2,:) ,'-*g');
    legend('shape mean','-3 std-deviation','+3 std-deviation')
    title(string(k)+' mode of variation');
end
end
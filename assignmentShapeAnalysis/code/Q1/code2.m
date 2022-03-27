function [points,shape_mean] = code1(nps,np,points)
shape_mean=sum(points,3)./nps;
threshold=5e-5;
while 1
    X1=sum(shape_mean(1,:))/np;
    Y1=sum(shape_mean(2,:))/np;
    W=1;
    for i=1:nps
        X2=sum(points(1,:,i))/np;
        Y2=sum(points(2,:,i))/np;
        Z=sum(points(:,:,i).^2,'all')/np;
        C1=sum(points(:,:,i).*shape_mean,'all')/np;
        C2=0;
        for k=1:np
            C2=C2+1/np*(shape_mean(2,k)*points(1,k,i)-shape_mean(1,k)*points(2,k,i));
        end
        A=[X2 -Y2 W 0;
            Y2 X2 0 W;
            Z 0 X2 Y2;
            0 Z -Y2 X2];
        B=[X1; Y1; C1; C2]; 
        L = linsolve(A,B);
        a=L(1);
        b=L(2);
        M=[a -b; b a];
        points(:,:,i)=M*points(:,:,i)+L(3:4);
    end
    new_shape_mean=sum(points,3)./nps;
    diff=sqrt(sum((new_shape_mean-shape_mean).^2,'all'));
    if(diff<threshold)
        break;
    end
    shape_mean=new_shape_mean;
end
plotter(nps,points);
hold on;
plot(shape_mean(1,:),shape_mean(2,:) ,'-*','LineWidth',2); 
sgtitle('aligned poinset and shape mean');
end

function [shape_mean] = code1(nps,np,preshape_points)
shape_mean=sum(preshape_points,3)./np;
threshold=6e-8;
while 1
    for i=1:nps
        A=preshape_points(:,:,i)*shape_mean.';
        [U,~,V] = svd(A);
        R=V*U.';
        if(det(R)==-1)
            if(R(1,1)>=R(2,2))
                R=V*[1,0;0,-1]*U.';
            else
                R=V*[-1,0;0,1]*U.'; 
            end
        end
        preshape_points(:,:,i)=R*preshape_points(:,:,i);
    end
    new_shape_mean=sum(preshape_points,3)./np;
    norm=sqrt(sum(new_shape_mean.^2,'all'));
    new_shape_mean=new_shape_mean./norm; 
    diff=sqrt(sum((new_shape_mean-shape_mean).^2,'all'));
    if(diff<threshold)
        break;
    end
    shape_mean=new_shape_mean;
end
plotter(nps,preshape_points);
hold on;
plot(shape_mean(1,:),shape_mean(2,:) ,'-*','LineWidth',2); 
sgtitle('aligned poinset and shape mean');
end
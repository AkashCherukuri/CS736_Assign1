function [shape_mean] = code1(nps,np,points)
centroid=sum(points,2)./np;
points=points-centroid;
shape_mean=sum(points,3)./nps;
threshold=5e-8;
while 1
    for i=1:nps
        A=points(:,:,i)*shape_mean.';
        [U,~,V] = svd(A);
        R=V*U.';
        if(det(R)==-1)
            if(R(1,1)>=R(2,2))
                R=V*[1,0;0,-1]*U.';
            end
        end
        points(:,:,i)=R*points(:,:,i);
    end
    norm_mean=sqrt(sum(shape_mean.^2,'all'));
    norm=sqrt(sum(points.^2,[1 2]));
    points=points./norm.*norm_mean;
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

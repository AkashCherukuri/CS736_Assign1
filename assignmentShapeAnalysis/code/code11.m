function [shape_mean] = code11(nps,np,points)
centroid=sum(points,2)./np;
preshape_points=points-centroid; 
%plotter(nps,preshape_points);
norm=sqrt(sum(preshape_points.^2,[1 2]));
preshape_points=preshape_points./norm; 
%plotter(nps,preshape_points);
shape_mean=code1(nps,np,preshape_points);
end
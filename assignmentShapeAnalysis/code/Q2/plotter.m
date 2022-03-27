function [] = plotter(nps,points)
    figure;
    cmap = hsv(nps);
    for i=1:nps 
        hold on;
        plot(points(1,:,i),points(2,:,i) ,'*','Color',cmap(i,:)); 
    end
end
function [value] = objective_function(x,y,u,alpha,gamma,prior,noise)
%calulates the value of objective function
sz = size(x);
m = sz(1);
n = sz(2);
obj_func = zeros(m,n);
for i = 1:m
    for j = 1:n
        xi=x(i,j);
        yi=y(i,j);
        if(noise==1)
            obj_func(i,j)=(1-alpha)*(yi-xi)^2;
        else
            obj_func(i,j)=(1-alpha)*(yi^2+xi^2)/2-log(besseli(0,(1-alpha)*xi*yi));
        end
        
        for idx = 1:4
            ui=u(idx,i,j);
            if prior == 1
                % Quadratic MRF Prior
                obj_func(i,j)=obj_func(i,j)+alpha*(ui^2);

            elseif prior == 2
                % Huber MRF Prior
                if(abs(ui)<=gamma)
                    obj_func(i,j)=obj_func(i,j)+alpha*0.5*(ui^2);
                else
                    obj_func(i,j)=obj_func(i,j)+alpha*(gamma*abs(ui)-0.5*gamma^2);
                end      
            elseif prior == 3
                % The custom function's prior
                obj_func(i,j)=obj_func(i,j)+alpha*(gamma*abs(ui)-gamma^2*log(1+abs(ui)/gamma));
            end
        end
    end
end
value=mean(obj_func,'all');
end
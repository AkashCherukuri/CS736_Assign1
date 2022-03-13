function [ll] = getLogPosterior(t_max,data,beta,mu,sigm)
    [n,~] = size(t_max);
    id_l = randperm(n);
    ll = 0;
    for i=1:n
        for j=1:n
            x = id_l(i); y = id_l(j);
            if(t_max(x,y) ~= -1)
                den = zeros(3,1);
                for k=1:3
                    val = 0;
                    if(t_max(x,y+1)~=k && t_max(x,y+1)~=-1)
                        val = val + beta;
                    end
                    if(t_max(x,y-1)~=k && t_max(x,y-1)~=-1)
                        val = val + beta;
                    end
                    if(t_max(x+1,y)~=k && t_max(x+1,y)~=-1)
                        val = val + beta;
                    end
                    if(t_max(x-1,y)~=k && t_max(x-1,y)~=-1)
                        val = val + beta;
                    end
                    den(k) = exp(-val);
                end
                tmp = den(t_max(x,y))/sum(den) * normpdf(data(x,y),mu(k), sigm(k));
                if (tmp ~= 0)
                    ll = ll + log(tmp);
                end
            end
        end
    end
end
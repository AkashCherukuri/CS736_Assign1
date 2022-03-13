function [t_max] = getLabelImg(u)
% Get the labeled image from membership matrix
[~,n,~] = size(u);
t_max = zeros(n,n);
    for xi=1:n
        for yi=1:n
            if(sum(u(xi,yi,:),3)~=0)
                [~,max_idx] = max(u(xi,yi,:));
                t_max(xi,yi) = max_idx;
            else
                t_max(xi,yi) = -1;
            end
        end
    end
end
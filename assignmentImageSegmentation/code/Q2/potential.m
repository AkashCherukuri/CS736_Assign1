function [pot] = potential(X_map,beta)
    % Find the potential function, ignoring norm const
    pot = zeros(256,256,3);
    for i=1:256
        for j=1:256
            if(X_map(i,j)~=-1)
                for k=1:3
                    v = 0;
                    if (X_map(i+1,j)~=k && X_map(i+1,j)~=-1)
                        v = v+beta;
                    end
                    if (X_map(i-1,j)~=k && X_map(i+1,j)~=-1)
                        v = v+beta;
                    end
                    if (X_map(i,j+1)~=k && X_map(i+1,j)~=-1)
                        v = v+beta;
                    end
                    if (X_map(i,j-1)~=k && X_map(i+1,j)~=-1)
                        v = v+beta;
                    end
                    pot(i,j,k) = exp(-v);
                end
            end
        end
    end
end
function [x_min,x_max,y_min,y_max]=GetRectangularBoundary(L,N)
    x_min=0;
    x_max=0;
    y_min=0;
    y_max=0;   
    for i=1:N
        % x min
        if L{i}{1,1}(1)<x_min
            x_min = L{i}{1,1}(1);
        end
        if L{i}{1,2}(1)<x_min
            x_min = L{i}{1,2}(1);
        end
    
        % x max
        if L{i}{1,1}(1)>x_max
            x_max = L{i}{1,1}(1);
        end
        if L{i}{1,2}(1)>x_max
            x_max = L{i}{1,2}(1);
        end
    
        % y min
        if L{i}{1,1}(2)<y_min
            y_min = L{i}{1,1}(2);
        end
        if L{i}{1,2}(2)<y_min
            y_min = L{i}{1,2}(2);
        end
    
        % y max
        if L{i}{1,1}(2)>y_max
            y_max = L{i}{1,1}(2);
        end
        if L{i}{1,2}(2)>y_max
            y_max = L{i}{1,2}(2);
        end
    end

end
function labelData = getLabel(points, dimension, labelValue)

    labelData = zeros(dimension);
    dimX = dimension(1);
    dimY = dimension(2);

    row = length(points)/4;
    col = 3;

    pts = zeros(row,col);
    k = 1;

    for i = 1 : 4 : length(points)
        pts(k,1) = points(i);
        pts(k,2:3) = [points(i+1), points(i+2)];
        if (k > 1)
            [x, y] = getBresenhamLine(pts(k,2),pts(k,3),pts(k-1,2),pts(k-1,3));
            for j = 1 : length(x)
                pts(k,1) = points(i);
                pts(k,2) = min(x(j), dimX);
                pts(k,3) = min(y(j), dimY);
                k = k + 1;
            end
            k = k - 1;
        end
        k = k + 1;
    end

    for i = 1:size(pts,1)
        labelData(pts(i,2),pts(i,3),pts(i,1)) = labelValue;
    end

end

% function [x y] = getInterpolatedPoints(pts)
% 
%     slices = unique(pts(:,1));
%     
%     for i = 1:length(slices)
%         k = slices(i);
%         r = 1;
%         while(pts(r,1) == k)
%             x(r) = pts(r,2);
%             y(r) = pts(r,3);
%             if (r > 1)
%                 [x, y] = getBresenhamLine(x(r),y(r),x(r-1),y(r-1));
%             end
%             r = r + 1;
%         end
% 
%         spl = spline(x,y);
% 
%         X = linspace(0,2,100)';
%         Y = ppval(spl,X);
% 
%     end
% end

function [x, y] = getBresenhamLine(x1,y1,x2,y2)
    x1=round(x1); 
    x2=round(x2);
    y1=round(y1); 
    y2=round(y2);
    dx = abs(x2-x1);
    dy = abs(y2-y1);
    steep = abs(dy) > abs(dx);
    if steep 
        t=dx;
        dx=dy;
        dy=t; 
    end
    % The main algorithm goes here.
    if dy==0
        q=zeros(dx+1,1);
    else
        q=[0;diff(mod([floor(dx/2):-dy:-dy*dx+floor(dx/2)]',dx))>=0];
    end
    % and ends here.
    
    if steep
        if y1<=y2 
            y=[y1:y2]'; 
        else 
            y=[y1:-1:y2]'; 
        end
        if x1<=x2 
            x=x1+cumsum(q);
        else 
            x=x1-cumsum(q); 
        end
    else
        if x1<=x2 
            x=[x1:x2]'; 
        else 
            x=[x1:-1:x2]'; 
        end
        if y1<=y2 
            y=y1+cumsum(q);
        else 
            y=y1-cumsum(q); 
        end
    end
end
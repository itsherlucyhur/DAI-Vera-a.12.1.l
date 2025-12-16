function L = getDistanceBetweenSlicesAB(x1, y1, xn, yn, extraPoints, hB, pixelSpacing)

    if (isempty(extraPoints))
        L = getDistanceFromTwoNeighboringPoints(x1, y1, xn, yn, hB, pixelSpacing);
    else
        tempL = 0;
        for i = 1:2:max(size(extraPoints))
            x2 = extraPoints(i);
            y2 = extraPoints(i+1);
            
            tempL = tempL + getDistanceFromTwoNeighboringPoints(x1, y1, x2, y2, hB, pixelSpacing);
            
            x1 = x2;
            y1 = y2;
        end
        L = tempL + getDistanceFromTwoNeighboringPoints(x1, y1, xn, yn, hB, pixelSpacing);
    end
end

function L = getDistanceFromTwoNeighboringPoints(x1, y1, x2, y2, hB, pixelSpacing)
    % hB is defined as (z2-z1)
    x = (x2-x1)* pixelSpacing(2); % column spacing
    y = (y2-y1)* pixelSpacing(1); % row spacing

    % convert x and y to cm:
    x = x / 10;
    y = y / 10;

    % hB is passed to this function as cm:
    L = sqrt( x*x + y*y + hB*hB);
end
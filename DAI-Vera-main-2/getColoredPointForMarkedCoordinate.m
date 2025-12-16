function img = getColoredPointForMarkedCoordinate(img, x, y, rgbVector)

    center_x = x;
    center_y = y;

    X = [center_x-1 center_x center_x+1 center_x-1 center_x center_x+1 center_x-1 center_x center_x+1];
    Y = [center_y-1 center_y-1 center_y-1 center_y center_y center_y center_y+1 center_y+1 center_y+1];

    for i = 1:max(size(X))
        img(X(i),Y(i),:) = rgbVector;
    end
    
end
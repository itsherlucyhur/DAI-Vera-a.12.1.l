function [imageWithContour, radiusIncm, areaOfContourInCmSq, X, Y] = getContour(x, y, searchWindowSize, slice, timePoint, fourDImageSet, pixelSpacing)
    
    radiusIncm = 0;
    areaOfContourInCmSq = 0;
    
    if (max(size(x)) ~= 1)
        imageWithContour(1:512, 1:512) = fourDImageSet(slice, timePoint, 1:512, 1:512);
        [X, Y] = getCloseContour(x,y);
        imageWithContour = getROIOverlayed(imageWithContour, X, Y);
        
        [Xall, Yall] = getAllPixelsInClosedContour(X, Y);
        numOfPixels = max(size(Xall));
        
        avgPixelSpacing = (pixelSpacing(1) + pixelSpacing(2)) / 2;
        areaOfContourInCmSq = numOfPixels * avgPixelSpacing * avgPixelSpacing / 100;
        
    else
        [sx, sy] = getSearchWindow(x,y,searchWindowSize);
        imageWithContour(1:512, 1:512) = fourDImageSet(slice, timePoint, 1:512, 1:512);    
        [X, Y, longAxis, shortAxis, maxX, minX, numOfPixels] = getContourIndices(sx, sy, searchWindowSize,imageWithContour, fourDImageSet, slice, timePoint, x, y);

        for i = 1:size(X)
            imageWithContour(X(i),Y(i)) = 1500;
        end

        avgPixelSpacing = (pixelSpacing(1) + pixelSpacing(2)) / 2;
        radiusInmm = (longAxis + shortAxis) / 2 * avgPixelSpacing;
        radiusIncm = radiusInmm / 10;

        areaOfContourInCmSq = numOfPixels * avgPixelSpacing * avgPixelSpacing / 100;
    end  
end

function [Xall, Yall] = getAllPixelsInClosedContour(X, Y)

    [xGrid, yGrid] = meshgrid(1:512, 1:512);
    xGridFlat = xGrid(:);
    yGridFlat = yGrid(:);
    [in, on] = inpolygon(xGridFlat, yGridFlat, X, Y);
    Xall = xGridFlat(in | on);
    Yall = yGridFlat(in | on);
end

function [X, Y, lX, sX, maxX, minX, numOfPixels] = getContourIndices(sx, sy, searchWindowSize, image2D, fourDImageSet, slice, timePoint, x, y)

    block2D(1:searchWindowSize, 1:searchWindowSize) = image2D(sx:sx+searchWindowSize-1, sy:sy+searchWindowSize-1);
    level = graythresh(image2D); % Emperical, instead of: level = graythresh(image2D);
    block2DBinary = imbinarize(block2D, level);
    
    boundaryImage = bwperim(block2DBinary);
    
    [labeledImage, numberOfBlobs] = bwlabel(boundaryImage);
    if (numberOfBlobs > 0)
        blobMeasurements = regionprops(labeledImage, 'area');
        allAreas = [blobMeasurements.Area];
        [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
        biggestBlob = ismember(labeledImage, sortIndexes(1:1));
        contourImage = biggestBlob > 0;
        
        [X, Y] = find(contourImage);
        X = round(X + sx);
        Y = round(Y + sy);
        
        [lX, sX, maxX, minX] = getLongAndShortAxis(contourImage);
        
        numOfPixels = getNumberOfPixels(contourImage);
    else
        radiusIncm = 0;
        areaOfContourInCmSq = 0;
        X = [];
        Y = [];
        lX = 0;
        sX = 0;
        maxX = 0;
        minX = 0;
        numOfPixels = 0;
        
        imageWithContour(1:512, 1:512) = fourDImageSet(slice, timePoint, 1:512, 1:512);
        [X, Y] = getWindowPerimeter(x, y, searchWindowSize, searchWindowSize);
        for i = 1:size(X)
            imageWithContour(X(i),Y(i)) = 1500;
        end
    end
end

function [longAxis, shortAxis, maxAxis, minAxis] = getLongAndShortAxis(binaryImage)

    measurements = regionprops(binaryImage, 'MajorAxisLength', 'MinorAxisLength', 'Orientation');
    longAxis = measurements.MajorAxisLength;
    shortAxis = measurements.MinorAxisLength;
    
    [maxAxis,LM] = bwferet(binaryImage,'MaxFeretProperties');
    [minAxis,LM] = bwferet(binaryImage,'MinFeretProperties');
end

function mask = getStraightLine(x1, y1, x2, y2, mask)
    % Distance (in pixels) between the two endpoints
    nPoints = ceil(sqrt((x2 - x1).^2 + (y2 - y1).^2)) + 1;

    % Determine x and y locations along the line
    xvalues = round(linspace(x1, x2, nPoints));
    yvalues = round(linspace(y1, y2, nPoints));

    % Replace the relevant values within the mask
    mask(sub2ind(size(mask), yvalues, xvalues)) = 1500;
end

function numOfPixels = getNumberOfPixels(contourImage)
    bw2 = imfill(contourImage,[1,1]);
    numOfPixels = size(contourImage,1) * size(contourImage,2) - nnz(bw2);
end

function [closedX, closedY] = getCloseContour(x, y)

    x = [x', x(1)];
    y = [y', y(1)];

    % Approach: By Erosion and Dilation
    % bim = false(512, 512);
    % for i = 1:max(size(x))
    %     bim(x(i),y(i)) = true;
    % end
    % structuralElement = ones(3,3);
    % contourImage = imerode(bim, structuralElement) ~= imdilate(bim, structuralElement);
    % [closedX, closedY] = find(contourImage == true);

    % Approach: By Bresenham's Line Algorithm
    closedX = [];
    closedY = [];
    for i = 1 : length(x) - 1
        
        x0 = x(i);
        y0 = y(i);
        x1 = x(i + 1);
        y1 = y(i + 1);

        [lineX, lineY] = bresenhamLine(x0, y0, x1, y1);

        lineX = lineX';
        lineY = lineY';

        closedX = [closedX, lineX];
        closedY = [closedY, lineY];
    end

end

function [x y] = bresenhamLine(x1,y1,x2,y2)
    x1 = round(x1); 
    x2 = round(x2);
    y1 = round(y1); 
    y2 = round(y2);

    dx = abs(x2-x1);
    dy = abs(y2-y1);
    steep = abs(dy) > abs(dx);
    if (steep) 
        t = dx;
        dx = dy;
        dy = t; 
    end
    
    if (dy == 0) 
        q = zeros(dx+1,1);
    else
        q = [0;diff(mod([floor(dx/2):-dy:-dy*dx+floor(dx/2)]',dx))>=0];
    end
    
    if (steep)
        if y1 <= y2 
            y = [y1:y2]'; 
        else 
            y = [y1:-1:y2]'; 
        end
        if x1 <= x2 
            x = x1 + cumsum(q);
        else 
            x = x1 - cumsum(q); 
        end
    else
        if x1 <= x2 
            x = [x1:x2]'; 
        else 
            x = [x1:-1:x2]'; 
        end
        if y1 <= y2 
            y = y1 + cumsum(q);
        else 
            y = y1 - cumsum(q); 
        end
    end
end

function [X Y] = getWindowPerimeter(sx, sy, width, height)
    k = 1;
    X = [];
    Y = [];
    for i = sx:sx + height
        for j = sy:sy + width
            if (i == sx || i == sx+height || j == sy || j == sy+width)
                X(k) = i;
                Y(k) = j;
                k = k + 1;
            end
        end
    end
end
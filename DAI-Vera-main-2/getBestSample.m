function [bestCurve, interpolatedSampledPoints, interPolatedTimePoints, searchWindowX, searchWindowY, RoiX, RoiY] = getBestSample(x, y, windowSize, roiM, roiN, slice, fourDImageSet, timePointValues)

    if (max(size(x)) ~= 1)
        binaryImage = false(512,512);
        for i = 1:max(size(x))
            binaryImage(x(i),y(i)) = true;
        end
        roiFilledBinaryImage = imfill(binaryImage, 'holes');
        [allX, allY] = find(roiFilledBinaryImage == true);

        timePoints = max(size(timePointValues));
        bestCurve = zeros(1, timePoints);
        for t = 1:timePoints
            currentTimePointImage(1:512,1:512) = fourDImageSet(slice, t, 1:512, 1:512);
            k = 1;
            allPixels = zeros(1,max(size(allX)));
            for i = 1:max(size(allX))
                allPixels(k) = currentTimePointImage(allX(i),allY(i));
                k = k + 1;
            end
            bestCurve(t) = mean(allPixels);
        end
        searchWindowX = x; 
        searchWindowY = y;
        RoiX = x;
        RoiY = y;
    else
        [sx, sy] = getSearchWindow(x,y,windowSize);
        [searchWindowX, searchWindowY] = getWindowPerimeter(sx, sy, windowSize, windowSize);
        timePoints = max(size(timePointValues));
        bestCurve = zeros(1, timePoints);
        RoiX = [];
        RoiY = [];
        for t = 1:timePoints
            maxPts = -4096;
            for X = sx : sx + windowSize - roiM
                for Y = sy : sy +windowSize - roiN
                    [Xpt, Ypt] = getCoordinates(X, Y, roiM, roiN);  
                    if (X == x && Y == y)
                        [RoiX, RoiY] = getWindowPerimeter(X, Y, roiN, roiM); 
                    end
                    for k = 1:max(size(Xpt))
                        pt(k) = fourDImageSet(slice, t, Xpt(k), Ypt(k));
                    end
                    
                    avgPts = mean(pt);
                    
                    if (maxPts < avgPts)
                        maxPts = avgPts;
                    end
                    
                end
            end
            bestCurve(t) = maxPts;
        end
    end
    
    if (timePoints < 25)
        [interpolatedSampledPoints, interPolatedTimePoints] = getInterpolatedCurve(timePointValues,bestCurve,25);
    else
        interpolatedSampledPoints = bestCurve;
        interPolatedTimePoints = timePointValues;
    end
end

function [X, Y] = getCoordinates(x, y, m, n)
    k = 1;
    for i = x : x + m
        for j = y : y + n
            X(k) = i;
            Y(k) = j;
            k = k + 1;
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
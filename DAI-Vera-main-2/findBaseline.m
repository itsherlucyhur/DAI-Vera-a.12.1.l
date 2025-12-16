function baselinePosition = findBaseline(tdc)

    if (ndims(tdc) > 1)
        tdc = tdc';
    end
    
    % baselinePositionByFindChangePts = getBaseLineFromFindChangePts(tdc);
    % baselinePositionByThreshold = getBaseLineFromThreshold(tdc);
    % baselinePositionByUpwardTrendOfThree = getBaseLineFromUpwardTrend(tdc);
    baselinePosition = getBaseLineFromDeltaDiff(tdc);
 
end

function baselinePositionByFindChangePts = getBaseLineFromFindChangePts(tdc)
    % FindChangePts Method
    [val, idx] = max(tdc);
    baselinePositionByFindChangePts = findchangepts(tdc(2:idx-1));
    
    if isempty(baselinePositionByFindChangePts)
        baselinePositionByFindChangePts = idx-1;
    end
end

function baselinePositionByThreshold = getBaseLineFromThreshold(tdc)
    % Previous Method (without minimum points)
    baselinePositionByThreshold = 1;
    threshold = max(tdc) * 10 / 100;
    for i = 1:size(tdc)
        if ((tdc(i+1) - tdc(i)) > threshold)
            baselinePositionByThreshold = i+1;
            break;
        end
    end
end

function baselinePositionByUpwardTrendOfThree = getBaseLineFromUpwardTrend(tdc)
    % Upward Trend Finding Method
    dTdc = diff(tdc)>0;
    stats = regionprops(bwlabel(dTdc), 'Area', 'PixelIdxList');
    threeOrLonger = find([stats.Area] >= 3);
    if ~isempty(threeOrLonger)
      % Take the first one, if multiple such pattern found:
      for blobIndex = 1 : 1
        startingIndex = stats(threeOrLonger(blobIndex)).PixelIdxList(1);
        endingIndex = stats(threeOrLonger(blobIndex)).PixelIdxList(end);
        baselinePositionByUpwardTrendOfThree = ceil((startingIndex + endingIndex) / 2 );
      end
    else
      baselinePositionByUpwardTrendOfThree = ceil(numel(tdc) * 20 / 100);
    end
end

function baselinePositionByDeltaDifference = getBaseLineFromDeltaDiff(tdc)

    lengthOfTDC = max(size(tdc));
    if (lengthOfTDC < 3)
        baselinePositionByDeltaDifference = 0;
    end
    
    if (lengthOfTDC == 3)
        startingIndex = 1;
        endingIndex = 3;
    end
    condition = false;
    if (lengthOfTDC > 3)
        startingIndex = 1;
        endingIndex = 3;
        condition = false;
        while(true)
            if (tdc(endingIndex) - tdc(startingIndex) >= 50)
                condition = true;
                break;
            else
                startingIndex = startingIndex + 1;
                endingIndex = endingIndex + 1;
            end
            
            if (endingIndex == lengthOfTDC)
                break;
            end
        end
    end
    if (condition)
        baselinePositionByDeltaDifference = startingIndex;
    else
        baselinePositionByDeltaDifference = ceil(lengthOfTDC * 15 / 100);
    end
end
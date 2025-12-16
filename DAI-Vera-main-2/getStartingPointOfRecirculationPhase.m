function position = getStartingPointOfRecirculationPhase(tdc, baselinePosition)
    if (ndims(tdc) > 1)
        tdc = tdc';
    end
   
    lengthOfTdc = max(size(tdc));
    lengthOf30PercentOfTdc = ceil(lengthOfTdc*30/100);
    idx = lengthOfTdc - lengthOf30PercentOfTdc;
    last30PercentElements = tdc(end - lengthOf30PercentOfTdc + 1:end);
    position = findchangepts(last30PercentElements);
    position = idx + position;
    
end
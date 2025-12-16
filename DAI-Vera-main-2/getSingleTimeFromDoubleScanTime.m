function timeIndex = getSingleTimeFromDoubleScanTime(times)
    
    startingTimes = times(1:2:end-1);
    
    timeIndex = containers.Map();
    
    k = 1;
    for i = 1:numel(times)
        key = num2str(times(i));
        value = startingTimes(k);
        timeIndex(key) = value;
        if (mod(i,2) == 0)
            k = k +1;    
        end
    end

end
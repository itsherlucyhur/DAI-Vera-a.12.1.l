function times = getTimes(timePoints)
    tempTime = timePoints(1);
    
    if (tempTime ~= ceil(tempTime))
        sTimePoints = string(timePoints);
        for i = 1:max(size(sTimePoints))
            splittedTime = strsplit(sTimePoints(i),'.');
            if (size(splittedTime,2) == 1)
                sTimePoints(i) = sTimePoints(i) + '.000';
            end
            if (strlength(splittedTime(1)) < 6)
                sTimePoints(i) = '0' + sTimePoints(i);
            end
        end
        
        if (strlength(splittedTime(1)) == 14)
            times = datetime(sTimePoints, 'InputFormat', 'yyyyMMddHHmmss.SS');
        else
            times = datetime(sTimePoints, 'InputFormat', 'HHmmss.SS');
        end
    else
        times = datetime(string(timePoints), 'InputFormat', 'HHmmss');
    end
end
function [fourDimImageSet, times, timeUnit, dicomInfo] = readAndSplitImages(directory, scannerType, choice)
    try
        if (strcmp(scannerType,'Siemens'))
            [fourDimImageSet, times, dicomInfo] = readAndSplitSiemensImages(directory, scannerType);
        elseif (strcmp(scannerType,'GE'))
            [fourDimImageSet, times, dicomInfo] = readAndSplitSiemensImages(directory, scannerType);
        elseif (strcmp(scannerType,'Canon'))
            [fourDimImageSet, times, dicomInfo] = readAndSplitCanonImages(directory, choice);
        elseif (strcmp(scannerType,'WholeHeartCycle'))
            [fourDimImageSet, times, dicomInfo] = wReadAndSplitImagesFromFolderForWholeHeartCycle(directory);
        end
    catch ME
        throw (ME);
    end
    
    thresholdTimeInSecondsForMilliSecondConversion = 2;
    timeDifferenceBetweenLastAndFirstTimePoint = times(end)-times(2);
    if ( timeDifferenceBetweenLastAndFirstTimePoint < thresholdTimeInSecondsForMilliSecondConversion)
        times = times * 1000;
        timeUnit = 'ms';
    else
        timeUnit = 's';
    end
end


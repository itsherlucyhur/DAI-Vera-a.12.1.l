function [fourDimImageSet, dicomInfo, times, numberOfTimePoints, numberOfSlices] = getFourDImageSetBasedOnSliceLocation(sliceLocations, I, allInfo)

    uniqueSliceLocations = unique(sliceLocations);
    
    numberOfSlices = size(uniqueSliceLocations,2);
    numberOfTimePoints = size(sliceLocations,2) / numberOfSlices;
    fourDimImageSet = zeros(numberOfSlices,numberOfTimePoints,512,512);
    dicomInfo = cell(1, numberOfSlices * numberOfTimePoints);
    
    % In readAndSplitCanonImagesFromFolder(), we read the images in the
    % following order: For each timePoint, read all slice values, and then
    % go to next timePoint and so on.
    % Here, the order should be same.
    tolerance = 0.0001;
    ptr = 1;
    timePoint = 1;
    for i = 1 : size(sliceLocations,2)
        
        sliceValue = sliceLocations(i);
        slicePosition = find(abs(uniqueSliceLocations - (sliceValue)) < tolerance);
        % timePoint = getTimePointPosition(allInfo{ptr}.Filename, numberOfSlices);
        
        fourDimImageSet(slicePosition,timePoint,:,:) = I{ptr};
        dicomInfo{ptr} = allInfo{ptr};
        ptr = ptr + 1;
        
        if (mod(i,numberOfSlices) == 0)
            timePoint = timePoint + 1;
        end
    end
    
    startTime = now;
    durationInSeconds = 3;
    sT = datetime(startTime,'ConvertFrom','datenum');
    for t = 1 : numberOfTimePoints
        sT = sT + duration([0, 0, durationInSeconds]);
        timePoints(t) = sT;
    end
    
    times = timePoints';
end

function timePointPosition = getTimePointPosition(fileName, numberOfSlices)
    [path, name, ext] = fileparts(fileName);
    fileNumber = str2double(extract(name, digitsPattern));
    
    if (mod(fileNumber, numberOfSlices) == 0)
        timePointPosition = fileNumber/numberOfSlices;
        timePointPosition = timePointPosition + 1;
    else
        timePointPosition = ceil(fileNumber/numberOfSlices);
    end
 
    %s = sprintf('fileName = %d, timePoint = %d\n',fileNumber,timePointPosition);
    %disp(s);
end



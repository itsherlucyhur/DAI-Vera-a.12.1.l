function [fourDimImageSet, times, dicomInfo] = readAndSplitSiemensImages(directory, scannerType)
    imageLoadingStartTime = clock;
    fix(imageLoadingStartTime);
    
    warning('off','all');
    
    dicomdict('set','dicom_dict_copy.txt');
   
    dicomlist = dir(directory);
    validSize = max(size(dicomlist))-2;
    allInfo = cell(1,validSize);
    I = cell(1,validSize);
    allAcquisitionTimePoints = zeros(1,validSize);
    allContentTimePoints = zeros(1,validSize);
    allInstanceCreationTimePoints = zeros(1,validSize);
    sopInstanceUIDArray = zeros(1,validSize);
    sopInstanceUIDArray2 = zeros(1,validSize);
    sliceLocations = zeros(1,validSize);
    pos = zeros(1,validSize);
    largeUID = false;
    sliceLocationExist = false;
    
    for k = 3 : validSize + 2
        fileName = strcat(directory, filesep, dicomlist(k).name);
        dcmData = dicomread(fileName);
        try
            dcmInfo = dicominfo(strcat(fileName));
            if (strcmp(dcmInfo.Format, 'DICOM'))
                allInfo{k-2} = dcmInfo;
                info = allInfo{k-2};
                slope = info.RescaleSlope;
                intercept = info.RescaleIntercept;
                I{k-2} = dcmData * slope + intercept;
                if (isfield(info, 'SliceLocation'))
                    sliceLocations(k-2) = info.SliceLocation;
                    sliceLocationExist = true;
                else
                    % ToDo:
                    % Prompt user to provide the slice location range:
                    sliceLocations(k-2) = k-2;
                end
                if (isfield(info, 'AcquisitionTime'))
                    allAcquisitionTimePoints(k-2) = str2double(string(info.AcquisitionTime));
                else
                    allAcquisitionTimePoints(k-2) = 0;
                end
                if (isfield(info, 'ContentTime'))
                    allContentTimePoints(k-2) = str2double(string(info.ContentTime));
                else
                    allContentTimePoints(k-2) = 0;
                end
                if (isfield(info, 'InstanceCreationTime'))
                    allInstanceCreationTimePoints(k-2) = str2double(string(info.InstanceCreationTime));
                else
                    allInstanceCreationTimePoints(k-2) = 0;
                end
                x = string(info.SOPInstanceUID);
                arr = strsplit(x,'.');
                sopInstanceUIDArray(k-2) = str2double(arr(end));
                y = string(dicomlist(k).name);
                arr2 = strsplit(y,'.');
                sopInstanceUIDArray2(k-2) = str2double(arr2(1));
                pos(k-2) = k-2;
            end
        catch ME
            if strcmp(ME.identifier, 'MATLAB:imagesci:dicominfo:notDICOM')
                continue;
            end
        end
    end
    
    if (strlength(arr(end)) > 5)
        largeUID = true;
    end
    
    % Size Validated for any non-dicom file.
    countZero = k - validSize;
    allInfo = allInfo(1:end-countZero);
    I = I(1:end-countZero);
    sliceLocations = sliceLocations(1:end-countZero);
    allAcquisitionTimePoints = allAcquisitionTimePoints(1:end-countZero);
    allContentTimePoints = allContentTimePoints(1:end-countZero);
    allInstanceCreationTimePoints = allInstanceCreationTimePoints(1:end-countZero);
    sopInstanceUIDArray = sopInstanceUIDArray(1:end-countZero);
    sopInstanceUIDArray2 = sopInstanceUIDArray2(1:end-countZero);
    pos = pos(1:end-countZero);
    
    if (largeUID)
        sopInstanceUIDArray = sopInstanceUIDArray2;
    end
    
    timePoints = unique(allAcquisitionTimePoints);
    allTimePoints = allAcquisitionTimePoints;
    if (max(size(timePoints)) == 1)
        timePoints = unique(allContentTimePoints);
        allTimePoints = allContentTimePoints;
        if (max(size(timePoints)) == 1)
            timePoints = unique(allInstanceCreationTimePoints);
            allTimePoints = allInstanceCreationTimePoints;
        end
    end
   
    if (strcmp(scannerType,'Siemens') && max(size(timePoints) > 14))
        if (timePoints(2) - timePoints(1) <= 2.20 && timePoints(3) - timePoints(1) > 2.20)
            timeIndexMap = getSingleTimeFromDoubleScanTime(timePoints);

            for i = 1:max(size(allTimePoints))
                allTimePoints(i) = timeIndexMap(num2str(allTimePoints(i)));
            end

            clear timePoints;
            timePoints = unique(allTimePoints);
        end
    end
    
    data = [pos', sopInstanceUIDArray', allTimePoints'];
    
    if (sopInstanceUIDArray(1) > sopInstanceUIDArray(end))
        sortedDataBySOPInstanceUIDs = sortrows(data,3);
    else
        sortedDataBySOPInstanceUIDs = sortrows(data,[3, 2]);
    end
    
    allTimePoints = sortedDataBySOPInstanceUIDs(:,3);

    numberOfTimePoints = max(size(timePoints));
    numberOfSlices = round(size(allTimePoints,1)/numberOfTimePoints);
    fourDimImageSet = zeros(numberOfSlices,numberOfTimePoints,512,512);
    dicomInfo = cell(1,size(sortedDataBySOPInstanceUIDs,1));
    
    if (numberOfTimePoints == 1)
        if (sliceLocationExist)
            [fourDimImageSet, dicomInfo, times, numberOfTimePoints, numberOfSlices] = getFourDImageSetBasedOnSliceLocation(sliceLocations, I, allInfo);
        end
    else
        ptr = 1;
        for timePoint = 1:numberOfTimePoints
            for slice = 1:numberOfSlices
                if (ptr <= size(sortedDataBySOPInstanceUIDs,1))
                    fourDimImageSet(slice,timePoint,1:512,1:512) = I{sortedDataBySOPInstanceUIDs(ptr)};
                    dicomInfo{ptr} = allInfo{sortedDataBySOPInstanceUIDs(ptr)};
                    ptr = ptr + 1;
                end
            end
        end
        
        times = getTimes(timePoints);
    end
    
    times = getTimesInSeconds(times);
    
    if (numberOfTimePoints <= 9)
        
        % Create copy of first time point:
        tempImageSet = zeros(numberOfSlices, numberOfTimePoints + 1, 512, 512);
        tempImageSet(:,1,:,:) = fourDimImageSet(:,1,:,:);
        tempImageSet(:,2,:,:) = fourDimImageSet(:,1,:,:);
        tempImageSet(:,3:end,:,:) = fourDimImageSet(:,2:end,:,:);
        clear fourDimImageSet;
        fourDimImageSet = tempImageSet;
        clear tempImageSet;
        
        % Create copy of dicomInfo for all slices for first time point
        tempDicomInfo = cell(1, size(dicomInfo,2) + numberOfSlices);
        tempDicomInfo(1:numberOfSlices) = dicomInfo(1:numberOfSlices);
        tempDicomInfo(numberOfSlices+1:2*numberOfSlices) = dicomInfo(1:numberOfSlices);
        tempDicomInfo(2*numberOfSlices+1:end) = dicomInfo(numberOfSlices+1:end);
        clear dicomInfo;
        dicomInfo = tempDicomInfo;
        clear tempDicomInfo;
        
        dicomInfo = getNewTimePointInDuplicatedSlices(dicomInfo, numberOfSlices);
        
        % Update time points:
        tempTimes = zeros(size(times,2)+1);
        tempTimes(:,2:end) = [];
        tempTimes(2:end) = times;
        tempTimes(1)= -1 * times(2);
        tempTimes = tempTimes + times(2);
        clear times;
        times = tempTimes;
        clear tempTimes;
    end
    
    factorToCombineSlices = isSliceCombinationNeeded(info.SliceThickness);
    if (factorToCombineSlices ~= 0)
        nFourDimImageSet = zeros(ceil(numberOfSlices/factorToCombineSlices),numberOfTimePoints,512,512);
        p = 1;
        for slice = 1:factorToCombineSlices:numberOfSlices
            if (slice + factorToCombineSlices - 1) <= numberOfSlices
                s = fourDimImageSet(slice : slice + factorToCombineSlices - 1, :, :, :);
                slc = mean(s,1);
                nFourDimImageSet(p,:,:,:) = slc;
                clear s;
                clear slc;
            else
                nFourDimImageSet(p,:,:,:) = fourDimImageSet(slice,:,:,:);
            end
            p = p + 1;
        end
        
        clear fourDimImageSet;
        fourDimImageSet = nFourDimImageSet;
        clear nFourDimImageSet;
        numberOfSlices = size(fourDimImageSet,1);
        
        sliceThickness = dicomInfo{1}.SliceThickness * factorToCombineSlices;
        tempDicomInfo = getNewDicomInfoForInterpolatedSlices(dicomInfo, numberOfSlices, numberOfTimePoints, times, sliceThickness);
        
        clear dicomInfo;
        dicomInfo = tempDicomInfo;
        clear tempDicomInfo;
        
    end
    
    imageLoadingEndTime = clock;
    fix(imageLoadingEndTime);
    
    seconds = etime(imageLoadingEndTime, imageLoadingStartTime);
    minutes = floor(seconds / 60);
    seconds = round(mod(seconds,60));
    fprintf('Image Loader took %d minutes %d seconds\n',minutes, seconds);
end
    
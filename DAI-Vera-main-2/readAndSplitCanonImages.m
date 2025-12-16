function [fourDimImageSet, times, dicomInfo] = readAndSplitCanonImages(directory, choice)
    dicomdict('set','dicom_dict_copy.txt');
    try
        if (strcmp(choice, 'Enhanced'))
            [fourDimImageSet, times, dicomInfo] = readAndSplitCanonImagesFromEnhancedDicom(directory);
        else
            [fourDimImageSet, times, dicomInfo] = readAndSplitCanonImagesFromFolder(directory);
        end
    catch ME
        throw (ME);
    end
end

function [fourDimImageSet, times, dicomInfo] = readAndSplitCanonImagesFromEnhancedDicom(directory)
    dicomlist = dir(directory);
    tempData = dicomread(strcat(directory, filesep, dicomlist(3).name));
    
    numberOfTimePoints = 0;
    for i = 3:numel(dicomlist)
        filePath = fullfile(directory, dicomlist(i).name);
        if isdicom(filePath)
            numberOfTimePoints = numberOfTimePoints + 1;
        end
    end
  
    numberOfSlices = size(tempData,4);
    
    fourDimImageSet = zeros(numberOfSlices,numberOfTimePoints,512,512);
    allTimePoints = zeros(1,numberOfTimePoints);
    validSize = numberOfTimePoints*numberOfSlices;
    dicomInfo = cell(1, validSize);
    sliceLocations = zeros(1,validSize);
    sliceLocationExist = false;
    startIndex = 1;
    
    for k = 3 : numel(dicomlist)
        fileName = strcat(directory, filesep, dicomlist(k).name);
        temp = dicomread(fileName);  
        try
            dcmInfo = dicominfo(strcat(fileName), 'UseVRHeuristic', false);
            if (strcmp(dcmInfo.Format, 'DICOM'))
                perframeFunctionalGroupSequence = dcmInfo.PerFrameFunctionalGroupsSequence;
                frameAcquistionTime = perframeFunctionalGroupSequence.Item_1.FrameContentSequence.Item_1.FrameAcquisitionDatetime;
                dcmInfo.frameAcquistionTime = frameAcquistionTime;
                sharedFunctionalGroupSequence = dcmInfo.SharedFunctionalGroupsSequence;
                pixelSpacing = sharedFunctionalGroupSequence.Item_1.PixelMeasuresSequence.Item_1.PixelSpacing;
                dcmInfo.PixelSpacing = pixelSpacing;
                allTimePoints(k-2) = str2double(string(frameAcquistionTime));
                if (isfield(dcmInfo, 'SliceLocation'))
                    sliceLocations(k-2) = dcmInfo.SliceLocation;
                    sliceLocationExist = true;
                else
                    % ToDo:
                    % Prompt user to provide the slice location range:
                    sliceLocations(k-2) = k-2;
                end
                
                
                % dicomInfo{k-2} = dcmInfo;
                endIndex = startIndex + numberOfSlices - 1;
                for i = startIndex:endIndex
                    dicomInfo{i} = dcmInfo;
                end
                startIndex = startIndex + numberOfSlices;
            
                for i = 1:numberOfSlices
                    fourDimImageSet(i,k-2,:,:) = temp(:,:,1,i);
                end
            end
        catch ME
            if strcmp(ME.identifier, 'MATLAB:imagesci:dicominfo:notDICOM')
                continue;
            end
        end
    end
    
    dicomInfo = getDicomInfoFromEnhancedDicomInfo(dicomInfo, fourDimImageSet);
    
    timePoints = unique(allTimePoints);
    % unique() automatically sorts allTimePoints and put them in
    % timePoints. We now find the corresponding indices of elements in
    % timePoints before applying unique in allTimePoints. Then based on
    % this idx, we need to update the image order.
    [~,idx] = ismember(timePoints, allTimePoints);
    tempFourDimImageSet = fourDimImageSet;
    for i = 1:max(size(idx))
        fourDimImageSet(:,i,:,:) = tempFourDimImageSet(:,idx(i),:,:);
    end

    
    if (max(size(timePoints)) == 1)
        if (sliceLocationExist)
            [fourDimImageSet, dicomInfo, times, numberOfTimePoints, numberOfSlices] = getFourDImageSetBasedOnSliceLocation(sliceLocations, I, dicomInfo);
        end
    else
        times = getTimes(timePoints);
    end
    times = getTimesInSeconds(times);
    
end

function [fourDimImageSet, times, dicomInfo] = readAndSplitCanonImagesFromFolder(directory)
    dicomlist = dir(directory);
    numberOfTimePoints = numel(dicomlist) - 2;
    numberOfSlices = numel(dir(strcat(directory,filesep,dicomlist(3).name,filesep))) - 2;
    
    fourDimImageSet = zeros(numberOfSlices,numberOfTimePoints,512,512);
    allTimePoints = zeros(1,numberOfTimePoints);
    validSize = numberOfTimePoints*numberOfSlices;
    dicomInfo = cell(1, validSize);
    sliceLocations = zeros(1,validSize);
    sliceLocationExist = false;
    
    counter = 1;
    for k = 3 : numel(dicomlist)
        currentDir = strcat(directory,filesep,dicomlist(k).name,filesep);
        dList = dir(currentDir);
        for i = 3:numel(dList)
            fileName = strcat(currentDir, dList(i).name);
            temp = dicomread(fileName);  
            if (size(temp) ~= [0, 0])
                dicomInfo{counter} = dicominfo(strcat(fileName));
                info = dicomInfo{counter};
                slope = info.RescaleSlope;
                intercept = info.RescaleIntercept;
                I{counter} = temp * slope + intercept;
                fourDimImageSet(i-2,k-2,:,:) = temp * slope + intercept;
                allAcquisitionTimes(counter) = str2double(info.AcquisitionTime);
                allContentTimes(counter) = str2double(string(info.ContentTime));
                if (isfield(info, 'SliceLocation'))
                    sliceLocations(counter) = info.SliceLocation;
                    sliceLocationExist = true;
                else
                    % ToDo:
                    % Prompt user to provide the slice location range:
                    sliceLocations(counter) = k-2;
                end
            end
            counter = counter + 1;
        end
    end
    
    acquisitionTime = unique(allAcquisitionTimes);
    if (max(size(acquisitionTime)) == 1)
        allTimePoints = allContentTimes;
    else
        allTimePoints = allAcquisitionTimes;
    end
   
    [timePoints, indices] = unique(allTimePoints, 'first');
    if (~issorted(indices))
        for timepoint = 1 : numberOfTimePoints
            location = indices(timepoint);
            for slice = 1 : numberOfSlices
                fourDimImageSet(slice,timepoint,:,:) = I{location};
                location = location + 1;
            end
        end
    end
    
    if (max(size(timePoints)) == 1)
        if (sliceLocationExist)
            [fourDimImageSet, dicomInfo, times, numberOfTimePoints, numberOfSlices] = getFourDImageSetBasedOnSliceLocation(sliceLocations, I, dicomInfo);
        end
    else
        times = getTimes(timePoints);
    end
    times = getTimesInSeconds(times);
end
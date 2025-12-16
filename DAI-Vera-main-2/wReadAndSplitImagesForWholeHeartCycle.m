function [fourDimImageSet, times, dicomInfo] = wReadAndSplitImagesFromFolderForWholeHeartCycle(directory)
    dicomlist = dir(directory);
    numberOfTimePoints = numel(dicomlist) - 2;
    numberOfSlices = numel(dir(strcat(directory,filesep,dicomlist(3).name,filesep))) - 2;
    
    if (numberOfSlices > 0 && numberOfTimePoints > 0)
        fourDimImageSet = zeros(numberOfSlices,numberOfTimePoints,512,512);
        validSize = numberOfTimePoints*numberOfSlices;
        dicomInfo = cell(1, validSize);
        allSliceLocations = zeros(1,validSize);
        allAcquisitionTimes = zeros(1,validSize);
        allContentTimes = zeros(1,validSize);
    end
    sliceLocationExist = false;
    
    if (max(size(dicomlist)) <= 21)
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
                    allAcquisitionTimes(counter) = str2double(info.AcquisitionTime);
                    allContentTimes(counter) = str2double(string(info.ContentTime));
                    if (isfield(info, 'SliceLocation'))
                        allSliceLocations(counter) = info.SliceLocation;
                        sliceLocationExist = true;
                    else
                        % ToDo:
                        % Prompt user to provide the slice location range:
                        allSliceLocations(counter) = k-2;
                    end
                end
                counter = counter + 1;
            end
        end
    else
        counter = 1;
        for k = 3 : numel(dicomlist)
            fileName = strcat(directory, filesep, dicomlist(k).name);
            dcmData = dicomread(fileName);
            try
                dcmInfo = dicominfo(strcat(fileName));
                if (strcmp(dcmInfo.Format, 'DICOM'))
                    
                    dicomInfo{counter} = dcmInfo;
                    info = dicomInfo{counter};
                    
                    slope = info.RescaleSlope;
                    intercept = info.RescaleIntercept;
                    I{counter} = dcmData * slope + intercept;
                    if (isfield(info, 'SliceLocation'))
                        allSliceLocations(counter) = info.SliceLocation;
                        sliceLocationExist = true;
                    else
                        % ToDo:
                        % Prompt user to provide the slice location range:
                        allSliceLocations(counter) = k-2;
                    end
                    if (isfield(info, 'AcquisitionTime'))
                        allAcquisitionTimes(counter) = str2double(string(info.AcquisitionTime));
                    else
                        allAcquisitionTimes(counter) = 0;
                    end
                    if (isfield(info, 'ContentTime'))
                        allContentTimes(counter) = str2double(string(info.ContentTime));
                    else
                        allContentTimes(counter) = 0;
                    end
                
                end
                counter = counter + 1;
            catch ME
                if strcmp(ME.identifier, 'MATLAB:imagesci:dicominfo:notDICOM')
                    continue;
                end
            end
        end
    end

    if (sliceLocationExist)
        locations = unique(allSliceLocations);
    end

    acquisitionTime = unique(allAcquisitionTimes);
    if (max(size(acquisitionTime)) == 1)
        allTimePoints = allContentTimes;
    else
        allTimePoints = allAcquisitionTimes;
    end
    timePoints = unique(allTimePoints);

    numberOfSlices = max(size(locations));
    numberOfTimePoints = max(size(timePoints));
    fourDimImageSet = zeros(numberOfSlices,numberOfTimePoints,512,512);
    
    for i = 1 : counter - 1
        s = find(locations == allSliceLocations(i));
        t = find(timePoints == allTimePoints(i));
        fourDimImageSet(s,t,:,:) = I{i};
    end

    times = getTimes(timePoints);
    times = getTimesInSeconds(times);
end
function times = readTimeInfoOnlyFromImages(directory)
    
    imageLoadingStartTime = clock;
    fix(imageLoadingStartTime);
    
    warning('off','all');
    
    dicomdict('set','dicom_dict_copy.txt');
   
    dicomlist = dir(directory);
    validSize = numel(dicomlist)-2;
    allInfo = cell(1,validSize);
    I = cell(1,validSize);
    allTimePoints = zeros(1,validSize);
    
    sliceLocations = zeros(1,validSize);
    pos = zeros(1,validSize);
    sliceLocationExist = false;
    
    for k = 3 : numel(dicomlist)
        fileName = strcat(directory, dicomlist(k).name);
        temp = dicomread(fileName);
        if (size(temp) ~= [0, 0])
            allInfo{k-2} = dicominfo(strcat(fileName));
            info = allInfo{k-2};
            slope = info.RescaleSlope;
            intercept = info.RescaleIntercept;
            I{k-2} = temp * slope + intercept;
            if (isfield(info, 'SliceLocation'))
                sliceLocations(k-2) = info.SliceLocation;
                sliceLocationExist = true;
            else
                % ToDo:
                % Prompt user to provide the slice location range:
                sliceLocations(k-2) = k-2;
            end
            allTimePoints(k-2) = str2double(string(info.AcquisitionTime));
    
            pos(k-2) = k-2;
        end
    end
    
    
    % Size Validated for any non-dicom file.
    countZero = k - validSize;
    allInfo = allInfo(1:end-countZero);
    I = I(1:end-countZero);
    sliceLocations = sliceLocations(1:end-countZero);
    allTimePoints = allTimePoints(1:end-countZero);
    pos = pos(1:end-countZero);
    
    timePoints = unique(allTimePoints);
    numberOfTimePoints = max(size(timePoints));
    
    if (numberOfTimePoints == 1)
        if (sliceLocationExist)
            [fourDimImageSet, dicomInfo, times, numberOfTimePoints, numberOfSlices] = getFourDImageSetBasedOnSliceLocation(sliceLocations, I, allInfo);
        end
    else
        
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
            times = datetime(sTimePoints, 'InputFormat', 'HHmmss.SS');
        else
            times = datetime(string(timePoints), 'InputFormat', 'HHmmss');
        end
    end
    
    
    times = diff(times);
    times = cumsum(times);
    [~, m, s] = hms(times);
    for i = 1:size(s)
        if (m(i) >= 1)
            s(i) = m(i) * 60 + s(i);
        end
    end
    clear times;
    times = s';
    
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
    
    imageLoadingEndTime = clock;
    fix(imageLoadingEndTime);
    
    seconds = etime(imageLoadingEndTime, imageLoadingStartTime);
    minutes = floor(seconds / 60);
    seconds = round(mod(seconds,60));
    fprintf('Image Loader took %d minutes %d seconds\n',minutes, seconds);
end


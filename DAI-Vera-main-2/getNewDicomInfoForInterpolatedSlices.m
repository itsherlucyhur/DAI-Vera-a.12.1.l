function dicomInfo = getNewDicomInfoForInterpolatedSlices(dicomInfo, numberOfSlices, numberOfTimePoints, times, sliceThickness)

    tempDicomInfo = cell(1, numberOfTimePoints*numberOfSlices);
    
    info = dicomInfo(1);
    info = info{1};
    firstTimePoint = getAcquisitionTime(str2double(info.AcquisitionTime));
    sopInstanceUID = getAllSopInstanceUIDs(info.SOPInstanceUID, numberOfTimePoints*numberOfSlices);
    
    time = timeofday(firstTimePoint);
    
    for t = 1:size(times,2)
        temp = time + seconds(times(t));
        [h,m,s] = hms(temp);
        hs = string(h);
        ms = string(m);
        ss = string(s);
        
        if (strlength(hs) == 1)
            hs = strcat('0',hs);
        end
        
        if (strlength(ms) == 1)
            ms = strcat('0',ms);
        end
        
        if (strlength(ss) == 1)
            ss = strcat('0',ss);
        end
        
        newTimes(t,:) = convertStringsToChars(hs + ms + ss);
    end
    
    ptr = 1;
    for timePoint = 1:numberOfTimePoints
        for slice = 1:numberOfSlices
            tempDicomInfo(ptr) = dicomInfo(ptr);
            newSOPInstanceUID = convertStringsToChars(sopInstanceUID(ptr,:));
            tempDicomInfo{ptr}.SOPInstanceUID = newSOPInstanceUID;
            tempDicomInfo{ptr}.MediaStorageSOPInstanceUID = newSOPInstanceUID;
            tempDicomInfo{ptr}.AcquisitionTime = newTimes(timePoint,:);
            tempDicomInfo{ptr}.SliceThickness = sliceThickness;
            ptr = ptr + 1;
        end
    end
    
    clear dicomInfo;
    dicomInfo = tempDicomInfo;
    clear tempDicomInfo;
end

function acquisitionTime = getAcquisitionTime(tempTime)
    if (tempTime ~= ceil(tempTime))
        acquisitionTime = datetime(string(tempTime), 'InputFormat', 'HHmmss.SS');
    else
        acquisitionTime = datetime(string(tempTime), 'InputFormat', 'HHmmss');
    end
end

function allSOPInstanceUIDs = getAllSopInstanceUIDs(startingUID, count)
    x = string(startingUID);
    arr = strsplit(x,'.');
    startingID = str2double(arr(end));
    for i = 1:count
        arr(end) = num2str(i);
        allSOPInstanceUIDs(i,:) = strjoin(arr,'.');
    end
end
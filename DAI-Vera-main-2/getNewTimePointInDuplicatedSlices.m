function dicomInfo = getNewTimePointInDuplicatedSlices(dicomInfo, numberOfSlices)
    info = dicomInfo(1);
    info = info{1};
    firstTimePoint = getAcquisitionTime(str2double(info.AcquisitionTime));
    
    info = dicomInfo(2*numberOfSlices+1);
    info = info{1};
    secondTimePoint = getAcquisitionTime(str2double(info.AcquisitionTime));
    
    [~,~,s] = hms(secondTimePoint - firstTimePoint);
    newTimeValue = firstTimePoint - seconds(s);
    newTimeValue = string(datestr(newTimeValue,'HHMMSS'));
    
    for i = 1:numberOfSlices
        info = dicomInfo(i);
        info = info{1};
        info.AcquisitionTime = newTimeValue;
        dicomInfo(i) = {info};
    end
end

function acquisitionTime = getAcquisitionTime(tempTime)
    if (tempTime ~= ceil(tempTime))
        acquisitionTime = datetime(string(tempTime), 'InputFormat', 'HHmmss.SS');
    else
        acquisitionTime = datetime(string(tempTime), 'InputFormat', 'HHmmss');
    end
end
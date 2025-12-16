function [uniqueAcquisitionTime, uniqueContentTime] = readTimeInfoOnlyFromCTPImages(directory)
    
    imageLoadingStartTime = clock;
    fix(imageLoadingStartTime);
    
    warning('off','all');
    
    dicomdict('set','dicom_dict_copy.txt');
   
    dicomlist = dir(directory);
    validSize = max(size(dicomlist))-2;

	allTimePoints = zeros(1,validSize);
    allAcquisitionTime = zeros(1,validSize);
    allContentTime = zeros(1,validSize);
    
    for k = 3 : validSize + 2
        fileName = strcat(directory, '\', dicomlist(k).name);
        dcmData = dicomread(fileName);
        if (size(dcmData) ~= [0, 0])
            info = dicominfo(strcat(fileName));
			allTimePoints(k-2) = str2double(string(info.AcquisitionTime));
            allAcquisitionTime(k-2) = str2double(string(info.AcquisitionTime));
			allContentTime(k-2) = str2double(string(info.ContentTime));
        end
    end
    
    
    % Size Validated for any non-dicom file.
    countZero = k - validSize;
	allTimePoints = allTimePoints(1:end-countZero);
    allAcquisitionTime = allAcquisitionTime(1:end-countZero);
	allContentTime = allContentTime(1:end-countZero);														   
    
    timePoints = unique(allTimePoints);
    uniqueAcquisitionTime = unique(allAcquisitionTime);
    uniqueContentTime = unique(allContentTime);

    lengthOfEachItem = [max(size(timePoints)), max(size(uniqueAcquisitionTime)), max(size(uniqueContentTime))];
    numberOfTimePoints = max(lengthOfEachItem);
    
    if (max(size(uniqueAcquisitionTime)) ~= numberOfTimePoints)
        uniqueAcquisitionTime = zeros(1,numberOfTimePoints);
    end
    if (max(size(uniqueContentTime)) ~= numberOfTimePoints)
        uniqueContentTime = zeros(1,numberOfTimePoints);
    end
    
    imageLoadingEndTime = clock;
    fix(imageLoadingEndTime);
    
    seconds = etime(imageLoadingEndTime, imageLoadingStartTime);
    minutes = floor(seconds / 60);
    seconds = round(mod(seconds,60));
    fprintf('Image Loader took %d minutes %d seconds\n',minutes, seconds);
end


function readAndUpdateHeaderFromGEFormattedImageFiles(directory, times)
    
    imageLoadingStartTime = clock;
    fix(imageLoadingStartTime);
    
    warning('off','all');
    
    dicomdict('set','dicom_dict_copy.txt');
   
    dicomlist = dir(directory);
    dicomlist = dicomlist(~[dicomlist.isdir]);
    validSize = max(size(dicomlist));
    numOfTimePoints = max(size(times.contentTime));
    numOfSlices = validSize / numOfTimePoints;
    
    updateContentTime = false;
    updateAcquisitionTime = false;
    if (any(times.contentTime))
        updateContentTime = true;
    end
    if (any(times.acquisitionTime))
        updateAcquisitionTime = true;
    end

    for k = 1 : validSize
        fileName = strcat(directory, '\', dicomlist(k).name);
        dcmData = dicomread(fileName);
        if (size(dcmData) ~= [0, 0])
            dcmInfo = dicominfo(strcat(fileName));
			
            if (isByteSwapNeeded(dcmInfo.TransferSyntaxUID))
                dcmData = swapbytes(dcmData);
            end

            [filepath,name,ext] = fileparts(fileName);
            partsOfName = split(ext,'.');
            numberInFileName = str2double(partsOfName{2});

            % Calculate the timePoint
            timePoint = floor((numberInFileName - 1) / numOfSlices) + 1;
            % Ensure that the timePoint is within the valid range
            timePoint = max(1, min(timePoint, numOfTimePoints));
            
            newDirectory = strcat(filepath, filesep, 'ImagesWithUpdatedHeader');
            if ~isfolder(newDirectory)
                mkdir(newDirectory);
            end
            fileName = strcat(newDirectory, filesep, name, ext);

            if (updateContentTime)
                dcmInfo.ContentTime = num2str(times.contentTime(timePoint));
            end
            if (updateAcquisitionTime)
                dcmInfo.AcquisitionTime = num2str(times.acquisitionTime(timePoint));
            end
            dicomwrite(dcmData,fileName,dcmInfo,'CreateMode','Copy');
        end
    end
    
    imageLoadingEndTime = clock;
    fix(imageLoadingEndTime);
    
    seconds = etime(imageLoadingEndTime, imageLoadingStartTime);
    minutes = floor(seconds / 60);
    seconds = round(mod(seconds,60));
    fprintf('Image Loader took %d minutes %d seconds\n',minutes, seconds);
end


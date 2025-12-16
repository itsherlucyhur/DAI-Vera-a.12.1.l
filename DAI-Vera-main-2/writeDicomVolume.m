function writeDicomVolume(fourDimImageSet, dicomInfo, restOrStress)

    numberOfSlices = size(fourDimImageSet, 1);
    numberOfTimePoints = size(fourDimImageSet, 2);
    row = size(fourDimImageSet, 3);
    col = size(fourDimImageSet, 4);
    
    directory = strcat(dicomInfo{1}.PatientName.FamilyName, restOrStress);
    mkdir (directory);
    
    ptr = 1;
    for timePoint = 1:numberOfTimePoints
        for slice = 1:numberOfSlices
            fileName = strcat(directory, '/', num2str(ptr),'.dcm');
            currentImage(1:row,1:col) = int16(fourDimImageSet(slice, timePoint, :, :));
            currentImage(1:row,1:col) = (currentImage - dicomInfo{ptr}.RescaleIntercept)/dicomInfo{ptr}.RescaleSlope;
            if (isByteSwapNeeded(dicomInfo{ptr}.TransferSyntaxUID))
                currentImage = swapbytes(currentImage);
            end
            dicomwrite(currentImage, fileName, dicomInfo{ptr});
            ptr = ptr + 1;
        end
    end
end
function volumeJPEG = getJPEGVolumeFromDicomVolume(dicomVolume, noOfChannel)
    
    logDAI('Inside getJPEGVolumeFromDicomVolume');
    logDAI('Calculating Size of row, column and number of slices');
    row = size(dicomVolume,1);
    column = size(dicomVolume,2);
    totalSlice = size(dicomVolume,3);
    
    logDAI('Checking number of channels');
    if (noOfChannel == 3)
        
        logDAI('Number of Channel = 3');
        logDAI('Creating Empty Volume');
        volumeJPEG = uint8(zeros(row, column, totalSlice, 3));
        logDAI('Generating images for the empty volume');
        for i = 1:totalSlice
            tempJPEG = uint8(255 * mat2gray(dicomVolume(:,:,i)));
            RGBtempJPEG = cat(3, tempJPEG, tempJPEG, tempJPEG);
            volumeJPEG(:,:,i,:) = RGBtempJPEG;
        end
        logDAI('Images for volume are populated successfully');
    elseif (noOfChannel == 1)
        
        logDAI('Number of Channel = 1');
        logDAI('Creating Empty Volume');
        volumeJPEG = uint8(zeros(row, column, totalSlice));
        logDAI('Generating images for the empty volume');
        for i = 1:totalSlice
            volumeJPEG(:,:,i) = uint8(255 * mat2gray(dicomVolume(:,:,i)));
        end
        logDAI('Images for volume are populated successfully');
    end
    
end
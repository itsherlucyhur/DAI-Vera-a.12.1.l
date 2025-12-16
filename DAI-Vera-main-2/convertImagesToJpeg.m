function [newDirectory] = convertImagesToJpeg(directory, threeDVolume, labelName)
    
    logDAI('Inside convertImagesToJpeg()');
    logDAI('Calling getJPEGVolumeFromDicomVolume with number of channels = 1');
    jpegVolume = getJPEGVolumeFromDicomVolume(threeDVolume, 1);
    logDAI('JPEG volume successfully created.');
    logDAI('JEPGData Directory is located at:');
    newDirectory = strcat(directory, labelName, '\');
    logDAI(newDirectory);
    logDAI('Creating JPEGData directory');
    mkdir (newDirectory);
    logDAI('Creating JPEGData directory is successful');
    logDAI('Writing JPEG Images');
    n = size(jpegVolume, 3);
    for i = 1:n
        labelFileName = strcat(newDirectory, num2str(i), '.jpg');
        imwrite(jpegVolume(:,:,i), labelFileName);
    end
end

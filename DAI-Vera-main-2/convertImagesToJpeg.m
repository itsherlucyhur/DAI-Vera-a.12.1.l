function [newDirectory] = convertImagesToJpeg(baseDir, dicomFolder, labelName)
    
    logDAI('Inside convertImagesToJpeg()');
    logDAI('Calling getJPEGVolumeFromDicomVolume with number of channels = 1');

    % Read DICOM files from folder safely
    jpegVolume = getJPEGVolumeFromDicomVolume(dicomFolder, 1);
    logDAI('JPEG volume successfully created.');

    % Create output directory (macOS + Windows safe)
    newDirectory = fullfile(baseDir, labelName);
    logDAI('JPEGData Directory is located at:');
    logDAI(newDirectory);

    if ~exist(newDirectory, 'dir')
        mkdir(newDirectory);
        logDAI('JPEGData directory created successfully.');
    else
        logDAI('JPEGData directory already exists.');
    end

    % Write JPEG images
    logDAI('Writing JPEG Images...');
    n = size(jpegVolume, 3);
    for i = 1:n
        labelFileName = fullfile(newDirectory, sprintf('%03d.jpg', i));
        imwrite(jpegVolume(:,:,i), labelFileName);
    end
    logDAI('All JPEG Images written successfully.');
end

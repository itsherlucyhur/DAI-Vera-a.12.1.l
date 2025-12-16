function exportFFRCurve(sliceLocations, dicomSliceLocation, ffrValues, preLesionSlice, velocities, patientName)

    allDataForCSVWrite = 'SliceNumber,SliceLocation,FFR,FlowVelocities\n';
    length = max(size(sliceLocations));
        stringForAllData = sprintf('%d,%s,%s,%.4f\n', preLesionSlice, '', '', velocities(1));
        allDataForCSVWrite = append(allDataForCSVWrite, newline, stringForAllData);
    for i = 1:length
        stringForAllData = sprintf('%d,%.4f,%.4f,%.4f\n', sliceLocations(i), dicomSliceLocation(i), ffrValues(i), velocities(i+1));
        allDataForCSVWrite = append(allDataForCSVWrite, newline, stringForAllData);
    end
    
    [fileName, directoryName] = generateFileName(patientName);
    fileName = convertCharsToStrings(fileName) + '_FFRCurve';
    txtFileName = strcat(fileName, '.txt');
    csvFileName = strcat(fileName, '.csv');
    xlsxFileName = strcat(fileName, '.xlsx');
    
    [status, attributes] = fileattrib(directoryName);
    if (attributes.UserWrite)
        fileID = fopen(txtFileName,'wt');
        fprintf(fileID,allDataForCSVWrite);
        fclose(fileID);
    else
        error_msg = 'You do not have permission to write in this directory. Please choose a directory where you have write permission.';
        errordlg(error_msg, 'Error');
        error(error_msg);
    end

    txt2csv(txtFileName, csvFileName, xlsxFileName);

    delete(txtFileName);
end
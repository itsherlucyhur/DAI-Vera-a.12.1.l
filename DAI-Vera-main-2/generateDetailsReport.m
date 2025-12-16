function generateDetailsReport(app)
    if (~isempty(app.dicomInfo))
        [fileName, directoryName] = generateFileName(app.dicomInfo.PatientName.FamilyName);
    elseif (~isempty(app.dicomInfoRest))
        [fileName, directoryName] = generateFileName(app.dicomInfoRest.PatientName.FamilyName);
    elseif (~isempty(app.dicomInfoStressOnly))
        [fileName, directoryName] = generateFileName(app.dicomInfoStressOnly.PatientName.FamilyName);
    else
        fileName = 'DiagnosticReport';
        directoryName = pwd;  % Use current directory if no DICOM info is available
            
    end
    txtFileName = strcat(fileName, '.txt');
    csvFileName = strcat(fileName, '.csv');
    xlsxFileName = strcat(fileName, '.xlsx');
    
    [status, attributes] = fileattrib(directoryName);
    if (attributes.UserWrite)
        fileID = fopen(txtFileName,'wt');
        fprintf(fileID,app.allResultsForCSVWrite);
        fclose(fileID);
    else
        error_msg = 'You do not have permission to write in this directory. Please choose a directory where you have write permission.';
        errordlg(error_msg, 'Error');
        error(error_msg);
    end
    txt2csv(txtFileName, csvFileName, xlsxFileName);
end
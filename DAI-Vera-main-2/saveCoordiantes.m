function saveCoordiantes(app)

    if (~isempty(app.dicomInfo))
        [fileName, directoryName] = generateFileName(app.dicomInfo.PatientName.FamilyName);
    elseif (~isempty(app.dicomInfoRest))
        [fileName, directoryName] = generateFileName(app.dicomInfoRest.PatientName.FamilyName);
    elseif (~isempty(app.dicomInfoStressOnly))
        [fileName, directoryName] = generateFileName(app.dicomInfoStressOnly.PatientName.FamilyName);
    end

    fileName = strcat(fileName, '_CoordinatesOnly');
    txtFileName = strcat(fileName, '.txt');
    csvFileName = strcat(fileName, '.csv');
    xlsxFileName = strcat(fileName, '.xlsx');
    
    [status, attributes] = fileattrib(directoryName);
    if (attributes.UserWrite)
        fileID = fopen(txtFileName,'wt');

        if (~isempty(app.dicomInfo))
            fprintf(fileID,app.coOrdinatesForCSVWrite);
        end

        if (~isempty(app.dicomInfoRest))
            fprintf(fileID,app.coOrdinatesForCSVWriteRest);
        end

        if (~isempty(app.dicomInfoStressOnly))
            fprintf(fileID,app.coOrdinatesForCSVWriteStressOnly);
        end

        fclose(fileID);
    else
        error_msg = 'You do not have permission to write in this directory. Please choose a directory where you have write permission.';
        errordlg(error_msg, 'Error');
        error(error_msg);
    end
    
    txt2csv(txtFileName, csvFileName, xlsxFileName);

end
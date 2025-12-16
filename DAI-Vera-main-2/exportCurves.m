function exportCurves(preLesionCurve, postLesionCurve, preLesionFittedCurve, postLesionFittedCurve, time, fittedTime, aucPreLesionFitted, aucPostLesionFitted, patientName, stressOrRest)

    sampledCurveLength = max(size(preLesionCurve));
    fittedCurveLength = max(size(preLesionFittedCurve));
    
    if (fittedCurveLength ~= sampledCurveLength)
        allDataForCSVWrite = 'TimePoints,PreLesionCurve,PostLesionCurve,FittedTimePoints,PreLesionFittedCurve,PostLesionFittedCurve\n';
        for i = 1:fittedCurveLength
            if (i > sampledCurveLength)
                stringForAllData = sprintf('%c,%c,%c,%.4f,%.4f,%.4f\n', '', '', '', fittedTime(i), preLesionFittedCurve(i), postLesionFittedCurve(i));
                allDataForCSVWrite = append(allDataForCSVWrite, newline, stringForAllData);
            else
                stringForAllData = sprintf('%.4f,%.4f,%.4f,%.4f,%.4f,%.4f\n', time(i), preLesionCurve(i), postLesionCurve(i), fittedTime(i), preLesionFittedCurve(i), postLesionFittedCurve(i));
                allDataForCSVWrite = append(allDataForCSVWrite, newline, stringForAllData);
            end
        end
    else
        allDataForCSVWrite = 'TimePoints,PreLesionCurve,PostLesionCurve\n';
        for i = 1:sampledCurveLength
            stringForAllData = sprintf('%.4f,%.4f,%.4f\n', time(i), preLesionCurve(i), postLesionCurve(i));
            allDataForCSVWrite = append(allDataForCSVWrite, newline, stringForAllData);
        end 
    end
    
    % stringForAllData = sprintf('%1s,%1s,%.4f,%1s,%.4f\n', '', '', aucPreLesionFitted, '', aucPostLesionFitted);
    allDataForCSVWrite = append(allDataForCSVWrite, newline, stringForAllData);
    
    [fileName, directoryName] = generateFileName(patientName);
    fileName = convertCharsToStrings(fileName) + '_exportedCurves_' + stressOrRest;
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
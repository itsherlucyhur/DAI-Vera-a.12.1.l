function pts = readPreviousDataPointsFromFile(app, fileName, type)

    switch type
        case 'RCA'
            points = app.ptsRCA;
        case 'LAD'
            points = app.ptsLAD;
        case 'LCx'
            points = app.ptsLCx;
        case 'Apex'
            points = app.ptsApex;
    end
    
    [status, attributes] = fileattrib(app.labelImageDirectory);
    if (attributes.UserWrite)
        fName = strcat(app.labelImageDirectory, fileName);
        if ~exist(fName, 'file')
            fileID = fopen(fName,'w');
            pts = points;
        else
            fileID = fopen(fName,'r');
            vector = fscanf(fileID, '%d');
            fclose(fileID);

            fileID = fopen(fName,'a');
            pts = [vector', points];
        end
        fprintf(fileID, '%d\n', points);
        fclose(fileID);
    else
        error_msg = 'You do not have permission to write in this directory. Please choose a directory where you have write permission.';
        errordlg(error_msg, 'Error');
        error(error_msg);
    end
end
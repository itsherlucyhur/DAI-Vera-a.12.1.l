function txt2csv(txtFileName, csvFileName, xlsxFileName)
    
    headerCellArray = getHeaderAsCellArrayOfString(txtFileName);
    
    opts = detectImportOptions(txtFileName);
    opts = setvartype(opts,'string');
    logDAI('Reading text file');
    txtData = readtable(txtFileName, opts);
    txtData.Properties.VariableNames = headerCellArray;
    logDAI('Writing text file as csv');
    writetable(txtData, csvFileName);
    
    % Convert csv to xlsx
    logDAI('Converting csv to xlsx');
    csvData = readtable(csvFileName);
    csvData.Properties.VariableNames = headerCellArray;
    writetable(csvData,xlsxFileName);
    logDAI('Converting csv to xlsx completed');
    
    % Delete text and csv file
    logDAI('Deleting intermediate text and csv files');
    delete(txtFileName);
    delete(csvFileName);
end

function headerCellArray = getHeaderAsCellArrayOfString(filename)

    fileID = fopen(filename, 'r');
    headerLine = fgetl(fileID);
    fclose(fileID);

    delimiter = ',';
    headerCellArray = strsplit(headerLine, delimiter);
end
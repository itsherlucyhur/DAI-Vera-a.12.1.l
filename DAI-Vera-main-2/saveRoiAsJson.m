function saveRoiAsJson(ROI)
    fileName = generateFileName('ROI Objects');
    jsonFileName = strcat(fileName, '.json');
    jstring = jsonencode(ROI);
    fid = fopen(jsonFileName, 'w');
    
    if fid == -1
        error('Cannot open file for writing: %s', jsonFileName);
    end
    
    try
        fprintf(fid, '%s', jstring);
        fclose(fid);
        fprintf('ROI saved successfully to: %s\n', jsonFileName);
    catch ME
        fclose(fid);
        error('Error writing to file: %s', ME.message);
    end
end

% If a user provided location and fileName is wished to be generated, 
% the following can be used. But in this case, the saving roi object
% should not be so frequent.

%filter = {'*.json'};
%[fileName, path] = uiputfile(filter);
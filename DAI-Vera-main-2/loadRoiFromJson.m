function roiObject = loadRoiFromJson(path, fileName)
    
    jsonFileName = fullfile(path, fileName);
    fid = fopen(jsonFileName, 'r');
    
    if fid == -1
        error('Cannot open file for reading: %s', jsonFileName);
    end
    
    try
        jsonStr = fread(fid, [1, inf], 'char=>char');
        fclose(fid);
        roiObject = jsondecode(jsonStr);
        fprintf('ROI loaded successfully from: %s\n', jsonFileName);
    catch ME
        fclose(fid);
        error('Error reading from file: %s', ME.message);
    end
end
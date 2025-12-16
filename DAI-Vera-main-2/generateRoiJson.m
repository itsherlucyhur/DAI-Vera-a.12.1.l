function generateRoiJson(prePoint, postPoint, varargin)
    % GENERATEROIJSON Generate ROI JSON file with pre and post points
    %
    % Syntax:
    %   generateRoiJson(prePoint, postPoint)
    %   generateRoiJson(prePoint, postPoint, filename)
    %   generateRoiJson(prePoint, postPoint, filename, outputDir)
    %
    % Inputs:
    %   prePoint  - [x, y] coordinates for pre ROI object (default z=1, t=0)
    %             - [x, y, z] coordinates for pre ROI object (default t=0)
    %             - [x, y, z, t] coordinates for pre ROI object
    %   postPoint - [x, y] coordinates for post ROI object (default z=1, t=0)
    %             - [x, y, z] coordinates for post ROI object (default t=0)
    %             - [x, y, z, t] coordinates for post ROI object
    %   filename  - (optional) Output filename (default: 'roi_YYYYMMDD_HHMMSS.json')
    %   outputDir - (optional) Output directory (default: 'C:\tmp')
    %
    % Example:
    %   generateRoiJson([10, 20], [183, 307])
    %   generateRoiJson([10, 20, 1, 0], [183, 307, 1, 0], 'my_roi.json')
    %   generateRoiJson([10, 20], [183, 307], 'roi.json', 'C:\output')
    
    % Parse input arguments
    p = inputParser;
    addRequired(p, 'prePoint', @(x) isnumeric(x) && length(x) >= 2 && length(x) <= 4);
    addRequired(p, 'postPoint', @(x) isnumeric(x) && length(x) >= 2 && length(x) <= 4);
    addOptional(p, 'filename', '', @ischar);
    addOptional(p, 'outputDir', 'C:\tmp', @ischar);
    
    parse(p, prePoint, postPoint, varargin{:});
    
    % Extract coordinates with defaults
    preX = prePoint(1);
    preY = prePoint(2);
    preZ = 1;
    preT = 0;
    
    if length(prePoint) >= 3
        preZ = prePoint(3);
    end
    if length(prePoint) >= 4
        preT = prePoint(4);
    end
    
    postX = postPoint(1);
    postY = postPoint(2);
    postZ = 1;
    postT = 0;
    
    if length(postPoint) >= 3
        postZ = postPoint(3);
    end
    if length(postPoint) >= 4
        postT = postPoint(4);
    end
    
    % Generate filename if not provided
    if isempty(p.Results.filename)
        timestamp = datestr(now, 'yyyymmdd_HHMMSS');
        filename = sprintf('roi_%s.json', timestamp);
    else
        filename = p.Results.filename;
    end
    
    % Ensure output directory exists
    outputDir = p.Results.outputDir;
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
        fprintf('Created directory: %s\n', outputDir);
    end
    
    % Create ROI structure
    roiData = struct();
    
    % Pre ROI Object
    roiData.preRoiObject = struct();
    roiData.preRoiObject.curveData = struct();
    roiData.preRoiObject.curveData.x = preX;
    roiData.preRoiObject.curveData.y = preY;
    roiData.preRoiObject.curveData.z = preZ;
    roiData.preRoiObject.curveData.t = preT;
    roiData.preRoiObject.curveData.curve = [0, 0];
    roiData.preRoiObject.curveData.timePoints = [0, 1];
    roiData.preRoiObject.curveData.FittedCurve = [0, 0];
    roiData.preRoiObject.curveData.FittedTimePoints = [0, 1];
    roiData.preRoiObject.curveData.FittedCurveAUC = 0;
    roiData.preRoiObject.curveData.roiPoints = struct();
    roiData.preRoiObject.curveData.roiPoints.x = [];
    roiData.preRoiObject.curveData.roiPoints.y = [];
    roiData.preRoiObject.ExtraPointsForDistanceBreaker = [];
    roiData.preRoiObject.NumberOfStenosis = 0;
    
    % Post ROI Object
    roiData.postRoiObject = struct();
    roiData.postRoiObject.curveData = struct();
    roiData.postRoiObject.curveData.x = postX;
    roiData.postRoiObject.curveData.y = postY;
    roiData.postRoiObject.curveData.z = postZ;
    roiData.postRoiObject.curveData.t = postT;
    roiData.postRoiObject.curveData.curve = [0, 0];
    roiData.postRoiObject.curveData.timePoints = [0, 1];
    roiData.postRoiObject.curveData.FittedCurve = [0, 0];
    roiData.postRoiObject.curveData.FittedTimePoints = [0, 1];
    roiData.postRoiObject.curveData.FittedCurveAUC = 0;
    roiData.postRoiObject.curveData.roiPoints = struct();
    roiData.postRoiObject.curveData.roiPoints.x = [];
    roiData.postRoiObject.curveData.roiPoints.y = [];
    roiData.postRoiObject.ExtraPointsForDistanceBreaker = [];
    roiData.postRoiObject.NumberOfStenosis = 0;
    
    % Convert to JSON and write to file
    jsonStr = jsonencode(roiData, 'PrettyPrint', true);
    
    % Full output path
    outputPath = fullfile(outputDir, filename);
    
    % Write JSON to file
    try
        fid = fopen(outputPath, 'w', 'n', 'UTF-8');
        if fid == -1
            error('Cannot open file for writing: %s', outputPath);
        end
        
        fprintf(fid, '%s', jsonStr);
        fclose(fid);
        
        fprintf('ROI JSON file created successfully:\n');
        fprintf('  File: %s\n', outputPath);
        fprintf('  Pre point: [%.1f, %.1f, %.1f, %.1f]\n', preX, preY, preZ, preT);
        fprintf('  Post point: [%.1f, %.1f, %.1f, %.1f]\n', postX, postY, postZ, postT);
        
    catch ME
        error('Error writing JSON file: %s', ME.message);
    end
end

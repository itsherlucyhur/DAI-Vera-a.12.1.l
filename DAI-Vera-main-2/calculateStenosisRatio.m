function ratios = calculateStenosisRatio(folderPath)
% CALCULATESTENOSISRATIO 
%   Calculate ratios of StenosisLine_k.mrk.json to avg(L files) with pattern:
%     StenosisLine_1 -> (L, L_1)
%     StenosisLine_2 -> (L_3, L_4)
%     StenosisLine_3 -> (L_6, L_7)
%     StenosisLine_4 -> (L_9, L_10), ...
%
% INPUT:
%   folderPath - Path to folder containing JSON files
%
% OUTPUT:
%   ratios - Array of doubles with ratios for each stenosis index

    if nargin < 1
        error('calculateStenosisRatio:MissingInput', 'Folder path is required');
    end
    if ~exist(folderPath, 'dir')
        error('calculateStenosisRatio:InvalidPath', ...
              'Specified folder does not exist: %s', folderPath);
    end

    % Get list of StenosisLine files
    stenosisFiles = dir(fullfile(folderPath, 'StenosisLine_*.mrk.json'));
    if isempty(stenosisFiles)
        error('calculateStenosisRatio:NoFilesFound', ...
              'No StenosisLine_*.mrk.json files found in: %s', folderPath);
    end

    % Extract numeric indices and sort
    fileNames = {stenosisFiles.name};
    stenosisIdx = cellfun(@(f) sscanf(f, 'StenosisLine_%d.mrk.json'), fileNames);
    [stenosisIdx, sortIdx] = sort(stenosisIdx);
    fileNames = fileNames(sortIdx);

    ratios = [];

    for k = 1:numel(stenosisIdx)
        stenosisNum = stenosisIdx(k);
        stenosisFile = fullfile(folderPath, sprintf('StenosisLine_%d.mrk.json', stenosisNum));

        % Special case: first stenosis
        if stenosisNum == 1
            lFile1 = fullfile(folderPath, 'L.mrk.json');
            lFile2 = fullfile(folderPath, 'L_1.mrk.json');
        else
            % General case: (L_{3k-3}, L_{3k-2})
            lStart = 3*stenosisNum - 3;
            lFile1 = fullfile(folderPath, sprintf('L_%d.mrk.json', lStart));
            lFile2 = fullfile(folderPath, sprintf('L_%d.mrk.json', lStart+1));
        end

        % Check existence
        if ~exist(lFile1, 'file') || ~exist(lFile2, 'file')
            warning('Missing L files for StenosisLine_%d, skipping...', stenosisNum);
            continue;
        end

        try
            % Load stenosis
            stenosisData = jsondecode(fileread(stenosisFile));
            stenosisValue = extractMeasurementValue(stenosisData, sprintf('StenosisLine_%d.mrk.json', stenosisNum));

            % Load L values
            lData1 = jsondecode(fileread(lFile1));
            lValue1 = extractMeasurementValue(lData1, getFileName(lFile1));

            lData2 = jsondecode(fileread(lFile2));
            lValue2 = extractMeasurementValue(lData2, getFileName(lFile2));

            % Average
            avgL = (lValue1 + lValue2) / 2;

            if avgL == 0
                warning('Average denominator is zero for StenosisLine_%d, skipping...', stenosisNum);
                continue;
            end

            % Ratio
            ratio = stenosisValue / avgL;
            ratios(end+1) = ratio;

            fprintf('Stenosis_%d: Stenosis=%.6f, %s=%.6f, %s=%.6f, Avg=%.6f, Ratio=%.6f\n', ...
                    stenosisNum, stenosisValue, getFileName(lFile1), lValue1, getFileName(lFile2), lValue2, avgL, ratio);

        catch ME
            warning('Error processing StenosisLine_%d: %s', stenosisNum, ME.message);
        end
    end
end

function name = getFileName(pathStr)
    [~, name, ext] = fileparts(pathStr);
    name = strcat(name, ext);
end

function value = extractMeasurementValue(data, filename)
% EXTRACTMEASUREMENTVALUE Extract the measurement value from parsed JSON data
%
% INPUTS:
%   data - Struct containing parsed JSON data
%   filename - String containing the filename (for error reporting)
%
% OUTPUTS:
%   value - Double containing the measurement value

    try
        % Navigate to markups array
        if ~isfield(data, 'markups') || isempty(data.markups)
            error('calculateStenosisRatio:InvalidStructure', 'No markups found in %s', filename);
        end
        
        % Get first markup (assuming single markup per file)
        markup = data.markups(1);
        
        % Check for measurements field
        if ~isfield(markup, 'measurements') || isempty(markup.measurements)
            error('calculateStenosisRatio:InvalidStructure', 'No measurements found in %s', filename);
        end
        
        % Get first measurement (assuming single measurement per markup)
        measurement = markup.measurements(1);
        
        % Extract value
        if ~isfield(measurement, 'value')
            error('calculateStenosisRatio:InvalidStructure', 'No value field found in measurements of %s', filename);
        end
        
        value = measurement.value;
        
        % Validate that value is numeric
        if ~isnumeric(value) || ~isscalar(value)
            error('calculateStenosisRatio:InvalidValue', 'Measurement value is not a valid numeric scalar in %s', filename);
        end
        
    catch ME
        if contains(ME.identifier, 'calculateStenosisRatio:')
            rethrow(ME);
        else
            error('calculateStenosisRatio:ExtractionError', 'Error extracting measurement from %s: %s', filename, ME.message);
        end
    end
end

function [fileName, directoryName] = generateFileName(patientName)
    directoryName = fullfile(pwd, patientName);
    
    % Create directory if it doesn't exist
    if ~exist(directoryName, 'dir')
        mkdir(patientName);
    end
    
    % Use fullfile for proper path separator handling
    fileName = fullfile(patientName, datestr(now,'yyyymmddTHHMMSSFFF'));
end
function logDAI(logMessage)
    % Get the current time and date
    currentTime = datestr(datetime('now'));
    currentDate = datestr(now, 'yyyy-mm-dd');
    
    % Check if user have write permission in the current directory
    directoryName = pwd;
    [status, attributes] = fileattrib(directoryName);
    if (attributes.UserWrite)
        logsDir = fullfile(directoryName, 'Logs');
        fileName = sprintf('Log%s.txt', currentDate);
        filePath = fullfile(logsDir, fileName);
        if ~exist(logsDir, 'dir')
            mkdir(logsDir);
        end
        % Create a log file named 'log.txt' if it does not exist
        if ~exist(filePath, 'file')
            fileID = fopen(filePath,'w');
        else
            fileID = fopen(filePath,'a');
        end
        % Write the log message to the file with the current time and date
        fprintf(fileID, '[%s] %s\n', currentTime, logMessage);
        fclose(fileID);
    else
        error_msg = 'You do not have permission to write in this directory. Please choose a directory where you have write permission.';
        errordlg(error_msg, 'Error');
        error(error_msg);
    end
end

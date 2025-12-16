function removeOlderLogFiles()

    % Get the current date and time
    currentDate = datetime('now');

    % Define the directory path
    logsDir = fullfile(pwd, 'Logs');

    % Get a list of all files in the Logs directory
    fileList = dir(fullfile(logsDir, '*.txt'));

    % Loop through each file in the directory
    for i = 1:numel(fileList)
        % Get the file creation date
        fileDate = datetime(fileList(i).date);

        % Calculate the difference in days
        daysDifference = days(currentDate - fileDate);

        % Check if the file is older than 14 days (2 weeks)
        if daysDifference > 14
            % Delete the file
            delete(fullfile(logsDir, fileList(i).name));
        end
    end

end
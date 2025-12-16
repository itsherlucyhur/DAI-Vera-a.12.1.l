function isLocked = checkLock(lockFile)
    % CHECKLOCK Check if the lock file exists
    % 
    % Usage: isLocked = checkLock('dai_lock.txt')
    %
    % This function checks if a lock file exists and returns true if it does.
    % Can be used to check the status of DAI processing.
    
    if nargin < 1
        lockFile = 'dai_lock.txt';
    end
    
    isLocked = exist(lockFile, 'file') == 2;
    
    if isLocked
        fprintf('DAI is currently locked (file exists): %s\n', lockFile);
    else
        fprintf('DAI is not locked (file does not exist): %s\n', lockFile);
    end
end

function releaseLock(lockFile)
    % RELEASELOCK Delete the lock file to indicate DAI has finished
    % 
    % Usage: releaseLock('dai_lock.txt')
    %
    % This function deletes the lock file created by acquireLock,
    % signaling that DAI processing is complete and other processes
    % can proceed.
    
    if nargin < 1
        lockFile = 'dai_lock.txt';
    end
    
    try
        if exist(lockFile, 'file')
            delete(lockFile);
            fprintf('Lock released: %s\n', lockFile);
        else
            fprintf('Lock file does not exist: %s\n', lockFile);
        end
        
    catch ME
        fprintf('Error releasing lock: %s\n', ME.message);
        rethrow(ME);
    end
end

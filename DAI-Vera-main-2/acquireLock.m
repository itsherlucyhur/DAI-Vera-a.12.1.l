function acquireLock(lockFile)
    % ACQUIRELOCK Create a lock file to indicate DAI is running
    % 
    % Usage: acquireLock('dai_lock.txt')
    %
    % This function creates a lock file that other processes can monitor
    % to determine if DAI is currently running.
    
    if nargin < 1
        lockFile = 'dai_lock.txt';
    end
    
    try
        % Create lock file with timestamp and process info
        fid = fopen(lockFile, 'w');
        if fid == -1
            error('Could not create lock file: %s', lockFile);
        end
        
        % Write lock information
        fprintf(fid, 'DAI Lock File\n');
        fprintf(fid, 'Created: %s\n', datestr(now));
        fprintf(fid, 'MATLAB PID: %d\n', feature('getpid'));
        fprintf(fid, 'Computer: %s\n', getenv('COMPUTERNAME'));
        fprintf(fid, 'User: %s\n', getenv('USERNAME'));
        
        fclose(fid);
        
        fprintf('Lock acquired: %s\n', lockFile);
        
    catch ME
        fprintf('Error acquiring lock: %s\n', ME.message);
        rethrow(ME);
    end
end

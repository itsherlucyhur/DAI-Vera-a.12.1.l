function waitForExternalProgramCompletion(lockFile, timeoutSeconds)
    % WAITFOREXTERNALPROGRAMCOMPLETION Wait for external program to complete execution
    % 
    % Usage: waitForExternalProgramCompletion('dai_slicer_lock.txt', 300)
    %
    % This function waits for an external program to complete by monitoring
    % the disappearance of the lock file. It's useful when you need to ensure
    % an external program has finished before continuing.
    
    if nargin < 2
        timeoutSeconds = 300; % Default 5 minutes
    end
    
    if nargin < 1
        error('Lock file path is required');
    end
    
    startTime = tic;
    
    try
        fprintf('Waiting for external program to complete...\n');
        fprintf('Monitoring lock file: %s\n', lockFile);
        fprintf('Timeout: %d seconds\n', timeoutSeconds);
        
        while exist(lockFile, 'file')
            % Check if we've exceeded the timeout
            if toc(startTime) > timeoutSeconds
                warning('Timeout waiting for external program completion after %d seconds', timeoutSeconds);
                break;
            end
            
            % Wait 1 second before checking again
            pause(1);
            
            % Show progress every 30 seconds
            if mod(floor(toc(startTime)), 30) == 0
                fprintf('Still waiting... (%d seconds elapsed)\n', floor(toc(startTime)));
            end
        end
        
        if ~exist(lockFile, 'file')
            fprintf('External program completed successfully.\n');
        else
            fprintf('External program may still be running (timeout reached).\n');
        end
        
    catch ME
        fprintf('Error waiting for external program: %s\n', ME.message);
        rethrow(ME);
    end
end

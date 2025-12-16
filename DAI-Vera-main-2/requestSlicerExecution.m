function requestSlicerExecution(lockFile)
    % REQUESTSLICEREXECUTION Request Slicer execution from parent PowerShell process
    % 
    % Usage: requestSlicerExecution('dai_slicer_lock.txt')
    %
    % This function creates a lock file to signal the parent PowerShell process
    % that Slicer should be executed. The PowerShell process monitors this file
    % and launches Slicer when the lock is detected.
    
    if nargin < 1
        lockFile = 'dai_slicer_lock.txt';
    end
    
    try
        % Create empty lock file to signal Slicer execution request
        fid = fopen(lockFile, 'w');
        if fid == -1
            error('Could not create Slicer lock file: %s', lockFile);
        end
        
        % Write minimal content to indicate request
        fprintf(fid, 'SLICER_EXECUTION_REQUEST\n');
        fprintf(fid, 'Created: %s\n', datestr(now));
        fprintf(fid, 'MATLAB PID: %d\n', feature('getpid'));
        
        fclose(fid);
        
        fprintf('Slicer execution requested: %s\n', lockFile);
        
    catch ME
        fprintf('Error requesting Slicer execution: %s\n', ME.message);
        rethrow(ME);
    end
end

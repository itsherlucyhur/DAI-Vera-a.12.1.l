function requestInVesaliusExecution(lockFile, pre, post, top, bottom, folderPath)
    % REQUESTINVESALIUSEXECUTION Request InVesalius execution from parent PowerShell process
    % 
    % Usage: requestInVesaliusExecution('dai_invesalius_lock.txt', pre, post, top, bottom, folderPath)
    %
    % This function creates a lock file containing InVesalius arguments to signal
    % the parent PowerShell process that InVesalius should be executed with the
    % provided parameters.
    
    if nargin < 6
        error('All arguments required: lockFile, pre, post, top, bottom, folderPath');
    end
    
    try
        % Create lock file with InVesalius arguments
        fid = fopen(lockFile, 'w');
        if fid == -1
            error('Could not create InVesalius lock file: %s', lockFile);
        end
        
        % Write each argument on a separate line
        fprintf(fid, '%s\n', pre);
        fprintf(fid, '%s\n', post);
        fprintf(fid, '%s\n', top);
        fprintf(fid, '%s\n', bottom);
        fprintf(fid, '%s\n', folderPath);
        
        fclose(fid);
        
        fprintf('InVesalius execution requested: %s\n', lockFile);
        fprintf('Arguments:\n');
        fprintf('  Pre: %s\n', pre);
        fprintf('  Post: %s\n', post);
        fprintf('  Top: %s\n', top);
        fprintf('  Bottom: %s\n', bottom);
        fprintf('  Folder: %s\n', folderPath);
        
    catch ME
        fprintf('Error requesting InVesalius execution: %s\n', ME.message);
        rethrow(ME);
    end
end

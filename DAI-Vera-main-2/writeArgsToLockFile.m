function writeArgsToLockFile(lockFile, pre, post, top, bottom, folderPath)
    % WRITEARGSTOLOCK Write InVesalius arguments to lock file
    % 
    % Usage: writeArgsToLockFile('dai_lock.txt', pre, post, top, bottom, folderPath)
    %
    % This function writes the InVesalius arguments to the lock file in a format
    % that the PowerShell script can read and parse.
    
    if nargin < 6
        error('All arguments required: lockFile, pre, post, top, bottom, folderPath');
    end
    
    % Create arguments file (separate from lock file)
    argsFile = strrep(lockFile, '.txt', '_args.txt');
    
    try
        % Write arguments in a structured format
        fid = fopen(argsFile, 'w');
        if fid == -1
            error('Could not create arguments file: %s', argsFile);
        end
        
        % Write header
        fprintf(fid, 'DAI InVesalius Arguments\n');
        fprintf(fid, 'Created: %s\n', datestr(now));
        fprintf(fid, '--- ARGUMENTS ---\n');
        
        % Write each argument on a separate line with identifier
        fprintf(fid, 'PRE=%s\n', pre);
        fprintf(fid, 'POST=%s\n', post);
        fprintf(fid, 'TOP=%s\n', top);
        fprintf(fid, 'BOTTOM=%s\n', bottom);
        fprintf(fid, 'FOLDER=%s\n', folderPath);
        
        fclose(fid);
        
        fprintf('Arguments written to: %s\n', argsFile);
        
    catch ME
        fprintf('Error writing arguments to file: %s\n', ME.message);
        rethrow(ME);
    end
end

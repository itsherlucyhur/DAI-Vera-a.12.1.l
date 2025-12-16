function migrateToLockBasedExecution()
    % MIGRATETOLOCKBASEDEXECUTION Utility to help migrate existing code to lock-based system
    % 
    % This function provides examples and templates for migrating existing direct
    % system calls to the lock-based execution system.
    
    fprintf('=== Lock-Based Execution Migration Guide ===\n\n');
    
    fprintf('1. Replace direct Slicer execution:\n');
    fprintf('   OLD: system([''start "" "'' shortcutPath ''"'']);\n');
    fprintf('   NEW: requestSlicerExecution(''dai_slicer_lock.txt'');\n\n');
    
    fprintf('2. Replace direct InVesalius execution:\n');
    fprintf('   OLD: system([''\"'' exePath ''\" '' args]);\n');
    fprintf('   NEW: requestInVesaliusExecution(''dai_invesalius_lock.txt'', pre, post, top, bottom, folderPath);\n\n');
    
    fprintf('3. Add waiting for external program completion (optional):\n');
    fprintf('   waitForExternalProgramCompletion(''dai_slicer_lock.txt'', 300);\n\n');
    
    fprintf('4. Lock file locations:\n');
    fprintf('   - Slicer requests: dai_slicer_lock.txt\n');
    fprintf('   - InVesalius requests: dai_invesalius_lock.txt\n');
    fprintf('   - Legacy support: dai_lock.txt (backward compatibility)\n\n');
    
    fprintf('5. Benefits of lock-based system:\n');
    fprintf('   - Parent PowerShell process manages all external executions\n');
    fprintf('   - Better process isolation and error handling\n');
    fprintf('   - Centralized logging and monitoring\n');
    fprintf('   - No direct system calls from MATLAB\n');
    fprintf('   - Easier debugging and maintenance\n\n');
    
    fprintf('6. Required files for lock-based system:\n');
    fprintf('   - requestSlicerExecution.m\n');
    fprintf('   - requestInVesaliusExecution.m\n');
    fprintf('   - waitForExternalProgramCompletion.m (optional)\n');
    fprintf('   - Updated run_slicer.ps1 with lock monitoring\n\n');
    
    fprintf('Example usage in your button callback:\n');
    fprintf('function myButtonCallback(app, event)\n');
    fprintf('    %% Request Slicer execution\n');
    fprintf('    requestSlicerExecution(''dai_slicer_lock.txt'');\n');
    fprintf('    \n');
    fprintf('    %% Wait for user to complete Slicer workflow\n');
    fprintf('    uialert(app.UIFigure, ''Complete Slicer workflow and click OK'', ''Info'');\n');
    fprintf('    \n');
    fprintf('    %% Continue with your processing...\n');
    fprintf('    %% [your existing code here]\n');
    fprintf('    \n');
    fprintf('    %% Request InVesalius execution\n');
    fprintf('    requestInVesaliusExecution(''dai_invesalius_lock.txt'', pre, post, top, bottom, folderPath);\n');
    fprintf('end\n\n');
    
    fprintf('Migration completed! Your code now uses the lock-based system.\n');
end

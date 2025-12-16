function ImportLesionPointsButtonPushed_LockBased(app, ~)
    % IMPORTLESIONPOINTSBUTTONPUSHED_LOCKBASED Handle lesion points import with lock-based external program execution
    % 
    % This function processes lesion points and coordinates external program execution
    % through a lock-based system with the parent PowerShell process, rather than
    % directly executing Slicer and InVesalius.
    
    try
        % Request Slicer execution through lock system
        fprintf('Requesting Slicer execution from parent process...\n');
        requestSlicerExecution('dai_slicer_lock.txt');
        
        % Wait for user to complete Slicer workflow
        uialert(app.UIFigure, 'Slicer has been launched. Please complete your workflow in Slicer and then click OK to continue.', 'Slicer Workflow', 'Icon', 'info');
        
        % File selection for DICOM load file
        [file, path] = uigetfile({'*.nrrd*', '.nrrd'}, 'Select dicom load file');
        if isequal(file,0) || isequal(path,0)
            uialert(app.UIFigure, 'No file selected.', 'Error');
            return;
        end
        selectedFile = fullfile(path, file);
        
        % Look for Centerline VTK files
        files = dir(fullfile(path, '*Centerline*.vtk'));
        if isempty(files)
            uialert(app.UIFigure, 'No Centerline VTK files found.', 'Error');
            return;
        end
        
        % Extract numbers from filenames and find the highest
        nums = zeros(1, numel(files));
        for i = 1:numel(files)
            tokens = regexp(files(i).name, '_(\d+)\.vtk$', 'tokens');
            if ~isempty(tokens)
                nums(i) = str2double(tokens{1}{1});
            else
                nums(i) = 0; % If no number, treat as 0
            end
        end
        
        [~, idx] = max(nums);
        vtkFile = fullfile(path, files(idx).name);
        
        % Process the VTK file to extract points and radii
        fprintf('Processing VTK file: %s\n', vtkFile);
        extract_sl(vtkFile);
        
        % Load the processed data
        data = load('C:\tmp\output.mat');
        points = data.points;
        radii = data.radius;
        
        % Ensure correct orientation
        if size(points,1) ~= numel(radii)
            error('Number of points and radii do not match.');
        end
        
        % Merge into cell array of {[x y z], r}
        merged = cell(numel(radii), 1);
        for i = 1:numel(radii)
            merged{i} = {points(i,:), radii(i)};
        end
        
        % Get point mapping
        [points, points_inv] = pointMapUtil(path, selectedFile);
        radii = [];
        
        % Match points to radii
        for i = 1:size(points, 1)
            xyz = points(i, :);
            xyz_comp = xyz;
            xyz_comp(2) = -xyz_comp(2); % Negate y for comparison only
            for j = 1:numel(merged)
                fprintf('xyz: [%f, %f, %f]\n', xyz);
                fprintf('merged{%d}{1}: [%f, %f, %f]\n', j, merged{j}{1});
                % Check if all coordinates are within 0.8
                if all(abs(merged{j}{1} - xyz_comp) <= 0.8)
                    radii = [radii; merged{j}{2}];
                    break; % Only take the first matching radius
                end
            end
        end
        
        fprintf('Matched radii: %s\n', mat2str(radii));
        
        % Update text fields with the first two radii (if available)
        if numel(radii) >= 1
            app.PrelesionLumenRadiuscmEditFieldStressOnly.Value = num2str(radii(1)/10);
            fprintf('Pre-lesion radius set to: %f cm\n', radii(1)/10);
        end
        
        if numel(radii) >= 2
            app.PostlesionLumenRadiuscmEditFieldStressOnly.Value = num2str(radii(2)/10);
            fprintf('Post-lesion radius set to: %f cm\n', radii(2)/10);
        end
        
        % Get folder for InVesalius input
        folderPath = uigetdir('', 'Select a folder for InVesalius input');
        if isequal(folderPath, 0)
            uialert(app.UIFigure, 'No folder selected.', 'Error');
            return;
        end
        
        % Generate ROI JSON file
        generateRoiJson(points_inv(1,:), points_inv(2,:));
        
        % Prepare coordinate arguments for InVesalius
        pre = ['[[' num2str(points_inv(1,1)) ',' num2str(points_inv(1,2)) ',' num2str(points_inv(1,3)) ']]'];
        post = ['[[' num2str(points_inv(2,1)) ',' num2str(points_inv(2,2)) ',' num2str(points_inv(2,3)) ']]'];
        top = ['[[' num2str(points_inv(3,1)) ',' num2str(points_inv(3,2)) ',' num2str(points_inv(3,3)) ']]'];
        bottom = ['[[' num2str(points_inv(4,1)) ',' num2str(points_inv(4,2)) ',' num2str(points_inv(4,3)) ']]'];
        
        % Request InVesalius execution through lock system
        fprintf('Requesting InVesalius execution from parent process...\n');
        fprintf('Coordinates:\n');
        fprintf('  Pre: %s\n', pre);
        fprintf('  Post: %s\n', post);
        fprintf('  Top: %s\n', top);
        fprintf('  Bottom: %s\n', bottom);
        fprintf('  Folder: %s\n', folderPath);
        
        requestInVesaliusExecution('dai_invesalius_lock.txt', pre, post, top, bottom, folderPath);
        
        % Show success message
        uialert(app.UIFigure, 'InVesalius execution has been requested. The parent process will launch InVesalius with the specified coordinates.', 'Success', 'Icon', 'success');
        
    catch ME
        fprintf('Error in ImportLesionPointsButtonPushed: %s\n', ME.message);
        uialert(app.UIFigure, ['Error processing lesion points: ' ME.message], 'Error');
        rethrow(ME);
    end
end

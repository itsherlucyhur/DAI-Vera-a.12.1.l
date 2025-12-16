% EXTRACT_SL Extract centerline points and radius from VTK polydata
% 
% Usage: extract_sl('path/to/centerline.vtk')
%
% This function reads a VTK polydata file and extracts centerline points
% and radius data, then saves the results to the current user's folder

function extract_sl(centerline_file)
    if nargin < 1
        error('Usage: extract_sl(''path/to/centerline.vtk'')');
    end
    
    % Parse VTK points and radius
    [points, radius] = parse_vtk_points_and_radius(centerline_file);
    
    % Auto-detect user home directory and create output path
    userHome = char(java.lang.System.getProperty('user.home'));
    output_path = fullfile(userHome, 'output.mat');
    
    % Save to MAT file
    save(output_path, 'points', 'radius');
    
    fprintf('Extracted %d points and saved to %s\n', size(points, 1), output_path);
end

function [points, radius] = parse_vtk_points_and_radius(filename)
    % Open file in binary mode
    fid = fopen(filename, 'rb');
    if fid == -1
        error('Could not open file: %s', filename);
    end
    
    try
        % Read lines until POINTS header
        while true
            line = fgetl(fid);
            if line == -1
                error('POINTS section not found');
            end
            if startsWith(line, 'POINTS')
                break;
            end
        end
        
        % Parse POINTS header
        parts = strsplit(line);
        num_points = str2double(parts{2});
        dtype = parts{3};
        if ~strcmpi(dtype, 'float')
            error('Only float type supported in this example');
        end
        
        % Read points data (big-endian float32)
        num_floats = num_points * 3;
        points_data = fread(fid, num_floats, 'float32', 0, 'ieee-be');
        
        % Reshape to [x,y,z] coordinates
        points = reshape(points_data, 3, num_points)';
        
        % Search for POINT_DATA section
        while true
            line = fgetl(fid);
            if line == -1
                error('POINT_DATA section not found');
            end
            if startsWith(line, 'POINT_DATA')
                break;
            end
        end
        
        % Confirm number of points matches
        parts = strsplit(line);
        assert(str2double(parts{2}) == num_points, 'Point count mismatch');
        
        % Search for FIELD FieldData
        while true
            line = fgetl(fid);
            if line == -1
                error('FIELD FieldData section not found');
            end
            if startsWith(line, 'FIELD')
                break;
            end
        end
        
        % Search for Radius field
        while true
            line = fgetl(fid);
            if line == -1
                error('Radius field not found');
            end
            if startsWith(line, 'Radius')
                break;
            end
        end
        
        % Parse Radius header
        parts = strsplit(line);
        num_tuples = str2double(parts{3});
        dtype = parts{4};
        if ~strcmpi(dtype, 'double')
            error('Only double type supported for Radius in this example');
        end
        assert(num_tuples == num_points, 'Radius count mismatch');
        
        % Read radius data (big-endian double)
        radius = fread(fid, num_tuples, 'double', 0, 'ieee-be');
        
    catch ME
        fclose(fid);
        rethrow(ME);
    end
    
    fclose(fid);
end



% Test command - uncomment to run
% extract_sl('G:\My Drive\Lawson\test_DAI_Slicer\Centerline model.vtk');

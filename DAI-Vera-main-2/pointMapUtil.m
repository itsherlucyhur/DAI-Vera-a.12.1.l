function [points, points_inv] = pointMapUtil(folder_path, nrrd_path)
    % Initialize outputs
    points = [];
    points_inv = [];
    nrrd_info = struct();

    %% --- Parse NRRD header if provided ---
    if nargin > 1 && exist(nrrd_path, 'file')
        fid = fopen(nrrd_path, 'r');
        if fid == -1
            error('Could not open NRRD file: %s', nrrd_path);
        end

        header_lines = {};
        while true
            line = fgetl(fid);
            if ~ischar(line), break; end
            if isempty(line), break; end
            if startsWith(line, 'NRRD0004') || startsWith(line, '#'), continue; end
            header_lines{end+1} = line; %#ok<AGROW>
        end
        fclose(fid);

        for i = 1:length(header_lines)
            line = header_lines{i};
            if startsWith(line, 'space:')
                nrrd_info.space = strtrim(extractAfter(line, ':'));
            elseif startsWith(line, 'sizes:')
                nrrd_info.sizes = str2double(strsplit(strtrim(extractAfter(line, ':'))));
            elseif startsWith(line, 'space origin:')
                origin_str = extractAfter(line, ':');
                nums = regexp(origin_str, '[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?', 'match');
                nrrd_info.space_origin = str2double(nums);
            elseif startsWith(line, 'space directions:')
                dirs_str = extractAfter(line, ':');
                dir_cells = regexp(dirs_str, '\(([^)]*)\)', 'tokens');
                nrrd_info.space_directions = cellfun(@(c) str2double(strsplit(c{1}, ',')), dir_cells, 'UniformOutput', false);
                nrrd_info.space_directions = vertcat(nrrd_info.space_directions{:});
            end
        end
    end

    %% --- Find latest .mrk file ---
    files_all = dir(fullfile(folder_path, 'F*.mrk*'));
    files = files_all(~contains({files_all.name}, 'Endpoints'));
    files = files(~contains({files.name}, 'curve'));

    if isempty(files)
        fprintf('No .mrk files found.\n');
        return;
    end

    % Extract numbers and pick highest
    file_nums = zeros(1, numel(files));
    for i = 1:numel(files)
        tokens = regexp(files(i).name, '_(\d+)\.mrk', 'tokens');
        if ~isempty(tokens)
            file_nums(i) = str2double(tokens{1}{1});
        else
            file_nums(i) = 0;
        end
    end
    [~, idx] = max(file_nums);
    filepath = fullfile(folder_path, files(idx).name);

    %% --- Read and parse JSON ---
    fid = fopen(filepath, 'r');
    if fid == -1
        fprintf('Could not open file: %s\n', filepath);
        return;
    end
    raw = fread(fid, '*char')';
    fclose(fid);
    json_data = jsondecode(raw);

    %% --- Extract points ---
    if isfield(json_data, 'markups') && ~isempty(json_data.markups)
        for m = 1:length(json_data.markups)
            if isfield(json_data.markups(m), 'controlPoints')
                cps = json_data.markups(m).controlPoints;
                for c = 1:length(cps)
                    pos_vec = cps(c).position(:)';   % ensure row vector
                    points = [points; pos_vec];

                    % Convert mm -> voxel using full direction matrix
                    if isfield(nrrd_info, 'space_origin') && isfield(nrrd_info, 'space_directions')
                        origin = nrrd_info.space_origin(:)';
                        dirs   = nrrd_info.space_directions;
                        position_voxel = mmToVoxel(pos_vec, origin, dirs, 'round');
                        points_inv = [points_inv; position_voxel];
                    else
                        points_inv = [points_inv; nan(1, numel(pos_vec))];
                    end
                end
            end
        end
    end

    fprintf('File: %s\n', filepath);
    fprintf('Extracted %d points.\n', size(points, 1));
    disp(points_inv);
end

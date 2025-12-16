function radii = matchPointsToRadii(points, merged)
% points: Nx3 array
% merged: Mx1 cell array, each cell is { [x y z], r }
% radii: Nx1 array, radius for each point (0 if not found)

    nPoints = size(points, 1);
    nMerged = numel(merged);
    radii = zeros(nPoints, 1);

    % Extract merged points and radii
    merged_points = zeros(nMerged, 3);
    merged_radii = zeros(nMerged, 1);
    for i = 1:nMerged
        merged_points(i, :) = merged{i}{1};
        merged_radii(i) = merged{i}{2};
    end

    % Match points
    for i = 1:nPoints
        idx = find(all(bsxfun(@eq, merged_points, points(i, :)), 2), 1);
        if ~isempty(idx)
            radii(i) = merged_radii(idx);
        end
    end
end
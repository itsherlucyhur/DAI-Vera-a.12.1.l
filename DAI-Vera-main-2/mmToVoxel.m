function ijk = mmToVoxel(mmCoord, origin, dirs, method)
% mmToVoxel  Convert mm (LPS) -> voxel indices using full 3x3 directions
%   mmCoord : [1x3] mm in LPS
%   origin  : [1x3] space origin (LPS)
%   dirs    : [3x3] space directions (each row = direction vector for I,J,K)
%   method  : 'round' (default) | 'floor' | 'ceil' | 'none'

    if nargin < 4 || isempty(method), method = 'round'; end

    % Solve [i j k] * dirs = (mm - origin)  (row-vector right division)
    ijkFloat = (mmCoord - origin) / dirs;   % 0-based, float

    switch lower(method)
        case 'round', ijk = round(ijkFloat);
        case 'floor', ijk = floor(ijkFloat);
        case 'ceil',  ijk = ceil(ijkFloat);
        otherwise,    ijk = ijkFloat;
    end
end

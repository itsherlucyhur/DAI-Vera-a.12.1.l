function setPoints(app, preStrings, postStrings)
    % testPointFromStrings - Process pre/post lesion point inputs from string arrays

    % Input:
    % preStrings  - cell array of 4 strings: {x, y, slice, time} for pre-lesion point
    % postStrings - cell array of 4 strings: {x, y, slice, time} for post-lesion point

    % Validate input format
    if numel(preStrings) ~= 4 || numel(postStrings) ~= 4
        error('Both preStrings and postStrings must contain exactly 4 string elements.');
    end

    % Parse pre-lesion input
    xPre = str2double(preStrings{1});
    yPre = str2double(preStrings{2});
    slicePre = str2double(preStrings{3});
    timePre = str2double(preStrings{4});

    % Parse post-lesion input
    xPost = str2double(postStrings{1});
    yPost = str2double(postStrings{2});
    slicePost = str2double(postStrings{3});
    timePost = str2double(postStrings{4});

    % Check for invalid conversions (e.g., str2double returned NaN)
    if any(isnan([xPre, yPre, slicePre, timePre, xPost, yPost, slicePost, timePost]))
        error('One or more input values could not be converted to numbers.');
    end
    

    % Call existing point-based ROI functions
    setPre(app, xPre, yPre, slicePre, timePre);
    setPost(app, xPost, yPost, slicePost, timePost);
end

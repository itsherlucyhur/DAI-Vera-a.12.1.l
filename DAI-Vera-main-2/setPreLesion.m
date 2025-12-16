% New function to set pre-lesion point using coordinates for all time points
function setPreLesion(app, x, y, z)
    % setPreLesion - Sets a pre-lesion point at specified coordinates for all time points
    % 
    % Inputs:
    %   app - The application object containing image data and settings
    %   x   - X coordinate of the pre-lesion point (column index)
    %   y   - Y coordinate of the pre-lesion point (row index)  
    %   z   - Z coordinate of the pre-lesion point (slice index)
    %
    % This function programmatically sets a pre-lesion ROI point without user interaction
    % and processes it for all available time points in the stress-only analysis
    
    % Disable zoom
    zoom(app.ImageAxesStressOnly, 'off');
    
    % Validate coordinates
    % if z < 1 || z > size(app.fourDImageSetStressOnly, 1)
    %     error('Z coordinate (slice) %d is out of range [1, %d]. Note: MATLAB uses 1-based indexing.', z, size(app.fourDImageSetStressOnly, 1));
    % end
    % if x < 1 || x > size(app.fourDImageSetStressOnly, 4)
    %     error('X coordinate %d is out of range [1, %d]', x, size(app.fourDImageSetStressOnly, 4));
    % end
    % if y < 1 || y > size(app.fourDImageSetStressOnly, 3)
    %     error('Y coordinate %d is out of range [1, %d]', y, size(app.fourDImageSetStressOnly, 3));
    % end
    
    % Set slice and current time point
    app.paSliceStressOnly = z;
    app.currentSliceStressOnly = z;
    app.paCurrentTimePointStressOnly = app.currentTimePointStressOnly;
    
    % Set segmentation window size
    segmentationWindowSize = 25;
    
    % Store the coordinates in the format expected by the system
    % [slice, timePoint, x, y] - note the coordinate order matches the original function
    app.paStressOnly = [z, app.currentTimePointStressOnly, round(x), round(y)];
    
    % Initialize fitted curve data and validate time points
    if isempty(app.timePointsStressOnly) || length(app.timePointsStressOnly) < 2
        % Auto-generate time points from 4D image set if not initialized
        numTimePoints = size(app.fourDImageSetStressOnly, 2);
        if numTimePoints >= 2
            app.timePointsStressOnly = (0:numTimePoints-1)';  % Simple sequential time points
            fprintf('Auto-generated %d time points for stress-only analysis\n', numTimePoints);
        else
            error('Cannot initialize time points: 4D image set must have at least 2 time points. Found %d time points.', numTimePoints);
        end
    end
    
    app.fittedCurvePaStressOnly = zeros(size(app.timePointsStressOnly));
    
    % Ensure timePointsStressOnly is a proper vector
    if size(app.timePointsStressOnly, 1) == 1
        app.timePointsStressOnly = app.timePointsStressOnly';  % Convert to column vector
    end
    
    % Get best sample for all time points using the specified coordinates
    [app.paCurveStressOnly, app.interpolatedSampledPointsPaStressOnly, app.interpolatedTimePointsStressOnly, ...
     app.sxPreStressOnly, app.syPreStressOnly, app.rxPreStressOnly, app.ryPreStressOnly] = ...
        getBestSample(round(x), round(y), app.searchROIMStressOnly, app.roiMStressOnly, ...
                     app.roiNStressOnly, z, app.fourDImageSetStressOnly, app.timePointsStressOnly);
    
    % Get contour information at the specified coordinates
    [~, radiusIncm, areaOfContourInCmSq] = ...
        getContour(round(x), round(y), segmentationWindowSize, z, ...
                  app.paCurrentTimePointStressOnly, app.fourDImageSetStressOnly, ...
                  app.dicomInfoStressOnly.PixelSpacing);
    
    % Create ROI object for the pre-lesion point
    app.preRoiObjectStressOnly = getROI(app.dicomInfoStressOnly.PatientName.FamilyName, ...
        size(app.fourDImageSetStressOnly,2), size(app.fourDImageSetStressOnly,1), ...
        app.paStressOnly(3), app.paStressOnly(4), app.paStressOnly(1), app.paStressOnly(2), ...
        app.paCurveStressOnly, app.timePointsStressOnly, app.fittedCurvePaStressOnly, ...
        app.fittedTimePaStressOnly, app.sxPreStressOnly, app.syPreStressOnly, ...
        0, 0, app.numberOfStenosis, 0, 0, 0, 0, 0);
    
    % Link to main ROI object and save
    app.roiObjectStressOnly.preRoiObject = app.preRoiObjectStressOnly;
    saveRoiAsJson(app.roiObjectStressOnly);
    
    % Update visualization for current time point
    imageData = zeros(512, 512);
    imageData(1:512, 1:512) = app.fourDImageSetStressOnly(z, app.currentTimePointStressOnly, 1:512, 1:512);
    imageWithContour = getROIOverlayed(imageData, app.sxPreStressOnly, app.syPreStressOnly);
    updateimageStressOnly(app, imageWithContour);
    
    % Add interactive draggable point for manual adjustment (unless suppressed during recalculation)
    if ~isfield(app, 'suppressDraggablePoint') || ~app.suppressDraggablePoint
        addDraggablePrePoint(app, x, y);
    end
    
    % Display measurement results
    fprintf('Pre-lesion point set at coordinates: (%d, %d, %d)\n', x, y, z);
    fprintf('Radius: %.2f cm\n', radiusIncm);
    fprintf('Area: %.2f cm²\n', areaOfContourInCmSq);
    
    % Draw the pre-lesion curve for all time points
    drawPreLesionCurveStressOnly(app);
    
    % Process for all time points to ensure consistency
    processAllTimePoints(app, x, y, z);
end

function processAllTimePoints(app, x, y, z)
    % processAllTimePoints - Internal function to process the pre-lesion point across all time points
    %
    % This function ensures the pre-lesion measurement is consistent across
    % all time points in the 4D image set
    
    originalTimePoint = app.currentTimePointStressOnly;
    numTimePoints = size(app.fourDImageSetStressOnly, 2);
    
    fprintf('Processing pre-lesion point across %d time points...\n', numTimePoints);
    
    % Store curves for each time point
    allTimeCurves = cell(numTimePoints, 1);
    
    for t = 1:numTimePoints
        try
            % Temporarily set current time point
            app.currentTimePointStressOnly = t;
            
            % Get sample data for this time point
            timePointData = app.fourDImageSetStressOnly(z, t, :, :);
            timePointData = squeeze(timePointData);
            
            % Store the intensity value at the specified coordinates
            if x <= size(timePointData, 2) && y <= size(timePointData, 1)
                intensityValue = timePointData(y, x);
                allTimeCurves{t} = intensityValue;
            else
                allTimeCurves{t} = 0; % Default value if coordinates are out of bounds
            end
            
        catch ME
            fprintf('Warning: Error processing time point %d: %s\n', t, ME.message);
            allTimeCurves{t} = 0;
        end
    end
    
    % Restore original time point
    app.currentTimePointStressOnly = originalTimePoint;
    
    % Store the complete time series data
    app.prelesionTimeSeriesData = cell2mat(allTimeCurves);
    
    fprintf('Pre-lesion time series data generated for %d time points\n', numTimePoints);
end

function addDraggablePrePoint(app, x, y)
    % Add a visible, draggable point that users can manually adjust for pre-lesion
    
    % Clear any existing draggable point
    if isfield(app, 'draggablePrePointStressOnly') && isvalid(app.draggablePrePointStressOnly)
        delete(app.draggablePrePointStressOnly);
    end
    
    % Enable zoom and pan off to allow point interaction
    zoom(app.ImageAxesStressOnly, 'off');
    pan(app.ImageAxesStressOnly, 'off');
    
    % Create the draggable point at the current position
    hold(app.ImageAxesStressOnly, 'on');
    app.draggablePrePointStressOnly = drawpoint(app.ImageAxesStressOnly, 'Position', [y, x], ...
        'Color', 'cyan', 'MarkerSize', 8, 'LineWidth', 2);
    
    % Set up callback for when the point is moved
    addlistener(app.draggablePrePointStressOnly, 'MovingROI', @(src, evt) updatePrePointPosition(app, src, evt));
    addlistener(app.draggablePrePointStressOnly, 'ROIMoved', @(src, evt) finalizePrePointPosition(app, src, evt));
    
    hold(app.ImageAxesStressOnly, 'off');
    
    % Add a context menu for the point
    c = uicontextmenu(app.UIFigure);
    app.draggablePrePointStressOnly.ContextMenu = c;
    uimenu(c, 'Text', 'Recalculate at this position', 'MenuSelectedFcn', @(src, evt) recalculatePreAtCurrentPosition(app));
    uimenu(c, 'Text', 'Remove draggable point', 'MenuSelectedFcn', @(src, evt) removeDraggablePrePoint(app));
end

function updatePrePointPosition(app, src, ~)
    % Called while the point is being dragged - provide real-time feedback
    try
        newPos = src.Position;
        newX = round(newPos(2));  % Note: drawpoint uses [y, x] format
        newY = round(newPos(1));
        
        % Optional: Update the title to show current coordinates
        if isfield(app, 'ImageAxesStressOnly') && isvalid(app.ImageAxesStressOnly)
            title(app.ImageAxesStressOnly, sprintf('Pre-lesion point: (%d, %d)', newX, newY), ...
                'Color', 'cyan', 'FontWeight', 'bold');
        end
    catch ME
        % Silently handle any errors during dragging
        disp(['Warning during pre-lesion point dragging: ', ME.message]);
    end
end

function finalizePrePointPosition(app, src, ~)
    % Called when the point dragging is complete - update the analysis
    try
        newPos = src.Position;
        newX = round(newPos(2));  % Note: drawpoint uses [y, x] format  
        newY = round(newPos(1));
        
        % Validate the new position is within image bounds
        if newX < 1 || newX > 512 || newY < 1 || newY > 512
            uialert(app.UIFigure, 'Point moved outside image bounds. Please place within the image area.', 'Invalid Position');
            % Reset to previous valid position
            src.Position = [app.paStressOnly(4), app.paStressOnly(3)];
            return;
        end
        
        % Update the stored position
        app.paStressOnly(3) = newX;  % Update x coordinate
        app.paStressOnly(4) = newY;  % Update y coordinate
        
        % Automatically recalculate the analysis at the new position
        recalculatePreAtCurrentPosition(app);
        
        fprintf('Pre-lesion point moved to: (%d, %d)\n', newX, newY);
        
    catch ME
        uialert(app.UIFigure, ['Error updating pre-lesion point position: ', ME.message], 'Error');
    end
end

function recalculatePreAtCurrentPosition(app)
    % Recalculate the pre-lesion analysis at the current draggable point position
    try
        if isfield(app, 'draggablePrePointStressOnly') && isvalid(app.draggablePrePointStressOnly)
            currentPos = app.draggablePrePointStressOnly.Position;
            newX = round(currentPos(2));  % Convert from [y, x] to x coordinate
            newY = round(currentPos(1));  % Convert from [y, x] to y coordinate
            
            % Use stored slice and time point
            slice = app.currentSliceStressOnly;
            
            % Call the main setPreLesion function with new coordinates
            % but suppress the creation of a new draggable point
            app.suppressDraggablePoint = true;
            setPreLesion(app, newX, newY, slice);
            app.suppressDraggablePoint = false;
            
            % Restore the draggable point after recalculation
            addDraggablePrePoint(app, newX, newY);
            
            fprintf('Recalculated pre-lesion analysis at position: (%d, %d)\n', newX, newY);
        end
    catch ME
        uialert(app.UIFigure, ['Error recalculating pre-lesion position: ', ME.message], 'Error');
    end
end

function removeDraggablePrePoint(app)
    % Remove the draggable pre-lesion point
    try
        if isfield(app, 'draggablePrePointStressOnly') && isvalid(app.draggablePrePointStressOnly)
            delete(app.draggablePrePointStressOnly);
            app.draggablePrePointStressOnly = [];
        end
        
        % Clear the coordinate display from title
        if isfield(app, 'ImageAxesStressOnly') && isvalid(app.ImageAxesStressOnly)
            title(app.ImageAxesStressOnly, '');
        end
        
        disp('Draggable pre-lesion point removed');
    catch ME
        disp(['Error removing draggable pre-lesion point: ', ME.message]);
    end
end

% Example usage:
% pts = pointMapUtil('C:\path\to\your\folder', 'C:\path\to\your\file.nrrd');
% setPreLesion(app, 256, 256, 10);  % Set pre-lesion at center of slice 10
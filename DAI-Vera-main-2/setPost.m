function setPost(app, x, y, slice, timePoint)
    segmentationWindowSize = 25;

    % Store current slice and time
    app.pdSliceStressOnly = slice;
    app.pdCurrentTimePointStressOnly = timePoint;

    % Store point data
    app.pdStressOnly = [slice, timePoint, round(y), round(x)];

    % Dummy fitted curve
    app.fittedCurvePdStressOnly = zeros(size(app.timePointsStressOnly));

    % Sample using region around point
    [app.pdCurveStressOnly, app.interpolatedSampledPointsPdStressOnly, ...
        app.interpolatedTimePointsStressOnly, ...
        app.sxPostStressOnly, app.syPostStressOnly, ...
        app.rxPostStressOnly, app.ryPostStressOnly] = getBestSample( ...
            round(x), round(y), ...
            app.searchROIMStressOnly, app.roiMStressOnly, app.roiNStressOnly, ...
            slice, app.fourDImageSetStressOnly, app.pdTimePointsStressOnly);

    % Get small ROI contour around point
    [~, radiusIncm, areaOfContourInCmSq] = getContour( ...
        round(x), round(y), segmentationWindowSize, ...
        slice, timePoint, ...
        app.fourDImageSetStressOnly, app.dicomInfoStressOnly.PixelSpacing);

    % Build and save ROI object
    app.postRoiObjectStressOnly = getROI( ...
        app.dicomInfoStressOnly.PatientName.FamilyName, ...
        size(app.fourDImageSetStressOnly, 2), ...
        size(app.fourDImageSetStressOnly, 1), ...
        round(x), round(y), ...
        slice, timePoint, ...
        app.pdCurveStressOnly, ...
        app.pdTimePointsStressOnly, ...
        app.fittedCurvePdStressOnly, ...
        app.fittedTimePdStressOnly, ...
        app.sxPostStressOnly, ...
        app.syPostStressOnly, ...
        0, 0, app.numberOfStenosis, ...
        0, 0, 0, 0, 0);

    app.roiObjectStressOnly.postRoiObject = app.postRoiObjectStressOnly;
    saveRoiAsJson(app.roiObjectStressOnly);

    % Overlay and update image
    imageData = squeeze(app.fourDImageSetStressOnly(slice, timePoint, 1:512, 1:512));
    imageWithContour = getROIOverlayed(imageData, app.sxPostStressOnly, app.syPostStressOnly);
    updateimageStressOnly(app, imageWithContour);

    % Add interactive draggable point for manual adjustment (unless suppressed)
    if ~isfield(app, 'suppressDraggablePoint') || ~app.suppressDraggablePoint
        addDraggablePostPointSimple(app, x, y);
    end

    % Debug info
    disp("Radius in cm:"); disp(radiusIncm);
    disp("Area in cm²:"); disp(areaOfContourInCmSq);

    drawPostLesionCurveStressOnly(app);
end

function addDraggablePostPointSimple(app, x, y)
    % Add a visible, draggable point that users can manually adjust for post-lesion (simple version)
    
    % Clear any existing draggable point
    if isfield(app, 'draggablePostPointSimpleStressOnly') && isvalid(app.draggablePostPointSimpleStressOnly)
        delete(app.draggablePostPointSimpleStressOnly);
    end
    
    % Disable zoom and pan for point interaction
    zoom(app.ImageAxesStressOnly, 'off');
    pan(app.ImageAxesStressOnly, 'off');
    
    % Create the draggable point at the current position
    hold(app.ImageAxesStressOnly, 'on');
    app.draggablePostPointSimpleStressOnly = drawpoint(app.ImageAxesStressOnly, 'Position', [y, x], ...
        'Color', 'red', 'MarkerSize', 8, 'LineWidth', 2);
    
    % Set up callback for when the point is moved
    addlistener(app.draggablePostPointSimpleStressOnly, 'MovingROI', @(src, evt) updatePostPointSimplePosition(app, src, evt));
    addlistener(app.draggablePostPointSimpleStressOnly, 'ROIMoved', @(src, evt) finalizePostPointSimplePosition(app, src, evt));
    
    hold(app.ImageAxesStressOnly, 'off');
    
    % Add a context menu for the point
    c = uicontextmenu(app.UIFigure);
    app.draggablePostPointSimpleStressOnly.ContextMenu = c;
    uimenu(c, 'Text', 'Recalculate at this position', 'MenuSelectedFcn', @(src, evt) recalculatePostSimpleAtCurrentPosition(app));
    uimenu(c, 'Text', 'Remove draggable point', 'MenuSelectedFcn', @(src, evt) removeDraggablePostPointSimple(app));
end

function updatePostPointSimplePosition(app, src, ~)
    % Called while the point is being dragged - provide real-time feedback
    try
        newPos = src.Position;
        newX = round(newPos(2));  % Note: drawpoint uses [y, x]
        newY = round(newPos(1));
        
        % Optional: Update the title with current coordinates
        if isfield(app, 'ImageAxesStressOnly') && isvalid(app.ImageAxesStressOnly)
            title(app.ImageAxesStressOnly, sprintf('Post-lesion point: (%d, %d)', newX, newY), ...
                'Color', 'red', 'FontWeight', 'bold');
        end
    catch ME
        disp(['Warning during post-lesion point dragging: ', ME.message]);
    end
end

function finalizePostPointSimplePosition(app, src, ~)
    % Called when point dragging is complete - update the analysis
    try
        newPos = src.Position;
        newX = round(newPos(2));  
        newY = round(newPos(1));
        
        % Validate within bounds
        if newX < 1 || newX > 512 || newY < 1 || newY > 512
            uialert(app.UIFigure, 'Point moved outside image bounds. Please place within the image area.', 'Invalid Position');
            src.Position = [app.pdStressOnly(4), app.pdStressOnly(3)];
            return;
        end
        
        % Update stored position
        app.pdStressOnly(3) = newX;  
        app.pdStressOnly(4) = newY;  
        
        % Recalculate at new position
        recalculatePostSimpleAtCurrentPosition(app);
        
        fprintf('Post-lesion point moved to: (%d, %d)\n', newX, newY);
        
    catch ME
        uialert(app.UIFigure, ['Error updating post-lesion point position: ', ME.message], 'Error');
    end
end

function recalculatePostSimpleAtCurrentPosition(app)
    % Recalculate the post-lesion analysis at the current draggable point position
    try
        if isfield(app, 'draggablePostPointSimpleStressOnly') && isvalid(app.draggablePostPointSimpleStressOnly)
            currentPos = app.draggablePostPointSimpleStressOnly.Position;
            newX = round(currentPos(2));  
            newY = round(currentPos(1));  
            
            % Use stored slice and time point
            slice = app.pdSliceStressOnly;
            timePoint = app.pdCurrentTimePointStressOnly;
            
            % Suppress new point creation during recalculation
            app.suppressDraggablePoint = true;
            setPost(app, newX, newY, slice, timePoint);
            app.suppressDraggablePoint = false;
            
            % Restore draggable point
            addDraggablePostPointSimple(app, newX, newY);
            
            fprintf('Recalculated post-lesion analysis at position: (%d, %d)\n', newX, newY);
        end
    catch ME
        uialert(app.UIFigure, ['Error recalculating post-lesion position: ', ME.message], 'Error');
    end
end

function removeDraggablePostPointSimple(app)
    % Remove the draggable post-lesion point
    try
        if isfield(app, 'draggablePostPointSimpleStressOnly') && isvalid(app.draggablePostPointSimpleStressOnly)
            delete(app.draggablePostPointSimpleStressOnly);
            app.draggablePostPointSimpleStressOnly = [];
        end
        
        % Clear title
        if isfield(app, 'ImageAxesStressOnly') && isvalid(app.ImageAxesStressOnly)
            title(app.ImageAxesStressOnly, '');
        end
        
        disp('Draggable post-lesion point removed');
    catch ME
        disp(['Error removing draggable post-lesion point: ', ME.message]);
    end
end

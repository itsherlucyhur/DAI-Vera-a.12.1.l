% function setPre(app, x, y, slice, timePoint)
%     segmentationWindowSize = 25;
% 
%     % Store current slice and time
%     app.paSliceStressOnly = slice;
%     app.paCurrentTimePointStressOnly = timePoint;
% 
%     % Store point data
%     app.paStressOnly = [slice, timePoint, round(y), round(x)];
% 
%     % Dummy fitted curve
%     app.fittedCurvePaStressOnly = zeros(size(app.timePointsStressOnly));
% 
%     % Sample using region around point
%     [app.paCurveStressOnly, app.interpolatedSampledPointsPaStressOnly, ...
%         app.interpolatedTimePointsStressOnly, ...
%         app.sxPreStressOnly, app.syPreStressOnly, ...
%         app.rxPreStressOnly, app.ryPreStressOnly] = getBestSample(...
%             round(x), round(y), ...
%             app.searchROIMStressOnly, app.roiMStressOnly, app.roiNStressOnly, ...
%             slice, app.fourDImageSetStressOnly, app.paTimePointsStressOnly);
% 
%     % Get small ROI contour around point
%     [~, radiusIncm, areaOfContourInCmSq] = getContour(...
%         round(x), round(y), segmentationWindowSize, ...
%         slice, timePoint, ...
%         app.fourDImageSetStressOnly, app.dicomInfoStressOnly.PixelSpacing);
% 
%     % Build and save ROI object
%     app.preRoiObjectStressOnly = getROI(...
%         app.dicomInfoStressOnly.PatientName.FamilyName, ...
%         size(app.fourDImageSetStressOnly, 2), ...
%         size(app.fourDImageSetStressOnly, 1), ...
%         round(x), round(y), ...
%         slice, timePoint, ...
%         app.paCurveStressOnly, ...
%         app.paTimePointsStressOnly, ...
%         app.fittedCurvePaStressOnly, ...
%         app.fittedTimePaStressOnly, ...
%         app.sxPreStressOnly, ...
%         app.syPreStressOnly, ...
%         0, 0, app.numberOfStenosis, ...
%         0, 0, 0, 0, 0);
% 
%     app.roiObjectStressOnly.preRoiObject = app.preRoiObjectStressOnly;
%     saveRoiAsJson(app.roiObjectStressOnly);
% 
%     % Overlay and update image
%     imageData = squeeze(app.fourDImageSetStressOnly(slice, timePoint, 1:512, 1:512));
%     imageWithContour = getROIOverlayed(imageData, app.sxPreStressOnly, app.syPreStressOnly);
%     updateimageStressOnly(app, imageWithContour);
% 
%     % Add interactive draggable point for manual adjustment (unless suppressed during recalculation)
%     if ~isfield(app, 'suppressDraggablePoint') || ~app.suppressDraggablePoint
%         addDraggablePrePointSimple(app, x, y);
%     end
% 
%     % Debug info
%     disp("Radius in cm:"); disp(radiusIncm);
%     disp("Area in cm²:"); disp(areaOfContourInCmSq);
% 
%     drawPreLesionCurveStressOnly(app);
% end
% 
% function addDraggablePrePointSimple(app, x, y)
%     % Add a visible, draggable point that users can manually adjust for pre-lesion (simple version)
% 
%     % Clear any existing draggable point
%     if isfield(app, 'draggablePrePointSimpleStressOnly') && isvalid(app.draggablePrePointSimpleStressOnly)
%         delete(app.draggablePrePointSimpleStressOnly);
%     end
% 
%     % Enable zoom and pan off to allow point interaction
%     zoom(app.ImageAxesStressOnly, 'off');
%     pan(app.ImageAxesStressOnly, 'off');
% 
%     % Create the draggable point at the current position
%     hold(app.ImageAxesStressOnly, 'on');
%     app.draggablePrePointSimpleStressOnly = drawpoint(app.ImageAxesStressOnly, 'Position', [y, x], ...
%         'Color', 'green', 'MarkerSize', 8, 'LineWidth', 2);
% 
%     % Set up callback for when the point is moved
%     addlistener(app.draggablePrePointSimpleStressOnly, 'MovingROI', @(src, evt) updatePrePointSimplePosition(app, src, evt));
%     addlistener(app.draggablePrePointSimpleStressOnly, 'ROIMoved', @(src, evt) finalizePrePointSimplePosition(app, src, evt));
% 
%     hold(app.ImageAxesStressOnly, 'off');
% 
%     % Add a context menu for the point
%     c = uicontextmenu(app.UIFigure);
%     app.draggablePrePointSimpleStressOnly.ContextMenu = c;
%     uimenu(c, 'Text', 'Recalculate at this position', 'MenuSelectedFcn', @(src, evt) recalculatePreSimpleAtCurrentPosition(app));
%     uimenu(c, 'Text', 'Remove draggable point', 'MenuSelectedFcn', @(src, evt) removeDraggablePrePointSimple(app));
% end
% 
% function updatePrePointSimplePosition(app, src, ~)
%     % Called while the point is being dragged - provide real-time feedback
%     try
%         newPos = src.Position;
%         newX = round(newPos(2));  % Note: drawpoint uses [y, x] format
%         newY = round(newPos(1));
% 
%         % Optional: Update the title to show current coordinates
%         if isfield(app, 'ImageAxesStressOnly') && isvalid(app.ImageAxesStressOnly)
%             title(app.ImageAxesStressOnly, sprintf('Pre-lesion point: (%d, %d)', newX, newY), ...
%                 'Color', 'green', 'FontWeight', 'bold');
%         end
%     catch ME
%         % Silently handle any errors during dragging
%         disp(['Warning during pre-lesion point dragging: ', ME.message]);
%     end
% end
% 
% function finalizePrePointSimplePosition(app, src, ~)
%     % Called when the point dragging is complete - update the analysis
%     try
%         newPos = src.Position;
%         newX = round(newPos(2));  % Note: drawpoint uses [y, x] format  
%         newY = round(newPos(1));
% 
%         % Validate the new position is within image bounds
%         if newX < 1 || newX > 512 || newY < 1 || newY > 512
%             uialert(app.UIFigure, 'Point moved outside image bounds. Please place within the image area.', 'Invalid Position');
%             % Reset to previous valid position
%             src.Position = [app.paStressOnly(4), app.paStressOnly(3)];
%             return;
%         end
% 
%         % Update the stored position
%         app.paStressOnly(3) = newX;  % Update x coordinate
%         app.paStressOnly(4) = newY;  % Update y coordinate
% 
%         % Automatically recalculate the analysis at the new position
%         recalculatePreSimpleAtCurrentPosition(app);
% 
%         fprintf('Pre-lesion point moved to: (%d, %d)\n', newX, newY);
% 
%     catch ME
%         uialert(app.UIFigure, ['Error updating pre-lesion point position: ', ME.message], 'Error');
%     end
% end
% 
% function recalculatePreSimpleAtCurrentPosition(app)
%     % Recalculate the pre-lesion analysis at the current draggable point position
%     try
%         if isfield(app, 'draggablePrePointSimpleStressOnly') && isvalid(app.draggablePrePointSimpleStressOnly)
%             currentPos = app.draggablePrePointSimpleStressOnly.Position;
%             newX = round(currentPos(2));  % Convert from [y, x] to x coordinate
%             newY = round(currentPos(1));  % Convert from [y, x] to y coordinate
% 
%             % Use stored slice and time point
%             slice = app.paSliceStressOnly;
%             timePoint = app.paCurrentTimePointStressOnly;
% 
%             % Call the main setPre function with new coordinates
%             % but suppress the creation of a new draggable point
%             app.suppressDraggablePoint = true;
%             setPre(app, newX, newY, slice, timePoint);
%             app.suppressDraggablePoint = false;
% 
%             % Restore the draggable point after recalculation
%             addDraggablePrePointSimple(app, newX, newY);
% 
%             fprintf('Recalculated pre-lesion analysis at position: (%d, %d)\n', newX, newY);
%         end
%     catch ME
%         uialert(app.UIFigure, ['Error recalculating pre-lesion position: ', ME.message], 'Error');
%     end
% end
% 
% function removeDraggablePrePointSimple(app)
%     % Remove the draggable pre-lesion point
%     try
%         if isfield(app, 'draggablePrePointSimpleStressOnly') && isvalid(app.draggablePrePointSimpleStressOnly)
%             delete(app.draggablePrePointSimpleStressOnly);
%             app.draggablePrePointSimpleStressOnly = [];
%         end
% 
%         % Clear the coordinate display from title
%         if isfield(app, 'ImageAxesStressOnly') && isvalid(app.ImageAxesStressOnly)
%             title(app.ImageAxesStressOnly, '');
%         end
% 
%         disp('Draggable pre-lesion point removed');
%     catch ME
%         disp(['Error removing draggable pre-lesion point: ', ME.message]);
%     end
% end
function setPre(app, x, y, slice, timePoint)
    segmentationWindowSize = 25;

    try
        % Store current slice and time
        app.paSliceStressOnly = slice;
        app.paCurrentTimePointStressOnly = timePoint;
        app.paStressOnly = [slice, timePoint, round(y), round(x)];
    catch ME
        disp(['Warning: Failed to store slice/timePoint: ' ME.message]);
    end

    try
        % Dummy fitted curve
        app.fittedCurvePaStressOnly = zeros(size(app.timePointsStressOnly));
    catch ME
        disp(['Warning: Failed to set dummy fitted curve: ' ME.message]);
    end

    try
        % Sample using region around point
        [app.paCurveStressOnly, app.interpolatedSampledPointsPaStressOnly, ...
            app.interpolatedTimePointsStressOnly, ...
            app.sxPreStressOnly, app.syPreStressOnly, ...
            app.rxPreStressOnly, app.ryPreStressOnly] = getBestSample(...
                round(x), round(y), ...
                app.searchROIMStressOnly, app.roiMStressOnly, app.roiNStressOnly, ...
                slice, app.fourDImageSetStressOnly, app.paTimePointsStressOnly);
    catch ME
        disp(['Warning: getBestSample failed: ' ME.message]);
    end

    radiusIncm = NaN; 
    areaOfContourInCmSq = NaN;
    try
        % Get small ROI contour around point
        [~, radiusIncm, areaOfContourInCmSq] = getContour(...
            round(x), round(y), segmentationWindowSize, ...
            slice, timePoint, ...
            app.fourDImageSetStressOnly, app.dicomInfoStressOnly.PixelSpacing);
    catch ME
        disp(['Warning: getContour failed: ' ME.message]);
    end

    try
        % Build and save ROI object
        app.preRoiObjectStressOnly = getROI(...
            app.dicomInfoStressOnly.PatientName.FamilyName, ...
            size(app.fourDImageSetStressOnly, 2), ...
            size(app.fourDImageSetStressOnly, 1), ...
            round(x), round(y), ...
            slice, timePoint, ...
            app.paCurveStressOnly, ...
            app.paTimePointsStressOnly, ...
            app.fittedCurvePaStressOnly, ...
            app.fittedTimePaStressOnly, ...
            app.sxPreStressOnly, ...
            app.syPreStressOnly, ...
            0, 0, app.numberOfStenosis, ...
            0, 0, 0, 0, 0);

        app.roiObjectStressOnly.preRoiObject = app.preRoiObjectStressOnly;
        saveRoiAsJson(app.roiObjectStressOnly);
    catch ME
        disp(['Warning: Failed to build/save ROI: ' ME.message]);
    end

    try
        % Overlay and update image
        imageData = squeeze(app.fourDImageSetStressOnly(slice, timePoint, 1:512, 1:512));
        imageWithContour = getROIOverlayed(imageData, app.sxPreStressOnly, app.syPreStressOnly);
        updateimageStressOnly(app, imageWithContour);
    catch ME
        disp(['Warning: Failed to update image: ' ME.message]);
    end

    try
        % Add draggable point unless suppressed
        if ~isfield(app, 'suppressDraggablePoint') || ~app.suppressDraggablePoint
            addDraggablePrePointSimple(app, x, y);
        end
    catch ME
        disp(['Warning: Failed to add draggable point: ' ME.message]);
    end

    try
        % Debug info
        disp("Radius in cm:"); disp(radiusIncm);
        disp("Area in cm²:"); disp(areaOfContourInCmSq);
    catch ME
        disp(['Warning: Failed to display debug info: ' ME.message]);
    end

    try
        drawPreLesionCurveStressOnly(app);
    catch ME
        disp(['Warning: Failed to draw curve: ' ME.message]);
    end
end

function callCustomInputDialog(app)
    % Get screen size
    screenSize = get(0, 'ScreenSize');
    screenWidth = screenSize(3);
    screenHeight = screenSize(4);

    % Calculate center position
    centerX = (screenWidth - 300) / 2;
    centerY = (screenHeight - 150) / 2;

    fig = figure('Position', [centerX, centerY, 330, 80], 'NumberTitle', 'off', 'Name', 'Locate Time Info and CTP Study');
    set(fig, 'MenuBar', 'none');
    set(fig, 'ToolBar', 'none');
    
    timeButtonPressed = false;
    studyButtonPressed = false;

    timeButton = uicontrol('Style', 'pushbutton', 'String', 'Locate Time Info File', 'Position', [10, 30, 120, 30], 'Callback', @(src, event) timeButtonCallback());
    studyButton = uicontrol('Style', 'pushbutton', 'String', 'Locate CTP Study To Apply Time Info', 'Position', [130, 30, 190, 30], 'Callback', @(src, event) studyButtonCallback());

    function timeButtonCallback()
        p = uigetfile('*.*');
        if (p == 0)
            % Do Nothing
        else
            set(gcf, 'Pointer','watch');
            drawnow;
            try
                [uniqueAcquisitionTime, uniqueContentTime] = loadTimeInfoAndApplyToCurrentCTPData(p);
                app.timeToCopy.contentTime = uniqueContentTime;
                app.timeToCopy.acquisitionTime = uniqueAcquisitionTime;
                set(gcf, 'Pointer','arrow');
            catch ME
                set(gcf, 'Pointer','arrow');
                msg = strcat('The DAI did not fail, there seems to be an issue with this TimeFile in particular: ', ME.message);
                errordlg(msg);
            end
        end
        set(timeButton,'Enable','off');
        timeButtonPressed = true;
    end

    function studyButtonCallback()
        p = uigetdir;
        if (p == 0)
            % Do Nothing
            figure(app.UIFigure);
        else
            set(gcf, 'Pointer','watch');
            drawnow;
            readAndUpdateHeaderFromGEFormattedImageFiles(p, app.timeToCopy);
            set(gcf, 'Pointer','arrow');
        end
        set(studyButton,'Enable','off');
        studyButtonPressed = true;

        if (timeButtonPressed && studyButtonPressed)
            delete(fig);
        end
    end

end
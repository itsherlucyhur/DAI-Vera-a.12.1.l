function buildPlot(app, lesionType)
    
    shadesOfBlue = [
        0 0.0 1.0;      % Royal Blue
        0 0.5 1.0;      % Dodger Blue
        0 0.7 1.0;      % Deep Sky Blue
        0 0.9 1.0;      % Light Blue
        0 0.4 0.8;      % Medium Blue
    ];

    if (strcmp(lesionType, 'pre') || strcmp(lesionType, 'entry'))
        if (~isVectorEmptyOrZero(app.paCurveStressOnly))
            curveData = struct();
            curveData.x = app.plotXPreStressOnly;
            curveData.y = app.paCurveStressOnly;
            curveData.color = 'm';
            curveData.shape = 'o';
            curveData.legend = 'Pre-Lesion';
            curveData.xData = [];
            app.plotData.pre.data(1) = curveData;
            % A pre-lesion sampled curve should always be in position 1
        end
        if (~isVectorEmptyOrZero(app.fittedCurvePaStressOnly))
            curveData = struct();
            curveData.x = app.fittedTimePaStressOnly;
            curveData.y = app.fittedCurvePaStressOnly;
            curveData.color = 'm';
            curveData.shape = '-';
            curveData.legend = 'Pre-Lesion Fitted';
            curveData.xData = [];
            app.plotData.pre.data(2) = curveData;
            % A pre-lesion fitted curve should always be in position 2
        end
        if (~isVectorEmptyOrZero(app.entryCurveStressOnly))
            curveData = struct();
            curveData.x = app.plotXEntryStressOnly;
            curveData.y = app.entryCurveStressOnly;
            curveData.color = shadesOfBlue(app.currentStenosisID,:);
            curveData.shape = '^';
            curveData.legend = 'Entry';
            curveData.legend = strcat(curveData.legend, ' # ', num2str(app.currentStenosisID));
            curveData.xData = [];
            switch app.currentStenosisID
                case 1
                    app.plotData.pre.data(3) = curveData;
                case 2
                    curveData.shape = 'square';
                    app.plotData.pre.data(5) = curveData;
                case 3
                    customShape = 'diamond';
                    curveData.shape = customShape;
                    app.plotData.pre.data(7) = curveData;
                case 4
                    customShape = 'hexagram';
                    curveData.shape = customShape;
                    app.plotData.pre.data(9) = curveData;
                case 5
                    customShape = '*';
                    curveData.shape = customShape;
                    app.plotData.pre.data(11) = curveData;
            end
            % An entry sampled curve should always be in position 3, 5 and 7
        end
        if (~isVectorEmptyOrZero(app.fittedCurveEntryStressOnly))
            curveData = struct();
            curveData.x = app.fittedTimeEntryStressOnly;
            curveData.y = app.fittedCurveEntryStressOnly;
            curveData.color = shadesOfBlue(app.currentStenosisID,:);
            curveData.shape = '-';
            curveData.legend = 'Entry Fitted';
            curveData.legend = strcat(curveData.legend, ' # ', num2str(app.currentStenosisID));
            curveData.xData = [];
            switch app.currentStenosisID
                case 1
                    app.plotData.pre.data(4) = curveData;
                case 2
                    if (~isequal(app.plotData.pre.data(4).y, curveData.y))
                        app.plotData.pre.data(6) = curveData;
                    end
                case 3
                    if (~isequal(app.plotData.pre.data(6).y, curveData.y))
                        app.plotData.pre.data(8) = curveData;
                    end
                case 4
                    if (~isequal(app.plotData.pre.data(8).y, curveData.y))
                        app.plotData.pre.data(10) = curveData;
                    end
                case 5
                    if (~isequal(app.plotData.pre.data(10).y, curveData.y))
                        app.plotData.pre.data(12) = curveData;
                    end
            end
            % An entry sampled curve should always be in position 4, 6, and 8
        end
    end
    
    if (strcmp(lesionType, 'post') || strcmp(lesionType, 'exit'))
        if (~isVectorEmptyOrZero(app.pdCurveStressOnly))
            curveData = struct();
            curveData.x = app.plotXPostStressOnly;
            curveData.y = app.pdCurveStressOnly;
            curveData.color = 'm';
            curveData.shape = 'o';
            curveData.legend = 'Post-Lesion';
            curveData.xData = [];
            app.plotData.post.data(1) = curveData;
            % A post-lesion sampled curve should always be in position 1
        end
        if (~isVectorEmptyOrZero(app.fittedCurvePdStressOnly))
            curveData = struct();
            curveData.x = app.fittedTimePdStressOnly;
            curveData.y = app.fittedCurvePdStressOnly;
            curveData.color = 'm';
            curveData.shape = '-';
            curveData.legend = 'Post-Lesion Fitted';
            curveData.xData = [];
            app.plotData.post.data(2) = curveData;
            % A post-lesion fitted curve should always be in position 2
        end
        if (~isVectorEmptyOrZero(app.exitCurveStressOnly))
            curveData = struct();
            curveData.x = app.plotXExitStressOnly;
            curveData.y = app.exitCurveStressOnly;
            curveData.color = shadesOfBlue(app.currentStenosisID,:);
            curveData.shape = '^';
            curveData.legend = 'Exit';
            curveData.legend = strcat(curveData.legend, ' # ', num2str(app.currentStenosisID));
            curveData.xData = [];
            switch app.currentStenosisID
                case 1
                    app.plotData.post.data(3) = curveData;
                case 2
                    curveData.shape = 'square';
                    app.plotData.post.data(5) = curveData;
                case 3
                    customShape = 'diamond';
                    curveData.shape = customShape;
                    app.plotData.post.data(7) = curveData;
                case 4
                    customShape = 'hexagram';
                    curveData.shape = customShape;
                    app.plotData.post.data(9) = curveData;
                case 5
                    customShape = '*';
                    curveData.shape = customShape;
                    app.plotData.post.data(11) = curveData;
            end
            % An exit sampled curve should always be in position 3, 5 and 7
        end
        if (~isVectorEmptyOrZero(app.fittedCurveExitStressOnly))
            curveData = struct();
            curveData.x = app.fittedTimeExitStressOnly;
            curveData.y = app.fittedCurveExitStressOnly;
            curveData.color = shadesOfBlue(app.currentStenosisID,:);
            curveData.shape = '-';
            curveData.legend = 'Exit Fitted';
            curveData.legend = strcat(curveData.legend, ' # ', num2str(app.currentStenosisID));
            curveData.xData = [];
            switch app.currentStenosisID
                case 1
                    app.plotData.post.data(4) = curveData;
                case 2
                    if (~isequal(app.plotData.post.data(4).y, curveData.y))
                        app.plotData.post.data(6) = curveData;
                    end
                case 3
                    if (~isequal(app.plotData.post.data(6).y, curveData.y))
                        app.plotData.post.data(8) = curveData;
                    end
                case 4
                    if (~isequal(app.plotData.post.data(8).y, curveData.y))
                        app.plotData.post.data(10) = curveData;
                    end
                case 5
                    if (~isequal(app.plotData.post.data(10).y, curveData.y))
                        app.plotData.post.data(12) = curveData;
                    end
            end
            % An exit sampled curve should always be in position 4, 6 and 8
        end
    end
end
function drawCurve(app, lesionType, studyType)

    if (strcmp(studyType,'stress'))
        getStressCurve(app,lesionType, app.viewMode);
    elseif (strcmp(studyType,'rest'))
        getRestCurve(app,lesionType, app.viewMode);
    elseif (strcmp(studyType,'stressOnly'))
        getStressOnlyCurve(app, lesionType);
    elseif (strcmp(studyType,'wing'))
        getWingCurve(app, lesionType);
    end

end

function getStressCurve(app, lesionType, mode)
    if (strcmp(lesionType, 'pre'))
        minY = -50;
        if (max(app.paCurve) > 500)
            maxY = max(app.paCurve) + 30;
        else
            maxY = 500;
        end
        if isrow(app.plotXRest)
            app.plotXRest = app.plotXRest';
        end
        if isrow(app.timePoints)
            app.timePoints = app.timePoints';
        end
        app.plotX = app.timePoints;
        app.paPlotArea.XLabel.String = sprintf('Time(%s)', app.timeUnit);
        app.paPlotArea.XLim = [0 max(app.timePoints)];
        app.paPlotArea.XTick = [0:max(app.timePoints)/10:max(app.timePoints)];
        app.paPlotArea.XTick = cast(app.paPlotArea.XTick, 'int16');
        app.paPlotArea.YLim = [minY maxY];
        interval = cast((maxY + (-minY))/5, 'int16');
        % app.paPlotArea.YTick = [minY:interval:maxY];
        app.paPlotArea.YTick = [cast(minY,'int16'):interval:cast(maxY,'int16')];
        if (isempty(app.paCurveRest))
            if (strcmp(mode, 'Dark'))
                plot(app.paPlotArea, app.plotX, app.paCurve, 'yo');
            else
                plot(app.paPlotArea, app.plotX, app.paCurve, 'mo');
            end
        else
            if (strcmp(mode, 'Dark'))
                plot(app.paPlotArea, app.plotX, app.paCurve, 'yo', app.plotXRest, app.paCurveRest, 'ws');
                legend(app.paPlotArea,'Pre-Lesion Sampled','Pre-Rest', 'TextColor','white');
            else
                plot(app.paPlotArea, app.plotX, app.paCurve, 'mo', app.plotXRest, app.paCurveRest, 'bs');
                legend(app.paPlotArea,'Pre-Lesion Sampled','Pre-Rest', 'TextColor','black');
            end
        end
    elseif (strcmp(lesionType, 'post'))
        minY = -50;
        if (max(app.paCurve) > 500)
            maxY = max(app.pdCurve) + 30;
        else
            maxY = 500;
        end
        if isrow(app.plotXRest)
            app.plotXRest = app.plotXRest';
        end
        if isrow(app.timePoints)
            app.timePoints = app.timePoints';
        end
        app.plotX = app.timePoints;
        app.pdPlotArea.XLabel.String = sprintf('Time(%s)', app.timeUnit);
        app.pdPlotArea.XLim = [0 max(app.timePoints)];
        app.pdPlotArea.XTick = [0:max(app.timePoints)/10:max(app.timePoints)];
        app.pdPlotArea.XTick = cast(app.paPlotArea.XTick, 'int16');
        app.pdPlotArea.YLim = [minY maxY];
        interval = cast((maxY + (minY))/5, 'int16');
        app.pdPlotArea.YTick = [cast(minY,'int16'):interval:cast(maxY,'int16')];
        if(isempty(app.pdCurveRest))
            if (strcmp(mode, 'Dark'))
                plot(app.pdPlotArea, app.plotX, app.pdCurve, 'yo');
            else
                plot(app.pdPlotArea, app.plotX, app.pdCurve, 'mo');
            end
        else
            if (strcmp(mode, 'Dark'))
                plot(app.pdPlotArea, app.plotX, app.pdCurve, 'yo', app.plotXRest, app.pdCurveRest, 'ws');
                legend(app.pdPlotArea,'Post-Lesion Sampled','Post-Rest', 'TextColor','white');
            else
                plot(app.pdPlotArea, app.plotX, app.pdCurve, 'mo', app.plotXRest, app.pdCurveRest, 'bs');
                legend(app.pdPlotArea,'Post-Lesion Sampled','Post-Rest', 'TextColor','black');
            end
        end
    end
end

function getRestCurve(app, lesionType, mode)
    if (strcmp(lesionType, 'pre'))
        minY = -50;
        if (max(app.paCurveRest) > 500)
            maxY = max(app.paCurveRest) + 30;
        else
            maxY = 500;
        end
        if isrow(app.timePointsRest)
            app.timePointsRest = app.timePointsRest';
        end
        app.plotXRest = app.timePointsRest;
        app.paPlotArea.XLabel.String = sprintf('Time(%s)', app.timeUnitRest);
        app.paPlotArea.XLim = [0 max(app.timePointsRest)];
        app.paPlotArea.XTick = [0:max(app.timePointsRest)/10:max(app.timePointsRest)];
        app.paPlotArea.XTick = cast(app.paPlotArea.XTick, 'int16');
        app.paPlotArea.YLim = [minY maxY];
        interval = cast((maxY + (-minY))/5, 'int16');
        % app.paPlotArea.YTick = [minY:interval:maxY];
        app.paPlotArea.YTick = [cast(minY,'int16'):interval:cast(maxY,'int16')];
        if (isempty(app.paCurve))
            if (strcmp(mode, 'Dark'))
                plot(app.paPlotArea, app.plotXRest, app.paCurveRest, 'ws');
            else
                plot(app.paPlotArea, app.plotXRest, app.paCurveRest, 'bs');
            end
        else
            if (strcmp(mode, 'Dark'))
                plot(app.paPlotArea, app.plotXRest, app.paCurveRest, 'ws', app.plotX, app.paCurve, 'yo');
                legend(app.paPlotArea,'Pre-Rest','Pre-Lesion Sampled', 'TextColor','white');
            else
                plot(app.paPlotArea, app.plotXRest, app.paCurveRest, 'bs', app.plotX, app.paCurve, 'mo');
                legend(app.paPlotArea,'Pre-Rest','Pre-Lesion Sampled', 'TextColor','black');
            end
        end
    elseif (strcmp(lesionType, 'post'))
        minY = -50;
        if (max(app.pdCurveRest) > 500)
            maxY = max(app.pdCurveRest) + 30;
        else
            maxY = 500;
        end
        if isrow(app.timePointsRest)
            app.timePointsRest = app.timePointsRest';
        end
        app.plotXRest = app.timePointsRest;
        app.pdPlotArea.XLabel.String = sprintf('Time(%s)', app.timeUnitRest);
        app.pdPlotArea.XLim = [0 max(app.timePointsRest)];
        app.pdPlotArea.XTick = [0:max(app.timePointsRest)/10:max(app.timePointsRest)];
        app.pdPlotArea.XTick = cast(app.paPlotArea.XTick, 'int16');
        app.pdPlotArea.YLim = [minY maxY];
        interval = cast((maxY + (minY))/5, 'int16');
        app.pdPlotArea.YTick = [cast(minY,'int16'):interval:cast(maxY,'int16')];
        if (isempty(app.pdCurve))
            if (strcmp(mode, 'Dark'))
                plot(app.pdPlotArea, app.plotXRest, app.pdCurveRest, 'ws');
            else
                plot(app.pdPlotArea, app.plotXRest, app.pdCurveRest, 'bs');
            end
        else
            if (strcmp(mode, 'Dark'))
                plot(app.pdPlotArea, app.plotXRest, app.pdCurveRest, 'ws', app.plotX, app.pdCurve, 'yo');
                legend(app.pdPlotArea,'Post-Rest','Post-Lesion Sampled', 'TextColor','white');
            else
                plot(app.pdPlotArea, app.plotXRest, app.pdCurveRest, 'bs', app.plotX, app.pdCurve, 'mo');
                legend(app.pdPlotArea,'Post-Rest','Post-Lesion Sampled', 'TextColor','black');
            end
        end
    end
end

function getStressOnlyCurve(app, lesionType)
    if (strcmp(lesionType, 'pre'))
        minY = -50;
        if (max(app.paCurveStressOnly) > 500)
            maxY = max(app.paCurveStressOnly) + 30;
        else
            maxY = 500;
        end
        if isrow(app.timePointsStressOnly)
            app.timePointsStressOnly = app.timePointsStressOnly';
        end
        app.plotXPreStressOnly = app.paTimePointsStressOnly;
        app.paPlotAreaStressOnly.XLabel.String = sprintf('Time(%s)', app.timeUnitStressOnly);
        app.paPlotAreaStressOnly.XLim = [0 max(app.timePointsStressOnly)];
        app.paPlotAreaStressOnly.XTick = [0:max(app.timePointsStressOnly)/10:max(app.timePointsStressOnly)];
        app.paPlotAreaStressOnly.XTick = cast(app.paPlotAreaStressOnly.XTick, 'int16');
        app.paPlotAreaStressOnly.YLim = [minY maxY];
        app.paPlotAreaStressOnly.YTick = getSliderTicks(app.yAxisLimitMin, maxY, app.maxYAxisInterval);
        
        buildPlot(app, 'pre');
        showPlot(app);

    elseif (strcmp(lesionType, 'post'))
        minY = -50;
        if (max(app.pdCurveStressOnly) > 500)
            maxY = max(app.pdCurveStressOnly) + 30;
        else
            maxY = 500;
        end
        if isrow(app.timePointsStressOnly)
            app.timePointsStressOnly = app.timePointsStressOnly';
        end
        app.plotXPostStressOnly = app.pdTimePointsStressOnly;
        app.paPlotAreaStressOnly.XLabel.String = sprintf('Time(%s)', app.timeUnitStressOnly);
        app.pdPlotAreaStressOnly.XLim = [0 max(app.timePointsStressOnly)];
        app.pdPlotAreaStressOnly.XTick = [0:max(app.timePointsStressOnly)/10:max(app.timePointsStressOnly)];
        app.pdPlotAreaStressOnly.XTick = cast(app.paPlotAreaStressOnly.XTick, 'int16');
        app.pdPlotAreaStressOnly.YLim = [minY maxY];
        app.pdPlotAreaStressOnly.YTick = getSliderTicks(app.yAxisLimitMin, maxY, app.maxYAxisInterval);
        
        buildPlot(app, 'post');
        showPlot(app);
        
    elseif (strcmp(lesionType, 'entry'))
        
        minY = -50;
        if (max(app.entryCurveStressOnly) > 500)
            maxY = max(app.entryCurveStressOnly) + 30;
        else
            maxY = 500;
        end
        if isrow(app.timePointsStressOnly)
            app.timePointsStressOnly = app.timePointsStressOnly';
        end
        
        app.plotXEntryStressOnly = app.entryTimePointStressOnly;
        app.paPlotAreaStressOnly.XLabel.String = sprintf('Time(%s)', app.timeUnitStressOnly);
        app.paPlotAreaStressOnly.XLim = [0 max(app.timePointsStressOnly)];
        app.paPlotAreaStressOnly.XTick = [0:max(app.timePointsStressOnly)/10:max(app.timePointsStressOnly)];
        app.paPlotAreaStressOnly.XTick = cast(app.paPlotAreaStressOnly.XTick, 'int16');
        app.paPlotAreaStressOnly.YLim = [minY maxY];
        app.paPlotAreaStressOnly.YTick = getSliderTicks(app.yAxisLimitMin, maxY, app.maxYAxisInterval);
        
        buildPlot(app, 'entry');
        showPlot(app);
        
    elseif (strcmp(lesionType, 'exit'))
        
        minY = -50;
        if (max(app.exitCurveStressOnly) > 500)
            maxY = max(app.exitCurveStressOnly) + 30;
        else
            maxY = 500;
        end
        if isrow(app.timePointsStressOnly)
            app.timePointsStressOnly = app.timePointsStressOnly';
        end
        
        app.plotXExitStressOnly = app.exitTimePointStressOnly;
        app.pdPlotAreaStressOnly.XLabel.String = sprintf('Time(%s)', app.timeUnitStressOnly);
        app.pdPlotAreaStressOnly.XLim = [0 max(app.timePointsStressOnly)];
        app.pdPlotAreaStressOnly.XTick = [0:max(app.timePointsStressOnly)/10:max(app.timePointsStressOnly)];
        app.pdPlotAreaStressOnly.XTick = cast(app.pdPlotAreaStressOnly.XTick, 'int16');
        app.pdPlotAreaStressOnly.YLim = [minY maxY];
        app.pdPlotAreaStressOnly.YTick = getSliderTicks(app.yAxisLimitMin, maxY, app.maxYAxisInterval);
        
        buildPlot(app, 'exit');
        showPlot(app);
        
    end
    
end

function getWingCurve(app, lesionType)
    if (strcmp(lesionType, 'pre'))
        minY = -50;
        if (max(app.preCurve) > 500)
            maxY = max(app.preCurve) + 30;
        else
            maxY = 500;
        end
        if isrow(app.timePoints)
            app.timePoints = app.timePoints';
        end
        app.plotXPre = app.preLesionTimePoints;
        app.preLesionPlotArea.XLabel.String = sprintf('Time(%s)', app.timeUnit);
        app.preLesionPlotArea.XLim = [0 max(app.timePoints)];
        app.preLesionPlotArea.XTick = [0:max(app.timePoints)/10:max(app.timePoints)];
        app.preLesionPlotArea.XTick = cast(app.preLesionPlotArea.XTick, 'int16');
        app.preLesionPlotArea.YLim = [minY maxY];
        app.preLesionPlotArea.YTick = getSliderTicks(app.yAxisLimitMin, maxY, app.maxYAxisInterval);
        
        if (isVectorEmptyOrZero(app.fittedCurvePre))
            plot(app.preLesionPlotArea, app.plotXPre, app.preCurve, 'bo');
            legend(app.preLesionPlotArea,'Pre-Lesion Sampled', 'TextColor','black');
        else
            plot(app.preLesionPlotArea, app.plotXPre, app.preCurve, 'bo', app.fittedTimePre, app.fittedCurvePre, 'b-');
            legend(app.preLesionPlotArea,'Pre-Lesion Sampled', 'Pre-Lesion Fitted');
        end

    elseif (strcmp(lesionType, 'post'))
        minY = -50;
        if (max(app.postCurve) > 500)
            maxY = max(app.postCurve) + 30;
        else
            maxY = 500;
        end
        if isrow(app.timePoints)
            app.timePoints = app.timePoints';
        end
        app.plotXPost = app.postLesionTimePoints;
        app.postLesionPlotArea.XLabel.String = sprintf('Time(%s)', app.timeUnit);
        app.postLesionPlotArea.XLim = [0 max(app.timePoints)];
        app.postLesionPlotArea.XTick = [0:max(app.timePoints)/10:max(app.timePoints)];
        app.postLesionPlotArea.XTick = cast(app.postLesionPlotArea.XTick, 'int16');
        app.postLesionPlotArea.YLim = [minY maxY];
        app.postLesionPlotArea.YTick = getSliderTicks(app.yAxisLimitMin, maxY, app.maxYAxisInterval);
        
        if (isVectorEmptyOrZero(app.fittedCurvePost))
            plot(app.postLesionPlotArea, app.plotXPost, app.postCurve, 'ro');
            legend(app.postLesionPlotArea,'Post-Lesion Sampled', 'TextColor','black');
        else
            plot(app.postLesionPlotArea, app.plotXPost, app.postCurve, 'ro', app.fittedTimePost, app.fittedCurvePost, 'r-');
            legend(app.postLesionPlotArea,'Post-Lesion Sampled', 'Post-Lesion Fitted');
        end

    elseif (strcmp(lesionType, 'whcPre'))
        minY = min(app.whcPreCurve) - 30;
        maxY = max(app.whcPreCurve) + 30;
        yInterval = 10;
        if isrow(app.whcTimePoints)
            app.whcTimePoints = app.whcTimePoints';
        end
        app.plotXPre = app.whcPreLesionTimePoints;
        app.preLesionPlotArea.XLabel.String = sprintf('Time(%s)', app.whcTimeUnit);
        app.preLesionPlotArea.XLim = [0 max(app.whcPreLesionTimePoints)];
        app.preLesionPlotArea.XTick = [0:max(app.whcPreLesionTimePoints)/10:max(app.whcPreLesionTimePoints)];
        app.preLesionPlotArea.XTick = cast(app.preLesionPlotArea.XTick, 'int16');
        app.preLesionPlotArea.YLim = [minY maxY];
        app.preLesionPlotArea.YTick = getSliderTicks(minY, maxY, yInterval);
        app.preLesionPlotArea.YTick = cast(app.preLesionPlotArea.YTick, 'int16');
        
        if (isVectorEmptyOrZero(app.whcFittedTimePre))
            plot(app.preLesionPlotArea, app.plotXPre, app.whcPreCurve, 'bo');
            legend(app.preLesionPlotArea,'Pre-Lesion Sampled', 'TextColor','black');
        else
            plot(app.preLesionPlotArea, app.plotXPre, app.whcPreCurve, 'bo', app.whcFittedTimePre, app.whcFittedCurvePre, 'b-');
            legend(app.preLesionPlotArea,'Pre-Lesion Sampled', 'Pre-Lesion Fitted');
        end
    
    elseif (strcmp(lesionType, 'whcPost'))
        minY = min(app.whcPostCurve) - 30;
        maxY = max(app.whcPostCurve) + 30;
        yInterval = 10;
        if isrow(app.whcTimePoints)
            app.whcTimePoints = app.whcTimePoints';
        end
        app.plotXPost = app.whcPostLesionTimePoints;
        app.postLesionPlotArea.XLabel.String = sprintf('Time(%s)', app.whcTimeUnit);
        app.postLesionPlotArea.XLim = [0 max(app.whcPostLesionTimePoints)];
        app.postLesionPlotArea.XTick = [0:max(app.whcPostLesionTimePoints)/10:max(app.whcPostLesionTimePoints)];
        app.postLesionPlotArea.XTick = cast(app.postLesionPlotArea.XTick, 'int16');
        app.postLesionPlotArea.YLim = [minY maxY];
        app.postLesionPlotArea.YTick = getSliderTicks(minY, maxY, yInterval);
        app.postLesionPlotArea.YTick = cast(app.postLesionPlotArea.YTick, 'int16');

        if (isVectorEmptyOrZero(app.whcFittedTimePost))
            plot(app.postLesionPlotArea, app.plotXPost, app.whcPostCurve, 'bo');
            legend(app.postLesionPlotArea,'Post-Lesion Sampled', 'TextColor','black');
        else
            plot(app.postLesionPlotArea, app.plotXPost, app.whcPostCurve, 'bo', app.whcFittedTimePost, app.whcFittedCurvePost, 'b-');
            legend(app.postLesionPlotArea,'Post-Lesion Sampled', 'Pre-Lesion Fitted');
        end

    elseif (strcmp(lesionType, 'whcPreVn'))
        minY = 1000;
        maxY = max(app.meanFlowVelocityPre) + 300;
        yInterval = (maxY - minY) / 10;
        if isrow(app.whcTimePoints)
            app.whcTimePoints = app.whcTimePoints';
        end
        app.plotXPre = app.whcPreLesionTimePoints;
        app.preLesionPlotArea.XLabel.String = sprintf('Time(%s)', app.whcTimeUnit);
        app.preLesionPlotArea.XLim = [0 max(app.whcPreLesionTimePoints)];
        app.preLesionPlotArea.XTick = [0:max(app.whcPreLesionTimePoints)/10:max(app.whcPreLesionTimePoints)];
        app.preLesionPlotArea.XTick = cast(app.preLesionPlotArea.XTick, 'int16');
        app.preLesionPlotArea.YLim = [minY maxY];
        app.preLesionPlotArea.YTick = getSliderTicks(minY, maxY, yInterval);
        app.preLesionPlotArea.YLabel.String = 'Flow Velocity';
        % app.preLesionPlotArea.YTick = cast(app.preLesionPlotArea.YTick, 'int16');
        
        plot(app.preLesionPlotArea, app.plotXPre, app.meanFlowVelocityPre, 'ro');
        legend(app.preLesionPlotArea,'Pre-Lesion Flow Velocity', 'TextColor','black');
    
    elseif (strcmp(lesionType, 'whcPostVn'))
        minY = 1000;
        maxY = max(app.meanFlowVelocityPost) + 300;
        yInterval = (maxY - minY) / 10;
        if isrow(app.whcTimePoints)
            app.whcTimePoints = app.whcTimePoints';
        end
        app.plotXPost = app.whcPostLesionTimePoints;
        app.postLesionPlotArea.XLabel.String = sprintf('Time(%s)', app.whcTimeUnit);
        app.postLesionPlotArea.XLim = [0 max(app.whcPostLesionTimePoints)];
        app.postLesionPlotArea.XTick = [0:max(app.whcPostLesionTimePoints)/10:max(app.whcPostLesionTimePoints)];
        app.postLesionPlotArea.XTick = cast(app.postLesionPlotArea.XTick, 'int16');
        app.postLesionPlotArea.YLim = [minY maxY];
        app.postLesionPlotArea.YTick = getSliderTicks(minY, maxY, yInterval);
        app.postLesionPlotArea.YLabel.String = 'Flow Velocity';
        % app.postLesionPlotArea.YTick = cast(app.postLesionPlotArea.YTick, 'int16');
        
        plot(app.postLesionPlotArea, app.plotXPost, app.meanFlowVelocityPost, 'ro');
        legend(app.postLesionPlotArea,'Pre-Lesion Flow Velocity', 'TextColor','black');
    end
end
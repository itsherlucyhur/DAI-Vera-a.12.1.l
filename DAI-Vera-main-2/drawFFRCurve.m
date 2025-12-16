function drawFFRCurve(app, plotType)

    if (nargin > 1)
        style = plotType;
    else
        style = '-';
    end
    
    if (strcmp(app.viewMode, 'Dark'))
        yyaxis(app.FFRVsSliceLocation,'left');
        app.FFRVsSliceLocation.YLim = [0, 1.2];
        color = [1 1 1];
        marker = "o";
        if (app.reversedALLFFRStressOnly == true)
            plot(app.FFRVsSliceLocation, app.allFFRStressOnlySliceLocations, flip(app.allFFRStressOnly), 'Color', color, 'LineStyle', style, 'Marker', marker);
        else
            plot(app.FFRVsSliceLocation, app.allFFRStressOnlySliceLocations, app.allFFRStressOnly, 'Color', color, 'LineStyle', style, 'Marker', marker);
        end
        hold on;
        yyaxis(app.FFRVsSliceLocation,'right');
        ylabel(app.FFRVsSliceLocation, 'Flow Velocity (cm/s)');
        app.FFRVsSliceLocation.YLim = [0, 100];
        app.FFRVsSliceLocation.YAxis(1).Color = [1 1 1];
        app.FFRVsSliceLocation.YAxis(2).Color = [1 1 1];
        color = [0.9290 0.6940 0.1250];
        marker = "square";
        app.allFlowVelocitiesStressOnly = unique(app.allFlowVelocitiesStressOnly, 'stable');
        app.allFlowVelocitiesSliceLocationsStressOnly = [app.paStressOnly(1), app.allFFRStressOnlySliceLocations];
        app.allFlowVelocitiesSliceLocationsStressOnly = unique(app.allFlowVelocitiesSliceLocationsStressOnly, 'stable');
        if (app.reversedALLFFRStressOnly == true)
            plot(app.FFRVsSliceLocation, app.allFlowVelocitiesSliceLocationsStressOnly, flip(app.allFlowVelocitiesStressOnly), 'Color', color, 'LineStyle', style, 'Marker', marker);
        else
            plot(app.FFRVsSliceLocation, app.allFlowVelocitiesSliceLocationsStressOnly, app.allFlowVelocitiesStressOnly, 'Color', color, 'LineStyle', style, 'Marker', marker);
        end
        
        legend(app.FFRVsSliceLocation, 'FFR','Flow Velocity');

        hold off;
        
    else
        yyaxis(app.FFRVsSliceLocation,'left');
        app.FFRVsSliceLocation.YLim = [0, 1.2];
        color = [0 0 1];
        marker = "o";
        if (app.reversedALLFFRStressOnly == true)
            plot(app.FFRVsSliceLocation, app.allFFRStressOnlySliceLocations, flip(app.allFFRStressOnly), 'Color', color, 'LineStyle', style, 'Marker', marker);
        else
            plot(app.FFRVsSliceLocation, app.allFFRStressOnlySliceLocations, app.allFFRStressOnly, 'Color', color, 'LineStyle', style, 'Marker', marker);
        end
        hold on;
        yyaxis(app.FFRVsSliceLocation,'right');
        ylabel(app.FFRVsSliceLocation, 'Flow Velocity  (cm/s)');
        app.FFRVsSliceLocation.YLim = [0, 100];
        app.FFRVsSliceLocation.YAxis(1).Color = [0 0 0];
        app.FFRVsSliceLocation.YAxis(2).Color = [0 0 0];
        color = [0.8500 0.3250 0.0980];
        marker = "square";
        if (strcmp(app.GraphAppearanceDropDown.Value, 'Smooth Line') == false)
            app.allFlowVelocitiesStressOnly = unique(app.allFlowVelocitiesStressOnly, 'stable');
            app.allFlowVelocitiesSliceLocationsStressOnly = [app.paStressOnly(1), app.allFFRStressOnlySliceLocations];
            app.allFlowVelocitiesSliceLocationsStressOnly = unique(app.allFlowVelocitiesSliceLocationsStressOnly, 'stable');
        end
        if (app.reversedALLFFRStressOnly == true)
            plot(app.FFRVsSliceLocation, app.allFlowVelocitiesSliceLocationsStressOnly, flip(app.allFlowVelocitiesStressOnly), 'Color', color, 'LineStyle', style, 'Marker', marker);
        else

            plot(app.FFRVsSliceLocation, app.allFlowVelocitiesSliceLocationsStressOnly, app.allFlowVelocitiesStressOnly, 'Color', color, 'LineStyle', style, 'Marker', marker);
        end

        legend(app.FFRVsSliceLocation, 'FFR','Flow Velocity');
        
        hold off;
    
    end
end
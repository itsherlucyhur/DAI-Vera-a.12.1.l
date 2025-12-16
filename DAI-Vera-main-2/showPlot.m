function showPlot(app)
    
    smallestFontSize = 6; %This is 80% of default font size 8.10
    
    % Loop through to show all the plots in Pre Lesion Axis
    if (isfield(app.plotData, 'pre'))
        cla(app.paPlotAreaStressOnly);
        if (~isempty(app.plotData.pre))
            hold(app.paPlotAreaStressOnly, 'on');
            for i = 1:max(size(app.plotData.pre.data))
                if (~ismember(i,app.plotIDsToRemoveFromPlotArea))
                    x = app.plotData.pre.data(i).x;
                    y = app.plotData.pre.data(i).y;
                    color = app.plotData.pre.data(i).color;
                    shape = app.plotData.pre.data(i).shape;
                    lengedColor = 'black';
                    if (strcmp(app.viewMode, 'Dark'))
                        lengedColor = 'white';
                        if (color(1) == 'm')
                            color = strrep(color,'m','y');
                        elseif (color(1) == 'b')
                            color = strrep(color,'b','w');
                        end
                    end
                    legendLabel = app.plotData.pre.data(i).legend;
                    if (~isempty(x))
                        if (mod(i, 2) == 1)
                            xData = plot(app.paPlotAreaStressOnly, x, y, 'Color', color, 'Marker', shape, 'LineStyle', 'none', 'DisplayName', legendLabel);
                        else
                            xData = plot(app.paPlotAreaStressOnly, x, y, 'Color', color, 'LineStyle', shape, 'DisplayName', '');
                        end
                        set(xData, 'ButtonDownFcn', @(src, event) getPlotID(src, app));
                        xticks(app.paPlotAreaStressOnly,[1:2:max(x)]);
                        xticklabels(app.paPlotAreaStressOnly, arrayfun(@num2str, [1:2:max(x)], 'UniformOutput', 0));
                        app.plotData.pre.data(i).xData = xData.XData;
                        lgd = legend(app.paPlotAreaStressOnly, 'show', 'TextColor', lengedColor);
                        if (app.numberOfStenosis > 1)
                            lgd.NumColumns = app.numberOfStenosis + 1;
                            lgd.FontSize = smallestFontSize;
                            if (app.numberOfStenosis > 4)
                                lgd.FontSize = smallestFontSize - 1.5;
                            end
                            lgd.Location = 'best';
                        end
                    end
                end
            end
            hold(app.paPlotAreaStressOnly, 'off');
        end
    end
    
    % Loop through to show all the plots in Post Lesion Axis
    if (isfield(app.plotData, 'post'))
        cla(app.pdPlotAreaStressOnly);
        if (~isempty(app.plotData.post))
            hold(app.pdPlotAreaStressOnly, 'on');
            for i = 1:max(size(app.plotData.post.data))
                if (~ismember(i,app.plotIDsToRemoveFromPlotArea))
                    x = app.plotData.post.data(i).x;
                    y = app.plotData.post.data(i).y;
                    color = app.plotData.post.data(i).color;
                    shape = app.plotData.post.data(i).shape;
                    lengedColor = 'black';
                    if (strcmp(app.viewMode, 'Dark'))
                        lengedColor = 'white';
                        if (color(1) == 'm')
                            color = strrep(color,'m','y');
                        elseif (color(1) == 'b')
                            color = strrep(color,'b','w');
                        end
                    end
                    legendLabel = app.plotData.post.data(i).legend;
                    if (~isempty(x))
                        if (mod(i, 2) == 1)
                            xData = plot(app.pdPlotAreaStressOnly, x, y, 'Color', color, 'Marker', shape, 'LineStyle', 'none', 'DisplayName', legendLabel);
                        else
                            xData = plot(app.pdPlotAreaStressOnly, x, y, 'Color', color, 'LineStyle', shape, 'DisplayName', '');
                        end
                        set(xData, 'ButtonDownFcn', @(src, event) getPlotID(src, app));
                        xticks(app.pdPlotAreaStressOnly,[1:2:max(x)]);
                        xticklabels(app.pdPlotAreaStressOnly, arrayfun(@num2str, [1:2:max(x)], 'UniformOutput', 0));
                        app.plotData.post.data(i).xData = xData.XData;
                        lgd = legend(app.pdPlotAreaStressOnly, 'show', 'TextColor', lengedColor);
                        if (app.numberOfStenosis > 1)
                            lgd.NumColumns = app.numberOfStenosis + 1;
                            lgd.FontSize = smallestFontSize;
                            if (app.numberOfStenosis > 4)
                                lgd.FontSize = smallestFontSize - 1.5;
                            end
                            lgd.Location = 'best';
                        end
                    end
                end
            end
            hold(app.pdPlotAreaStressOnly, 'off');
        end
    end
        
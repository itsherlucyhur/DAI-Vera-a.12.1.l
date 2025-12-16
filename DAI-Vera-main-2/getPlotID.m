function getPlotID(line, app)

    plotName = get(line, 'DisplayName');
    if (contains(plotName, 'Pre'))
        app.plotToRemovePoint = 'pre';
    elseif (contains(plotName, 'Post'))
        app.plotToRemovePoint = 'post';
    elseif (contains(plotName, 'Entry'))
        app.plotToRemovePoint = strcat('entry',plotName(end));
    elseif (contains(plotName, 'Exit'))
        app.plotToRemovePoint = strcat('exit',plotName(end));
    end
    
end


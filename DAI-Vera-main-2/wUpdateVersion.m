function wUpdateVersion(app)
    newVersion = app.versionNumberDAIWing;
    panelTitle = ['Dynamic Angiographic Imaging (DAI) - Wing', '   ', newVersion];
    figureTitle = ['DAI - Wing', ' ', newVersion];
    
    app.DAIWingUIFigure.Name = figureTitle;

    app.DynamicAngiographicImagingDAIWingPanel.Title = panelTitle;

end
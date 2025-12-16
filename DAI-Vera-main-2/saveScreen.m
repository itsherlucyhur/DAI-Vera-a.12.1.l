function saveScreen(app)
    left = app.UIFigure.Position(1);
    bottom = app.UIFigure.Position(2);
    width = app.UIFigure.Position(3);
    height = app.UIFigure.Position(4);
    top = bottom + height;
    captureScreen(left-1, top-1, width, height);
end
function interval = getPlotInterval(minY, maxY)

    interval = cast((maxY + (-minY))/5, 'int16');

end
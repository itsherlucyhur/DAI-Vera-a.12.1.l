function [interPolatedY, interPolatedX] = getInterpolatedCurve(x,y,limit)
    interPolatedX = linspace(min(x),max(x),limit);
    interPolatedY = interp1(x,y,interPolatedX);
end

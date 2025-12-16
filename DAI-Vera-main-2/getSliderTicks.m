function tickValues = getSliderTicks(minValue, maxValue, fixedInterval)

    if (nargin > 2)
        interval = fixedInterval;
        primaryInterval = 25;
    else
        primaryInterval = 5;
        interval = primaryInterval;
        if ((maxValue - minValue) >= 99)
            interval = cast((maxValue - minValue + 1) / 10,"double");
            interval = interval - rem(interval, 10);
        else
            interval = round(maxValue / 10);
        end
    end
    tickValues = minValue:interval:maxValue;
    if (tickValues(end) ~= maxValue)
        if (maxValue - tickValues(end) < primaryInterval)
            tickValues(end) = round(maxValue);
        else
            tickValues = [tickValues, round(maxValue)];
        end
    end
end
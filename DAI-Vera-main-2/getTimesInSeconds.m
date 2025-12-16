function times = getTimesInSeconds(times)
    times = diff(times);
    times = cumsum(times);
    [~, m, s] = hms(times);
    for i = 1:max(size(s))
        if (m(i) >= 1)
            s(i) = m(i) * 60 + s(i);
        end
    end
    clear times;
    if (size(s,1) > size(s,2))
        times = [0, s'];
    else
        times = [0, s];
    end
end
function baselineSubtractedCurve = subtractBaseline(tdc, position)

if (ndims(tdc) > 1)
    tdc = tdc';
end

baseline = mean(tdc(1:position));
baselineSubtractedCurve = tdc - baseline;

if (ndims(baselineSubtractedCurve) > 1)
    baselineSubtractedCurve = baselineSubtractedCurve';
end

end
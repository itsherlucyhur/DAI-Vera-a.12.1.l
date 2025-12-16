function auc = getAreaUnderCurve(tdc, time)
    auc = trapz(time, tdc);
end

% function fineTDC = getMoreSamples(numOfSampleTaken)
%     y = 1:numel(tdc);
%     yFine = linspace(y(1), y(end), numOfSampleTaken);
%     tdc2 = interp1(y, tdc, yFine);
%     x = 1:numel(time);
%     xFine = linspace(x(1), x(end), numOfSampleTaken);
%     time2 = interp1(x, time, xFine);
%     auc = trapz(time2, tdc2);
% end
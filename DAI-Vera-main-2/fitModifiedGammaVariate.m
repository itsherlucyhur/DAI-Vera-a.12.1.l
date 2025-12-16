% AT is a vector. The every point in AT will be the corresponding point in
% time - contrast arrival time.
% The contrast arrival time is roughly 5th/6th point in the time.
function [fittedData, stretchedTime, k, alpha, beta] = fitModifiedGammaVariate(time, data, K, alpha, beta, numOfDataPointsToConsider, contrastArrivalTime)

initialParameters = [K, alpha, beta];

s = sprintf('Inside fitModifiedGammaVariate()');
logDAI(s);
s = sprintf('Contrast Arrival Time = %d',contrastArrivalTime);
logDAI(s);
s = sprintf('Initial K = %d',K);
logDAI(s);
s = sprintf('Initial alpha = %d',alpha);
logDAI(s);
s = sprintf('Initial beta = %d',beta);
logDAI(s);
s = sprintf('numOfDataPointsToConsider = %d',numOfDataPointsToConsider);
logDAI(s);

% Discard wash-out phase
if (numOfDataPointsToConsider > 0)
    times = time(1:numOfDataPointsToConsider);
    datas = data(1:numOfDataPointsToConsider);
else
    times = time;
    datas = data;
end

s = sprintf('Length of "times" = %d',max(size(times)));
logDAI(s);
s = sprintf('Length of "datas" = %d',max(size(datas)));
logDAI(s);

    function ct = mgv(initialParameters, time)
        tAT = time - time(contrastArrivalTime);
        tAT(tAT < 0) = 0;
        tATalpha = tAT.^initialParameters(2);
        tATbeta = tAT / initialParameters(3);
        tATbeta = -tATbeta;
        tATexp = exp(tATbeta);

        % ct = initialParametersVector(1) * tATalpha .* tATexp;
        sz = 1;
        if (isrow(tAT))
            sz = size(tAT,2); 
        else
            sz = size(tAT,1);
        end
        
        for i = 1:sz
            ct(i) = initialParameters(1) * tATalpha(i) * tATexp(i);
        end
        ct = ct';
    end

% Function Approach:
options = optimoptions('lsqcurvefit', 'MaxFunctionEvaluations', 3000, 'FunctionTolerance', 1e-10);
lowerBound = -Inf;
upperBound = Inf;
estimatedParameters = lsqcurvefit(@mgv, initialParameters, times, datas, lowerBound, upperBound, options);

peakData = max(data);
stretchedTime = linspace(time(1),time(end));
absoluteDifferenceValues = abs(stretchedTime-time(contrastArrivalTime));
minAbsoluteValue = min(absoluteDifferenceValues);
closestIndex = find(absoluteDifferenceValues == minAbsoluteValue);
if (max(size(closestIndex)) > 1)
    closestIndex = closestIndex(1);
end
contrastArrivalTime = closestIndex;
fittedData = mgv(estimatedParameters,stretchedTime);
peakFit = max(fittedData);
thresh = 5;
factor = 1.05;
while(peakData - peakFit > thresh)
    estimatedParameters(1) = estimatedParameters(1) * factor;
    fittedData = mgv(estimatedParameters,stretchedTime);
    peakFit = max(fittedData);
    factor = factor + 0.05;
end

fprintf('Estiamted k = %f, alpha = %f, beta = %f\n', estimatedParameters(1), estimatedParameters(2), estimatedParameters(3));
k = estimatedParameters(1);
alpha = estimatedParameters(2);
beta = estimatedParameters(3);
fittedData = mgv(estimatedParameters, stretchedTime);

end



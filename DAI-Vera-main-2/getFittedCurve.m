function [fittedCurve, fittedTime, baselineSubtractedCurve, rmse, k, alpha, beta] = getFittedCurve(sampleCurve, sampleTime, baseline, washout)
    % Baseline Subtraction/Data Normalization
    if (baseline ~= 0)
        position = baseline;
    else
        position = findBaseline(sampleCurve);
    end
    if (position == 0)
        position = 1;
    end
    baselineSubtractedCurve = subtractBaseline(sampleCurve, position);
        
    % Get Washout Phase's Starting Point
    if (washout ~= 0)
        recirculationPhasePosition = washout;
    else
        recirculationPhasePosition = getStartingPointOfRecirculationPhase(baselineSubtractedCurve, position);
    end
    numOfDataPointsToConsider = recirculationPhasePosition;
    s = sprintf('Basline = %d', position);
    logDAI(s);
    s = sprintf('Washout Position = %d', recirculationPhasePosition);
    logDAI(s);
        
    % Convert time to seconds if time is in milliseconds
    if sampleTime(2) >= 500
        sampleTime = sampleTime / 1000;
    end
        
    % Curve Fitting
    k = 1;
    alpha = 5;
    beta = 1.5;
    if (isrow(sampleTime))
        sampleTime = sampleTime';
    end
    if (isrow(baselineSubtractedCurve))
        baselineSubtractedCurve = baselineSubtractedCurve';
    end
    try
        [fittedCurve, fittedTime, k, alpha, beta] = fitModifiedGammaVariate(sampleTime, baselineSubtractedCurve, k, alpha, beta, numOfDataPointsToConsider, position);
        rmse = sqrt(immse(fittedCurve, linspace(baselineSubtractedCurve(1),baselineSubtractedCurve(end))'));
    catch ME
        throw (ME);
    end
end


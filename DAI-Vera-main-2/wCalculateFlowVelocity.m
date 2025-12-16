function wCalculateFlowVelocity(app)

    % Vera protocol Flow Velocity Calculation
    [app.referenceFlowVelocityPre, app.referenceFlowVelocityPost] = calculateFlowVelocityUsingVeraProtocol(app);
    
    % Wing protocol Flow Velocity Calculation
    [app.meanFlowVelocityPre, app.meanFlowVelocityPost] = calculateFlowVelocityUsingWingProtocol(app);
    
end

function [meanFlowVelocityPre, meanFlowVelocityPost] = calculateFlowVelocityUsingWingProtocol(app)

    % Eq-12
    % Unit of massIdodine is mg.
    massIodine = calculateMassIodine(app);
    
    % Eq-13, Volumetric Flow Rate, Q
    % Unit of Q is mL/Second
    [QPre, QPost] = CalculateMeanFlowRate(app, massIodine);
    
    % Unit of time is second.
    timeEnhancementDurationPre = getEnhancedTimeFromSignal(app.preCurve, app.timePoints);
    timeEnhancementDurationPost = getEnhancedTimeFromSignal(app.postCurve, app.timePoints);
    
    % Eq-14, Blood Volume mixed with Iodine, Vi
    % Unit of Vi is mL.
    preVi = QPre * timeEnhancementDurationPre;
    postVi = QPost * timeEnhancementDurationPost;
    
    % Eq-15, Density of Iodine, Rho
    % Unit of Rho is mg/mL
    rhoPre = massIodine / preVi;
    rhoPost = massIodine / postVi;
    
    % whcPreCurve and whcPostCurve are already sampled based on isotropic voxels
    % and PCA was performed on the isotropic HU profiles to get them. Here
    % we only convert them to their corresponding netFlowVelocity
    
    netFlowVelocityPre = getFlowVelocityFromHUProfile(app, timeEnhancementDurationPre, rhoPre, 'pre');
    netFlowVelocityPost = getFlowVelocityFromHUProfile(app, timeEnhancementDurationPost, rhoPost, 'post');
    
    meanFlowVelocityPre = netFlowVelocityPre;
    meanFlowVelocityPost = netFlowVelocityPost;
    
end

function flowVelocity = getFlowVelocityFromHUProfile(app, timeEnhancementDuration, rho, option)
    
    referencePercentage = app.referencePercentage;
    A = app.areaOfAnIsotropicPixel;
    
    % Convert time to second becase ∇t should be in second
    if (strcmp(option, 'pre'))
        huProfile = app.whcPreCurve;
        timePoints = app.whcPreLesionTimePoints / 1000;  
    elseif (strcmp(option, 'post'))
        huProfile = app.whcPostCurve;
        timePoints = app.whcPostLesionTimePoints / 1000;
    end

    numOfElements = max(size(huProfile));
    flowVelocity = zeros(1, numOfElements);
    maxPercentage = 5 * numOfElements;
    minPercentage = 5;
    interval = 5;
    percentageIndex = minPercentage : interval : maxPercentage;
   
    referenceIndex = find(percentageIndex == referencePercentage);
    
    % Eq-11B, A is area for each isotropic voxel
    for currentIndex = 1 : numOfElements

        deltaT = abs(timePoints(referenceIndex) - timePoints(currentIndex));
        deltaH = abs(huProfile(referenceIndex) - huProfile(currentIndex));
        % Eq-17, Let: slope = ∇HU/∇t. d = conversionFactor, Vt = contrastVolume
        timeRateOfChangeOfTracerMass = (deltaH / deltaT * app.conversionFactor) * (app.contrastVolume * deltaT / timeEnhancementDuration);

        if (currentIndex == referenceIndex && strcmp(option, 'pre'))
            flowVelocity(currentIndex) = app.referenceFlowVelocityPre;
        elseif (currentIndex == referenceIndex && strcmp(option, 'post'))
            flowVelocity(currentIndex) = app.referenceFlowVelocityPost;
        else
            flowVelocity(currentIndex) = timeRateOfChangeOfTracerMass / (rho * A);
        end
    end
end

function [Xall, Yall] = getAllPixelsInClosedContour(X, Y)

    [xGrid, yGrid] = meshgrid(1:512, 1:512);
    xGridFlat = xGrid(:);
    yGridFlat = yGrid(:);
    [in, on] = inpolygon(xGridFlat, yGridFlat, X, Y);
    Xall = xGridFlat(in | on);
    Yall = yGridFlat(in | on);
end

function timeEnhancementDuration = getEnhancedTimeFromSignal(sampleCurve, sampleTime)

    baseLinePosition = findBaseline(sampleCurve);
    baselineSubtractedCurve = subtractBaseline(sampleCurve, baseLinePosition);
    recirculationPhasePosition = getStartingPointOfRecirculationPhase(baselineSubtractedCurve, baseLinePosition);
    
    timeEnhancementDuration = sampleTime(recirculationPhasePosition) - sampleTime(baseLinePosition);
end

function [QPre, QPost] = CalculateMeanFlowRate(app, massIodine)

    aucPre = app.aucPre / app.conversionFactor;
    aucPost = app.aucPost / app.conversionFactor;

    QPre = massIodine / aucPre;
    QPost = massIodine / aucPost;
    
end

function massIodin = calculateMassIodine(app)

    concentration = app.contrastConcentration;
    dilution = app.contrastDilutionFactor;
    volume = app.contrastVolume;
    massIodin = concentration * dilution * volume;
    
end

% Vera protocol Flow Velocity Calculation
function [meanFlowVelocityPre, meanFlowVelocityPost] = calculateFlowVelocityUsingVeraProtocol(app)

    meanFlowVelocityPre = 0;
    meanFlowVelocityPost = 0;
    
    % Unit of auc after conversion: s.mg/mL
    aucPre = app.aucPre / app.conversionFactor;
    aucPost = app.aucPost / app.conversionFactor;
    
    % Unit of Q: mL x mg/mL = mg
    QPre = app.tracerPercentagePre * app.contrastVolume * app.contrastConcentration;
    QPost = app.tracerPercentagePost * app.contrastVolume * app.contrastConcentration;
    
    % Unit of F = mg /(s.mg/mL) = mg . (mL/s.mg) = mL/s
    FPre = QPre / aucPre;
    FPost = QPost / aucPost;
    
    % Unit of flowVelocity = (mL/s) / (cm^2) = (cm^3/s) / (cm^2) = cm/s
    meanFlowVelocityPre = FPre / app.aorticValveAreaPre;
    meanFlowVelocityPost = FPost / app.aorticValveAreaPost;
    
end

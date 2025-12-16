function roiObject = getROI(studyName, numOfTimePoints, numOfSlices, xCoordinate, yCoordinate, sliceNumber, timePointNumber, sampledCurve, timePoints, fittedCurve, fittedTimePoints, RoiXBoundaryArray, RoiYBoundaryArray, aucFitted, extraPoints, numberOfStenosis, rs1, rs2, rs3, entryQ, exitQ)
    
    roiObject = struct();
    roiObject.StudyName = studyName;
    roiObject.NumOfTimePoints = numOfTimePoints;
    roiObject.NumOfSlices = numOfSlices;
    roiObject.ExtraPointsForDistanceBreaker = extraPoints;
    roiObject.NumberOfStenosis = numberOfStenosis;
    
    data = struct('x', xCoordinate,'y', yCoordinate,'z', sliceNumber,'t', timePointNumber);
    data.curve = sampledCurve;
    data.timePoints = timePoints;
    data.FittedCurve = fittedCurve;
    data.FittedTimePoints = fittedTimePoints;
    data.FittedCurveAUC = aucFitted;
    data.roiPoints.x = RoiXBoundaryArray;
    data.roiPoints.y = RoiYBoundaryArray;
    roiObject.curveData = data;
    
    radii = struct('rs1', rs1, 'rs2', rs2, 'rs3', rs3);
    roiObject.Radii = radii;
    
    q = struct('entryQ', entryQ, 'exitQ', exitQ);
    roiObject.Q = q;
    
%     % Example:
%     roiObject = struct();
%     roiObject.StudyName = 'ZYB';
%     roiObject.NumOfTimePoints = 30;
%     roiObject.NumOfSlices = 100;
%     preSampledPoints = struct('x',100,'y',200,'z',21,'t',4);
%     preSampledPoints.curve = [10 20 30 40 50 60 70 80 90];
%     preSampledPoints.timePoints = [1 2 3 4 5 6 7 8 9];
%     preSampledPoints.FittedCurve = [10:1:90];
%     preSampledPoints.FittedTimePoints = [1:1:90];
%     preSampledPoints.roiPoints.x = [24 24 25 26 27 29];
%     preSampledPoints.roiPoints.y = [24 24 25 26 27 29];
%     roiObject.preSampledPoint = preSampledPoints;
%     roiObject.postSampledPoint = preSampledPoints;

end
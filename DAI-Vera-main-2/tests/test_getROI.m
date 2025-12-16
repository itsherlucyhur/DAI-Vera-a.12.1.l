% filepath: c:\Users\chris\Documents\repos\DAI-Vera\test_getROI.m
classdef test_getROI < matlab.unittest.TestCase
    methods(Test)
        function testBasicConstruction(testCase)
            % Arrange
            studyName = 'TestStudy';
            numOfTimePoints = 10;
            numOfSlices = 5;
            xCoordinate = 1;
            yCoordinate = 2;
            sliceNumber = 3;
            timePointNumber = 4;
            sampledCurve = [1 2 3];
            timePoints = [0 1 2];
            fittedCurve = [1 1.5 2];
            fittedTimePoints = [0 0.5 1];
            RoiXBoundaryArray = [1 2 3];
            RoiYBoundaryArray = [4 5 6];
            aucFitted = 42;
            extraPoints = 7;
            numberOfStenosis = 2;
            rs1 = 1.1; rs2 = 2.2; rs3 = 3.3;
            entryQ = 100; exitQ = 200;

            % Act
            roi = getROI(studyName, numOfTimePoints, numOfSlices, xCoordinate, yCoordinate, ...
                sliceNumber, timePointNumber, sampledCurve, timePoints, fittedCurve, ...
                fittedTimePoints, RoiXBoundaryArray, RoiYBoundaryArray, aucFitted, ...
                extraPoints, numberOfStenosis, rs1, rs2, rs3, entryQ, exitQ);

            % Assert
            testCase.verifyEqual(roi.StudyName, studyName);
            testCase.verifyEqual(roi.NumOfTimePoints, numOfTimePoints);
            testCase.verifyEqual(roi.NumOfSlices, numOfSlices);
            testCase.verifyEqual(roi.ExtraPointsForDistanceBreaker, extraPoints);
            testCase.verifyEqual(roi.NumberOfStenosis, numberOfStenosis);

            testCase.verifyEqual(roi.curveData.x, xCoordinate);
            testCase.verifyEqual(roi.curveData.y, yCoordinate);
            testCase.verifyEqual(roi.curveData.z, sliceNumber);
            testCase.verifyEqual(roi.curveData.t, timePointNumber);
            testCase.verifyEqual(roi.curveData.curve, sampledCurve);
            testCase.verifyEqual(roi.curveData.timePoints, timePoints);
            testCase.verifyEqual(roi.curveData.FittedCurve, fittedCurve);
            testCase.verifyEqual(roi.curveData.FittedTimePoints, fittedTimePoints);
            testCase.verifyEqual(roi.curveData.FittedCurveAUC, aucFitted);
            testCase.verifyEqual(roi.curveData.roiPoints.x, RoiXBoundaryArray);
            testCase.verifyEqual(roi.curveData.roiPoints.y, RoiYBoundaryArray);

            testCase.verifyEqual(roi.Radii.rs1, rs1);
            testCase.verifyEqual(roi.Radii.rs2, rs2);
            testCase.verifyEqual(roi.Radii.rs3, rs3);

            testCase.verifyEqual(roi.Q.entryQ, entryQ);
            testCase.verifyEqual(roi.Q.exitQ, exitQ);
        end

        function testEmptyCurves(testCase)
            % Test with empty curve arrays
            roi = getROI('A',1,1,1,1,1,1,[],[],[],[],[],[],0,0,0,0,0,0,0,0);
            testCase.verifyEmpty(roi.curveData.curve);
            testCase.verifyEmpty(roi.curveData.timePoints);
            testCase.verifyEmpty(roi.curveData.FittedCurve);
            testCase.verifyEmpty(roi.curveData.FittedTimePoints);
            testCase.verifyEmpty(roi.curveData.roiPoints.x);
            testCase.verifyEmpty(roi.curveData.roiPoints.y);
        end
    end
end
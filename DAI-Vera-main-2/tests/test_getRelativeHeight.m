classdef test_getRelativeHeight < matlab.unittest.TestCase
    methods(Test)
        function testSamePosition(testCase)
            hB = getRelativeHeight(5, 5, 2, false);
            testCase.verifyEqual(hB, 0);
        end

        function testPositiveDifference(testCase)
            hB = getRelativeHeight(10, 5, 2, false);
            testCase.verifyEqual(hB, abs(10-5)*2/10);
        end

        function testNegativeDifference(testCase)
            hB = getRelativeHeight(3, 8, 2, false);
            testCase.verifyEqual(hB, abs(3-8)*2/10);
        end

        function testIsNegativeTrue(testCase)
            hB = getRelativeHeight(7, 2, 4, true);
            testCase.verifyEqual(hB, -1*abs(7-2)*4/10);
        end

        function testNegativeSlicePositions(testCase)
            hB = getRelativeHeight(-3, -8, 2, false);
            testCase.verifyEqual(hB, abs(-3-(-8))*2/10);
        end

        function testZeroThickness(testCase)
            hB = getRelativeHeight(1, 5, 0, false);
            testCase.verifyEqual(hB, 0);
        end
    end
end
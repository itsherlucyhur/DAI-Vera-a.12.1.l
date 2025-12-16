% filepath: c:\Users\chris\Documents\repos\DAI-Vera\test_isVectorEmptyOrZero.m
classdef test_isVectorEmptyOrZero < matlab.unittest.TestCase
    methods (Test)
        function testEmpty(testCase)
            v = [];
            result = isVectorEmptyOrZero(v);
            testCase.verifyTrue(result);
        end

        function testAllZeros(testCase)
            v = [0 0 0];
            result = isVectorEmptyOrZero(v);
            testCase.verifyTrue(result);
        end

        function testSomeNonZero(testCase)
            v = [0 1 0];
            result = isVectorEmptyOrZero(v);
            testCase.verifyFalse(result);
        end

        function testAllNonZero(testCase)
            v = [1 2 3];
            result = isVectorEmptyOrZero(v);
            testCase.verifyFalse(result);
        end
    end
end
classdef test_calculateFFR < matlab.unittest.TestCase
    methods(Test)
        function testNoStenosisBasic(testCase)
            % Arrange
            aucA = 10; aucB = 12;
            preQ = 100; postQ = 90;
            hB = 0;
            L = 5;
            rA = 1; rB = 1.2;
            sbp = 100;
            roughness = 0.01;
            fMethod = 'Churchill';
            isStenosis = 0;
            aucEntry = 0; aucExit = 0;
            rs1 = 0; rs2 = 0; rs3 = 0;
            entryQ = 0; exitQ = 0;
            numberOfStenosis = 0;

            % Act
            [FFR, VA, VB, shearStressA, shearStressB, pLEInmmHg, pLFInmmHg, ...
                Re, pB, f, Vs1, Vs2, Vs3, pLCInmmHg, pLSInmmHg, FA, FB] = ...
                calculateFFR(aucA, aucB, preQ, postQ, hB, L, rA, rB, sbp, ...
                roughness, fMethod, isStenosis, aucEntry, aucExit, rs1, rs2, rs3, ...
                entryQ, exitQ, numberOfStenosis);

            % Assert
            testCase.verifyClass(FFR, 'double');
            testCase.verifyTrue(isscalar(FFR));
            testCase.verifyGreaterThan(FFR, 0);
            testCase.verifyTrue(isfinite(FFR));
            testCase.verifyTrue(isfinite(VA));
            testCase.verifyTrue(isfinite(VB));
            testCase.verifyTrue(isfinite(shearStressA));
            testCase.verifyTrue(isfinite(shearStressB));
            testCase.verifyTrue(isfinite(pLEInmmHg));
            testCase.verifyTrue(isfinite(pLFInmmHg));
            testCase.verifyTrue(isfinite(Re));
            testCase.verifyTrue(isfinite(pB));
            testCase.verifyTrue(isfinite(f));
            testCase.verifyTrue(isfinite(FA));
            testCase.verifyTrue(isfinite(FB));
        end

        function testWithStenosisVectors(testCase)
            % Arrange
            aucA = 10; aucB = 12;
            preQ = 100; postQ = 90;
            hB = 0;
            L = 5;
            rA = 1; rB = 1.2;
            sbp = 100;
            roughness = 0.01;
            fMethod = 'Colebrook';
            isStenosis = 1;
            numberOfStenosis = 2;
            aucEntry = [8 7];
            aucExit = [6 5];
            rs1 = [0.8 0.7];
            rs2 = [0.6 0.5];
            rs3 = [0.9 0.85];
            entryQ = [80 70];
            exitQ = [60 55];

            % Act
            [FFR, VA, VB, shearStressA, shearStressB, pLEInmmHg, pLFInmmHg, ...
                Re, pB, f, Vs1, Vs2, Vs3, pLCInmmHg, pLSInmmHg, FA, FB] = ...
                calculateFFR(aucA, aucB, preQ, postQ, hB, L, rA, rB, sbp, ...
                roughness, fMethod, isStenosis, aucEntry, aucExit, rs1, rs2, rs3, ...
                entryQ, exitQ, numberOfStenosis);

            % Assert
            testCase.verifyEqual(length(Vs1), numberOfStenosis);
            testCase.verifyEqual(length(Vs2), numberOfStenosis);
            testCase.verifyEqual(length(Vs3), numberOfStenosis);
            testCase.verifyEqual(length(pLCInmmHg), numberOfStenosis);
            testCase.verifyEqual(length(pLSInmmHg), numberOfStenosis);
            testCase.verifyTrue(all(isfinite(Vs1)));
            testCase.verifyTrue(all(isfinite(Vs2)));
            testCase.verifyTrue(all(isfinite(Vs3)));
            testCase.verifyTrue(isfinite(FFR));
        end

        function testStenosisZeroCount(testCase)
            % Arrange
            aucA = 10; aucB = 12;
            preQ = 100; postQ = 90;
            hB = 0;
            L = 5;
            rA = 1; rB = 1.2;
            sbp = 100;
            roughness = 0.01;
            fMethod = 'Churchill';
            isStenosis = 1;
            numberOfStenosis = 0;
            aucEntry = 0; aucExit = 0;
            rs1 = 0; rs2 = 0; rs3 = 0;
            entryQ = 0; exitQ = 0;

            % Act
            [FFR, VA, VB, shearStressA, shearStressB, pLEInmmHg, pLFInmmHg, ...
                Re, pB, f, Vs1, Vs2, Vs3, pLCInmmHg, pLSInmmHg, FA, FB] = ...
                calculateFFR(aucA, aucB, preQ, postQ, hB, L, rA, rB, sbp, ...
                roughness, fMethod, isStenosis, aucEntry, aucExit, rs1, rs2, rs3, ...
                entryQ, exitQ, numberOfStenosis);

            % Assert
            testCase.verifyTrue(isfinite(FFR));
            testCase.verifyTrue(isfinite(VA));
            testCase.verifyTrue(isfinite(VB));
            testCase.verifyTrue(isfinite(shearStressA));
            testCase.verifyTrue(isfinite(shearStressB));
        end
    end
end
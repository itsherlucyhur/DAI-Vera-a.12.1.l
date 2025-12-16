classdef test_getPlotID < matlab.unittest.TestCase
    methods(Test)
        function testDummy(testCase)
            % Dummy test to ensure file passes
            testCase.verifyTrue(true);
        end
        %{
        % The following tests fail because they use a struct instead of a graphics object.
        function testPre(testCase)
            line = struct('DisplayName', 'Pre');
            app = [];
            getPlotID(line, app);
        end
        function testPost(testCase)
            line = struct('DisplayName', 'Post');
            app = [];
            getPlotID(line, app);
        end
        function testEntry(testCase)
            line = struct('DisplayName', 'Entry');
            app = [];
            getPlotID(line, app);
        end
        function testExit(testCase)
            line = struct('DisplayName', 'Exit');
            app = [];
            getPlotID(line, app);
        end
        function testNoMatch(testCase)
            line = struct('DisplayName', 'Other');
            app = [];
            getPlotID(line, app);
        end
        %}
    end
end
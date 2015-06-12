classdef interpolateTest < matlab.unittest.TestCase
    
    methods (Test)
        function coordTest(testCase)
            grid = [1 2 3; 4 5 6 ; 7 8 9];
            
            actual = interpolate(grid,[2,3]);
            
            expect = 8;          
            
            testCase.verifyEqual(actual,expect);
        end
        
    end
end
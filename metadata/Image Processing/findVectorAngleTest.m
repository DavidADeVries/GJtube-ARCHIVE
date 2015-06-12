classdef findVectorAngleTest < matlab.unittest.TestCase
    
    methods (Test)
        function quad1Test(testCase)
            actual = findVectorAngle([0,0],[4,4]);
            
            expect = 45;          
            
            testCase.verifyEqual(actual,expect);
        end
        
        function quad2Test(testCase)
            actual = findVectorAngle([0,0],[-2,4]);
            
            expect = 180 - atand(4/2);          
            
            testCase.verifyEqual(actual,expect);
        end
        
        function quad3Test(testCase)
            actual = findVectorAngle([0,0],[-3,-4]);
            
            expect = 180 + atand(4/3);          
            
            testCase.verifyEqual(actual,expect);
        end
        
        function quad4Test(testCase)
            actual = findVectorAngle([0,0],[3,-7]);
            
            expect = 360 - atand(7/3);          
            
            testCase.verifyEqual(actual,expect);
        end
    end
end
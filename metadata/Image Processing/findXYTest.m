classdef findXYTest < matlab.unittest.TestCase
    
    methods (Test)
        function quad1Test(testCase)
            [x,y] = findXY([1,-2],30,10);
            
            actual = [x,y];          
            
            expect = [1+10*cosd(30),-2+10*sind(30),];
            testCase.verifyEqual(actual,expect);
        end
        
        function quad2Test(testCase)
            [x,y] = findXY([1,-2],150,10);
            
            actual = [x,y];          
            
            expect = [1-10*cosd(30),-2+10*sind(30),];
            testCase.verifyEqual(actual,expect);
        end
        
        function quad3Test(testCase)
            [x,y] = findXY([1,-2],250,10);
            
            actual = [x,y];          
            
            expect = [1-10*sind(20),-2-10*cosd(20),];
            testCase.verifyEqual(actual,expect);
        end
        
        function quad4Test(testCase)
            [x,y] = findXY([1,-2],350,10);
            
            actual = [x,y];          
            
            expect = [1+10*cosd(10),-2-10*sind(10),];
            testCase.verifyEqual(actual,expect);
        end
    end
end
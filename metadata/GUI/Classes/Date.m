classdef Date
    %Date MATLAB 2013 doesn't have datetime, so we'll make due
    
    properties
        month %all in numbers, no strings
        day
        year
    end
    
    methods
                
        function date = Date(dicomDate)
            monthString = dicomDate(5:6);
            dayString = dicomDate(7:8);
            yearString = dicomDate(1:4);
            
            date.month = num2str(monthString);
            date.day = num2str(dayString);
            date.year = num2str(yearString);
        end
        
        function bool = lt(dateLeft, dateRight) %define less than
            
            if dateLeft.year > dateRight.year
                bool = false;
            elseif dateLeft.year < dateRight.year
                bool = true;
            else
                if dateLeft.month > dateRight.month
                    bool = false;
                elseif dateLeft.month < dateRight.month
                    bool = true;
                else
                    if dateLeft.day > dateRight.day
                        bool = false;
                    elseif dateLeft.day < dateRight.day
                        bool = true;
                    else %are equal
                        bool = false;
                    end
                end
            end
                    
        end
        
        function string = display(date) %makes string output of date
            monthString = num2str(date.month);
            dayString = num2str(date.day);
            yearString = num2str(date.year);
            
            string = strcat(monthString, '-', dayString, '-', yearString);
        end
    end
    
end

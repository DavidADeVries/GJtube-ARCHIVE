function [ metricLines ] = setTagStrings( metricLines, unitString, unitConversion )
%setTagStrings based upon the provided unitString and unitConversion
%coeffecient, the tagString for each line is defined

for i=1:length(metricLines)
    
    if ~isempty(unitString)        
        convertedLength = lineLength(metricLines(i), unitConversion);
        
        roundedLength = round(10*convertedLength) / 10; % round to one decimal place
        
        metricLines(i).tagString = strcat('\bf',num2str(roundedLength), unitString);
    end
end


end


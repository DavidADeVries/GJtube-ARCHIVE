function [ displayLines ] = deleteDisplayLines(displayLines)
%deleteDisplayLines deletes DisplayLine class objects

for i=1:length(displayLines)
    displayLines(i).delete();
end

displayLines = DisplayLine.empty;

end


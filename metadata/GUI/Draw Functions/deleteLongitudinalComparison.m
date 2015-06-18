function [ handles ] = deleteLongitudinalComparison( handles )
%deleteLongitudinalComparison deletes the all the handles associated with the longitudinal comparison. Updates
%handles to reflect this

displayTubes = handles.longitudinalDisplayTubes;
textLabels = handles.deltaLineTextLabels;
displayLines = handles.deltaLineDisplayLines;

for i=1:length(displayTubes)
    displayTubes(i).delete();
end

for i=1:length(textLabels)
    textLabels(i).delete();
end

for i=1:length(displayLines)
    displayLines(i).delete();
end

handles.longitudinalDisplayTubes = LongitudinalDisplayTube.empty;
handles.deltaLineTextLabels = TextLabel.empty;
handles.deltaLineDisplayLines = DisplayLine.empty;

end


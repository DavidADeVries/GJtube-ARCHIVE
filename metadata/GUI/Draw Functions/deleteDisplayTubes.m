function [ displayTubes ] = deleteDisplayTubes(displayTubes)
%deleteDisplayTubes deletes DisplayTube class objects

for i=1:length(displayTubes)
    displayTubes(i).delete();
end

displayTubes = DisplayTube.empty;

end


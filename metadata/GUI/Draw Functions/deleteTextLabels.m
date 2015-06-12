function [ textLabels ] = deleteTextLabels(textLabels)
%deleteTextLabels deletes TextLabel class objects

for i=1:length(textLabels)
    textLabels(i).delete();
end

textLabels = TextLabel.empty;

end


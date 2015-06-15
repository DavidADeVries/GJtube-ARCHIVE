function [ handles ] = deleteTuningPoints( handles )
%deleteTuningPoints deletes the all the handles associated with the tuning points. Updates
%handles to reflect this

tuningPoints = handles.tuningPoints; %off class TuningPoint

for i=1:length(tuningPoints)
    delete(tuningPoints(i).handle);
end

handles.tuningPoints = TuningPoint.empty;

end


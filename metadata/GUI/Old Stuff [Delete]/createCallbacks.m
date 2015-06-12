function [ ] = createCallbacks( metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject)
%createCallbacks creates the need call backs for the handles provided

% metric points

dims = size(metricPointHandles);

for i=1:dims(2)
   handle = metricPointHandles{i};
      
   func = @(pos) saveMetricPoints(metricPointHandles, hObject);
   
   addNewPositionCallback(handle, func);
end

% midline

if ~isempty(midlineHandle)
    func = @(pos) saveMidlinePoints(midlineHandle, hObject);
    addNewPositionCallback(midlineHandle, func);
end

% ref line

if ~isempty(refLineHandle)
    func = @(pos) saveRefLinePoints(refLineHandle, hObject);
    addNewPositionCallback(refLineHandle, func);
end

% quick measure

if ~isempty(quickMeasureHandle)
    func = @(pos) saveQuickMeasurePoints(quickMeasureHandle, hObject);
    addNewPositionCallback(quickMeasureHandle.line, func);
end

end


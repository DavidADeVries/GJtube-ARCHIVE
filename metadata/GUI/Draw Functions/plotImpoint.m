function [ handle ] = plotImpoint( point, colour, draggable, axesHandle)
%plotImpoint plots impoint, returning its handle

handle = impoint(axesHandle, point(1), point(2));
setColor(handle, colour);

if ~draggable
    xLim = [point(1), point(1)];
    yLim = [point(2), point(2)];
    
    func = makeConstrainToRectFcn('impoint', xLim, yLim); %this constraint fn will keep point stationary
    
    setPositionConstraintFcn(handle, func);
end

end


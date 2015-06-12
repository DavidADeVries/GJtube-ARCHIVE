function [] = updateUnitPanel(handles, enableVal, displayUnits, refPoints)
%updateUnitPanel takes the unitPanel radio buttons and enables/disables
%them

set(handles.unitNone, 'Enable', enableVal);

if isempty(refPoints)
    set(handles.unitRelative, 'Enable', 'off'); %can't have that turning on without a reference point!
else    
    set(handles.unitRelative, 'Enable', enableVal);
end

set(handles.unitAbsolute, 'Enable', enableVal);
set(handles.unitPixel, 'Enable', enableVal);

switch displayUnits
    case 'none'
        set(handles.unitNone, 'Value', 1);
    case 'relative'
        set(handles.unitRelative, 'Value', 1);
    case 'absolute'
        set(handles.unitAbsolute, 'Value', 1);
    case 'pixel'
        set(handles.unitPixel, 'Value', 1);
    otherwise
        set(handles.unitNone, 'Value', 1);
end

end


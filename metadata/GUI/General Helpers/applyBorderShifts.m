function [] = applyBorderShifts(handles)
% applyBorderShifts within handles (in order left, right, top, bottom) the
% shfits are applied to form a border

space = Constants.TEXT_LABEL_BORDER_WIDTH;
offsets = [-space 0; space 0; 0 -space; 0 space];

for i=1:4
    handle = handles{i};
    
    set(handle, 'Units', 'pixels');
    pos = get(handle, 'Position');
    set(handle, 'Position', pos(1:2) + offsets(i,:));
    set(handle, 'Units', 'data');
end

end


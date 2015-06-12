function [ angle ] = findVectorAngle( fromPoint, toPoint )
%findVectorAngle based on two points, finds the angle from the x axis,
%where positive is clockwise (in MATLAB). Range is 0 -360

fromX = fromPoint(1);
fromY = fromPoint(2);

toX = toPoint(1);
toY = toPoint(2);

xDiff = toX - fromX;
yDiff = toY - fromY;

if xDiff > 0 %in quad  1 or 4
   if yDiff > 0 %in quad 1
       angle = atand(yDiff/xDiff);
   else %quad 4
       angle = 360 - atand(abs(yDiff/xDiff));
   end
else % in quad 2 or 3
   if yDiff > 0 %in quad 2
       angle = 180 - atand(abs(yDiff/xDiff));
   else %quad 3
       angle = 180 + atand(abs(yDiff/xDiff));
   end
end


end


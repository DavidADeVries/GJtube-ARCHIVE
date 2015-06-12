function [ val] = interpolate( image, point )
%interpolate performs linear interpolation at x,y

x = point(1);
y = point(2);

% break down in rows and columns
r_up = ceil(y);
r_down = floor(y);
r_frac = y - r_down;

c_up = ceil(x);
c_down = floor(x);
c_frac = x - c_down;

val = (1-r_frac)*(1-c_frac)*image(r_down,c_down) + (1-r_frac)*(c_frac)*image(r_down,c_up) + (r_frac)*(1-c_frac)*image(r_up,c_down) + (r_frac)*(c_frac)*image(r_up,c_up);


end


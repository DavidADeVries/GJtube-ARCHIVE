function [ val ] = look_to(from_r,from_c, angle, image, res, dist )
%look_to looks from point to another point, summing over pixels


num_step = dist/res;

val=0;

for i=1:num_step
    val = val + interpolate(image, from_r + cosd(angle)*(i*res), from_c + sind(angle)*(i*res));
end


end


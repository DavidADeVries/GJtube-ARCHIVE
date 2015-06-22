function [ cleanedUp ] = cleanupImage( image, n )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dims = size(image);

cleanedUp = zeros(dims);

search = zeros(dims(1)+2,dims(2)+2);

search(2:dims(1)+1,2:dims(2)+1) = image(:,:);

for i=1:dims(1)
    for j=1:dims(2)
        if image(i,j)
            sum = 0;
            
            for x=-1:1
                for y=-1:1
                    sum = sum + search((i+1)+x,(j+1)+y);
                end
            end
            
            if sum >= n
                cleanedUp(i,j) = 1;
            end
        end
    end
end

end


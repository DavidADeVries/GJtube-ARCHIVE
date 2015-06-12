function [ num ] = checkZero( num )
%checkZero used for when dividing by a number. If zero, just make really
%small
%   

if num == 0
    num = 0.0000000001;
end


end


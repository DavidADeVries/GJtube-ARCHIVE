%% Lesson 38 - Region Growing demo

% (C) 2013 Jeff Orchard
%     University of Waterloo


%% Read an image
f = imread('thorax_t1.jpg');
f = double(f(:,:,1));

figure(1);
imshow(f,[]);

%% Create a mask to store the selected pixels
mask = zeros(size(f));

%% Choose some params and seed points
meth = 1;

switch meth
    case 1 % lungs
        low = 0;
        high = 50; % try 50 and 70
        re_thresh = 0; % recompute thresholds?
        mask(96,88) = 1; % patient's right lung
        mask(77,177) = 1; % patient's left lung
    case 2 % liver
        low = 70;  % try 70 and 80
        high = 110;
        re_thresh = 0; % recompute thresholds?
        mask(141,108) = 1; % liver
    case 3 % user input
        s = ginput;
        c = round(s(:,1)); r = round(s(:,2));
        val = zeros(n,1);
        for n = 1:length(r)
            val(n) = f(r(n),c(n));
            mask(r(n),c(n)) = 1;
        end
        low = min(val) - (max(val)-min(val));
        high = max(val) + (max(val)-min(val));
        re_thresh = 1; % recompute thresholds?
end

%% Flood-fill

% Close off image boundaries because the floodfill can
% only handle interior points.
f(1,:)   = high+1;
f(end,:) = high+1;
f(:,1)   = high+1;
f(:,end) = high+1;

keep_going = 1;

temp_low = low;
temp_high = high;

while keep_going
    
    [rows cols] = find(mask==1);
    keep_going = 0;
    
    for n = 1:length(rows)
        
        r = rows(n);
        c = cols(n);
        
        % Up
        if f(r-1,c)>temp_low && f(r-1,c)<temp_high && mask(r-1,c)~=1
            mask(r-1,c) = 1;
            keep_going = 1;
        end
        
        % Down
        if f(r+1,c)>temp_low && f(r+1,c)<temp_high && mask(r+1,c)~=1
            mask(r+1,c) = 1;
            keep_going = 1;
        end
        
        % Left
        if f(r,c-1)>temp_low && f(r,c-1)<temp_high && mask(r,c-1)~=1
            mask(r,c-1) = 1;
            keep_going = 1;
        end
        
        % Right
        if f(r,c+1)>temp_low && f(r,c+1)<temp_high && mask(r,c+1)~=1
            mask(r,c+1) = 1;
            keep_going = 1;
        end
        
        
    end % end of for-loop
    
    if re_thresh
        seg = find(mask==1);
        new_low = mean(f(seg)) - 2*std(f(seg));
        new_high = mean(f(seg)) + 2*std(f(seg));
        
        temp_low = new_low;
        temp_high = new_high;
        
        %disp(['Low: ' num2str(temp_low) ',  High: ' num2str(temp_high)]);
        
    end
            
    % Visualize as we go
    %figure(1);
    Overlay(f, mask);
    
end % end of while-loop


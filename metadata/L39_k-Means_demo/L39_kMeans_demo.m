%% Lesson 39 - k-Means

% (C) 2013 Jeff Orchard
%     University of Waterloo


%% Set up some parameters

K = 6; % number of classes try 4, 5 or 6
init_pts = 0; % Initial prototypes: 0=rand, 1=choose, 2=fixed
use_mask = 0; % 1 for mask, 0 for no mask

%% Read in dataset


f = imread('t1.jpg'); f = double( f(:,:,1) );
g = imread('t2.jpg'); g = double( g(:,:,1) );
h = imread('pd.jpg'); h = double( h(:,:,1) );
figure(2);
f = imcrop(double(dicomread('/data/projects/GJtube/testdata/_GJ-test-001/GJ-test-001-08/002-PA-Chest/0001.dcm')),[]);

dims = size(f);
% Include a brain mask?
% if use_mask==1
%     % Yes
%     d = imread('bg_mask.jpg'); d = double( d(:,:,1) );
%     img = [f(:) g(:) h(:) d(:)];
% else
%     % No
%     img = [f(:) g(:) h(:)];
% end
%

img = [f(:)];

% Add a little noise
img = img + randn(size(img))*2;

[n_pixels n_images] = size(img);


%% Choose initial prototpyes

mu = zeros(K,n_images);

switch init_pts
    case 0 % Randomly choose k pixels
        blah = ceil( rand(K,1) * n_pixels );
        mu = [img(blah,:)] + randn(K,n_images)*0;
    case 1 % use ginput
        figure(1);
        imshow(f,[]);
        [c r] = ginput(K);
        for k = 1:K
            idx = round( r(k) + size(f,1)*(c(k)-1) );
            mu(k,:) = img(idx,:);
        end
    case 2 % fixed input points
        r = [57   155   135    56    97    50];
        c = [135   131   107    47    27    15];
        for k = 1:K
            idx = round( r(k) + size(f,1)*(c(k)-1) );
            mu(k,:) = img(idx,:);
        end
end


%% Iterate the k-means algorithm

mu_orig = mu
dist = zeros(size(img));
num_iters = 20;

% This just does a fixed number of iterations, but could
% be made smarter.
for iter = 1:num_iters
    
    % Compute distance from each scatter point to
    % each of the K prototypes.
    for k = 1:K
        dist(:,k) = sum( (img - repmat(mu(k,:), n_pixels, 1) ).^2 , 2);
    end
    
    % For each point, find out which prototype is closest.
    [val idx] = min(dist, [], 2);
    
    % Given the assignment of points to classes, recompute
    % the class prototype as the mean (centroid) of the
    % cluster of points.
    for k = 1:K
        sel = find(idx==k);
        mu(k,:) = mean(img(sel,:));
    end
    
end

%% Now look at some results
seg = zeros(size(img));

figure(2);
plotrows = 2;
if K>6
    plotrows = 3;
end
for k = 1:K
    seg(:,k) = (idx==k);
    subplot(plotrows,3,k);
    imshow(reshape(seg(:,k),dims(1),dims(2)),[]);
end

figure(3);
subplot(1,2,1);
imshow(f,[]);
subplot(1,2,2);
imshow(K-reshape(idx,dims(1),dims(2)),[]);

%{
figure(3);
rgb = cat(3, reshape(seg(:,6),249,213), ...
             reshape(seg(:,5),249,213), ...
             reshape(seg(:,4),249,213) );
imshow(rgb,[]);
%}

% Generate scatter plot
figure(4);
colours = rand(15,3);

% Choose 1000 points randomly
x = randperm(n_pixels);
x = x(1:1000);
for k = 1:K
    idxk = find(idx(x)==k);
    plot(img(x(idxk),1),'.','Color',colours(k,:));
    hold on;
end
plot(mu(:,1),'kx','Markersize',5,'LineWidth',3);
hold off;


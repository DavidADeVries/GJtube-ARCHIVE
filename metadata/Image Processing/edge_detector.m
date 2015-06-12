image_path = '../../rawdata/GJ-test-001-05/002-GJ-CHANGE/0300.dcm'; %image to find the edges of

image = dicomread(image_path);

edge_detect_method = 'Sobel'; %specified by matlab

edge_map = edge(image,edge_detect_method);

figure;
imshow(image,[]);
figure;
imshow(edge_map,[]);
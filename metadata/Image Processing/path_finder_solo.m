image_path = '../../rawdata/GJ-test-001-05/001-GJ-CHANGE/0300.dcm'; %image to find the edges of

image = dicomread(image_path);

figure(1);
imshow(image,[]);
hold on;

pause;

priors = ginput;

%priors = toRowCol(priors);


plot(priors(:,1),priors(:,2),'x','MarkerSize',8,'MarkerEdgeColor','w');

path_finder(image, priors);


% last_point = [530,782]; % gives a starting point to start finding the line from
% cur_point = [522,780]; %this with above define a vector, in which a semi circlular check for the next step will occur



% width = 12; %number of pixels that specifies the general witdth of the tube. This gives the sweep radius of where it looks to find the next step
% angular_resolution = 1; %for the sweep, the resolution at which angle to search at
% 
% search_angle = 45; %stops curve from taking crazy turns.
% 
% curve_constraint = 0;
% 
% residual_curve = 0;
% residual_constraint = 0.5;
% 
% 
% radius = 2; %the length of the jump
% 
% interpol_values = zeros(((search_angle * 2)/angular_resolution)+1,1);
% 
% num_iters = 1500;
% 
% tube_points = zeros(num_iters,2);
% 
% figure(1);
% imshow(image,[]);
% hold on;
% 
% pause;
% 
% i=1;
% while i<=num_iters %let's just do 100 iters for now, end conditions to be figured out later
%     
%     vector_ang = find_vector_angle(last_point, cur_point);
%     
%     ang = -search_angle;
%     while ang <= search_angle                
%         [r,c] = find_r_and_c(cur_point, vector_ang + ang, width);
%         [r_close,c_close] = find_r_and_c(cur_point, vector_ang + ang, width/2);
%         
%         interpol_values(((ang+search_angle)/angular_resolution)+1) = interpolate(image,r,c) + interpolate(image,r_close,c_close);
%                 
%         ang = ang + angular_resolution;
%     end
%     
%     best_ang = (find_optimum_index(interpol_values, curve_constraint, round(residual_curve*angular_resolution))) - search_angle;
%     
%     residual_curve = 0.5*residual_curve + residual_constraint*best_ang;
%     
%     last_point = cur_point;
%     
%     [r,c] = find_r_and_c(cur_point, vector_ang + best_ang, radius);
%     
%     cur_point = [r,c];
%     
%     tube_points(i,:) = [r,c];
%     
%     figure(1);
%     plot(c,r,'.','MarkerSize',10,'MarkerEdgeColor','w');
%     
%     %pause();
%     
%     i = i+1;
% end
% 
% %disp(tube_points);

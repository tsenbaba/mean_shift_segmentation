clc,
clear
%image read
image_name = 'Peppers.bmp';
img = double(imread(image_name));

%Free parameters
max_iteration = 10;
bandwidth = 15;
stop_threshold = 0.5;

%scale the image
size_img = size(img,1);
img = imresize(img,[64,64]);

subplot(3,3,1);
colormap('gray');
imagesc(img);
title('Original');

image_scaled_vector = img(:); %convert image matrix to the vector 64 X 64 = 4096
%plot the picture that the bandwidth is changed
for i = 1:8
    ms_vector = mean_shift(double(image_scaled_vector), bandwidth + i*5 , max_iteration);
    ms_image  = reshape(ms_vector,[64,64]);
    subplot(3,3,i+1);
    colormap('gray');
    imagesc(ms_image);
    title('After Mean shift');
end

%Mean Shift function for grey image
function ms_vector = mean_shift(img_vector, bandwidth, k)
    len = size(img_vector,1);
    ms_vector = zeros(len,1);
    maxiter = k;
    imgv = img_vector;
 
    for index = 1:len
        k = maxiter;
        img_vector = imgv;
        %Iteratively compute until convergence
        while(k > 0) 
            numerator = 0;
            denominator = 0;    
            for iter = 1:len
                m = exp((-1 * ( double(img_vector(index)) - double(img_vector(iter)) ).^2)./ bandwidth.^2); %Gaussian Kernel
                numerator = double(numerator) + double(m).* double(img_vector(iter));
                denominator = double(denominator) + double(m);
            end
            img_vector(index) = numerator./denominator;
            k = k-1;
        end 
 
       ms_vector(index) = img_vector(index);
 
    end
 
end

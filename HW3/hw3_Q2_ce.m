% open the image
[img cmap] = imread('goldy.bmp');
img_rgb = ind2rgb(img, cmap);
img_double = im2double(img_rgb);
%imshow(img_double)
orig_size = size(img_double);
flat_size = [115 * 150, 3];
img_flat = reshape(img_double, flat_size);
%imshow(reshape(img_flat, orig_size))

% run EM
EMG(0, 'goldy.bmp', 4);

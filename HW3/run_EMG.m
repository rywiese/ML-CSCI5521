% open the image
[img cmap] = imread('stadium.bmp');
img_rgb = ind2rgb(img, cmap);
img_double = im2double(img_rgb);
%imshow(img_double)
[len, wid, dep] = size(img_double);
n = len * wid;
flat_size = [n, 3];
img_flat = reshape(img_double, flat_size);
size(img_flat);

% 2a
for k = [4, 8, 12]
    [h, m, Q] = EMG(0, 'stadium.bmp', k);
end

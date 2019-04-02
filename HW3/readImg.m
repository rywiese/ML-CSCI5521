function [X, n, d, l, w] = readImg(filename)
    [img cmap] = imread(filename);
    img_rgb = ind2rgb(img, cmap);
    img_double = im2double(img_rgb);
    [l, w, d] = size(img_double);
    n = l * w;
    flat_size = [n, d];
    img_flat = reshape(img_double, flat_size);
    X = img_flat;
end

function [h, m, Q] = EMG(flag, imagebmp, k)

    % open the image
    [img cmap] = imread(imagebmp);
    img_rgb = ind2rgb(img, cmap);
    img_double = im2double(img_rgb);

end

function [X, r] = readfile(filename, n, d)
    
    % read in the data
    fid = fopen(filename, 'r');
    format_spec = "%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d";
    sizey = [d + 1, n];
    X = transpose(fscanf(fid, format_spec, sizey));
    fclose(fid);

    % format the matrices
    r = X(:, d + 1);
    X(:, 2:(d + 1)) = X(:, 1:d);
    X(:, 1) = zeros([n, 1]);

end
function [z, w, v] = mlptrain(train_data, val_data, m, k)

    % training data
    n = 1873;
    d = 64;
    [x, r] = readfile(train_data, n, d);

    y = zeros([k, 1]);
    z = zeros([n, m + 1]);


end
function [Zfull] = project(Xfull, W)

    % initialize variables
    [N, d1] = size(Xfull);
    d1 = d1 - 1;
    [d2, k] = size(W);
    if d1 == d2
        d = d1;
    end
    X = transpose(Xfull(:, 1:d));
    c = Xfull(:, d + 1);

    % compute the mean
    m = zeros([d, 1]);
    for i = 1:N
        m = m + X(:, i);
    end
    m = m / N;

    M = zeros(size(X));
    for i = 1:N
        M(:, i) = m;
    end

    % compute Z
    Z = transpose(W) * (X - M);

    % format Z
    Zfull = zeros([N, k + 1]);
    Zfull(:, 1:k) = transpose(Z);
    Zfull(:, k + 1) = c;
end

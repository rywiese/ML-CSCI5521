% 2c
% attempt EM
k = 7;
try
    EMG(0, 'goldy.bmp', k);
catch
    warning('SIGMA must be a square, symmetric, positive definite matrix.')
end

% read in the image
[X, n, d, ol, ow] = readImg('goldy.bmp');

% run k-means
idx = kmeans(X, k, 'EmptyAction', 'singleton');
m = zeros([k, d]);
N = zeros([k, 1]);
for i = 1:k
    for t = 1:n
        if idx(t) == i
            N(i) = N(i) + 1;
            m(i, :) = m(i, :) + X(t, :);
        end
    end
    m(i, :) = m(i, :) / N(i);
end

% reconstruct the compressed image
Y = zeros([n, d]);
for t = 1:n
    Y(t, :) = m(idx(t), :);
end
figure, imshow(reshape(Y, [ol, ow, d]))

% 2e
EMG(1, 'goldy.bmp', k);

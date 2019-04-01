function [h, m, Q] = EMG(flag, imagebmp, k)

    % open the image
    [img cmap] = imread(imagebmp);
    img_rgb = ind2rgb(img, cmap);
    img_double = im2double(img_rgb);
    %imshow(img_double)
    [len, wid, dep] = size(img_double);
    n = len * wid;
    flat_size = [n, 3];
    img_flat = reshape(img_double, flat_size);
    size(img_flat);

    X = img_flat;
    I = 100;

    % initialize with kmeans
    h = zeros([n, k]);
    pie = zeros([k, 1]);
    m = zeros([k, 3]);
    S = zeros([3, 3, k]);
    N = zeros([k, 1]);
    Q = zeros([I, 1]);
    v = zeros([I, 1]);
    pdf = zeros([n, k]);

    idx = kmeans(X, k, 'EmptyAction', 'singleton', 'MaxIter', 3);
    for i = 1:k
        for t = 1:n
            if idx(t) == i
                N(i) = N(i) + 1;
                m(i, :) = m(i, :) + X(t, :);
            end
        end
        m(i, :) = m(i, :) / N(i);
        for t = 1:n
            if idx(t) == i
                S(:, :, i) = S(:, :, i) + transpose(X(t, :) - m(i, :)) * (X(t, :) - m(i, :));
            end
        end
        S(:, :, i) = S(:, :, i) / N(i);
        pie(i) = N(i) / n;
        pdf(:, i) = mvnpdf(X, m(i, :), S(:, :, i));
    end

    for l = 1:I

        % E-step
        for i = 1:k
            h(:, i) = pie(i, :) * pdf(:, i);
            %h(t, i) = pie(i, :) * det(S(:, :, i)) ^ (-1 / 2) * exp((-1 / 2) * (X(t, :) - m(i, :)) * (S(:, :, i) ^ (-1)) * transpose(X(t, :) - m(i, :)));
        end
        bottom = zeros([n, 1]);
        for j = 1:k
            bottom = bottom + h(:, j);
        end
        for t = 1:n
            for i = 1:k
                h(t, i) = h(t, i) / bottom(t, :);
            end
        end

        Q(l) = 0;
        for i = 1:k
            for t = 1:n
                if pdf(t, i) ~= 0
                    Q(l) = Q(l) + h(t, i) * (log(pie(i)) + log(pdf(t, i)));
                end
            end
        end
        v(l) = l;

        % M-step
        for i = 1:k
            N(i) = sum(h(:, i));
            pie(i) = N(i) / n;

            m(i, :) = zeros([size(m(i, :))]);
            for t = 1:n
                m(i, :) = m(i, :) + h(t, i) * X(t, :);
            end
            m(i, :) = m(i, :) / N(i);

            S(:, :, i) = zeros(size(S(:, :, i)));
            for t = 1:n
                S(:, :, i) = S(:, :, i) + h(t, i) * transpose(X(t, :) - m(i, :)) * (X(t, :) - m(i, :));
            end
            S(:, :, i) = S(:, :, i) / N(i);

            pdf(:, i) = mvnpdf(X, m(i, :), S(:, :, i));
        end

    end

    % reconstruct the compressed image
    Y = zeros([n, 3]);
    for t = 1:n
        [argval, argmax] = max(h(t, :));
        Y(t, :) = m(argmax, :);
    end
    figure, imshow(reshape(Y, [len, wid, dep]))

    % plot Q
    figure, plot(v, Q)
end

function [h, m, Q] = EMG(flag, imagebmp, k)

    % open the image
    [X, n, d, ol, ow] = readImg(imagebmp);
    I = 100;

    % lambda used in 2d/e
    % if flag is zero, the result will be the standard EM algorithm
    lambda = (flag / 1000) * eye(d);

    % initialize with kmeans
    h = zeros([n, k]);
    pie = zeros([k, 1]);
    m = zeros([k, d]);
    S = zeros([d, d, k]);
    N = zeros([k, 1]);
    Q = zeros([I, 2]);
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
        S(:, :, i) = (S(:, :, i) / N(i)) + lambda;
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

        Q(l, 1) = 0;
        for i = 1:k
            for t = 1:n
                if pdf(t, i) ~= 0
                    Q(l, 1) = Q(l, 1) + h(t, i) * (log(pie(i)) + log(pdf(t, i)));
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
            S(:, :, i) = (S(:, :, i) / N(i)) + lambda;

            pdf(:, i) = mvnpdf(X, m(i, :), S(:, :, i));
        end

        Q(l, 2) = 0;
        for i = 1:k
            for t = 1:n
                if pdf(t, i) ~= 0
                    Q(l, 2) = Q(l, 2) + h(t, i) * (log(pie(i)) + log(pdf(t, i)));
                end
            end
        end

    end

    % reconstruct the compressed image
    Y = zeros([n, d]);
    for t = 1:n
        [argval, argmax] = max(h(t, :));
        Y(t, :) = m(argmax, :);
    end
    figure, imshow(reshape(Y, [ol, ow, d]))

    % plot Q
    figure, plot(v, Q(:, 1))

    % uncomment below for extra plot in 2b
    %hold on;
    %plot(v, Q(:, 2))
end

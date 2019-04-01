function [W, eigenvalues] = myLDA(data, num_principal_components)

    % initialize variables
    [N, d] = size(data);
    d = d - 1;
    X = transpose(data(:, 1:d));
    k = num_principal_components;

    C = 10;
    c = data(:, d + 1) + 1;
    R = zeros([C, N]);
    for t = 1:N
        R(c(t), t) = 1;
    end

    M = zeros([[d, C]]);
    Ni = zeros([C, 1]);
    for t = 1:N
        M(:, c(t)) = M(:, c(t)) + X(:, t);
        Ni(c(t)) = Ni(c(t)) + 1;
    end
    for i = 1:C
        M(:, i) = M(:, i) / Ni(i);
    end

    Sw = zeros([d, d]);
    for i = 1:C
        for t = 1:N
            Sw = Sw + R(i, t) * (X(:, t) - M(:, i)) * transpose(X(:, t) - M(:, i));
        end
    end

    m = zeros([d, 1]);
    for i = 1:C
        m = m + M(:, i);
    end
    m = m / C;

    Sb = zeros([d, d]);
    for i = 1:C
        Sb = Sb + Ni(i) * (M(:, i) - m) * transpose(M(:, i) - m);
    end

    [Vecs, Vals] = eig(pinv(Sw) * Sb);
    for i = 1:k
        j = d - i + 1;
        eigenvalues(i) = Vals(j, j);
        W(1:d, i) = Vecs(1:d, j);
    end

end

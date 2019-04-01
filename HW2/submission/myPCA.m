function [components, eigenvalues] = myPCA(data, num_principal_components)

    [N, d] = size(data);
    d = d - 1;
    X = data;
    k = num_principal_components;

    % learn covariance matrix
    n1 = 0;
    n2 = 0;
    m1 = zeros([d, 1]);
    m2 = zeros([d, 1]);
    for t = 1:N
        c = X(t, d + 1);
        xt = transpose(X(t, 1:d));
        if c == 1
            n1 = n1 + 1;
            m1 = m1 + xt;
        elseif c == 2
            n2 = n2 + 1;
            m2 = m2 + xt;
        end
    end
    m1 = m1 / n1;
    m2 = m2 / n2;

    S = zeros([d, d]);
    for t = 1:N
        c = X(t, d + 1);
        xt = transpose(X(t, 1:d));
        if c == 1
            S = S + (xt - m1) * transpose(xt - m1);
        elseif c == 2
            S = S + (xt - m2) * transpose(xt - m2);
        end
    end
    S = S / N;

    % find the eigenvalues/vectors
    eigenvalues = zeros([k, 1]);
    components = zeros([d, k]);
    [Vecs, Vals] = eig(S);
    for i = 1:k
        j = d - i + 1;
        eigenvalues(i) = Vals(j, j);
        components(1:d, i) = Vecs(1:d, j);
    end
end

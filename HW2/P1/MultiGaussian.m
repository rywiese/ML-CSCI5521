function [S1, S2] = MultiGaussian(training_data, testing_data, Model)

    % initialize constants
    d = 8;
    N = 100;

    % open and read the training data
    tdID = fopen(training_data, 'r');
    formatSpec = '%f, %f, %f, %f, %f, %f, %f, %f, %d';
    size = [d + 1, N];
    X = transpose(fscanf(tdID, formatSpec, size));

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
    pc1 = n1 / N
    pc2 = n2 / N
    m1 = m1 / n1
    m2 = m2 / n2

    if Model == 1
        S1 = zeros([d, d]);
        S2 = zeros([d, d]);
        for t = 1:N
            c = X(t, d + 1);
            xt = transpose(X(t, 1:d));
            if c == 1
                S1 = S1 + (xt - m1) * transpose(xt - m1);
            elseif c == 2
                S2 = S2 + (xt - m2) * transpose(xt - m2);
            end
        end
        S1 = S1 / n1
        S2 = S2 / n2

    elseif Model == 2
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
        S = S / N
        S1 = S;
        S2 = S;

    elseif Model == 3
        a1 = 0;
        a2 = 0;
        for t = 1:N
            c = X(t, d + 1);
            xt = transpose(X(t, 1:d));
            if c == 1
                a1 = a1 + transpose(xt - m1) * (xt - m1);
            elseif c == 2
                a2 = a2 + transpose(xt - m2) * (xt - m2);
            end
        end
        a1 = (2 / (N * d)) * a1
        a2 = (2 / (N * d)) * a2
        S1 = a1;
        S2 = a2;
    end

    % open and read the testing data
    tdID = fopen(testing_data, 'r');
    formatSpec = '%f, %f, %f, %f, %f, %f, %f, %f, %d';
    size = [d + 1, N];
    X = transpose(fscanf(tdID, formatSpec, size));

    classes = zeros([N, 1]);
    numWrong = 0;
    for t = 1:N
        c = X(t, d + 1);
        xt = transpose(X(t, 1:d));
        if Model == 1
            g1 = - (d / 2) * log(2 * pi) - (1 / 2) * log(det(S1)) - (1 / 2) * transpose(xt - m1) * inv(S1) * (xt - m1) + log(pc1);
            g2 = - (d / 2) * log(2 * pi) - (1 / 2) * log(det(S2)) - (1 / 2) * transpose(xt - m2) * inv(S2) * (xt - m2) + log(pc2);
        elseif Model == 2
            g1 = - (1 / 2) * transpose(xt - m1) * inv(S) * (xt - m1) + log(pc1);
            g2 = - (1 / 2) * transpose(xt - m2) * inv(S) * (xt - m2) + log(pc2);
        elseif Model == 3
            g1 = - (d / 2) * log(2 * pi) - (1 / 2) * d * log(a1) - (1 / 2) * (1 / a1) * transpose(xt - m1) * (xt - m1) + log(pc1);
            g2 = - (d / 2) * log(2 * pi) - (1 / 2) * d * log(a2) - (1 / 2) * (1 / a2) * transpose(xt - m2) * (xt - m2) + log(pc2);
        end
        if g1 >= g2
            classes(t) = 1;
        else
            classes(t) = 2;
        end
        if classes(t) ~= c
            numWrong = numWrong + 1;
        end
    end
    err = numWrong / N


end

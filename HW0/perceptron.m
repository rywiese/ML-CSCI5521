function w = perceptron(X, y)
    w = [1,-1];
    c = 0;
    while c == 0
        c = 1;
        for i = 1:40
            if (dot(w, X(i,:)) * y(i)) <= 0
                w = w + y(i) * X(i,:);
                c = 0;
            end
        end
    end
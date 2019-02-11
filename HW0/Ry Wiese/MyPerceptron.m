function [w, step] = MyPerceptron(X, y, w0)
    %Compute
    w = [1,-1];
    step = 0;
    c = 0;
    while c == 0
        c = 1;
        for i = 1:40
            if (dot(w, X(i,:)) * y(i)) <= 0
                w = w + y(i) * X(i,:);
                step = step + 1;
                c = 0;
            end
        end
    end
    
    %Plot
    colors = zeros(40, 3);
    for i = 1:40
        if y(i) == 1
            colors(i,:) = [1,0,0];
        else
            colors(i,:) = [0,0,1];
        end
    end
    scatter(X(:,1), X(:,2), [], colors, 'filled');
    hold on;
    xaxis = X(:,1);
    line(xaxis, (-w(1) * xaxis) / w(2));
    axis([-1 1 -1 1]);
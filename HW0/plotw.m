function plotw(X, y, w)
    colors = zeros(40, 3);
    for i = 1:40
        if y(i) == 1
            colors(i,:) = [1,0,0];
        else colors(i,:) = [0,0,1];
        end
    end
    scatter(X(:,1), X(:,2), [], colors, 'filled');
    hold on;
    xaxis = X(:,1);
    line(xaxis, (-w(1) * xaxis) / w(2));
    axis([-1 1 -1 1]);
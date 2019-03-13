function dist = distance(a, b)

    D = 64;
    dist = 0;

    c = a - b;

    for i = 1:D
        dist = dist + c(i)^2;
    end

    dist = sqrt(dist);

end

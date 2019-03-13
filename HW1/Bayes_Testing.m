function Bayes_Testing(test_data, p1, p2, pc1, pc2)

    %dimension
    D = 100;

    %read in the testing data into matrix TD
    tdID = fopen(test_data, 'r');
    formatSpec = '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d';
    size = [D+1, Inf];
    TD = transpose(fscanf(tdID, formatSpec, size));

    x = zeros([1, D]);
    PC = zeros([1, 2]);
    class = zeros([1, 200]);
    error = 0;
    for samp = 1:200
        x = TD(samp, 1:D);
        actualClass = TD(samp, D + 1);
        PC(1) = pc1;
        PC(2) = pc2;

        % after this loop, PC(i) will be proportional to p(x|C_i)
        % based on my rule from part 3
        for j = 1:D
            PC(1) = PC(1) * (p1(j) ^ (1 - x(j))) * ((1 - p1(j)) ^ (x(j)));
            PC(2) = PC(2) * (p2(j) ^ (1 - x(j))) * ((1 - p2(j)) ^ (x(j)));
        end

        if PC(1) > PC(2)
            class(samp) = 1;
        elseif PC(2) > PC(1)
            class(samp) = 2;
        end

        if actualClass ~= class(samp)
            error = error + 1;
        end

    end
    sprintf('The error rate is: %f', error / 2)
end

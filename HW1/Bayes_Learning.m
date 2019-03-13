function [p1, p2, pc1, pc2] = Bayes_Learning(training_data, validation_data)

    %dimension
    D = 100;

    %read in the training data into matrix TD
    tdID = fopen(training_data, 'r');
    formatSpec = '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d';
    size = [D+1, Inf];
    TD = transpose(fscanf(tdID, formatSpec, size));

    %read in the validation data into matrix VD
    vdID = fopen(validation_data, 'r');
    formatSpec = '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d';
    VD = transpose(fscanf(vdID, formatSpec, size));

    %ni is the number of samples in C_i
    %sumi is the sum of every vector in C_i
    n1 = 0;
    sum1 = zeros([1, D]);
    n2 = 0;
    sum2 = zeros([1, D]);

    for s = 1:1600
        if TD(s, D+1) == 1
            sum1 = sum1 + TD(s, 1:D);
            n1 = n1 + 1;
        end
        if TD(s, D+1) == 2
            sum2 = sum2 + TD(s, 1:D);
            n2 = n2 + 1;
        end
    end

    % the estimate for P(x=1) is (sumi / ni)
    % pi is the estimate for P(x=0) = 1 - P(x=1)
    p1 = 1 - (sum1 / n1);
    p2 = 1 - (sum2 / n2);

    for i = 1:D
        if p1(i) == 0
            p1(i) = exp(-10);
        end
        if p2(i) == 0
            p2(i) = exp(-10);
        end
    end

    sigma = [.00001, .0001, .001, .01, .1, 1, 2, 3, 4, 5, 6];

    % PC[i] = P(C_i)
    PC = zeros([2, 1]);

    % class(i,j) is the learned class that sample i belongs to in validation data
    % for the jth value of sigma
    class = zeros([200, 11]);

    error = zeros([1, 11]);

    % this loop classifies the validation set
    for sig = 1:11
        for samp = 1:200
            x = VD(samp, 1:D);
            actualClass = VD(samp, D + 1);
            PC(1) = 1 - exp(-1 * sigma(1, sig));
            PC(2) = 1 - PC(1);

            % after this loop, PC(i) will be proportional to p(C_i|x)
            % based on my rule from part 3
            for j = 1:D
                PC(1) = PC(1) * (p1(j) ^ (1 - x(j))) * ((1 - p1(j)) ^ (x(j)));
                PC(2) = PC(2) * (p2(j) ^ (1 - x(j))) * ((1 - p2(j)) ^ (x(j)));
            end

            if PC(1) > PC(2)
                class(samp, sig) = 1;
            elseif PC(2) > PC(1)
                class(samp, sig) = 2;
            end

            if actualClass ~= class(samp, sig)
                error(sig) = error(sig) + 1;
            end

        end
    end

    error = 100 * (error / 200);

    for i = 1:11
        sprintf('sigma: %f\tError: %f', sigma(i), error(i))
    end

    minError = Inf;
    pc1 = 0;
    for i = 1:11
        if error(i) < minError
            minError = error(i);
            pc1 = 1 - exp(-1 * sigma(1, i));
        end
    end
    pc2 = 1 - pc1;
end

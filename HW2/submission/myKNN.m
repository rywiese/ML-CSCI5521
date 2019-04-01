function [prediction] = myKNN(training_data, test_data, k)

    [Ntrain, d] = size(training_data);
    [Ntest, d] = size(test_data);
    d = d - 1;
    %Ntrain = 1500;
    %Ntest = 297;

    prediction = zeros([1, Ntest]);
    neighbors = zeros([Ntrain, 2]);
    classes = zeros([1, 10]);
    for sample = 1:Ntest
        neighbors = zeros([Ntrain, 2]);
        classes = zeros([1, 10]);
        for i = 1:Ntrain
            neighbors(i, 1) = i;
            neighbors(i, 2) = norm(test_data(sample, 1:d) - training_data(i, 1:d));
        end
        [~,idx] = sort(neighbors(:,2));
        neighbors = neighbors(idx,:);
        for i = 1:k
            j = neighbors(i, 1);
            classes(training_data(j, d+1) + 1) = classes(training_data(j, d+1) + 1) + 1;
        end
        [~,argmax] = max(classes);
        prediction(sample) = argmax - 1;
    end
end

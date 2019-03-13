function [prediction] = myKNN(training_data, test_data, k)

    D = 64;
    Ntrain = 1500;
    Ntest = 297;

    prediction = zeros([1, Ntest]);
    neighbors = zeros([Ntrain, 2]);
    classes = zeros([1, 10]);
    for sample = 1:Ntest
        neighbors = zeros([Ntrain, 2]);
        classes = zeros([1, 10]);
        for i = 1:Ntrain
            neighbors(i, 1) = i;
            neighbors(i, 2) = distance(test_data(sample, 1:D), training_data(i, 1:D));
        end
        [~,idx] = sort(neighbors(:,2));
        neighbors = neighbors(idx,:)
        for i = 1:k
            j = neighbors(i, 1);
            classes(training_data(j, D+1) + 1) = classes(training_data(j, D+1) + 1) + 1;
        end
        [~,argmax] = max(classes);
        %classes
        %prediction(sample) = argmax - 1
    end
end

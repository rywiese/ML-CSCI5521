d = 64;
Ntrain = 1500;
Ntest = 297;

% read in the training data into matrix Xtrain
tdID = fopen('optdigits_train.txt', 'r');
formatSpec = '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d';
size = [d+1, Ntrain];
Xtrain = transpose(fscanf(tdID, formatSpec, size));

% read in the test data into matrix Xtest
tdID = fopen('optdigits_test.txt', 'r');
formatSpec = '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d';
size = [d+1, Ntest];
Xtest = transpose(fscanf(tdID, formatSpec, size));

L = [2, 4, 9];
k = [1, 3, 5];
for i = 1:3

    [W, ~] = myLDA(Xtrain, L(i));
    Ztrain = project(Xtrain, W);
    Ztest = project(Xtest, W);
    for j = 1:3
        predictions = myKNN(Ztrain, Ztest, k(j));
        numWrong = 0;
        for b = 1:Ntest
            if predictions(b) ~= Xtest(b, d+1)
                numWrong = numWrong + 1;
            end
        end
        "L value:"
        L(i)
        "K value:"
        k(j)
        "Error:"
        numWrong / Ntest
        ""
    end
end

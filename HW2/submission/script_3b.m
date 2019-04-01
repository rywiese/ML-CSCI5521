d = 960;
Ntrain = 500;
Ntest = 124;
totalTrace = 352650;

% read in the training data into matrix Xtrain
tdID = fopen('face_train_data_960.txt', 'r');
formatSpec = '%d';
size = [d+1, Ntrain];
Xtrain = transpose(fscanf(tdID, formatSpec, size));

% read in the test data into matrix Xtest
tdID = fopen('face_test_data_960.txt', 'r');
formatSpec = '%d';
size = [d+1, Ntest];
Xtest = transpose(fscanf(tdID, formatSpec, size));



numVectors = zeros([d, 1]);
prop = zeros([d, 1]);
for i = 1:d
    i
    numVectors(i) = i;
    [vecs, vals] = myPCA(Xtrain, i);
    prop(i) = sum(vals) / totalTrace;
end

 scatter(numVectors, prop);

k = 34;

[W, vals] = myPCA(Xtrain, k);
Ztrain = project(Xtrain, W);
Ztest = project(Xtest, W);

% run KNN
k = [1,3,5,7];
predictions = zeros([1, Ntest]);

for i = 1:4
    predictions = myKNN(Ztrain, Ztest, k(i));
    numWrong = 0;
    for j = 1:Ntest
        if predictions(j) ~= Xtest(j, d+1)
            numWrong = numWrong + 1;
        end
    end
    "K value:"
    k(i)
    "Error:"
    numWrong / Ntest
    ""
end

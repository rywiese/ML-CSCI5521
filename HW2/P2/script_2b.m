d = 64;
Ntrain = 1500;
Ntest = 297;
totalTrace = 171.8141;

% read in the training data into matrix Xtrain
tdID = fopen('optdigits_train.txt', 'r');
formatSpec = '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d';
size = [d+1, Ntrain];
Xtrain = transpose(fscanf(tdID, formatSpec, size));

% read in the training data into matrix Xtest
tdID = fopen('optdigits_test.txt', 'r');
formatSpec = '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d';
size = [d+1, Ntest];
Xtest = transpose(fscanf(tdID, formatSpec, size));

numVectors = zeros([d, 1]);
prop = zeros([d, 1]);
for i = 1:d
    numVectors(i) = i;
    [vecs, vals] = myPCA(Xtrain, i);
    prop(i) = sum(vals) / totalTrace;
end

% scatter(numVectors, prop);

k = 15;

% find the mean matrix Mtrain
m = zeros([1, d]);
for t = 1:Ntrain
    m = m + Xtrain(t, 1:d);
end
m = m / Ntrain;
Mtrain = zeros([d, Ntrain]);
for i = 1:Ntrain
    Mtrain(:, i) = transpose(m);
end

% project the training data
[W, vals] = myPCA(Xtrain, k);
X = transpose(Xtrain(:, 1:d));
Ztrain = transpose(W) * (X - Mtrain);

% find the mean matrix Mtest
m = zeros([1, d]);
for t = 1:Ntest
    m = m + Xtest(t, 1:d);
end
m = m / Ntest;
Mtest = zeros([d, Ntest]);
for i = 1:Ntest
    Mtest(:, i) = transpose(m);
end

% project the test data
X = transpose(Xtest(:, 1:d));
Ztest = transpose(W) * (X - Mtest);

% format the z matrices for KNN
FormatZtrain = zeros([Ntrain, k + 1]);
FormatZtrain(:, 1:k) = transpose(Ztrain);
FormatZtrain(:, k+1) = Xtrain(:, d+1);

FormatZtest = zeros([Ntest, k + 1]);
FormatZtest(:, 1:k) = transpose(Ztest);
FormatZtest(:, k+1) = Xtest(:, d+1);

% run KNN
k = [1,3,5,7];
predictions = zeros([1, Ntest]);

for i = 1:4
    predictions = myKNN(FormatZtrain, FormatZtest, k(i));
    numWrong = 0;
    for j = 1:Ntest
        if predictions(j) ~= Test(j, D+1)
            numWrong = numWrong + 1;
        end
    end
    %"K value:"
    %k(i)
    %"Error:"
    numWrong / Ntest
    %""
end

d = 960;
Ntrain = 500;
Ntest = 124;
N = Ntrain + Ntest;

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

X = zeros(N, d + 1);
X(1:Ntrain, :) = Xtrain;
X(Ntrain + 1:N, :) = Xtest;

[W, vals] = myPCA(X, 5);

for i = 1:5
    imagesc(reshape(W(1:end,i),32,30)');
    thisfig = figure();
end

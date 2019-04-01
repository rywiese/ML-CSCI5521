d = 960;
Ntrain = 500;
Ntest = 124;
totalTrace = 352650;

% read in the training data into matrix Xtrain
tdID = fopen('face_train_data_960.txt', 'r');
formatSpec = '%d';
s = [d+1, Ntrain];
Xtrain = transpose(fscanf(tdID, formatSpec, s));

% read in the test data into matrix Xtest
tdID = fopen('face_test_data_960.txt', 'r');
formatSpec = '%d';
s = [d+1, Ntest];
Xtest = transpose(fscanf(tdID, formatSpec, s));

m = zeros([1, d]);
for i = 1:Ntrain
    m = m + Xtrain(i, 1:d);
end
m = m / Ntrain;
m = transpose(m);
K = [10, 50, 100];

for r = 1:5
    x = transpose(Xtest(r, 1:d));
    for i = 1:3
        thisfig = figure();
        [W, vals] = myPCA(Xtrain, K(i));
        z = transpose(W) * (x - m);
        xHat = W * z + m;
        imagesc(reshape(xHat, 32, 30));
    end
end

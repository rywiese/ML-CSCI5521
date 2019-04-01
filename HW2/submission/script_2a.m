D = 64;
Ntrain = 1500;
Ntest = 297;

%read in the training data into matrix Train
tdID = fopen('optdigits_train.txt', 'r');
formatSpec = '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d';
size = [D+1, Ntrain];
Train = transpose(fscanf(tdID, formatSpec, size));

%read in the training data into matrix Test
tdID = fopen('optdigits_test.txt', 'r');
formatSpec = '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d';
size = [D+1, Ntest];
Test = transpose(fscanf(tdID, formatSpec, size));

k = [1,3,5,7];
predictions = zeros([1, Ntest]);

for i = 1:4
    predictions = myKNN(Train, Test, k(i));
    numWrong = 0;
    for j = 1:Ntest
        if predictions(j) ~= Test(j, D+1)
            numWrong = numWrong + 1;
        end
    end
    "K value:"
    k(i)
    "Error:"
    numWrong / Ntest
    ""
end

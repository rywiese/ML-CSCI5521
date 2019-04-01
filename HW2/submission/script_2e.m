d = 64;
Ntrain = 1500;
Ntest = 297;

% read in the training data into matrix Xtrain
tdID = fopen('optdigits_train.txt', 'r');
formatSpec = '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d';
s = [d+1, Ntrain];
Xtrain = transpose(fscanf(tdID, formatSpec, s));

% read in the training data into matrix Xtest
tdID = fopen('optdigits_test.txt', 'r');
formatSpec = '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d';
s = [d+1, Ntest];
Xtest = transpose(fscanf(tdID, formatSpec, s));

[W, vals] = myLDA(Xtrain, 2);
Ztrain = project(Xtrain, W);
Ztest = project(Xtest, W);

% plot training data
x = Ztrain(:, 1);
y = Ztrain(:, 2);
c = Ztrain(:, 3);

colors = zeros([Ntrain, 3]);
for i = 1:Ntrain
    if c(i) == 0
        colors(i, :) = [0,0,1];
    elseif c(i) == 1
        colors(i, :) = [0,1,0];
    elseif c(i, :) == 2
        colors(i, :) = [0,1,1];
    elseif c(i, :) == 3
        colors(i, :) = [1,0,0];
    elseif c(i, :) == 4
        colors(i, :) = [1,0,1];
    elseif c(i, :) == 5
        colors(i, :) = [1,1,0];
    elseif c(i, :) == 6
        colors(i, :) = [1,1,1];
    elseif c(i, :) == 7
        colors(i, :) = [.8,.3,.5];
    elseif c(i, :) == 8
        colors(i, :) = [.4,.6,.1];
    elseif c(i, :) == 9
        colors(i, :) = [.3,.7,.8];
    end
end
scatter(x, y, [], colors, 'filled');
labels = strings(size(x));
labels(1:100) = num2str(c(1:100));
text(x, y, cellstr(labels));

thisfig = figure();

% plot test data
x = Ztest(:, 1);
y = Ztest(:, 2);
c = Ztest(:, 3);

colors = zeros([Ntest, 3]);
for i = 1:Ntest
    if c(i) == 0
        colors(i, :) = [0,0,1];
    elseif c(i) == 1
        colors(i, :) = [0,1,0];
    elseif c(i, :) == 2
        colors(i, :) = [0,1,1];
    elseif c(i, :) == 3
        colors(i, :) = [1,0,0];
    elseif c(i, :) == 4
        colors(i, :) = [1,0,1];
    elseif c(i, :) == 5
        colors(i, :) = [1,1,0];
    elseif c(i, :) == 6
        colors(i, :) = [1,1,1];
    elseif c(i, :) == 7
        colors(i, :) = [.8,.3,.5];
    elseif c(i, :) == 8
        colors(i, :) = [.4,.6,.1];
    elseif c(i, :) == 9
        colors(i, :) = [.3,.7,.8];
    end
end
scatter(x, y, [], colors, 'filled');
labels = strings(size(x));
labels(1:100) = num2str(c(1:100));
text(x + .25, y, cellstr(labels));

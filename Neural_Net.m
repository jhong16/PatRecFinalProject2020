
% Define a neural network using with a hidden layer.
% Examine performance with different training functions: trainbr, traingd, traingdm
net = fitnet(2, 'trainbr');


% Network initialization
net = initlay(net);


% Change the activation functions in the hidden layer and the output
% layer, and set both of them equal to ‘tansig’.
net.layers{1}.transferFcn = 'tansig'; % Hidden layer
net.layers{2}.transferFcn = 'tansig'; % Output layer


% Set the value of initial learning rate: Default is 0.01
net.trainParam.lr = 0.01;


% Set the value of maximum number of epochs in training: Default is 1000
net.trainParam.epochs = 1000;


% Indicate which column indices in the ‘data’ matrix belong to training,
% validation and test set.
net.divideFcn = 'divideind';
net.divideParam.trainInd = 1:size(train_data,1);
net.divideParam.valInd = (size(train_data,1)+1):(size(train_data,1)+1+size(val_data,1));
net.divideParam.testInd = (size(train_data,1)+size(val_data,1)+2):size(data,1);


% Train the neural network using ‘train’ function
[net, info] = train(net,data,label,'CheckpointFile','MyCheckpoint');


% Examine hidden layer weights
% weights = getwb(net); % weights = [ Iw(:); b1(:); Lw(:); b2(:) ];
Iw = cell2mat(net.IW);
b1  = cell2mat(net.b(1));
Lw = cell2mat(net.Lw);
b2 = cell2mat(net.b(2));

% comb (2x14)
comb = [Iw,b1];
weight_safe = comb(1,:);
weight_unsafe = comb(2,:);

% Using the trained network, determine the output for the test dataset and
% calculate accuracy. 

% Simulate the network on the test data
simout = sim(net,test_data');

% Set the positive predictions to 1 (safe) and negative predictions to
% -1 (unsafe)
simout(simout>0) = 1;
simout(simout<0) = -1;
% Calculate accuracy
safe_correct = sum(simout(1:length(safe_countries)) == 1);
unsafe_correct = sum(simout((length(safe_countries)+1):end) == -1);

fprintf("Accuracy of predicting 'safe' test data: %.2f\n",safe_correct/length(safe_countries));
fprintf("Accuracy of predicting 'unsafe' test data: %.2f\n",unsafe_correct/length(unsafe_countries));
fprintf("Total accuracy of test data: %.2f\n",(safe_correct + unsafe_correct)/size(test_data,1));


%% Results:
% 80 safe:
% categories = [7:2:21,22,24,29:30,33]:

% ***
% net = fitnet(2, 'traingd'):
% Accuracy of predicting 'safe' test data: 0.76
% Accuracy of predicting 'unsafe' test data: 0.76
% Total accuracy of test data: 0.76

% ***
% net = fitnet(2, 'trainbr'):
% Accuracy of predicting 'safe' test data: 0.86
% Accuracy of predicting 'unsafe' test data: 0.80
% Total accuracy of test data: 0.83


% ***
% net = fitnet(2, 'traingdm')
% Accuracy of predicting 'safe' test data: 0.84
% Accuracy of predicting 'unsafe' test data: 0.67
% Total accuracy of test data: 0.75


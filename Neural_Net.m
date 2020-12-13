
% Define a neural network using with a hidden layer that has 2 nodes.*****
net = fitnet(2, 'traingd');
% Here, the second argument sets the value of ‘net.trainFcn’ to ‘traingd’
% which is necessary to define gradient descent backpropagation.


% Network initialization
net = initlay(net);


% Change the activation functions in the hidden layer and the output
% layer, and set both of them equal to ‘tansig’.*****
net.layers{1}.transferFcn = 'tansig'; % Hidden layer*****
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
% 100 safe:
% categories = [7:2:21,22,24,29:30,33]:
% Accuracy of predicting 'safe' test data: 0.90
% Accuracy of predicting 'unsafe' test data: 0.58
% Total accuracy of test data: 0.77

% 80 safe:
% categories = [7:2:21,22,24,29:30,33]:
% Accuracy of predicting 'safe' test data: 0.76
% Accuracy of predicting 'unsafe' test data: 0.76
% Total accuracy of test data: 0.76


%% Plot

% figure,scatter(top20(:,1),top20(:,2),'r')
% hold on,scatter(bottom80(:,1),bottom80(:,2),'b')
% legend('safe','unsafe')
% xlabel('Avg Government policy score (last month)')
% ylabel('Avg case total (last month)')
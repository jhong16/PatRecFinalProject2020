
%% Plotting Accuracy vs. Number of Categories Considered
% categories = [7:2:21,22,24,29:30,33]: ***size 13
% Accuracy of predicting 'safe' test data: 0.76
% Accuracy of predicting 'unsafe' test data: 0.76
% Total accuracy of test data: 0.76

% categories = [7:2:17,29:30,33]: ***size 9
% Accuracy of predicting 'safe' test data: 0.64
% Accuracy of predicting 'unsafe' test data: 0.79
% Total accuracy of test data: 0.72

% categories = [7:2:17,22,24,29:30,33]: ***size 11
% Accuracy of predicting 'safe' test data: 0.75
% Accuracy of predicting 'unsafe' test data: 0.72
% Total accuracy of test data: 0.74

safe_acc = [0.64 0.75 0.76];
unsafe_acc = [0.79 0.72 0.76];
total_acc = [0.72 0.74 0.76];
num_cats = [9 11 13];

figure, plot(num_cats, safe_acc, 'red')
hold on, plot(num_cats, unsafe_acc, 'green')
plot(num_cats, total_acc, 'blue')
legend("Accuracy for 'Safe' Category Data","Accuracy for 'Unsafe' Category Data","Total Accuracy")
xlabel('Number of Categories Considered')
ylabel('Accuracy')
title('Accuracy vs. Number of Categories Considered')


%% Plotting Accuracies for Network Training Functions

traingd = [0.76 0.76 0.76];
trainbr = [0.86 0.80 0.83];
traingdm = [0.84 0.67 0.75];

x = categorical({'traingd','traingdm','trainbr'});
vals = [traingd; traingdm; trainbr];
figure,bar(x,vals)
hold on, ylim([0.6 0.9])
xlabel('Training Function'),ylabel('Accuracy')
title('Accuracies for Network Training Functions')

b = bar(x,vals);

xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

xtips3 = b(3).XEndPoints;
ytips3 = b(3).YEndPoints;
labels3 = string(b(3).YData);
text(xtips3,ytips3,labels3,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')




% Logistic Regression

%% Initialization
clear ; close all; clc

% csv train file
%train_csv = "train_2.csv";

%% smaller train dataset to develop code
train_csv = "c.csv";

% load variables from file (50% for train and validation)
File_io = csvread(train_csv);

% Shuffle the rows
%File_io = File_io(randperm(size(File_io,1)),:);

X = File_io(1:end*0.5, 3:end);

X_val = File_io(end*0.5+1:end, 3:end);

y = File_io(1:end*0.5, 1);

y_val = File_io(end*0.5+1:end, 1);

id = File_io(:, 2);

%  Setup the data matrix appropriately, and add ones for the intercept term
[m, n] = size(X);

% Add intercept term to x and X_val
X = [ones(m, 1) X];
X_val = [ones(size(X_val, 1), 1) X_val];

% Set regularization parameter lambda
lambda = 1;

% train logistic regression
[theta] = trainLogisticReg(X, y, lambda);

% Calculate the learning curve
[error_train, error_val] = learningCurve(X, y, X_val, y_val, lambda);
				  
% 
plot(1:100:m, error_train(1:100:m), 1:100:m, error_val(1:100:m));
title('Learning curve for linear regression')
legend('Train', 'Cross Validation')
xlabel('Number of training examples')
ylabel('Error')
%axis([0 13 0 150])

% Validation for Selecting Lambda
[lambda_vec, error_train, error_val] = validationCurve(X, y, X_val, y_val);

figure(2);
plot(lambda_vec, error_train, lambda_vec, error_val);
legend('Train', 'Cross Validation');
xlabel('lambda');
ylabel('Error');

% predict
p = sigmoid(X * theta);

% save theta vector
save('theta.mat', 'theta')

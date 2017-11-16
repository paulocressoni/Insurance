% Logistic Regression

%% Initialization
clear ; close all; clc

% csv train file
%train_csv = "train_2.csv";
train_csv = "c.csv";

% load variables from file (50% for train and validation)
X = csvread(train_csv)(1:end*0.5, 3:end);
X_val = csvread(train_csv)(end*0.5+1:end, 3:end);
y = csvread(train_csv)(1:end*0.5, 1);
y_val = csvread(train_csv)(end*0.5+1:end, 1);
id = csvread(train_csv)(:, 2);

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
plot(1:m, error_train, 1:m, error_test);

title(sprintf('Polynomial Regression Learning Curve (lambda = %f)', lambda));
xlabel('Number of training examples')
ylabel('Error')
%axis([0 13 0 100])
legend('Train', 'Test')

% predict
p = sigmoid(X * theta);
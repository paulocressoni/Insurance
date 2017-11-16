function [error_train, error_val] = ...
    learningCurve(X, y, Xval, yval, lambda)
%LEARNINGCURVE Generates the train and cross validation set errors needed 
%to plot a learning curve
%   [error_train, error_val] = ...
%       LEARNINGCURVE(X, y, Xval, yval, lambda) returns the train and
%       cross validation set errors for a learning curve. In particular, 
%       it returns two vectors of the same length - error_train and 
%       error_val. Then, error_train(i) contains the training error for
%       i examples (and similarly for error_val(i)).
%
%   In this function, you will compute the train and test errors for
%   dataset sizes from 1 up to m. In practice, when working with larger
%   datasets, you might want to do this in larger intervals.
%

% Number of training examples
m = size(X, 1);

% You need to return these values correctly
error_train = zeros(m, 1);
error_val   = zeros(m, 1);

% loop from 1 to m training examples
for i = 1:100:m
	X_train = X(1:100:i, :);
	y_train = y(1:100:i);
	
	% obtaining theta parameters for the training set
	[theta] = trainLogisticReg(X_train, y_train, lambda);
	
	% cost of the training set
	[error_train(i), grad] = costFunctionReg(theta, X_train, y_train, 0);
	% lambda is set to zero cause the theta values are already regularized
	
	% cost of the cross validation set
	[error_val(i), grad] = costFunctionReg(theta, Xval, yval, 0);
end


end

library(ggplot2)
library(dplyr)
library(tidyr)

# clean R memory
rm(list=ls(all=TRUE));

setwd("~/Documents/Porto Kaggle/")

# import DataSets
train_orig <- read.csv("train.csv", header = T);
test <- read.csv("test.csv", header = T);

n_train_orig <- nrow(train_orig);
n_test <- nrow(test);


# create the target variable
target <- train_orig[,2]

# remove target from train
train_orig[,2] <- NULL;

train <- dplyr::union(train_orig, test);

# replace missing values (-1) by NA
train[train == -1] <- NA;
test[test == -1] <- NA;

# show collumns classes
sapply(train, class);

# convert some collumns to Factor
cols_cat <- c("ps_ind_02_cat", "ps_ind_04_cat", "ps_ind_05_cat", "ps_car_01_cat", "ps_car_02_cat", 
          "ps_car_03_cat", "ps_car_11_cat", "ps_car_05_cat", "ps_car_06_cat", "ps_car_07_cat", 
          "ps_car_08_cat", "ps_car_09_cat", "ps_car_10_cat", "ps_car_04_cat");

train[cols_cat] <- lapply(train[cols_cat], factor);
test[cols_cat] <- lapply(test[cols_cat], factor);

# convert some collumns to binary(factor)
cols_bin <- c("ps_ind_06_bin", "ps_ind_07_bin", "ps_ind_08_bin", "ps_ind_09_bin", 
              "ps_ind_10_bin", "ps_ind_11_bin", "ps_ind_12_bin", "ps_ind_13_bin", 
              "ps_ind_16_bin", "ps_ind_17_bin", "ps_ind_18_bin", "ps_calc_15_bin", 
              "ps_calc_16_bin", "ps_calc_17_bin", "ps_calc_18_bin", "ps_calc_19_bin", 
              "ps_calc_20_bin");
train[cols_bin] <- lapply(train[cols_bin], factor);
test[cols_bin] <- lapply(test[cols_bin], factor);

# porcentage of NA in each column
na_perc <- sapply(train, function(x) sum(length(which(is.na(x))))/nrow(train));
round(na_perc, digits = 4);

# No missing data on test dataset???
na_perc_test <- sapply(test, function(x) sum(length(which(is.na(x))))/nrow(test));
round(na_perc_test, digits = 4);

# "ps_reg_03", "ps_car_05_cat", "ps_car_03_cat", "ps_reg_03" have too many missing values
# maybe "ps_car_14" has too

# create dummy variable 
#dummy_ps_car_04_cat <- model.matrix(~train$ps_car_04_cat + 0);
# colSums(dummy_ps_car_04_cat)
# summary(train$ps_car_04_cat)

# Analysing missing data
summary(train)
sapply(train, function(x) sum(length(which(is.na(x)))));

# let's treat the missing data of 'ps_car_14'
summary(train$ps_car_14)
# fill missing data with mean
train$ps_car_14[is.na(train$ps_car_14)] <- mean(train$ps_car_14, na.rm = T)

# let's treat the missing data of 'ps_car_09_cat'
summary(train$ps_car_09_cat)
train$ps_car_09_cat[is.na(train$ps_car_09_cat)] <- 2

# let's treat the missing data of 'ps_car_07_cat'
summary(train$ps_car_07_cat)
train$ps_car_07_cat[is.na(train$ps_car_07_cat)] <- 1

# let's treat the missing data of 'ps_car_05_cat'
summary(train$ps_car_05_cat)
train$ps_car_05_cat[is.na(train$ps_car_05_cat)] <- 1

# let's treat the missing data of 'ps_reg_03'
summary(train$ps_reg_03)
train$ps_reg_03[is.na(train$ps_reg_03)] <- mean(train$ps_reg_03, na.rm = T)

# let's treat the missing data of 'ps_car_01_cat'
summary(train$ps_car_01_cat)
train$ps_car_01_cat[is.na(train$ps_car_01_cat)] <- 11

# let's treat the missing data of 'ps_car_03_cat'
summary(train$ps_car_03_cat)
train$ps_car_03_cat[is.na(train$ps_car_03_cat)] <- 1

# let's treat the missing data of 'ps_ind_05_cat'
summary(train$ps_ind_05_cat)
train$ps_ind_05_cat[is.na(train$ps_ind_05_cat)] <- 0

# let's treat the missing data of 'ps_ind_02_cat'
summary(train$ps_ind_02_cat)
train$ps_ind_02_cat[is.na(train$ps_ind_02_cat)] <- 1

# let's treat the missing data of 'ps_ind_04_cat'
summary(train$ps_ind_04_cat)
train$ps_ind_04_cat[is.na(train$ps_ind_04_cat)] <- 0

# let's treat the missing data of 'ps_car_02_cat'
summary(train$ps_car_02_cat)
train$ps_car_02_cat[is.na(train$ps_car_02_cat)] <- 1

# let's treat the missing data of 'ps_car_11'
summary(train$ps_car_11)
train$ps_car_11[is.na(train$ps_car_11)] <- mean(train$ps_car_11, na.rm = T)

# let's treat the missing data of 'ps_car_12'
summary(train$ps_car_12)
train$ps_car_12[is.na(train$ps_car_12)] <- mean(train$ps_car_12, na.rm = T)


# Number of columns to be added (dummy variables)
#nc <- 0
# Number of columns to be deleted
#nd <- 0

# iterate through the categorical columns
for (col_cat in cols_cat) {
  # create the dummy variables for the "i" column
  train_col_cat <- train[[col_cat]]
  dummy_var <- model.matrix(~train_col_cat + 0)
  
  # merge the dataset with the dummy variables
  train <- dplyr::bind_cols(train, as.data.frame(dummy_var))
  
  # add number of columns added
  #nc <- nc + ncol(dummy_var)
  
  # delete the original column
  train[[col_cat]] <- NULL
  
  # add number of columns deleted
  #nd <- nd + 1
}

# this should equals...
#ncol(train_orig) + nc - nd
# ...this
#ncol(train)
# above is just a control #


# convert the binaries/factors to integer
train[cols_bin] <- lapply(train[cols_bin], function(x) as.integer(levels(x))[x]);

# separate the test dataset
n <- n_train_orig + 1
test <- train[n:nrow(train), ]

# separate the train dataset
train <- train[1:n_train_orig, ]

# include the target on the train dataset
train <- dplyr::bind_cols(as.data.frame(target), train)

# write the CSV train file
write.table(train, file = "train_2.csv",row.names=FALSE, 
            col.names=FALSE, sep=",")

# write the CSV test file
write.table(test, file = "test_2.csv",row.names=FALSE, 
            col.names=FALSE, sep=",")

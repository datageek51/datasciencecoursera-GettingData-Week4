##The goal is to prepare tidy data that can be used for later analysis. 
## You will be graded by your peers on a series of yes/no questions related to the project. 
## You will be required to submit: 
##   1) a tidy data set as described below, 
##   2) a link to a Github repository with your script for performing the analysis, and 
##  3) a code book that describes the variables, the data, and any transformations or 
##  work that you performed to clean up the data called CodeBook.md. 
## You should also include a README.md in the repo with your scripts. 
##  This repo explains how all of the scripts work and how they are connected.
## Author Navin Parmar
## Created on 23 July 2017
## Last Updated on 23 July 2017


## Loading required library packages
library(reshape2)

    	
## 1: Merges the training and the test sets to create one data set

# read data into data frames
#setwd("C:/DataScience/folder/Week4/Project/UCI HAR Dataset")
subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")
X_train <- read.table("./train/X_train.txt")
X_test <- read.table("./test/X_test.txt")
y_train <- read.table("./train/y_train.txt")
y_test <- read.table("./test/y_test.txt")

# add column name for subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# add column names for measurement files
featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

# add column name for label files
names(y_train) <- "activity"
names(y_test) <- "activity"

# combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)


## 2: Extracts only the measurements on the mean and standard
## deviation for each measurement.

# determine which columns contain "mean()" or "std()"
meanstdcols <- grepl("mean\\(\\)", names(combined)) |
    grepl("std\\(\\)", names(combined))

# ensure that we also keep the subjectID and activity columns
meanstdcols[1:2] <- TRUE

# remove unnecessary columns
combined <- combined[, meanstdcols]


## 3: Uses descriptive activity names to name the activities
## in the data set.
## 4: Appropriately labels the data set with descriptive
## activity names. 

# convert the activity column from integer to factor
combined$activity <- factor(combined$activity, labels=c("Walking",
    "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))


## 5: Creates a second, independent tidy data set with the
## average of each variable for each activity and each subject.

# creating the tidy data set
melted <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy, "tidy.csv", row.names=FALSE)

# run_analysis.R
# 12/26/2015 improvcode
# Create a tidy dataset from from the accelerometers from the Samsung Galaxy S smartphone
# Jorge-L. Reyes-Ortiz, Luca Oneto, Albert SamÃ , Xavier Parra, Davide Anguita. Transition-Aware Human Activity Recognition Using Smartphones. Neurocomputing. Springer 2015. 

library(magrittr)
library(dplyr)

# Create a temporary file to download the zipped data
temp <- tempfile()
# Dowload the data into the temporary file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
# Get the contents of the zip file
file_ls <- unzip(temp, list=TRUE)
# Extract the README.txt and features_info files to use as reference
unzip(temp, file="UCI HAR Dataset/README.txt")
unzip(temp, file="UCI HAR Dataset/features_info.txt")
# Extract the activity labels and feature files
features <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
activity_labels <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))
# Add variable names to the activity data frame for ease of merging later
names(activity_labels) <- c("activity_code", "activity_label")

# Extract the training data
X_train <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
subj_train <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
# Label the variables
names(X_train) <- features[,2]
names(y_train) <- "activity_code"
names(subj_train) <- "subject_code"
# Merge label for activity code
y_train <- merge(y_train, activity_labels, by=c("activity_code"))
# Create a source vector
source_train <- data.frame(rep("train", dim(y_train)[1]))
names(source_train) <- "source_id"

# Extract the test data
X_test <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
subj_test <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
names(X_test) <- features[,2]
names(y_test) <- "activity_code"
names(subj_test) <- "subject_code"
# Merge label for activity code
y_test <- merge(y_test, activity_labels, by=c("activity_code"))
# Create a source vector
source_test <- data.frame(rep("test", dim(y_test)[1]))
names(source_test) <- "source_id"

# Join train and test to create a single dataset
# Use regular expression lookup to match only the columns with mean() or std() in the name
UCI_HAR <- rbind(cbind(subj_train, y_train, 
                       X_train[, grepl("mean\\(\\)|std\\(\\)",features[[2]])],
                       source_train),
                 cbind(subj_test, y_test, 
                       X_test[, grepl("mean\\(\\)|std\\(\\)",features[[2]])],
                       source_test))

# Create additional dataset with the average of each variable for each activity and each subject
UCI_HAR_AVG <- UCI_HAR %>% 
  group_by(subject_code, activity_code, activity_label) %>%
  select(-source_id) %>%
  summarise_each(funs(mean))

# Write averages to text file
write.table(UCI_HAR_AVG, file="uci_har_avg.txt", row.names=FALSE)

# Clean up temporary file
unlink(temp)

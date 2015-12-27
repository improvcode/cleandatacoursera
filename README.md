# cleandatacoursera
Course project for Coursera class in data cleaning

The main file in this repository is run_analysis.R.
This file downloads the zipped data for the Human Activity Recognition Using Smartphones Data Set. This data represents data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data is downloaded from the following link: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  from this link:

Running this scripts performs the following analysis:

1. The zipped data is downloaded to a temporary file in the current working directory
2. The descriptive files with activity names and full feature list are extracted
3. The feature data for both the training and test data is downloaded and variables are labeled appropriately. For each set three files are extracted
  a. subject codes
  b. activity codes
  c. feature data
4. The activity labels are merged to the activity codes
5. Only the features with mean and standard deviation measurements are kept
6. A source vector is created for each set and then the training and test datasets are joined by appending
7. Averages for each feature are calculated by subject and activity id
8. The averages are written out to the file uci_har_avg.txt


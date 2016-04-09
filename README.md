#Project Description
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

This README file explains details on how to process the data files are included and what are their features.

##Data Source

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Files Included in Repository
This repo includes following files:
1. CodeBook.md: information about raw and tidy data set and elaboration made to transform them
2. README.md: this file
3. run_analysis.R: R script to transform raw data set in a tidy one


#data processing with run_analysis.R Script

Downloads the dataset from the URL mentioned above and unzips it to create UCI HAR Dataset folder

Imports test and train datsets and then Merges the training and the test sets to create one dataset.

Extracts a subset of data with only the measurements on the mean mean() and standard deviation std() for each measurement. 

Updates the variable names in the dataset to improve readibility

Appropriately labels the data set with descriptive activity names in place of activity Ids

Create a new dataset with average of each measurement variable for each activity and each subject
Writes new tidy datasetto a text file to create the required tidy data set file of 180 observations and 68 columns(2 columns for activityName and subjectID and 66 columns for measurement variables)

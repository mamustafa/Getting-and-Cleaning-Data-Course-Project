---
output: word_document
---
#Getting and Cleaning Data Course Project
```{r Get  time, echo=FALSE}
time <- format(Sys.time(), "%a %b %d %X %Y")
```
##Last  Updated on `r time`.
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


##Download project  Data
```{r}
if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "./data/analysis.zip")
unzip(zipfile="./data/analysis.zip",exdir="./data")
filesPath <- file.path("./data" , "UCI HAR Dataset")
filelist <- list.files(filesPath, recursive=TRUE)
```

```{r Reading the The Data}
#calling r libraries
library(data.table)
library(plyr)

#Read the Activity files
ActivityTestData  <- read.table(file.path(filesPath, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrainData <- read.table(file.path(filesPath, "train", "Y_train.txt"),header = FALSE)

#Read the Subject files
SubjectTrainData <- read.table(file.path(filesPath, "train", "subject_train.txt"),header = FALSE)
SubjectTestData  <- read.table(file.path(filesPath, "test" , "subject_test.txt"),header = FALSE)

#Read Fearures files
FeaturesTestData  <- read.table(file.path(filesPath, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrainData <- read.table(file.path(filesPath, "train", "X_train.txt"),header = FALSE)
```
# 1- Merge the training and the test sets to create one data set

```{r Merge the Data}
#Merges the training and the test sets to create one data set
#Concatenate the data tables by rows using rbind

#subject Data
SubjectData <- rbind(SubjectTrainData, SubjectTestData)
#Activity Data
ActivityData<- rbind(ActivityTrainData, ActivityTestData)
#Features Data  
FeaturesData<- rbind(FeaturesTrainData, FeaturesTestData)

```

```{r}
#add  names to variables
names(SubjectData)<-c("subject")
names(ActivityData)<- c("activity")
featureNames <- read.table(file.path(filesPath, "features.txt"),head=FALSE)
names(FeaturesData)<- featureNames$V2
#The data from  SubjectData,ActivityData and FeaturesData are merged
compDataSet <- cbind(SubjectData,ActivityData,FeaturesData)

```
# 2- Extracts only the measurements on the mean and standard deviation for each measurement
```{r standard deviation for each measurement}
#Extract the column that have either mean or std in them.
subdataFeaturesNames <-featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )

```

```{r}
#create subset data based on the required columns
MyData<-subset(compDataSet,select=selectedNames)

```
# 3- Uses descriptive activity names to name the activities in the data set

```{r}
#Read descriptive activity names from “activity_labels.txt”
activityLabels <- read.table(file.path(filesPath, "activity_labels.txt"),header = FALSE)

MyData$activity <- as.character(MyData$activity)
for (i in 1:6){
        MyData$activity [MyData$activity == i] <- as.character(activityLabels[i,2])
}

#actor the activity variable, once the activity names are updated.
MyData$activity  <- as.factor(MyData$activity )

names(MyData)
```
# 4 - Appropriately labels the data set with descriptive variable names
```{r}
#fix the columns names
names(MyData)<-gsub("Acc", "Accelerometer", names(MyData))
names(MyData)<-gsub("Gyro", "Gyroscope", names(MyData))
names(MyData)<-gsub("BodyBody", "Body", names(MyData))
names(MyData)<-gsub("Mag", "Magnitude", names(MyData))
names(MyData)<-gsub("^t", "Time", names(MyData))
names(MyData)<-gsub("^f", "Frequency", names(MyData))
names(MyData)<-gsub("tBody", "TimeBody", names(MyData))
names(MyData)<-gsub("-mean()", "Mean", names(MyData), ignore.case = TRUE)
names(MyData)<-gsub("-std()", "STD", names(MyData), ignore.case = TRUE)
names(MyData)<-gsub("-freq()", "Frequency", names(MyData), ignore.case = TRUE)
names(MyData)<-gsub("angle", "Angle", names(MyData))
names(MyData)<-gsub("gravity", "Gravity", names(MyData))

names(MyData)
```
# 5- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

```{r Create tidy dataset}
MyData$subject <- as.factor(MyData$subject)
tData<-aggregate(. ~subject + activity, MyData, mean)
tData<-tData[order(tData$subject,tData$activity),]
write.table(tData, file = "Tidy.txt", row.names = FALSE)
```


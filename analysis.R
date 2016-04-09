#download the project file 
if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "./data/analysis.zip")
unzip(zipfile="./data/analysis.zip",exdir="./data")
filesPath <- file.path("./data" , "UCI HAR Dataset")
filelist <- list.files(filesPath, recursive=TRUE)

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

#Merges the training and the test sets to create one data set
#Concatenate the data tables by rows using rbind

#subject Data
SubjectData <- rbind(SubjectTrainData, SubjectTestData)
#Activity Data
ActivityData<- rbind(ActivityTrainData, ActivityTestData)
#Features Data
FeaturesData<- rbind(FeaturesTrainData, FeaturesTestData)

#add  names to variables
names(SubjectData)<-c("subject")
names(ActivityData)<- c("activity")
featureNames <- read.table(file.path(filesPath, "features.txt"),head=FALSE)
names(FeaturesData)<- featureNames$V2
#The data from  SubjectData,ActivityData and FeaturesData are merged
compDataSet <- cbind(SubjectData,ActivityData,FeaturesData)


#Extract the column that have either mean or std in them.
subdataFeaturesNames <-featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )

#create subset data based on the required columns
MyData<-subset(compDataSet,select=selectedNames)


#Read descriptive activity names from “activity_labels.txt”
activityLabels <- read.table(file.path(filesPath, "activity_labels.txt"),header = FALSE)

MyData$activity <- as.character(MyData$activity)
for (i in 1:6){
        MyData$activity [MyData$activity == i] <- as.character(activityLabels[i,2])
}

#factor the activity and subject variables, once the activity names are updated.
MyData$activity  <- as.factor(MyData$activity )
MyData$subject <- as.factor(MyData$subject)

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

#From the data set in step 4, creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject
tData<-aggregate(. ~subject + activity, MyData, mean)
tData<-tData[order(tData$subject,tData$activity),]
write.table(tData, file = "Tidy.txt", row.names = FALSE)

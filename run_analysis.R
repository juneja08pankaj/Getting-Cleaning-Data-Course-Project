#Clean workspace and setup working directory
remove(list=ls())
#Please replace the following Path with working directory
setwd("D://Practice//R//Assignment//CleanData")
getwd()

#create a folder, if not already exists 
if(!file.exists("./data")){dir.create("./data")}
# Download files
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
# Unzip files
unzip(zipfile="./data/Dataset.zip",exdir="./data")
# Remove redundant zip file
unlink("./data/Dataset.zip",recursive = TRUE)
path_rootFolder <- file.path("./data" , "UCI HAR Dataset")
# Navigate list of files
files<-list.files(path_rootFolder, recursive=TRUE)

#Read the Activity files
dataActivityTest  <- read.table(file.path(path_rootFolder, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rootFolder, "train", "Y_train.txt"),header = FALSE)
#Read the Subject files
dataSubjectTrain <- read.table(file.path(path_rootFolder, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rootFolder, "test" , "subject_test.txt"),header = FALSE)
#Read Fearures files
dataFeaturesTest  <- read.table(file.path(path_rootFolder, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rootFolder, "train", "X_train.txt"),header = FALSE)

# merges the training and the test sets
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

# Uses descriptive activity names to name the activities in the data set
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rootFolder, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

# Extracts only the measurements on the mean and standard deviation for each measurement.
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

# Appropriately labels the data set with descriptive variable names.
activityLabels <- read.table(file.path(path_rootFolder, "activity_labels.txt"),header = FALSE)
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#call libraries and create an independent tidy data set with the average of each variable for each activity and each subject

library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)



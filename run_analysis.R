setwd("D:\\BI\\Coursera\\Courses\\3Getting&CleaningData\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset")


## 1. Merges the training and the test sets to create one data set.
Xtrain <- read.table("./train/X_train.txt")  ##training set
dim(Xtrain)

Xtest <- read.table("./test/X_test.txt")   ##test set
dim(Xtest)

mergedData <- merge(Xtrain,Xtest,all=TRUE)   ##merged set
dim(mergedData)


# 2. Extracts only the measurements on the mean and standard deviation 
# for each measurement.

features <- read.table("features.txt")
dim(features)
str(features)
names(features)

x <- features[grep("mean()",features$V2,fixed = TRUE),]
x
y <- features[grep("std()",features$V2),]
y
z<-merge(x,y,all=TRUE)
z

# 3. Uses descriptive activity names to name the activities in the data set

Ytrainactivity <- read.table("./train/Y_train.txt")
Ytestactivity <- read.table("./test/Y_test.txt")
dim(Ytrainactivity)
dim(Ytestactivity)
activity <- rbind(Ytrainactivity,Ytestactivity)
mergedData <- cbind(mergedData,activity)
colnames(mergedData)[562]<-"activity"
list1 <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")

for(i in 1:6)
{
mergedData$activity <- gsub(i,list1[i],mergedData$activity)
}



# 4. Appropriately labels the data set with descriptive variable names.

features <- read.table("features.txt")

for(i in 1:561)
{
  x<-features[i,2]  
  colnames(mergedData)[i]<-as.character(x)
}
colnames(mergedData)
dim(mergedData)


# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject

trainsubj <- read.table("./train/subject_train.txt")
testsubj <- read.table("./test/subject_test.txt")

subject <- rbind(trainsubj,testsubj)

dim(subject)
library(Hmisc)
library(plyr)

mergedData <- cbind(mergedData,subject)
colnames(mergedData)[563]<-"subject"
colnames(mergedData)
write.csv(mergedData,file="mergedData.csv")

avg <- aggregate(mergedData[,1:561],by=list(mergedData$activity,mergedData$subject),FUN=mean)
write.table(avg,file="mergedData.txt",row.names = FALSE)

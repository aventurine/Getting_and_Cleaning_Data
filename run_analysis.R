#0. Check if .zip file with data has already been downloaded, download it if it isn't there, then change to the UCI HAR Dataset directory.

if(dir.create("UCI HAR Dataset")==TRUE) {  	#check if the folder exists (if it does, assume it has the files in it)
if(!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
	setInternet2(use = TRUE) #needed for downloading via IE, which is used by my employer
	download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "getdata_projectfiles_UCI HAR Dataset.zip")
}
	unzip("getdata_projectfiles_UCI HAR Dataset.zip")	
}
setwd(".\\UCI HAR Dataset")


#1. Merge the training and test sets to create one data set.

features <- read.table("features.txt", stringsAsFactors = FALSE)

trainS <- read.table("train\\subject_train.txt")
testS <- read.table("test\\subject_test.txt")

act_train <- read.table("train\\y_train.txt")
act_test <- read.table("test\\y_test.txt")

trainData <- read.table("train\\X_train.txt")
testData <- read.table("test\\X_test.txt")

testSet<-cbind(testS$V1, act_test$V1, testData)
colnames(testSet) <- c("Subject", "Activity", features$V2)

trainSet<-cbind(trainS$V1, act_train$V1, trainData)
colnames(trainSet) <- c("Subject", "Activity", features$V2)

mergedSet <- rbind(trainSet, testSet)
orderedSet <- mergedSet[order(mergedSet$Subject),]

 

#2. Extract only the variables with the mean and standard deviation for each measurement.

#load stringi package to detect strings in variable names

install.packages("stringi")  #install the stringi package if necessary
library(stringi)

#extract from features.txt only the features that contain "mean()" and "std()"

ms <- c("mean()", "std()")
mean_std <- features[sapply(features$V2, function(x) any(stri_detect_fixed(x, ms))),] #mean_std$V2 has the 66 features we want

cnames <- c("Subject", "Activity", mean_std$V2)

extractedSet<-orderedSet[,cnames]


#3. Use descriptive activity names to name the activities in the data set. 

extractedSet$Activity <- factor(extractedSet$Activity, levels = c(1,2,3,4,5,6), labels = c("Walking", "WalkingUpstairs", "WalkingDownstairs", "Sitting", "Standing", "Lying")) 


#4. Appropriately label the data set with descriptive activity names. (Per the Community TA, this should include the variable names as well as the activity names.)
#5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

library(reshape2)
library(stringr)

#melt the set so that the Subjects and Activities appear in columns
meltSet <- melt(extractedSet, id=c('Subject','Activity'))

meltSet$Source[str_detect(meltSet$variable, "Body")]<-"Body"
meltSet$Source[str_detect(meltSet$variable, "Gravity")]<-"Gravity"

meltSet$Type[str_detect(meltSet$variable, "Acc")]<-"Linear"
meltSet$Type[str_detect(meltSet$variable, "AccJerk")]<-"Linear"
meltSet$Type[str_detect(meltSet$variable, "Gyro")]<-"Angular"

meltSet$Motion[str_detect(meltSet$variable, "Gyro-")]<-"Velocity"
meltSet$Motion[str_detect(meltSet$variable, "Acc")]<-"Acceleration"
meltSet$Motion[str_detect(meltSet$variable, "GyroMag")]<-"Acceleration"
meltSet$Motion[str_detect(meltSet$variable, "Jerk")]<-"Jerk"

meltSet$Domain[str_detect(meltSet$variable, "tB")]<-"Time"
meltSet$Domain[str_detect(meltSet$variable, "tG")]<-"Time"
meltSet$Domain[str_detect(meltSet$variable, "fB")]<-"Frequency"


meltSet$Measured[str_detect(meltSet$variable, "-X")]<-"X"
meltSet$Measured[str_detect(meltSet$variable, "-Y")]<-"Y"
meltSet$Measured[str_detect(meltSet$variable, "-Z")]<-"Z"
meltSet$Measured[str_detect(meltSet$variable, "Mag")]<-"Magnitude"

meltSet$Measurement[str_detect(meltSet$variable, "mean()")]<-"Mean"
meltSet$Measurement[str_detect(meltSet$variable, "std()")]<-"StdDev"

#de-cast so that means and standard deviations appear in separate columns and averages of each variable are calculated for each subject and activity
castSet<-dcast(meltSet, Subject + Activity + Source + Type + Motion + Measured + Domain ~ Measurement, value.var = "value", fun.aggregate=mean)

#sort 
attach(castSet)
castSort<-castSet[order(Subject, Activity, Source, -xtfrm(Type), Motion, Measured, -xtfrm(Domain)),]

#write the sorted tidy data set to a file
write.table(castSort, file = "tidy_data.txt")









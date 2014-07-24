Getting and Cleaning Data Course Project
========


## Introduction

As stated in the Getting and Cleaning Data Course Project description, the purpose of this project was to demonstrate the ability to “collect, work with, and clean” a data set by preparing a “tidy” data set that can be analyzed later. The data source is the Human Activity Recognition (HAR) Using Smartphones Data Set posted at the UC Irvine Machine Learning Repository [1]. This dataset is described briefly below. The tidy data set, tidy\_data.txt, was produced by a single R script, run\_analysis.R, as described below. The R script is available in this repo. The Code Book (CodeBook.md), also in this repo, summarizes the contents of the tidy data set. The tidy data set can be accessed in R using the read.table command.


## UCI HAR Data Set

The HAR data collection procedures are described in detail in a README accompanying the data set [2] and in a conference paper [3] (see also [4]) and are not provided here. In brief, each of 30 volunteers, aged 19 to 48 years, performed several repetitions of six static activities of daily living (STANDING, SITTING, LYING, and SITTING) and six dynamic activities (WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS) while wearing a Samsung Galaxy S II smartphone at the waist. The researchers sampled (at a constant 50 Hz rate) triaxial (X, Y, Z) linear acceleration data and triaxial angular velocity data from the phone’s embedded accelerometer and gyroscope, respectively. 

Details of signal processing are provided in [2] and [3] and are omitted here. The researchers produced a  set of 33 basic signals and assigned them names (with the XYZ suffix representing three signals) in the following manner, as specified in [2]:
 
A. The acceleration signal was separated into body and gravity acceleration signals: tBodyAcc-XYZ,  tGravityAcc-XYZ

B. The body linear acceleration and body angular velocity were time differentiated to obtain Jerk signals: tBodyAccJerk-XYZ, tBodyGyroJerk-XYZ

C. The magnitudes of the three-dimensional signals were calculated using the euclidean norm: tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag

D. A Fast Fourier Transform (FFT) was applied to some signals: fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag


Finally, the researchers estimated a set of 17 variables from each signal. Of these estimates, only those for which mean and standard deviation were both present were extracted and used in this project. Thus the estimates  meanFreq, gravityMean, and tBodyAccMean were not extracted.

It must be noted that the descriptions and labels of the signal features produced in Step B differ in [2] and [3]. In [3], jerk is correctly described as the time derivative of acceleration, rather than that of velocity, as in [2], and the time derivative of angular velocity is correctly referred to as angular acceleration, not jerk. However, the feature labels in the actual data file follow [2], not [3], as shown in Table 1. Thus, in transforming the feature labels into variable names, as described in the next section, the labeling in [2] and the data file is followed.

[Table 1](https://github.com/aventurine/aventurine.github.io/Table 1.gif)

## Feature Label-to-Variable Name Transformations
The feature labels in the HAR data set have a characteristic of messy datasets, as identified on page 5 of [5]: “multiple variables are stored in one column.” For example, tBodyGyroJerk-mean()-X contains values of six variables. 

These six variables are listed here, along with their possible values and (in parentheses) the corresponding abbreviations in the HAR feature names:

* Domain: Time (t), Frequency (f)

* Source (of estimation): Body, Gravity

* Type (of motion): Linear, Angular (Gyro)

* Motion: Velocity, Acceleration (Acc), Jerk

* Measurement: Mean (mean), StdDev (std)

* Measured (value): X, Y, Z, Magnitude (Magnitude)

Table 2 shows the complete mapping of components of the HAR feature labels to these variables and their values. 

[Table 2](https://github.com/aventurine/aventurine.github.io/Table 2.gif)

To create the tidy data set, I heeded two principles listed on page 4 of [5]:

1. Each variable forms a column.

2. Each observation forms a row. 

Following the example in section 3.3 and Table 12 of [5], I placed the each of the six variables into a separate column, with Measurement values (Mean, StdDev) in separate columns. 

## R script
The R script, run\_analysis.R, first checks if the required files are present in the local directory and downloads them if they are not. It then accomplishes the following, as described on the Course Project requirement page:

**1. Merges the training and the test sets created by the HAR researchers into a single data set.** 
I did this using rbind.

**2. Extracts only the mean and standard deviation measurements**; i.e., those with the suffixes mean() and std().
I used the stringi library to extract only the data with feature labels in which  mean() and sd() appeared.

**3. Uses descriptive activity names to label the activities of daily living (ADLs) recorded in the data set.** 
This involved changing the ADL number codes into verb forms using the factor function:

1 => Walking 

2 => WalkingUpstairs  

3 => WalkingDownstairs 

4 => Sitting 

5 => Standing 

6 => Lying


**4. Labels the data set with descriptive activity names.** 
Per the Community TAs on the course discussion forums, this refers to the names of the signal features generated by the HAR researchers. I used the reshape2 and stringr libraries and melted the set so that the Subject and Activities appeared in columns. I used str_detect to make the substitutions shown in Table 2 and create new columns for each of the variables. 

**5. Creates an independent tidy data set with the average of each variable for each activity and each subject.**  Using the dcast function, I rotated the Measurement variable (with levels Mean and StdDev) back into two separate columns and calculated the averages of each variable for each Subject and Activity. Finally, I sorted the data alphabetically by variable name and exported it to a text file using the write.table command in R. 


## References

[1] http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

[2] Feature Selection (features_info.txt) included in the UCI HAR Data Set download,  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

[3] Anguita D, Ghio A, Oneto L, Parra X, and Reyes-Ortiz JL. A Public Domain Dataset for Human Activity Recognition Using Smartphones. European Symposium on Artificial Neural Networks (ESANN 2013). Bruges, Belgium, April 2013.

[4] Anguita D, Ghio A, Oneto L, Parra X, and Reyes-Ortiz JL. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain, December 2012.

[5] Wickham H. Tidy Data. Unpublished manuscript. http://vita.had.co.nz/papers/tidy-data.pdf

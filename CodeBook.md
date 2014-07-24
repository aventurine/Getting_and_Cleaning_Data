Code Book
========
Getting and Cleaning Data Course Project
========


The tidy data file in this repo (tidy\_data.txt) contains data from 30 subjects, each of whom performed several repetitions of six activities, three dynamic (walking, walking upstairs, walking downstairs) and three static (sitting, standing, and lying). Subject ID numbers are provided in column 2 and activities are indicated in column 3. Column 1 preserves the original row numbers of the data before they were sorted.

Gyroscope and accelerometer readings were taken from a smartphone worn by each subject while performing the activities. The original researchers performed several transformations of the these readings, as described in the README, producing a total of 33 signals for each activity within each subject (30 subjects x 6 activities x 33 transformations = 5940 rows of data). 

The numeric data in the tidy\_data file (columns 9 and 10) are the means and standard deviations of the signals resulting from these transformations, within each activity by each subject. 

The labels of the transformations provided by the original researchers were recoded in accordance with "tidy data" principles, as described in the README. These codes, representing values of variables, are provided in columns 4-8: Source, Type, Motion, Measured, Domain. 
  

* **Source** of the measurements: Body (measured or calculated from accelerometer or gyroscope), Gravity (calculated from accelerometer) 

* **Type** (of motion): Linear (measured from accelerometer), Angular (measured from gyroscope)

* **Motion**: Velocity (measured for Angular motion), Acceleration (measured for Linear motion, calculated for Angular motion), Jerk (calculated for Linear and Angular motion)

* **Measured** value: X, Y, Z (measured from from accelerometer or gyroscope), Magnitude (calculated from X, Y, Z signals)

* **Domain**: Time (measured or calculated from accelerometer or gyroscope), Frequency (calculated from Time domain signals via FFT)


The tidy_data.txt may be read into R using the read.table function.

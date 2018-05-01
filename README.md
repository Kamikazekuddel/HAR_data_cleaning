#Human Activity Recognition Using Smartphones Dataset Data Cleaning

The run_analysis.R script downloads the data and addresses the follwoing points from the assignment

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

One should note that point 4. is mostly done in connection with point five.
Furthermore the process of tidying the dataset splits it into three differrent tables
such that each table contains one observational unit. Therefore the run_analysis.R
script outputs three .txt files

* observations.txt
* measurement_details.txt
* transformation_details.txt

The first of these files was submitted for the assignment but the other two also contain important reference data.
To learn details about these tables please refer to the CodeBook.
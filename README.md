#Human Activity Recognition Using Smartphones Dataset Data Cleaning

The run_analysis.R script downloads the data and addresses the follwoing points from the assignment

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The points in the task are done out of order. When reading in the X data features
belonging to mean and std are select (point 2). When reading in the y data
activities are converted into a more readable factor representation (point 3).
Afterwards train and test data is merged (point 1). Appropriately labeling the
variable names is for subjects and activities is done when reading the data
from the files. For the measurement features the names are already descriptive
and except for some slight cleanup no changes are performed (point 4).
Finally the measurements are averaged across subject and activity and the tidy
output file is created (point 5).

The script generates a file called averageObservations.txt as it's output.
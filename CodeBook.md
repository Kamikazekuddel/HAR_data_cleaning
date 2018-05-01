#CodeBook

## General Structure
The general structure of the cleaned data consists of
three tables.

* observations
* measurement_details
* transformation_details

The logic behind this spilt is,that our data is obtained from raw Inertial Signals data.
This data is transformed in various ways and then itis aggregated to obtain our observations.
This means that we can make serveral observations from one original raw measurement!

This is the content of the observations table. This table specifies
specifies the original measurement and the performed transformation
and shows the resulting aggregate variables

The measurement_details table contain variables with more details on a specific
measurement, i.e. who the subject was and what the activity was.

The transformation_details table contain variables with more details on the specific
transformations done to the raw data to create our observations. Transformations
can be as simple as selecteing specific raw data for aggregation but
they can involve more complicated steps like FFTs and low pass filters.

### observations fields
**measurement_id: ** Unique ID identifiying the measurement here and
in the transfromation_details table

**transformation_id: **Unique ID of a specific transformation

**mean: ** Mean of the raw data after the transformation

**std: ** Standarddeviation of the raw data after the transformation

### measurement_details fields
**subject: ** Unique ID that identifies the subjects of the measurement.

**activity: ** Activity during this measurement.

**measurement_id: ** Unique ID identifiying the measurement here and
in the transfromation_details table


### transformation_details fields

**transformation_id: **Unique ID of a specific transformation

**transformation_domain: **Contains the values

* frequency
* time

indicating wheather the transformation was done in time or frequency domain.

**transformation_type: **Contains the values

* Body
* Gravity

indicating wheather the type of data.

**transformation_quantity: **Contains the values

* Acc
* AccJerk
* Gyro
* GyroJerk

indicating which quantity was measured.

**transformation_direction: **Contains the values

* X
* Y
* Z
* Mag - Magnitude, i.e. value along its own direction

indicating which direction was measured. It is important to keep the
magnitude as a seperate observation becaues aggregates of the magnitude
are not the same as magnitudes of aggregates.

## Data Cleaning Details
In order to arrive at the tidy tables the following steps where performed

1. X train/test data were read into data frames, column names from features.txt were added
and only columns with ".mean." and ".std." where
selected from the frame afterwards. Particularly FreqMean is excluded in this way.
2. y train/test and subjects train/test where read in and the activities (y values) where converted
into factors with the names from the activity_labels.txt file to increase readability
3. The train data (X,y, subjects) and the test data where concatenated column wise
4. Train and test data where concatinated row wise and a unique measurement_id for each row was created
5. measurement_details was created as the selection of subject, activity and measurement_id
6. observations was created by first deselecting subject and activity and gathering all mean and std variables
7. The different gathered mean and std column names are split into seperate columns unsing extract. These columns correspond to
different modular components of the performed transformations.
8. To increase readability some variables and columns are renamed and all character values are turned into factors
9. All transformation specific columns are extracted into a seperate table (transformation_detail) and given a unique id
10. The new transformation_detail table is rejoined with observations to add the newly generated id. The other
transformation specific columns are then deselected from observations.
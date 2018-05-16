# CodeBook

## General Structure
The cleaned data consists of
tables the table averageObservations, which has
180 observations and 68 features.

### observations features

The first two features of every observation are

**subject: ** Id that identifies the test subject

**activity: ** Activity the subject was performing during the measurements

All the other features correspond to the averages across measurements for a
specific combination of subject and activity. Instead of liting all of them
individually, the logic behind their names will be described.
The names have the sructure
**(t|f)(Body|Gravity).(mean|std)...(X|Y|Z|Mag)** where the items in braces
denote alternatives for that part of the word.

The meaning of the individual parts (in order) is

**domain: ** Indicates whether the quantity was obtained in frequency (f) or 
time (t) domain

**origin: ** Idicates whether the signal originates from the subjects body
or simply from gravity

**aggregate: ** Denotes the aggregate that was calculated from the original raw
data

**direction: ** Direction of the measurement (X,Y or Z) or the overall magnitude
of the measurement (Mag). It is important to retain this information seperately
because there is no relationship between X, Y, Z and Mag after aggregating the data.


## Data Cleaning Details
In order to arrive at the tidy tables the following steps where performed

1. X train/test data were read into data frames, column names from features.txt were added
and only columns with ".mean." and ".std." where
selected from the frame afterwards. Particularly FreqMean is excluded in this way.
2. y train/test and subjects train/test where read in and the activities (y values) where converted
into factors with the names from the activity_labels.txt file to increase readability
3. The train data (X,y, subjects) and the test data where concatenated column wise
4. Train and test data where concatinated row wise and the column names where cleaned up
5. The data was grouped according to subject and activity and the averages of all features
where calculated.

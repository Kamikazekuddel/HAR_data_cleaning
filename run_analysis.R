if (!dir.exists('./data')) dir.create('./data')
zipFilePath<-'./data/samsung.zip'
outDir<-'./data'
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',zipFilePath,'curl')
unzip(zipFilePath,exdir=outDir) 

getDataPath <- function(X_y_subject,train_test){
  paste('.','data','UCI HAR Dataset',train_test,paste0(X_y_subject,"_",train_test,".txt"),sep = '/')
}

featureNamePath <- "./data/UCI HAR Dataset/features.txt"
featureNameFrame <- read.csv(featureNamePath,
                             header = FALSE,
                             row.names = 1,
                             col.names = c("index","feature_name"),
                             sep=' ',stringsAsFactors = FALSE)
numfeatures <- nrow(featureNameFrame)

#columns of interest
activityNamePath <- "./data/UCI HAR Dataset/activity_labels.txt"
activityNames <- read.csv(activityNamePath,
                          header=FALSE,
                          row.names = 1,
                          col.names = c("index","activity_name"),
                          sep = ' ',stringsAsFactors = FALSE)

require(dplyr)


#The points in the task are done out of order. When reading in the X data features
# belonging to mean and std are select (point 2). When reading in the y data
# activities are converted into a more readable factor representation (point 3).
# Afterwards train and test data is merged (point 1). Appropriately labeling the
# variable names is for subjects and activities is done when reading the data
# from the files. For the measurement features the names are already descriptive
# and except for some slight cleanup no changes are performed (point 4).
# Finally the measurements are averaged across subject and activity and the tidy
# output file is created (point 5)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
xtrain <-read.fwf(getDataPath('X','train')
                  ,header=FALSE
                  ,widths = rep(16,numfeatures)
                  ,col.names = featureNameFrame$feature_name) %>%
  as_tibble() %>%
  select(contains(match='.mean.',ignore.case=FALSE),contains('.std.'))

xtest <-read.fwf(getDataPath('X','test')
                 ,header=FALSE
                 ,widths = rep(16,numfeatures)
                 ,col.names = featureNameFrame$feature_name) %>%
  as_tibble() %>%
  select(contains(match = 'mean.',ignore.case=FALSE),contains('std.'))

#3. Uses descriptive activity names to name the activities in the data set
ytrain <-read.csv(getDataPath('y','train')
                  ,header=FALSE
                  ,col.names = 'activity') %>%
  as_tibble() %>%
  mutate(activity = factor(activity,labels= activityNames$activity_name))
ytest<-read.csv(getDataPath('y','test')
                ,header=FALSE
                ,col.names = 'activity') %>%
  as_tibble() %>%
  mutate(activity = factor(activity,labels= activityNames$activity_name))

subjecttrain<-read.csv(getDataPath('subject','train'),header=FALSE,col.names = 'subject') %>% as_tibble()
subjecttest<-read.csv(getDataPath('subject','test'),header=FALSE,col.names = 'subject') %>% as_tibble()

# 1. Merges the training and the test sets to create one data set.
train<-bind_cols(subjecttrain,ytrain,xtrain)
test<-bind_cols(subjecttest,ytest,xtest)

total<-bind_rows(train,test)

#4. Appropriately labels the data set with descriptive variable names.
#small name changes in the column names
names(total)<-names(total) %>%
{gsub('BodyBody','Body',.)} %>% #Cleanup typo in the data
{gsub('Mag(.*)','\\1\\.Mag',.)} #Allign Mag with X,Y,Z representation

#5. From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject.
averageObservations <- total %>%
  group_by(subject,activity) %>%
  summarise_all(mean)


averageObservations %>% write.table(file = "averageObservations.txt",
                                    row.name = FALSE)

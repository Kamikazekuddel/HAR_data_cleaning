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

train<-bind_cols(subjecttrain,ytrain,xtrain)
test<-bind_cols(subjecttest,ytest,xtest)

total<-bind_rows(train,test) %>% mutate(measurement_id = row_number())

#small name changes in the column names
names(total)<-names(total) %>%
{gsub('BodyBody','Body',.)} %>% #Cleanup typo in the data
{gsub('Mag(.*)','\\1\\.Mag',.)} #Allign Mag with X,Y,Z representation

#Data cleaning 
require(tidyr)

extractRegexp<-"(t|f)(Body|Gravity)(Acc|AccJerk|Gyro|GyroJerk)\\.(mean|std)\\.{3}(X|Y|Z|Mag)"

measurement_details <- total %>%
  select(subject,activity,measurement_id)

observations <- total %>% 
  select(-subject,-activity) %>% 
  gather(measurement
         ,value
         ,-c("measurement_id")) %>%
  extract(measurement,
          c("transformation_domain","transformation_type","transformation_quantity","statistic","transformation_direction"),
          regex = extractRegexp) %>%
  mutate(transformation_domain = if_else(transformation_domain == "f","frequency","time"),
         transformation_domain = factor(transformation_domain),
         transformation_type = factor(transformation_type),
         transformation_quantity = factor(transformation_quantity),
         transformation_direction = factor(transformation_direction)) %>%
  spread(statistic,value)

#extract unique transformation details in rejoin observations with the corresponding id
transformation_details <- observations %>% 
  select(-measurement_id,-mean,-std) %>% 
  unique() %>%
  mutate(transformation_id = row_number()) %>%
  select(transformation_id,transformation_domain,transformation_type,transformation_quantity,transformation_direction)

observations <- inner_join(observations,transformation_details) %>%
  select(measurement_id,transformation_id,mean,std)

observations %>% write.table(file = "observations.txt",row.name = FALSE)
measurement_details %>% write.table(file = "measurement_details.txt",row.name = FALSE)
transformation_details %>% write.table(file = "transformation_details.txt",row.name = FALSE)

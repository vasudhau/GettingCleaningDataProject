Introduction

This code book explains how the data was transformed in to a tidy data set from the source at

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

and describes the variables in the output file. You can read more about the data set here

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Program Description

The program starts by loading the rquired libraries

require(data.table)
require(plyr)

Then all the relevant data files are read.

features<-read.table("UCI HAR Dataset/features.txt")
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels)<-c("activity","description")
test_data<-read.table("UCI HAR Dataset/test/X_test.txt",header=F)
train_data<-read.table("UCI HAR Dataset/train/X_train.txt",header=F)
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
names(subject_test)<-c("subject")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
names(subject_train)<-c("subject")
test_labels<-read.table("UCI HAR Dataset/test/y_test.txt")
names(test_labels)<-c("activity")
test_labels<-data.frame(activity=join(test_labels,activity_labels)[["description"]])
train_labels<-read.table("UCI HAR Dataset/train/y_train.txt")
names(train_labels)<-c("activity")
train_labels<-data.frame(activity=join(train_labels,activity_labels)[,"description"])


Next it transforms the filters only the columns necessary to create the tidy data set

relevant_features<-features[features[["V2"]] %like% c("mean\\(\\)") | features[["V2"]] %like% c("std\\(\\)"),]
test_data<-test_data[,relevant_features[["V1"]]]
train_data<-train_data[,relevant_features[["V1"]]]

Set Appropriate column names by removing dashes and brackets
names(test_data)<-gsub("\\)","",gsub("\\(","",tolower(gsub("-","",relevant_features[["V2"]]))))
names(train_data)<-gsub("\\)","",gsub("\\(","",tolower(gsub("-","",relevant_features[["V2"]]))))

Create  using column bind test and training datasets with descriptive activities and subjects
test_data<-cbind(subject_test,test_labels,test_data)
train_data<-cbind(subject_train,train_labels,train_data)

Merge both datasets into a final dataset using row bind
final_data<-rbind(test_data,train_data)

Write  the first tidy data set as CSV
write.csv(final_data,file="output.csv",row.names=FALSE)

For the final data set we are using ddply to group by subject and activity and finally calculating the column means function

final_tidy<-ddply(final_data,.(subject,activity),function(x){
  colMeans(x[,c(3:68)])
})

Write second tidy data set as text file
write.table(final_tidy_data,file="output_activity_subject.txt",row.names=FALSE)
Variables in the Data Set


"subject","activity","tbodyaccmeanx","tbodyaccmeany","tbodyaccmeanz","tbodyaccstdx","tbodyaccstdy","tbodyaccstdz","tgravityaccmeanx","tgravityaccmeany","tgravityaccmeanz","tgravityaccstdx","tgravityaccstdy","tgravityaccstdz","tbodyaccjerkmeanx","tbodyaccjerkmeany","tbodyaccjerkmeanz","tbodyaccjerkstdx","tbodyaccjerkstdy","tbodyaccjerkstdz","tbodygyromeanx","tbodygyromeany","tbodygyromeanz","tbodygyrostdx","tbodygyrostdy","tbodygyrostdz","tbodygyrojerkmeanx","tbodygyrojerkmeany","tbodygyrojerkmeanz","tbodygyrojerkstdx","tbodygyrojerkstdy","tbodygyrojerkstdz","tbodyaccmagmean","tbodyaccmagstd","tgravityaccmagmean","tgravityaccmagstd","tbodyaccjerkmagmean","tbodyaccjerkmagstd","tbodygyromagmean","tbodygyromagstd","tbodygyrojerkmagmean","tbodygyrojerkmagstd","fbodyaccmeanx","fbodyaccmeany","fbodyaccmeanz","fbodyaccstdx","fbodyaccstdy","fbodyaccstdz","fbodyaccjerkmeanx","fbodyaccjerkmeany","fbodyaccjerkmeanz","fbodyaccjerkstdx","fbodyaccjerkstdy","fbodyaccjerkstdz","fbodygyromeanx","fbodygyromeany","fbodygyromeanz","fbodygyrostdx","fbodygyrostdy","fbodygyrostdz","fbodyaccmagmean","fbodyaccmagstd","fbodybodyaccjerkmagmean","fbodybodyaccjerkmagstd","fbodybodygyromagmean","fbodybodygyromagstd","fbodybodygyrojerkmagmean","fbodybodygyrojerkmagstd"

The following variables are present in the codebook

Variable Name   	Desciption
subject 		The ID of the subject
activity 		The Descriptive activity,
tbodyaccmeanx 		The mean value of activty combination for the field x
tbodyaccmeany 		The mean value of activty combination for the field y
tbodyaccmeanz 		The mean value of activty combination for the field z
tbodyaccstdx	 	The standard deviation of subject/activty combination for the field x
tbodyaccstdy	 	The standard deviation of subject/activty combination for the field y
tbodyaccstdz	 	The standard deviation of subject/activty combination for the field z
tgravityaccmeanx 	The mean value of gravity/activty combination for the field x
tgravityaccmeany 	The mean value of gravity/activty combination for the field y
tgravityaccmeanz 	The mean value of gravity/activty combination for the field z
tgravityaccstdx 	The standard deviation of gravity/activty combination for the field x
tgravityaccstdy 	The standard deviation of gravity/activty combination for the field y
tgravityaccstdz 	The mean value of gravity/activty combination for the field z
tbodyaccjerkmeanx 	The mean value of jerk/activty combination for the field x
tbodyaccjerkmeany 	The mean value of jerk/activty combination for the field y
tbodyaccjerkmeanz 	The mean value of jerk/activty combination for the field z
tbodyaccjerkstdx 	The standard deviation of jerk/activty combination for the field x
tbodyaccjerkstdy 	The standard deviation of jerk/activty combination for the field y
tbodyaccjerkstdz 	The standard deviation of jerk/activty combination for the field z
tbodygyromeanx 		The mean value of body/gyro combination for the field x
tbodygyromeany 		The mean value of body/gyro combination for the field y
tbodygyromeanz 		The mean value of body/gyro combination for the field z
tbodygyrostdx 		The standard deviation of body/gyro combination for the field x
tbodygyrostdy 		The standard deviation of body/gyro combination for the field y
tbodygyrostdz 		The standard deviation of body/gyro combination for the field z
tbodygyrojerkmeanx 	The mean value of body/gyro/jerk combination for the field
tbodygyrojerkmeany 	The mean value of body/gyro/jerk combination for the field
tbodygyrojerkmeanz 	The mean value of body/gyro/jerk combination for the field
tbodygyrojerkstdx 	The standard deviation value of body/gyro/jerk combination for the field x
tbodygyrojerkstdy 	The standard deviation value of body/gyro/jerk combination for the field y
tbodygyrojerkstdz 	The standard deviation value of body/gyro/jerk combination for the field z
tbodyaccmagmean 	The mean value of body/activty/mag combination for the field
tbodyaccmagstd 		The standard deviation of body/activty/mag combination for the field
tgravityaccmagmean 	The mean value of body/activty/mag combination for the field
tgravityaccmagstd 	The standard deviation of body/activty/mag combination for the field
tbodyaccjerkmagmean 	The mean value of body/activty/jerk combination for the field
tbodyaccjerkmagstd 	The standard deviation of body/activty/jerk combination for the field
tbodygyromagmean 	The mean value of body/gyro/mag combination for the field
tbodygyromagstd 	The standard deviation of body/gyro/mag combination for the field
tbodygyrojerkmagmean 	The mean value of body/gyro/mag combination for the field
tbodygyrojerkmagstd 	The standard deviation of body/gyro/mag combination for the field
fbodyaccmeanx 		The mean value of body/activty combination for the field x
fbodyaccmeany 		The mean value of body/activty combination for the field y
fbodyaccmeanz 		The mean value of body/activty combination for the field z
fbodyaccstdx	 	The standard deviation of body/activty combination for the field x
fbodyaccstdy	 	The standard deviation of body/activty combination for the field y
fbodyaccstdz	 	The standard deviation of body/activty/jerk combination for the field z
fbodyaccjerkmeanx 	The mean value of body/activty/jerk combination for the field x
fbodyaccjerkmeany 	The mean value of body/activty/jerk combination for the field y
fbodyaccjerkmeanz 	The mean value of body/activty/jerk combination for the field z
fbodyaccjerkstdx 	The standard deviation of body/activty/jerk combination for the field x
fbodyaccjerkstdy 	The standard deviation of body/activty/jerk combination for the field y
fbodyaccjerkstdz 	The standard deviation of body/activty/jerk combination for the field z
fbodygyromeanx	 	The mean value of body/gyro combination for the field x
fbodygyromeany	 	The mean value of body/gyro combination for the field y
fbodygyromeanz	 	The mean value of body/gyro combination for the field z
fbodygyrostdx 		The standard deviation of body/gyro combination for the field x
fbodygyrostdy 		The standard deviation of body/gyro combination for the field y
fbodygyrostdz 		The standard deviation of body/gyro combination for the field z
fbodyaccmagmean 	The mean value of body/activty/mag combination for the field
fbodyaccmagstd	 	The standard deviation of body/activty/mag combination for the field
fbodybodyaccjerkmagmean 	The mean value of body/activty/jerk combination for the field
fbodybodyaccjerkmagstd 	The standard deviation of body/activty/jerk/mag combination for the field
fbodybodygyromagmean 	The mean value of body/activty/gyro/mag combination for the field
fbodybodygyromagstd 	The standard deviation of body/activty/gyro/mag for the field
fbodybodygyrojerkmagmean 	The mean value of body/gyro/jerk/mag combination for the field
fbodybodygyrojerkmagstd 	The standard deviation of body/gyro/jerk/mag combination for the field


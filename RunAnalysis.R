###RunAnalysis.R

# This Program assumes the data is downloaded and extracted from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and put in the same folder
# Read all the necessary files

require(data.table)
require(plyr)
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

#Extract only the relevant Features we need -  all the means and standard deviations
features_needed<-features[features[["V2"]] %like% c("mean\\(\\)") | features[["V2"]] %like% c("std\\(\\)"),]
test_data<-test_data[,features_needed[["V1"]]]
train_data<-train_data[,features_needed[["V1"]]]

#Set Appropriate column names
names(test_data)<-gsub("\\)","",gsub("\\(","",tolower(gsub("-","",relevant_features[["V2"]]))))
names(train_data)<-gsub("\\)","",gsub("\\(","",tolower(gsub("-","",relevant_features[["V2"]]))))

#Create  using column bind  test and training datasets with descriptive activities and subjects
test_data<-cbind(subject_test,test_labels,test_data)
train_data<-cbind(subject_train,train_labels,train_data)

#Merge both datasets into a final dataset using row bind
final_data<-rbind(test_data,train_data)

#Write  the first tidy data set as CSV
write.csv(final_data,file="output.csv",row.names=FALSE)

#For the final data set we are using ddply to group by subject and activity and finally calculating the column means function
final_tidy<-ddply(final_data,.(subject,activity),function(x){
  colMeans(x[,c(3:68)])
})

#Write second tidy data set as text file

write.table(final_tidy_data,file="output_activity_subject.txt",row.names=FALSE)
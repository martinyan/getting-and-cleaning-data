#This script is part of the answer to course Getting and Cleaning Data on Cousera, Aug-2014 session
#The ultimate goal of this script is to generate a tidy dataset as described in the project scope
#And to accomplish that, the following steps are involved

#Step 1
# merges the training set files containg the measurments (train/X_train.txt) with the subject
# file (train/subject_train.txt) and activities file (train/y_train.txt). 
# assuming the all the data are sitting inside "UCI HAR Dataset" folder under the working directory

train.data <- read.table("UCI HAR Dataset/train/X_train.txt")
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train.activity <- read.table("UCI HAR Dataset/train/y_train.txt")
train.merged <- cbind(train.subject,train.activity,train.data)
# Step 2
# repeat step 1 with respective files in test folder , i.e. measurements (test/X_test.txt), 
# subjects (test/subject_test.txt) abnd activities file (test/y_test.txt)
test.data <- read.table("UCI HAR Dataset/test/X_test.txt")
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test.activity <- read.table("UCI HAR Dataset/test/y_test.txt")
test.merged <- cbind(test.subject,test.activity,test.data)

#step 3
# merger the train data set with the test data set into one single data frame
all.combined <- rbind(train.merged,test.merged)

#step 4
# subset the merged data frame by columns that contains measurements on mean and std deviation
# big assumption is that all the features associated with this defintion has either mean or std in its naming.
# the way to do it is to grep the word "mean" or "std" (case insensitive) from all the features as defined in "features.txt" table
#
feature.table <- read.table("UCI HAR Dataset/features.txt")
feature.table <- feature.table[grep("mean|std", feature.table$V2 ,ignore.case=TRUE),]
feature.table.selected.col <- feature.table[,1]
feature.table.selected.name <- feature.table[,2]

all.combined.selected.col <- c(1,2,feature.table.selected.col+2)
all.combined.subset <- all.combined[,all.combined.selected.col] #new table with only mean and std measurements
colnames(all.combined.subset) <- c("subject","activity",as.character(feature.table.selected.name)) #setting the col names

# step 5 
# add the activity label into the combined data frame by looking at the activity_labels.txt

activity.map <- read.table("UCI HAR Dataset/activity_labels.txt")
all.combined.subset[,2]<- activity.map[match(all.combined.subset[,2],activity.map[,1]),2]


#Step 6 Tidy dataset
tidy.dataset <- ddply(all.combined.subset, .(subject, activity), numcolwise(mean))
write.table(tidy.dataset , row.names = FALSE, file = "tidydata.txt")

### load library
library(plyr)
library(dplyr)

#Step1
#Merges the training and the test sets to create one data set.
###########################################################################

#load data
x_train <- read.table("week4/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("week4/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("week4/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("week4/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("week4/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("week4/UCI HAR Dataset/test/subject_test.txt")

# create data set
xTotal <- rbind(x_train, x_test)
yTotal <- rbind(y_train, y_test)

# create 'subject' data set
subjectData <- rbind(subject_train, subject_test)


###################################################################################
# Step2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

features <- read.table("week4/UCI HAR Dataset/features.txt")
indexs <- grep("-(mean|std)\\(\\)", features[, 2])
xTotal <- xTotal[, indexs]
names(xTotal) <- features[indexs, 2]

##########################################################################
#Step3
# Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table("week4/UCI HAR Dataset/activity_labels.txt")
colnames(yTotal) <- "id"
colnames(activities) <- c("id","activity")
#labels <- merge(x=as.character(yTotal),y=as.character(activities), by = id, all = TRUE)  
yTotal$activitylabel <- factor(yTotal$id, labels = as.character(activities[,2]))


###########################################################################
# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

names(subjectData) <- "subject"
all_data <- cbind(xTotal, yTotal$activitylabel , subjectData)

#############################################################################
# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################
total_mean <- all_data %>% group_by(`yTotal$activitylabel`, subject)  %>% summarize_all(funs(mean))
colnames(total_mean)[1] <- "label"
write.table(total_mean, "averages_data.txt", row.name=FALSE)


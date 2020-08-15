library(dplyr)
filename <- "Coursera_projectfile.zip"
# Checking if file exist
if(!file.exists(filename)){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = filename)
}
# Checking if folder exist
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}
features <- read.table("UCI HAR Dataset/features.txt",col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("code","activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt",col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",col.names = "code")


# merging training & test sets to create one data set
X <- rbind(x_train,x_test)
Y <- rbind(y_train,y_test)
Subject <- rbind(subject_train,subject_test)
merged_data <- cbind(Subject,Y,X)

# Extracting measurments on mean and standard deviation for each measurment
Tidy_data <- merged_data %>% select(subject,code,contains("mean"),contains("std"))

# Using descriptive activity names to name the activities in the data set
Tidy_data$code <- activities[Tidy_data$code,2]

# Appropriately lables to the data set with descriptive variable names
names(Tidy_data)[2] <- "activity"
names(Tidy_data) <- gsub("Acc","Accelerometer",names(Tidy_data))
names(Tidy_data) <- gsub("Gyro","Gyroscope",names(Tidy_data))
names(Tidy_data) <- gsub("Mag","Magnitude",names(Tidy_data))
names(Tidy_data) <- gsub("BodyBody","Body",names(Tidy_data))
names(Tidy_data) <- gsub("^t","Time",names(Tidy_data))
names(Tidy_data) <- gsub("^f","Frequency",names(Tidy_data))
names(Tidy_data) <- gsub("tBody","TimeBody",names(Tidy_data))
names(Tidy_data) <- gsub("-mean()","Mean",names(Tidy_data),ignore.case = TRUE)
names(Tidy_data) <- gsub("-freq()","Frequency",names(Tidy_data),ignore.case = TRUE)
names(Tidy_data) <- gsub("-std()","STD",names(Tidy_data),ignore.case = TRUE)
names(Tidy_data) <- gsub("angle","Angle",names(Tidy_data))
names(Tidy_data) <- gsub("gravity","Gravity",names(Tidy_data))

# creating a second, independent tidy data set with the average of each variable for each activity and each subject.
FinalData <- Tidy_data %>% 
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(FinalData,"FinalData.txt",row.names = FALSE)

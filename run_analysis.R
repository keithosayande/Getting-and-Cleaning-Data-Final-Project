library('dplyr')
library('readr')
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
filename <- 'data.zip'
if (!file.exists(filename)){
  download.file(fileURL, filename, method="curl")
}
if (!file.exists("UCI HAR Dataset")) {
  unzip(filename)
}
features <- read_table2("UCI HAR Dataset/features.txt", col_names = c("n","functions"))
lables <- read_table2("UCI HAR Dataset/activity_labels.txt", col_names = c("code", "activity"))
x_test <- read_table2("UCI HAR Dataset/test/X_test.txt", col_names = features$functions)
subject_test <- read_table2("UCI HAR Dataset/test/subject_test.txt", col_names = c("subject"))
y_test <- read_table2("UCI HAR Dataset/test/y_test.txt", col_names = "code")
x_train <- read_table2("UCI HAR Dataset/train/X_train.txt", col_names = features$functions)
subject_train <- read_table2("UCI HAR Dataset/train/subject_train.txt", col_names = c("subject"))
y_train <- read_table2("UCI HAR Dataset/train/y_train.txt", col_names = "code")
merged_x <- bind_rows(x_test, x_train)
merged_y <- bind_rows(y_test, y_train)
merged_subject <- bind_rows(subject_test, subject_train)
merged_data <- bind_cols(merged_subject,merged_y,merged_x)
tidy_data <- merged_data %>% select(subject, code, contains("mean"), contains("std"))
tidy_data$code <- lables[tidy_data$code, 2]
names(tidy_data)[2] = "activity"
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
final_data <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))
write.table(final_data, "final_data.txt", row.name=FALSE)


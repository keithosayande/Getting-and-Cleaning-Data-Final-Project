run_anlysis.r follows the 5 steps listed in the project description.
## 1. Merges the training and the test sets to create one data set.
  ```r
  features <- read_table2("UCI HAR Dataset/features.txt", col_names = c("n","functions"))
  lables <- read_table2("UCI HAR Dataset/activity_labels.txt", col_names = c("code", "activity"))
  x_test <- read_table2("UCI HAR Dataset/test/X_test.txt", col_names = features$functions)
  subject_test <- read_table2("UCI HAR Dataset/test/subject_test.txt", col_names = c("subject"))
  y_test <- read_table2("UCI HAR Dataset/test/y_test.txt", col_names = "code")
  x_train <- read_table2("UCI HAR Dataset/train/X_train.txt", col_names = features$functions)
  subject_train <- read_table2("UCI HAR Dataset/train/subject_train.txt", col_names = c("subject"))
  y_train <- read_table2("UCI HAR Dataset/train/y_train.txt", col_names = "code")
  ```
 I assign each txt file to a variable and give the columns the apropriate headings. 
 ```r
  merged_x <- bind_rows(x_test, x_train)
  merged_y <- bind_rows(y_test, y_train)
  merged_subject <- bind_rows(subject_test, subject_train)
  merged_data <- bind_cols(merged_subject,merged_y,merged_x)
  ```
  I merge the test and training data into a single data set.
  
  ## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  ```r
  tidy_data <- merged_data %>% select(subject, code, contains("mean"), contains("std"))
  ```
  By using gsub, I am able to extact every column that contains the strings "mean" and "std".
  
  ## 3. Uses descriptive activity names to name the activities in the data set
  ```r
  tidy_data$code <- lables[tidy_data$code, 2]
  names(tidy_data)[2] = "activity"
  ```
  I assign change every activity code to their name and rename the "code" column to "activity"
  
  ## 4. Appropriately labels the data set with descriptive variable names. 
  ```r
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
  ```
  Cleaned up some of the naming conventions for all of the columns.
  
  ## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  ```r 
  final_data <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))
  write.table(final_data, "final_data.txt", row.name=FALSE)
  ```
  I use the pipelining feature of the dplyr package, to first group each subject and activity pairing together, then I take the mean of each of those parings. This resulting data set is written to a file.

  

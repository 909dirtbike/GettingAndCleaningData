
library(data.table)
library(reshape2)

# activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# features
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Read test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# name columns
names(X_test) <- features

# identify only mean and sd features
sel_features <- grepl("mean|std", features)

# Limit to rows pertaining to the selected features
X_test <- X_test[,sel_features]

# add activity label description
y_test[,2] <- activity_labels[y_test[,1]]

# name columns
names(y_test) <- c("Activity_ID", "Activity_Label")
names(subject_test) <- "subject"

# combine the test data
test_set <- cbind(as.data.table(subject_test), y_test, X_test)


# Read training data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# name columns
names(X_train) <- features

# Limit to rows pertaining to the selected features
X_train <- X_train[,sel_features]

# add activity label description
y_train[,2] <- activity_labels[y_train[,1]]

# name columns
names(y_train) <- c("Activity_ID", "Activity_Label")
names(subject_train) <- "subject"

# combine the training data
train_set <- cbind(as.data.table(subject_train), y_train, X_train)


# combine test and training sets
comb.data <- rbind(test_set, train_set)

# use melt to get one row per measurement/factor combination
melted <- melt(comb.data, c(1:3), c(4:82))

#create a tidy data set with the average of each variable for each activity 
#and each subject.

final_data <- dcast(melted, subject + Activity_Label ~ variable, mean)

write.table(final_data, file = "./final_data.txt", row.names = FALSE)

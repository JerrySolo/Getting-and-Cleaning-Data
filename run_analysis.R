library(reshape2)

subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")

# add column name for subject files
names(subject_train) <- "subjectId"
names(subject_test) <- "subjectId"

# add column names for measurement files
featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

names(y_train) <- "activity"
names(y_test) <- "activity"

# combine
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)

# get "mean()" or "std() cols"
meansOrStd <- grepl("mean\\(\\)", names(combined)) |
  grepl("std\\(\\)", names(combined))

meansOrStd[1:2] <- TRUE

combined <- combined[, meansOrStd]

combined$activity <- factor(combined$activity, labels=c("Walking",
"Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

melted <- melt(combined, id=c("subjectId","activity"))
tidy <- dcast(melted, subjectId+activity ~ variable, mean)

# save as file
write.table(tidy, "tidydata.txt", row.names=FALSE)
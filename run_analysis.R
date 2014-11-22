# Reduces Data to a Tidy Data Set

# Read in the column labels
columnHeaders <- read.delim("UCI HAR Dataset\\features.txt", sep=" ", header = FALSE)
numberOfColumns <- length(columnHeaders$V1)

# Read in the test and train data
testData <- read.fwf("UCI HAR Dataset\\test\\X_test.txt", seq(16, 16,length=numberOfColumns), header = FALSE)
trainData <- read.fwf("UCI HAR Dataset\\train\\X_train.txt", seq(16, 16,length=numberOfColumns), header = FALSE)
testActivity <- read.table("UCI HAR Dataset\\test\\y_test.txt")
trainActivity <- read.table("UCI HAR Dataset\\train\\y_train.txt")
testSubject <- read.table("UCI HAR Dataset\\test\\subject_test.txt")
trainSubject <- read.table("UCI HAR Dataset\\train\\subject_train.txt")

# Merge the test and train data into a single table
data <- rbind(trainData,testData)

#Extract The mean and std measurements
ndx <- c(grep("mean()", columnHeaders$V2),grep("std()", columnHeaders$V2))
ndx <- sort(ndx)
dataReduced <- data[,ndx]

# Apply Activity names to the data
activity <- rbind(trainActivity,testActivity)
activityLevels <- read.delim("UCI HAR Dataset\\activity_labels.txt", sep=" ", header = FALSE)
activityFactor <- factor(activity$V1, levels=seq(1,6), labels=activityLevels$V2)
subject <- rbind(trainSubject,testSubject)
dataMerged <- cbind(activityFactor, subject, dataReduced)

# Apply Column names to data
colnames(dataMerged) <- c("Activity", "Subject", as.character(columnHeaders$V2[ndx]))

# Create 2nd Dataset with mean for each activity and subject
library(reshape2)
dataMelt <- melt(dataMerged, id=c("Activity","Subject"), measure.vars=columnHeaders$V2[ndx])
dataMean <- dcast(dataMelt, Activity + Subject ~ variable, mean)

# Write the final dataset out to a file
write.table(dataMean, file="project_data.txt", row.name=FALSE)

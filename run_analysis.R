# Make Sure you put the script inside the Folder (UCI HAR Dataset)
#Set the working directory to where the script and data is
FILE <- file.choose()
DIR  <- dirname(FILE)
setwd(DIR)

trainXfile <- "X_train.txt"
testXfile <- "X_test.txt"
trainYfile <- "y_train.txt"
testYfile <- "y_test.txt"
trainSubjFile <- "subject_train.txt"
testSubjFile <- "subject_test.txt"
featuresFile <- "features.txt"

#This Function to guarentee access to files even if the working directory had been set in a higher level than it should be
getTable <- function(filename)
{
	l <- list.files(pattern =paste0("^",filename,"$"),all.files=1,recursive=1)
	return(read.table(l[1], header=0))
}

#Collect Data from sources
features <- getTable(featuresFile)
trainData <-getTable(trainXfile)
testData <- getTable(testXfile)
trainActivity <- getTable(trainYfile)
testActivity <- getTable(testYfile)
trainSubject <- getTable(trainSubjFile)
testSubject <- getTable(testSubjFile)

#Rename Columns  (Appropriately labels the data set with descriptive activity names)
names(trainData) <- features[[2]]
names(testData) <- features[[2]]

#Creat the final Train and Test Sets
train <- cbind(trainData,trainActivity, trainSubject)
test <- cbind(testData, testActivity, testSubject)

#Merges the training and the test sets to create one data set
mergedData <-rbind(train,test)


#Extracts only the measurements on the mean and standard deviation for each measurement.
cols <- length(mergedData)
cols <- c(cols-1,cols)
mergedData <- mergedData[c(grep("mean\\(\\)|std\\(\\)", features[[2]]), cols)]

#Appropriately labels the data set with descriptive activity names
cols <- length(mergedData)
cols <- c(cols-1,cols)
names(cols) <- c("Activity","Subject")
names(mergedData)[cols] <- names(cols)


#Uses descriptive activity names to name the activities
Activities <- c("walking", "walking upstairs", "walking downstairs","sitting", "standing", "laying")
mergedData$Activity <- as.factor(mergedData$Activity)
mergedData$Activity <- Labels[mergedData$Activity]

#Independent tidy data set with the average of each variable for each activity and each subject.
FinalTable <- aggregate(. ~ Activity+Subject, data = mergedData, mean)

#Export Data into comma based data file (But .txt) to be uploal in the course page
write.csv(FinalTable, file="UCI HAR Dataset.txt", row.names=FALSE)
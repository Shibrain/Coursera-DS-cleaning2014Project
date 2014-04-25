Getting and Cleaning Data Course Project
========================================================


Introduction 
-------------------------
This R Markdown document is to explain the script used to perform data munging project at Coursera Course **[Getting and Cleaning Data](https://www.coursera.org/course/getdata)**, The Data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 


What has been done:
-------------------------

### File and Directories 
In This part I Tried to make sure to make files accessible as much as it could be make the code more dynamic in getting files and avoid the working directory problem . 

This Part is meant to set the working directory for script user to insure that the script is within the specific directory.
```{r}
FILE <- file.choose()
DIR  <- dirname(FILE)
setwd(DIR)
```

This one is just to identify files names for each component
```{r}
trainXfile <- "X_train.txt"
testXfile <- "X_test.txt"
trainYfile <- "y_train.txt"
testYfile <- "y_test.txt"
trainSubjFile <- "subject_train.txt"
testSubjFile <- "subject_test.txt"
featuresFile <- "features.txt"
```


### Getting Data

This Function to guarentee access to files even if the working directory had been set in a higher level than it should be, and return the result as data frame:

```{r fig.width=7, fig.height=6}
getTable <- function(filename)
{
  l <- list.files(pattern =paste0("^",filename,"$"),all.files=1,recursive=1)
	return(read.table(l[1], header=0))
}
```


Calls for the previous function to Collect Data from its sources:

```{r fig.width=7, fig.height=6}
features <- getTable(featuresFile)
trainData <-getTable(trainXfile)
testData <- getTable(testXfile)
trainActivity <- getTable(trainYfile)
testActivity <- getTable(testYfile)
trainSubject <- getTable(trainSubjFile)
testSubject <- getTable(testSubjFile)
```


### Data Merge and Reshape

The Original data is messy, separated, and not labled only text files contain numbers, this part is to merge test and train data sets, and well label them. 

here I used features which contains the discription of variables, to rename the columns 
```{r}
names(trainData) <- features[[2]]
names(testData) <- features[[2]]
```
 
Creat the final Train and Test Sets by merge the data coulmns with activity and subject coulmns for each one speratly
```{r}
train <- cbind(trainData,trainActivity, trainSubject)
test <- cbind(testData, testActivity, testSubject)
```

This for merge the test and train in one data set
```{r}
mergedData <-rbind(train,test)
cols <- length(mergedData)
cols <- c(cols-1,cols)
```


### Get meaningful data as required 

Extracts only the measurements on the mean and standard deviation for each measurement.
```{r}
mergedData <- mergedData[c(grep("mean\\(\\)|std\\(\\)", features[[2]]), cols)]
```

Appropriately labels the data set with descriptive activity names
```{r}
names(cols) <- c("Activity","Subject")
names(mergedData)[cols] <- names(cols)
```

Uses descriptive activity names to name the activities instade of thier numbers
```{r}
Activities <- c("walking", "walking upstairs", "walking downstairs","sitting", "standing", "laying")
mergedData$Activity <- as.factor(mergedData$Activity)
mergedData$Activity <- Labels[mergedData$Activity]
```

### Summariz Data
Form An Independent tidy data set with the average of each variable for each activity and each subject.
```{r}
FinalTable <- aggregate(. ~ Activity+Subject, data = SubData, mean)
```


Export Data into CSV file
```{r}
write.csv(FinalTable, file="UCI HAR Dataset.csv", row.names=FALSE)
```
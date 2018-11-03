run_analysis <- function(){
        
        #make sure necessary packages are installed
        install.packages(c("dplyr", "reshape2"))
        library(dplyr); library(reshape2)
        
        #first check for the UCI HAR directory, if it doesn't exist then download the data
        if(!dir.exists("UCI HAR Dataset")){
                download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "Data.zip")
                unzip("Data.zip")
                file.remove("Data.zip")
        }
        
        ##Next read in all of the data and combine into one set
        
        #Read in the variable names for the datasets
        features <- read.table("UCI HAR Dataset/features.txt", col.names = c("col", "feature"))
        
        #read in the activity labels
        activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
        
        #read in the activity values for each observation in train and test sets
        x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
        x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
        
        #assign column/variable names to the separate datasets
        colnames(x_train) <- features$feature
        colnames(x_test) <- features$feature
        
        #read in the subject ID for each observation in the datasets
        subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", colClasses = "factor")
        subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", colClasses = "factor")
        
        #read in the activity for each observation in the datasets
        y_train <- readLines("UCI HAR Dataset/train/y_train.txt")
        y_trainlab <- factor(y_train, labels = activity_labels$V2)
        y_test <- readLines("UCI HAR Dataset/test/y_test.txt")
        y_testlab <- factor(y_test, labels = activity_labels$V2)
        
        #add in the subject ID and activity for each observation to the train/test datasets
        train <- cbind(Subject = subject_train, Activity = y_trainlab, x_train); colnames(train)[1] <- "Subject"
        test <- cbind(Subject = subject_test, Activity = y_testlab, x_test); colnames(test)[1] <- "Subject"
        
        #combine the data
        combineddata <- rbind(train, test)
        
        #select only the mean and stdev columns and rename to cleaner names
        selectdata <- combineddata[,grep("mean[^Freq]|std()|Activity|Subject", names(combineddata))]
        names(selectdata) <- gsub("[-()]", "", names(selectdata))
        names(selectdata) <- gsub("mean", "Mean", names(selectdata))
        names(selectdata) <- gsub("std", "Std", names(selectdata))
        
        #reform the data with the average of each variable for each subject and activity
        meltdata <- melt(selectdata, c("Subject","Activity"))
        castdata <- dcast(meltdata, Subject + Activity ~ variable, mean)
        
        #order the data to make it prettier
        castdata$Subject <- factor(castdata$Subject, 1:30)
        castdata <- arrange(castdata, Subject)
        
        #write out a new, tidy dataset
        write.table(castdata, file = "tidydata.txt", row.names = FALSE)
        
}
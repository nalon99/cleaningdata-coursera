library(plyr)
# this script has to be run from the parent directory of "UCI HAR Dataset"

create_tidy_dataset <- function(path, files, activities, features) {
	# path represents a string containing the relative path to the train dataset and test dataset
	# files is a vector containing: x_test, subject_test, y_test filenames
	# activities is a dataframe containing activities description
	# features is a dataframe containing all the features description
	# this function outputs a merged dataframe with train and test datasets

	df.x <- read.table(file=paste(path , files[1], sep="/"), sep="", header=F, stringsAsFactors=F)
	df.subject <- read.table(paste(path , files[2], sep="/"), sep="", header=F, stringsAsFactors=F)
	colnames(df.subject) <- "subject"
	df.activity <- read.table(file=paste(path , files[3], sep="/"), sep="", header=F, stringsAsFactors=F)
	
	# merge does not preserve the original order row of test.activity, so I use join instead
	df.activity$activity <- join(x=df.activity, y=activities, by="V1", type="inner")[, 2]

	df.cols.mean <- subset(features, grepl("mean", V2)) # only keeps columns which have a mean content
	df.cols.std <- subset(features, grepl("std", V2))  # only keeps columns which have a std content
	
	# keeps all of mean and std columns, and discard all the others measurements
	df.x <- df.x[, c(df.cols.mean[, 1], df.cols.std[, 1])]
	colnames(df.x) <- c(df.cols.mean[, 2], df.cols.std[, 2]) # name the columns appropriately 
	df.tidy <- cbind(df.subject, df.activity$activity, df.x)
	colnames(df.tidy)[2] <- "activity"  # rename 2nd column with "activity"
	df.tidy # return the tidy dataframe 

}

setwd("./UCI HAR Dataset") # go into the UCI HAR directory
# ------------------------------------------MAIN PROGRAM--------------------------------------
# reads common data to both train and test data sets
activities <- read.table(file="activity_labels.txt", sep="", header=F, stringsAsFactors=F)
features <- read.table(file="features.txt", sep="", header=F, stringsAsFactors=F)

# elaborating data sets
message("Reading recorded values from test directory, please wait...")
tidy.test <- create_tidy_dataset("test", c("X_test.txt", "subject_test.txt", "y_test.txt"), activities, features)
message("Reading recorded values from train directory, please wait...")
tidy.train <- create_tidy_dataset("train", c("X_train.txt", "subject_train.txt", "y_train.txt"), activities, features)

message("Elaborating data")
# merging train and data test together
tidy.data <- rbind(tidy.test, tidy.train)

# creating the output dataset with mean value for each physical variable, activity and subject
# since the first column is the subject, the second activity, I'll use the 3rd column to the last one to calculate mean values
tidy.mean <- ddply(tidy.data, .(subject, activity), function(x) colMeans(x[, 3:81]))
setwd("../") # go back to the parent directory
write.table(x=tidy.mean, file="tidydata.txt", row.names=F)
message("Output file: tidydata.txt written successfully!")

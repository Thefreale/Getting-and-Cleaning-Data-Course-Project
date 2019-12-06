###
###     Getting and Cleaning Data - Course Project
###
###

### use setwd("your local directory where the UCU HAR Dataset resides") 


xtrain<- read.table ("UCI HAR Dataset/train/X_train.txt") #reads in the training data set
ytrain<-read.table ("UCI HAR Dataset/train/y_train.txt") #reads in the training labels

xtest<- read.table ("UCI HAR Dataset/test/X_test.txt") #reads in the test data set
ytest<- read.table ("UCI HAR Dataset/test/y_test.txt") #reads in the test labels

subjtrain<- read.table ("UCI HAR Dataset/train/subject_train.txt") #read in subject identifier for training data
subjtest<- read.table ("UCI HAR Dataset/test/subject_test.txt") #read in subject identifier for test data

## read variable names from features.txt

varnames <- scan("UCI HAR Dataset/features.txt", what = list(varnum = 0, name="")) #read variable names
actlabels <-scan("UCI HAR Dataset/activity_labels.txt", what = list(varnum = 0, activity="")) #read activity labels

## column (variables names) are now in varnames$names

names<-varnames$name ##define character vector of length 561 which has variable names



xdata<-rbind(xtrain,xtest) # combine training and test data

colnames(xdata)<- names #name variables

ydata<-rbind (ytrain,ytest) # combine label data

rm(xtrain,xtest,ytrain,ytest) #remove some of the data sets no longer needed

colnames(ydata)<-"activity" # name the activity variable

mnames<- grep("mean",names, ignore.case=TRUE) ##gives indices for 53 variables with mean in the variable name

snames<- grep("std",names, ignore.case=TRUE) ##gives indices for 33 variables with sd in the name


z<-c(mnames,snames) #combine the indices

#now sort z

z<-sort(z)

xdatameansd<- xdata[,z] #get rid of variables that are not mean and sd related

#subject numbers

subject<-rbind(subjtrain,subjtest)

colnames(subject)<-"subject"

# Adding the subject & activity codes to the data

xdatams<-cbind (subject,ydata,xdatameansd)

# Now drop the "freq means" as they are repeats

dropmnames <- grep("meanFreq", names(xdatams),ignore.case=TRUE)

xdatams <-xdatams[,-dropmnames]

rm(xdatameansd) #remove un-needed dataset

##now have to label activity with activity labels


xdatams$activity <- factor(xdatams$activity,levels = actlabels$varnum,labels = actlabels$activity) 


## now use aggregate to produce "newdata" which is tidy data set 


newdata<- aggregate(xdatams[,3:75],list(subject = xdatams$subject, activity = xdatams$activity),mean)

##write table as a text file ("tidySamsungdata.txt" as instructed in the course project

write.table (newdata,file="tidySamsungdata.txt", row.names=FALSE)

## the below code will display the data to show the tidy data structure 
#much more clearly than as a text file
# "tidySamsungdata.txt" should be in your working directory


data <- read.table("tidySamsungdata.txt", header = TRUE)
View(data)

names (newdata)



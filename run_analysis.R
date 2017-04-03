#url of the source
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#name of zip file
zfile<-"dataset.zip"

#download the zip file
download.file(url, zfile)

#unzip to current folder
unzip(zfile,exdir=".")

#test files path
tstPath<-"./UCI HAR Dataset/test"

#train files path
trnPath<-"./UCI HAR Dataset/train"

#get x test file
x_test<-read.table(paste0(tstPath,"/X_test.txt"))
                   
#get x train file
x_train<-read.table(paste0(trnPath,"/X_train.txt"))

#row bind the 2 tables
x_combin<-rbind(x_test,x_train)

#follow the same for y files

#get y test file
y_test<-read.table(paste0(tstPath,"/y_test.txt"))

#get y train file
y_train<-read.table(paste0(trnPath,"/y_train.txt"))

#row bind the 2 tables
y_combin<-rbind(y_test,y_train)

#follow the same for y files

#get subject test file
subject_test<-read.table(paste0(tstPath,"/subject_test.txt"))

#get y train file
subject_train<-read.table(paste0(trnPath,"/subject_train.txt"))

#row bind the 2 tables
subject_combin<-rbind(subject_test,subject_train)

#get features txt
features<-read.table(paste0("./UCI HAR Dataset/","features.txt"))

######## 2 #########################
#search mean and standard deviation in features, \\is for escaping ( and )
resIndices<-grep("-mean\\(\\)|-std\\(\\)", features[,2])

#set variable name
names(x_combin)<-features[,2]

#matching dataset
match <- x_combin[, resIndices]

# remove ()
names(match)<-gsub("\\(|\\)","",names(match))
# make columns tolower case
names(match)<-tolower(names(match))

######## 3 #########################
#get activities txt
activities<-read.table(paste0("./UCI HAR Dataset/","activity_labels.txt"))
#change activities to lower case
activities[,2]<-tolower(activities[,2])
#remove _
activities[,2]<-gsub("_","",activities[,2])
# change the activity id in y_combin
y_combin[,1]<-activities[y_combin[,1], 2]
# set varriable name
names(y_combin)<-c("activity")


######## 4 #########################
names(subject_combin)<-c("subject")

######## 5 #########################
cleanedData<-cbind(subject_combin,y_combin,match)
averageData<-aggregate(cleanedData[, 3:68], list(cleanedData$subject,cleanedData$activity ), mean)
names(averageData)[1]<-"subject"
names(averageData)[2]<-"activity"
write.table(averageData, "mergedcleaned.txt", row.name=FALSE)



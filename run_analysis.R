library(reshape2)
# Load Features
features = read.table('UCI HAR Dataset/features.txt')[,2]
features.index = grep('mean|std',features)
features.select = features[features.index]
features.select = gsub('\\(\\)','',features.select)
# Load Activites
activities = read.table("UCI HAR Dataset/activity_labels.txt")
activities.name = as.character(activities[,2])
# Load the datasets
## For the train set
train = read.table("UCI HAR Dataset/train/X_train.txt")[,features.select]
train.activities = read.table("UCI HAR Dataset/train/y_train.txt")
train.subjects = read.table("UCI HAR Dataset/train/subject_train.txt")
train = cbind(train.subjects,train.activities,train)
## same for the test set
test = read.table("UCI HAR Dataset/test/X_test.txt")[,features.select]
test.activities = read.table("UCI HAR Dataset/test/y_test.txt")
test.subjects = read.table("UCI HAR Dataset/test/subject_test.txt")
test = cbind(test.subjects,test.activities,test)

# Merge train and test data
merged = rbind(train,test)
colnames(merged) = c('Subject ID','Activity',as.character(features.select))
merged$`Subject ID` = as.integer(merged$`Subject ID`)
head(merged[,1:2])
merged$Activity = factor(merged$Activity,levels = 1:6,labels = activities.name)

# Aggregate by subject and activity
merged.melted = melt(merged, id = c("Subject ID", "Activity"))
newdata = dcast(merged.melted,`Subject ID` + Activity ~ variable, mean)
write.table(newdata,file = 'cleaned.txt',row.names = FALSE)



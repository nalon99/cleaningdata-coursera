<b>Description of the variables used in the run_analysis.R</b>

According to the README.txt in the "UCI HAR Dataset" folder variables:
  - activities is the data frame containing activity_labels.txt
  - features is the data frame containing features.txt
  
both variables are common to the train and test data sets.<br>
tidy.test is the tidy data set concerning test data, whereas tidy.train contains training data.<br>
tidy.data contains merged data sets from test and training data.<br><br>
tidy.mean is the final data frame with the mean values of each physical variable contained in the test and training data.
Mean values refer to each subject and activity.

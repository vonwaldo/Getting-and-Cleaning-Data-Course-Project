# Getting-and-Cleaning-Data-Course-Project
Final project for the corresponding Coursera class.

Run_Analysis.R does the following:
1. Download the UCI HAR dataset for "Human Activity Recognition Using Smartphones" if it doesn't already exist in the working directory.
2. Reads in the variable/feature names, activity labels and values, subject values, and combines them with the measurement features into a single dataset that includes both the training and testing data.
3. Selects only the mean and standard deviation features in the new dataset and tidies up the names of the remaining features
4. Reforms the dataset to show the average of each of the remaining features for each subject and activity.
5. Outputs a "tidydata.txt" as a tidy dataset of #4, also included in this repository.

A description of the measurements (or features) and how they relate to the original dataset is given in the CodeBook included in this repository.

